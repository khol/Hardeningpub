# Helper function to check if running as admin (place at the beginning of your script)
function Is-Admin {
    return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

# Function to set registry keys
function Set-RegistryKeys {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable]$table,
        [switch]$RunAsAdmin
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

# CIS Control: 1.2.4. (L1) Ensure 'Reset account lockout counter after' is set to '15 or more minute(s)'
# In simpler terms: This setting controls how long a user's account stays locked out after too many failed login attempts.
# Recommended Value: 15 minutes
# Possible Values: Any integer greater than 0
$cisControl_1_2_4 = @{
    "ID" = "1.2.4"
    "Description" = "Ensure 'Reset account lockout counter after' is set to '15 or more minute(s)'"
    "SimpleTerms" = "This setting controls how long a user's account stays locked out after too many failed login attempts."
    "RecommendedValue" = "15 minutes"
    "PossibleValues" = "Any integer greater than 0"
    "RegistryChanges" = @{
        "HKLM\SECURITY\Policy\PolAdt" = @{
            "LockoutResetMin" = 15 # Value in minutes
        }
    }
}

# CIS Control: 1.2.3. (L1) Ensure 'Allow Administrator account lockout' is set to 'Enabled'
# In simpler terms: This setting makes sure that even the main administrator account can be locked out if someone tries to guess the password too many times.
# Recommended Value: 30 minutes
# Possible Values: Any positive integer (0 disables)
$cisControl_1_2_3 = @{
    "ID" = "1.2.3"
    "Description" = "Ensure 'Allow Administrator account lockout' is set to 'Enabled'"
    "SimpleTerms" = "This setting makes sure that even the main administrator account can be locked out if someone tries to guess the password too many times."
    "RecommendedValue" = "30 minutes"
    "PossibleValues" = "Any positive integer (0 disables)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" = @{
            "AdministratorAccountLockout" = 30 # Value in minutes (0 disables)
        }
    }
}

# Process CIS controls
$cisControls = @($cisControl_1_2_4, $cisControl_1_2_3)

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
