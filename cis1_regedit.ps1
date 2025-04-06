 

Write-Host "  Run: - Set-ExecutionPolicy RemoteSigned "



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

# CIS Control: 1.2.4. (L1) Ensure 'Reset account lockout counter after' is set to '15 or more minute(s)'
# In simpler terms: This setting controls how long a user's account stays locked out after too many failed login attempts.
# Recommended Value: 15 minutes
# Possible Values: Any integer greater than 0
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
    "ApplyMethod" = "NetAccounts" # Use a consistent naming convention
    "Parameters" = @{
        "LockoutResetMin" = 15 # Value in minutes
    }
}

# CIS Control: 1.2.3. (L1) Ensure 'Allow Administrator account lockout' is set to 'Enabled'
# In simpler terms: This setting makes sure that even the main administrator account can be locked out if someone tries to guess the password too many times.
# Recommended Value: 30 minutes
# Possible Values: Any positive integer (0 disables)
$cisControl_1_2_3 = @{
    "ID" = "1.2.3"
    "ApplyMethod" = "Registry"
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

# CIS Control: 1.2.1. (L1) Ensure 'Account lockout duration' is set to '15 or more minute(s)'
# In simpler terms: This setting controls how long an account stays locked out after too many failed login attempts.
# Recommended Value: 15 minutes
# Possible Values: Any positive integer greater than 0
$cisControl_1_2_1 = @{
    "ID" = "1.2.1"
    "Description" = "Ensure 'Account lockout duration' is set to '15 or more minute(s)'"
    "SimpleTerms" = "This setting controls how long an account stays locked out after too many failed login attempts."
    "RecommendedValue" = "15 minutes"
    "PossibleValues" = "Any integer greater than 0"
    "ApplyMethod" = "NetAccounts"
    "Parameters" = @{
        "LockoutDuration" = 15 # Value in minutes
    }
}

# CIS Control: 1.1.7. (L1) Ensure 'Store passwords using reversible encryption' is set to 'Disabled'
# In simpler terms: This setting makes sure Windows doesn't store passwords in a way that can be easily turned back into the original password.
# Recommended Value: Disabled
# Possible Values: Enabled, Disabled
$cisControl_1_1_7 = @{
    "ID" = "1.1.7"
    "ApplyMethod" = "Registry"
    "Description" = "Ensure 'Store passwords using reversible encryption' is set to 'Disabled'"
    "SimpleTerms" = "This setting makes sure Windows doesn't store passwords in a way that can be easily turned back into the original password."
    "RecommendedValue" = "Disabled"
    "PossibleValues" = "Enabled, Disabled"
    "RegistryChanges" = @{ # This might be incorrect. Password policies are usually not set directly in the registry.
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" = @{ # You'll need to verify the correct key/value
            "UseLmCompatibility" = 0 # Example: 0 (or a similar value) disables LM Hash storage
        }
    }
}


# CIS Control: 1.1.5. (L1) Ensure 'Password must meet complexity requirements' is set to 'Enabled'
# In simpler terms: This setting forces users to create strong passwords that are hard to guess.
# Recommended Value: Enabled
# Possible Values: Enabled, Disabled
$cisControl_1_1_5 = @{
    "ID" = "1.1.5"
    "ApplyMethod" = "Registry"
    "Description" = "Ensure 'Password must meet complexity requirements' is set to 'Enabled'"
    "SimpleTerms" = "This setting forces users to create strong passwords that are hard to guess."
    "RecommendedValue" = "Enabled"
    "PossibleValues" = "Enabled, Disabled"
    "RegistryChanges" = @{ # This might be incorrect. Password policies are usually not set directly in the registry.
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" = @{ # You'll need to verify the correct key/value
            "complexity" = 1 # Example: 1 (or a similar value) enables complexity
        }
    }
}


# CIS Control: 1.1.1. (L1) Ensure 'Enforce password history' is set to '24 or more password(s)'
# In simpler terms: This setting makes sure users can't reuse their old passwords for a certain number of changes.
# Recommended Value: 24 passwords
# Possible Values: Any integer greater than 0
$cisControl_1_1_1 = @{
    "ID" = "1.1.1"
    "Description" = "Ensure 'Enforce password history' is set to '24 or more password(s)'"
    "SimpleTerms" = "This setting makes sure users can't reuse their old passwords for a certain number of changes."
    "RecommendedValue" = "24 passwords"
    "PossibleValues" = "Any integer greater than 0"
    "ApplyMethod" = "SecPolicy" # or "GroupPolicy" if you use that
    "Parameters" = @{
        "HistoryCount" = 24
    }
}

# Process CIS controls
$cisControls = @($cisControl_1_2_4, 
                $cisControl_1_2_3, 
                $cisControl_1_2_1,
                $cisControl_1_1_7,
                $cisControl_1_1_5,
                $cisControl_1_1_1)

foreach ($cisControl in $cisControls) {
    Write-Host "###################################################################################" -ForegroundColor Cyan
    Write-Host "Processing CIS Control $($cisControl.ID): $($cisControl.Description)" -ForegroundColor Cyan
    Write-Host "  In simpler terms: $($cisControl.SimpleTerms)"
    Write-Host "  Recommended Value: $($cisControl.RecommendedValue)"
    Write-Host "  Possible Values: $($cisControl.PossibleValues)"

    try {
        switch ($cisControl.ApplyMethod) {
            "Registry" {
                if ($cisControl.RegistryChanges) {
                    Set-RegistryKeys -Table $cisControl.RegistryChanges -RunAsAdmin
                }
            }
            "net accounts" {
                if ($cisControl.Parameters) {
                    Set-AccountLockoutPolicy_1_2_4 @($cisControl.Parameters) # Pass parameters
                }
            }
            default {
                if ($cisControl.RegistryChanges) {
                    Set-RegistryKeys -Table $cisControl.RegistryChanges -RunAsAdmin
                }
            }
        }
    } catch {
        Write-Error "  Failed to apply CIS Control $($cisControl.ID): $_"
    }

    Write-Host "###################################################################################" -ForegroundColor Cyan
} 
