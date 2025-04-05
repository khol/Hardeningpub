# CIS Control: 1.2.4. (L1) Ensure 'Reset account lockout counter after' is set to '15 or more minute(s)'
# In simpler terms: This setting controls how long a user's account stays locked out after too many failed login attempts.

# Define the security policy setting and desired value
$policyName = "Reset account lockout counter after"
$desiredValue = 15 # Value is in minutes

# Function to get the current security policy setting
function Get-SecurityPolicySetting {
    param($policyName)

    try {
        Import-Module SecPolicy # Import the SecPolicy module
        $currentPolicy = Get-LocalSecurityPolicy -Name $policyName -ErrorAction Stop
        return $currentPolicy.EffectiveValue
    } catch {
        return $null
    }
}

# Function to set the security policy setting
function Set-SecurityPolicySetting {
    param($policyName, $value)

    Import-Module SecPolicy # Import the SecPolicy module
    Set-LocalSecurityPolicy -Name $policyName -Value $value
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
