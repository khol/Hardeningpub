# CIS Control: 1.2.4. (L1) Ensure 'Reset account lockout counter after' is set to '15 or more minute(s)'
# Define the security policy setting and desired value
$desiredValue124 = 15

# Create hashtable for CIS 1.2.4
$cis124Settings = @{
    "HKLM\SECURITY\Policy\PolAdt" = @{
        "LockoutResetMin" = $desiredValue124
    }
}

# CIS Control: 1.2.3. (L1) Ensure 'Allow Administrator account lockout' is set to 'Enabled'
# In simpler terms: This setting makes sure that even the main administrator account can be locked out if someone tries to guess the password too many times.
# Define the security policy setting and desired value
$policyName123 = "Administrator account lockout duration" # This policy determines if lockout is active
$desiredValue123 = 30 # Any value other than 0 enables lockout. We'll use 30 minutes as a reasonable default.
$cis123Settings = @{
    "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" = @{
        "AdministratorAccountLockout" = $desiredValue123
    }
}

# CIS Control: 1.2.4. (L1) Ensure 'Reset account lockout counter after' is set to '15 or more minute(s)'
# In simpler terms: This setting controls how long a user's account stays locked out after too many failed login attempts.
# Define the CIS control information
$cisControl = @{
    "ID" = "1.2.4"
    "Description" = "Ensure 'Reset account lockout counter after' is set to '15 or more minute(s)'"
    "SimpleTerms" = "This setting controls how long a user's account stays locked out after too many failed login attempts."
    "RegistryChanges" = @{
        "HKLM\SECURITY\Policy\PolAdt" = @{
            "LockoutResetMin" = 15 # Value in minutes
        }
    }
}




# Installera PSRegistry (om det inte redan är installerat)
try {
    Get-Module -Name PSRegistry -ListAvailable -ErrorAction Stop | Out-Null
    Write-Host "PSRegistry är redan installerat." -ForegroundColor Green
} catch {
    Write-Host "Installerar PSRegistry..." -ForegroundColor Yellow
    try {
        Install-Module PSRegistry -Scope CurrentUser -Force -ErrorAction Stop
        Write-Host "PSRegistry installerat." -ForegroundColor Green
    } catch {
        Write-Error "Misslyckades med att installera PSRegistry: $_"
        return # Avbryt skriptet om installationen misslyckas
    }
}

# Importera PSRegistry
try {
    Install-Module -Name PSRegistry
    Import-Module PSRegistry -ErrorAction Stop
    Write-Host "PSRegistry importerat." -ForegroundColor Green
} catch {
    Write-Error "Misslyckades med att importera PSRegistry: $_"
    return # Avbryt skriptet om importen misslyckas
}

# Kontrollera att modulen ar tillganglig
if (Get-Module -Name PSRegistry) {
    Write-Host "PSRegistry-modulen är tillgänglig." -ForegroundColor Green
} else {
    Write-Error "PSRegistry-modulen är inte tillgänglig efter import."
    return # Avbryt skriptet om modulen inte ar tillgänglig
}


# Helper function to check if running as admin
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

Write-Host "###################################################################################" 
# Apply CIS 1.2.4 settings
Set-RegistryKeys -Table $cis124Settings -RunAsAdmin
Write-Host "CIS 1.2.4: 'Reset account lockout counter after' set to $desiredValue124 minutes" -ForegroundColor Green
Write-Host "###################################################################################" 
# Apply CIS 1.2.3. settings
Set-RegistryKeys -Table $cis123Settings -RunAsAdmin
Write-Host " CIS Control: 1.2.3. (L1) Ensure 'Allow Administrator account lockout' is set to 'Enabled'" -ForegroundColor Green
Write-Host "###################################################################################" 
# Apply CIS 1.2.4 settings
Write-Host "###################################################################################" -ForegroundColor Cyan
Write-Host "Processing CIS Control $($cisControl.ID): $($cisControl.Description)" -ForegroundColor Cyan
Write-Host "  In simpler terms: $($cisControl.SimpleTerms)"

if ($cisControl.RegistryChanges) {
    Set-RegistryKeys -Table $cisControl.RegistryChanges -RunAsAdmin
}

Write-Host "###################################################################################" -ForegroundColor Cyan

