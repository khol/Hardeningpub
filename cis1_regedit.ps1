
# Install and import PSRegistry (only if needed)
if (-not (Get-Module -Name PSRegistry -ListAvailable)) {
    try {
        Write-Host "Installing PSRegistry..." -ForegroundColor Yellow
        Install-Module PSRegistry -Scope CurrentUser -Force -ErrorAction Stop
        Import-Module PSRegistry -ErrorAction Stop
        Write-Host "PSRegistry installed and imported." -ForegroundColor Green
    } catch {
        Write-Error "Misslyckades med att installera PSRegistry: $_"
        return # Avbryt skriptet om installationen misslyckas
    }
} else {
    try {
        Import-Module PSRegistry -ErrorAction Stop
        Write-Host "PSRegistry-modulen är tillgänglig." -ForegroundColor Green
    } catch {
        Write-Error "Misslyckades med att importera PSRegistry: $_"
        return # Avbryt skriptet om modulen inte ar tillganglig
    }
}


function Set-RegistryKeys {
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]$table
    )
    foreach ($key in $table.Keys) {
        try {
            # Convert HKLM to full path
            $fullPath = $key -replace '^HKLM\\', 'HKLM:\\'
            
            if (!(Test-Path $fullPath)) {
                New-Item -Path $fullPath -Force | Out-Null
            }
            $values = $table[$key]
            foreach ($valueName in $values.Keys) {
                $value = $values[$valueName]
                $type = if ($value -is [int]) { "DWord" } else { "String" }
                
                # Use New-ItemProperty instead of Set-ItemProperty
                if (Get-ItemProperty -Path $fullPath -Name $valueName -ErrorAction SilentlyContinue) {
                    Set-ItemProperty -Path $fullPath -Name $valueName -Value $value
                } else {
                    New-ItemProperty -Path $fullPath -Name $valueName -Value $value -PropertyType $type -Force | Out-Null
                }
            }
        }
        catch {
            Write-Error "Failed to process key '$fullPath': $_"
        }
    }
}
function Set-UserRegistryKeys {
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]$Table,
        [switch]$RunAsAdmin  # <-- This is how the parameter is defined!
    )

    # Get all user SIDs from HKEY_USERS except system SIDs
    $userSIDs = Get-ChildItem -Path "Registry::HKEY_USERS" | Where-Object {
        $_.PSChildName -notmatch '^(S-1-5-18|S-1-5-19|S-1-5-20|\.DEFAULT)$'
    }

    foreach ($sid in $userSIDs) {
        foreach ($key in $Table.Keys) {
            # Replace the placeholder [USER SID] with the actual user SID
            $userKey = $key -replace '\[USER SID\]', $sid.PSChildName
            $userKey = "Registry::$userKey"  # Ensure we're using the Registry provider

            if (!(Test-Path $userKey)) {
                try {
                    New-Item -Path $userKey -Force | Out-Null
                }
                catch {
                    Write-Error "Failed to create registry key '$userKey': $_"
                    continue
                }
            }

            $values = $Table[$key]
            foreach ($valueName in $values.Keys) {
                $value = $values[$valueName]
                try {
                    $type = if ($value -is [int]) { "DWord" } else { "String" }
                    Set-ItemProperty -Path $userKey -Name $valueName -Value $value -Type $type
                }
                catch {
                    Write-Error "Failed to set value '$valueName' in key '$userKey': $_"
                }
            }
        }
    }
}


# CIS Control: 1.2.4. (L1) Ensure 'Reset account lockout counter after' is set to '15 or more minute(s)'
# In simpler terms: This setting controls how long a user's account stays locked out after too many failed login attempts.
# Recommended Value: 15 or more minutes
# Possible Values: Any integer greater than 0
$cisControl_1_2_4 = @{
    "ID" = "1.2.4"
    "Description" = "Ensure 'Reset account lockout counter after' is set to '15 or more minute(s)'"
    "SimpleTerms" = "This setting controls how long a user's account stays locked out after too many failed login attempts."
    "RegistryChanges" = @{
        "HKLM\SECURITY\Policy\PolAdt" = @{
            "LockoutResetMin" = 15 # Value in minutes
        }
    }
}

# CIS Control: 1.2.3. (L1) Ensure 'Allow Administrator account lockout' is set to 'Enabled'
# In simpler terms: This setting makes sure that even the main administrator account can be locked out if someone tries to guess the password too many times.
# Recommended Value: Any integer greater than 0 (e.g., 30 minutes)
# Possible Values: Any integer (0 disables lockout)
$cisControl_1_2_3 = @{
    "ID" = "1.2.3"
    "Description" = "Ensure 'Allow Administrator account lockout' is set to 'Enabled'"
    "SimpleTerms" = "This setting makes sure that even the main administrator account can be locked out if someone tries to guess the password too many times."
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" = @{
            "AdministratorAccountLockout" = 30 # Value in minutes (0 disables)
        }
    }
}

# Process CIS controls
foreach ($cisControl in @($cisControl_1_2_4, $cisControl_1_2_3)) {
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
