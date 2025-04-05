# CIS Control: 1.2.4. (L1) Ensure 'Reset account lockout counter after' is set to '15 or more minute(s)'
# In simpler terms: This setting controls how long a user's account stays locked out after too many failed login attempts.

# Define the security policy setting and desired value
$policyName = "Reset account lockout counter after"
$desiredValue = 15 # Value is in minutes

# Function to get the current security policy setting
function Get-SecurityPolicySetting {
    param($policyName)

    try {
        Import-Module SecPolicy -ErrorAction Stop # Try to import, stop on error
        $currentPolicy = Get-LocalSecurityPolicy -Name $policyName -ErrorAction Stop
        return $currentPolicy.EffectiveValue
    } catch {
        Write-Warning "SecPolicy module not found. Using registry method (limited functionality)."
        # *** REPLACE WITH REGISTRY METHOD HERE (SEE BELOW) ***
        $registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
        $valueName = "ResetLockoutCount" # This is a *possible* registry value name
        if (Test-Path $registryKey) {
            try {
                return (Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue)
            } catch {
                return $null
            }
        } else {
            return $null
        }
    }
}

# Function to set the security policy setting
function Set-SecurityPolicySetting {
    param($policyName, $value)

    try {
        Import-Module SecPolicy -ErrorAction Stop # Try to import, stop on error
        Set-LocalSecurityPolicy -Name $policyName -Value $value
    } catch {
        Write-Warning "SecPolicy module not found. Using registry method (limited functionality)."
        # *** REPLACE WITH REGISTRY METHOD HERE (SEE BELOW) ***
        $registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
        $valueName = "ResetLockoutCount" # This is a *possible* registry value name
        Set-ItemProperty -Path $registryKey -Name $valueName -Value $value -Force
    }
}

# Get the current setting
$currentValue = Get-SecurityPolicySetting -policyName $policyName

Write-Host "  Current Value: $currentValue (minutes)"

# Set the desired value if it's less than 15 or doesn't exist
if ($currentValue -lt $desiredValue -or $currentValue -eq $null) {
    Set-SecurityPolicySetting -policyName $policyName -value $desiredValue
    Write-Host "  CIS 1.2.4: 'Reset account lockout counter after' set to $desiredValue minutes" -ForegroundColor Green
} else {
    Write-Host "  CIS 1.2.4: 'Reset account lockout counter after' is already set to $desiredValue minutes or more" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-SecurityPolicySetting -policyName $policyName

Write-Host "  New Value: $newValue (minutes)"

# **Registry Method (Example - NEEDS VERIFICATION!)**
#
# **CRITICAL: You MUST verify the correct registry key and value names**
# **for your specific Windows version (e.g., Windows 10, Windows 11, Server 2019, etc.).**
#
# The following is an example and might not be accurate:
#
# $registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
# $valueName = "ResetLockoutCount"
#
# Function Get-RegistrySetting {
#     param($key, $name)
#     if (Test-Path $key) {
#         return (Get-ItemProperty -Path $key).$name
#     } else {
#         return $null
#     }
# }
#
# Function Set-RegistrySetting {
#     param($key, $name, $value)
#     Set-ItemProperty -Path $key -Name $name -Value $value
# }
#
# $currentValue = Get-RegistrySetting -key $registryKey -name $valueName
#
# ... your logic to compare and set ...
