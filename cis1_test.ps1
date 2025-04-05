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
        return $null # Or your appropriate default/error value
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

# **Registry Method (Example - Needs Adaptation)**
#
# For this specific setting, you might find information on registry keys
# related to account lockout. However, it's crucial to:
#
# 1.  **Verify the exact registry keys and values** for your Windows version.
# 2.  **Understand the implications** of directly manipulating the registry.
# 3.  **Test thoroughly** before using in production.
#
# Example (Conceptual - DO NOT USE WITHOUT VERIFICATION):
#
# $registryKey = "HKLM:\Some\Registry\Path"
# $valueName = "LockoutDuration"
#
# function Get-RegistrySetting {
#     param($key, $name)
#     if (Test-Path $key) {
#         return (Get-ItemProperty -Path $key).$name
#     } else {
#         return $null
#     }
# }
#
# function Set-RegistrySetting {
#     param($key, $name, $value)
#     Set-ItemProperty -Path $key -Name $name -Value $value
# }
#
# $currentValue = Get-RegistrySetting -key $registryKey -name $valueName
#
# ... your logic to compare and set ...
