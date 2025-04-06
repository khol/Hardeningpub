# Helper function to check if running as admin (place at the beginning of your script)
function Is-Admin {
    return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

# Function to set registry keys
function Set-RegistryKeys {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable]$table,
        [switch]$RunAsAdmin  # <-- This is how the parameter is defined!
    )

    # Check if running as admin
    if (-not (Is-Admin)) {
        if ($MyInvocation.MyCommand.Path) {
            Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs -Wait
        } else {
            Write-Warning "Script path not available. Cannot elevate."
            return
        }
        return
    }

    foreach ($key in $table.Keys) {
        try {
            # Convert HKLM to full path
            $fullPath = $key -replace '^HKLM\\', 'HKLM:\\'

            # Ensure the key exists
            if (!(Test-Path $fullPath)) {
                New-Item -Path $fullPath -ItemType Directory -Force | Out-Null
            }

            $values = $table[$key]
            foreach ($valueName in $values.Keys) {
                $value = $values[$valueName]
                $type = if ($value -is [int]) { "DWord" } else { "String" }

                # Get existing value with better error handling and type check
                try {
                    $item = Get-ItemProperty -Path $fullPath -Name $valueName -ErrorAction Stop
                    $currentValue = $item.$valueName
                    $currentType = $item.PSObject.Properties[$valueName].TypeNameOfValue
                    Write-Host "  Existing value for '$valueName' in key '$fullPath' is: '$currentValue' (Type: $currentType)" -ForegroundColor Yellow
                } catch {
                    Write-Host "  Value '$valueName' does not exist in key '$fullPath'" -ForegroundColor DarkYellow
                    $currentValue = $null
                }

                # Set the value only if it's different or doesn't exist
                if ($currentValue -ne $value -or $currentValue -eq $null) {
                    try {
                        New-ItemProperty -Path $fullPath -Name $valueName -Value $value -PropertyType $type -Force | Out-Null
                        Write-Host "  Set registry value '$valueName' in key '$fullPath' to '$value' (Type: $type)." -ForegroundColor Green
                    } catch {
                        Write-Error "  Failed to set registry value '$valueName' in key '$fullPath': $_"
                    }
                } else {
                    Write-Host "  Value '$valueName' in key '$fullPath' is already set to '$value'." -ForegroundColor Green
                }
            }
        }
        catch {
            Write-Error "  Failed to process key '$fullPath': $_"
        }
    }
}

# Install and import PSRegistry (only if needed)
if (-not (Get-Module -Name PSRegistry -ListAvailable)) {
    try {
        Write-Host "Installing PSRegistry..." -ForegroundColor Yellow
        Install-Module PSRegistry -Scope CurrentUser -Force -ErrorAction Stop
        Import-Module PSRegistry -ErrorAction Stop
        Write-Host "PSRegistry installed and imported." -ForegroundColor Green
    } catch {
        Write-Error "Failed to install/import PSRegistry: $_"
        return # Exit if PSRegistry fails
    }
} else {
    try {
        Import-Module PSRegistry -ErrorAction Stop
        Write-Host "PSRegistry module is available." -ForegroundColor Green
    } catch {
        Write-Error "Failed to import PSRegistry: $_"
        return # Exit if PSRegistry fails
    }
}



# CIS Control: 2.3.9.4. (L1) Ensure 'Microsoft network server: Disconnect clients when logon hours expire' is set to 'Enabled'
# In simpler terms: This setting forces users to be disconnected from the server when the times they're allowed to be logged in are over.
# Recommended Value: Enabled
# Possible Values: Enabled, Disabled

$cisControl_2_3_9_4 = @{
    "ID" = "2.3.9.4"
    "Description" = "Ensure 'Microsoft network server: Disconnect clients when logon hours expire' is set to 'Enabled'"
    "SimpleTerms" = "This setting forces users to be disconnected from the server when the times they're allowed to be logged in are over."
    "RecommendedValue" = "Enabled"
    "PossibleValues" = "Enabled, Disabled"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" = @{
            "EnableForcedLogoff" = 1 # 1 = Enabled, 0 = Disabled
        }
    }
}

# CIS Control: 2.3.9.1. (L1) Ensure 'Microsoft network server: Amount of idle time required before suspending session' is set to '15 or fewer minute(s)'
# In simpler terms: This setting makes the server disconnect inactive users after 15 minutes or less of inactivity.
# Recommended Value: 15 minutes
# Possible Values: Any integer greater than 0

$cisControl_2_3_9_1 = @{
    "ID" = "2.3.9.1"
    "Description" = "Ensure 'Microsoft network server: Amount of idle time required before suspending session' is set to '15 or fewer minute(s)'"
    "SimpleTerms" = "This setting makes the server disconnect inactive users after 15 minutes or less of inactivity."
    "RecommendedValue" = "15 minutes"
    "PossibleValues" = "Any integer greater than 0"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" = @{
            "Autodisconnect" = 15 # Value in minutes
        }
    }
}


# CIS Control: 2.3.8.3. (L1) Ensure 'Microsoft network client: Send unencrypted password to third-party SMB servers' is set to 'Disabled'
# In simpler terms: This setting prevents your computer from sending your password without encryption to some older file servers.
# Recommended Value: Disabled
# Possible Values: Enabled, Disabled

$cisControl_2_3_8_3 = @{
    "ID" = "2.3.8.3"
    "Description" = "Ensure 'Microsoft network client: Send unencrypted password to third-party SMB servers' is set to 'Disabled'"
    "SimpleTerms" = "This setting prevents your computer from sending your password without encryption to some older file servers."
    "RecommendedValue" = "Disabled"
    "PossibleValues" = "Enabled, Disabled"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" = @{
            "EnablePlainTextPassword" = 0 # 0 = Disabled, 1 = Enabled
        }
    }
}


# CIS Control: 2.3.8.2. (L1) Ensure 'Microsoft network client: Digitally sign communications (if server agrees)' is set to 'Enabled'
# In simpler terms: This setting tells your computer to use digital signatures to verify data sent to file servers, if the server supports it.
# Recommended Value: Enabled
# Possible Values: Enabled, Disabled

$cisControl_2_3_8_2 = @{
    "ID" = "2.3.8.2"
    "Description" = "Ensure 'Microsoft network client: Digitally sign communications (if server agrees)' is set to 'Enabled'"
    "SimpleTerms" = "This setting tells your computer to use digital signatures to verify data sent to file servers, if the server supports it."
    "RecommendedValue" = "Enabled"
    "PossibleValues" = "Enabled, Disabled"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" = @{
            "RequireSecureNegotiate" = 1 # 1 = Enabled, 0 = Disabled
        }
    }
}

# CIS Control: 2.3.7.8. (L1) Ensure 'Interactive logon: Prompt user to change password before expiration' is set to 'between 5 and 14 days'
# In simpler terms: This setting makes Windows warn users to change their password a few days before it expires.
# Recommended Value: 14 days (or another value within the 5-14 day range)
# Possible Values: Any integer between 0 and 999 (but CIS recommends 5-14)

$cisControl_2_3_7_8 = @{
    "ID" = "2.3.7.8"
    "Description" = "Ensure 'Interactive logon: Prompt user to change password before expiration' is set to 'between 5 and 14 days'"
    "SimpleTerms" = "This setting makes Windows warn users to change their password a few days before it expires."
    "RecommendedValue" = "14 days"
    "PossibleValues" = "Any integer between 0 and 999 (but CIS recommends 5-14)"
    "RegistryChanges" = @{
        "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" = @{
            "PasswordExpiryWarning" = 14 # Value in days (example: 14)
        }
    }
}


# CIS Control: 2.3.6.6. (L1) Ensure 'Domain member: Require strong (Windows 2000 or later) session key' is set to 'Enabled'
# In simpler terms: This setting makes sure your computer uses strong encryption when talking to domain controllers.
# Recommended Value: Enabled (value 5)
# Possible Values: 0, 1, 2, 3, 5 (5 is the strongest)

$cisControl_2_3_6_6 = @{
    "ID" = "2.3.6.6"
    "Description" = "Ensure 'Domain member: Require strong (Windows 2000 or later) session key' is set to 'Enabled'"
    "SimpleTerms" = "This setting makes sure your computer uses strong encryption when talking to domain controllers."
    "RecommendedValue" = "Enabled (value 5)"
    "PossibleValues" = "0, 1, 2, 3, 5 (5 is the strongest)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\LMCompatibility Level" = @{
            "LmCompatibilityLevel" = 5 # 5 is the strongest
        }
    }
}


# Process CIS controls
$cisControls = @($cisControl_2_3_9_4, 
                $cisControl_2_3_9_1, 
                $cisControl_2_3_8_3,
                $cisControl_2_3_8_2,
                $cisControl_2_3_7_8,
               $cisControl_2_3_6_6)

foreach ($cisControl in $cisControls) {
    Write-Host "###################################################################################" -ForegroundColor Cyan
    Write-Host "Processing CIS Control $($cisControl.ID): $($cisControl.Description)" -ForegroundColor Cyan
    Write-Host "  In simpler terms: $($cisControl.SimpleTerms)"
    Write-Host "  Recommended Value: $($cisControl.RecommendedValue)"
    Write-Host "  Possible Values: $($cisControl.PossibleValues)"

    if ($cisControl.RegistryChanges) {
        Set-RegistryKeys -Table $cisControl.RegistryChanges -RunAsAdmin
    }

    Write-Host "###################################################################################" -ForegroundColor Cyan
}
