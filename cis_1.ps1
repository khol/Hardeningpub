# CIS Control: 1.2.4. (L1) Ensure 'Reset account lockout counter after' is set to '15 or more minute(s)'
# In simpler terms: This setting controls how long a user's account stays locked out after too many failed login attempts.

# Define the security policy setting and desired value
$policyName = "Reset account lockout counter after"
$desiredValue = 15 # Value is in minutes

# Function to get the current security policy setting
function Get-SecurityPolicySetting {
    param($policyName)

    try {
        $currentPolicy = Get-LocalSecurityPolicy -Name $policyName -ErrorAction Stop
        return $currentPolicy.EffectiveValue
    } catch {
        return $null
    }
}

# Function to set the security policy setting
function Set-SecurityPolicySetting {
    param($policyName, $value)

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


# CIS Control: 1.2.3. (L1) Ensure 'Allow Administrator account lockout' is set to 'Enabled'
# In simpler terms: This setting makes sure that even the main administrator account can be locked out if someone tries to guess the password too many times.

# Define the security policy setting and desired value
$policyName = "Administrator account lockout duration" # This policy determines if lockout is active
$desiredValue = 30 # Any value other than 0 enables lockout. We'll use 30 minutes as a reasonable default.

# Function to get the current security policy setting
function Get-SecurityPolicySetting {
    param($policyName)

    try {
        $currentPolicy = Get-LocalSecurityPolicy -Name $policyName -ErrorAction Stop
        return $currentPolicy.EffectiveValue
    } catch {
        return $null
    }
}

# Function to set the security policy setting
function Set-SecurityPolicySetting {
    param($policyName, $value)

    Set-LocalSecurityPolicy -Name $policyName -Value $value
}

# Get the current setting
$currentValue = Get-SecurityPolicySetting -policyName $policyName

Write-Host "  Current Value: $currentValue (minutes)"

# Set the desired value if it's 0 or doesn't exist
if ($currentValue -eq 0 -or $currentValue -eq $null) {
    Set-SecurityPolicySetting -policyName $policyName -value $desiredValue
    Write-Host "  CIS 1.2.3: 'Allow Administrator account lockout' set to Enabled (lockout duration: $desiredValue minutes)" -ForegroundColor Green
} else {
    Write-Host "  CIS 1.2.3: 'Allow Administrator account lockout' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-SecurityPolicySetting -policyName $policyName

Write-Host "  New Value: $newValue (minutes)"


# CIS Control: 1.2.1. (L1) Ensure 'Account lockout duration' is set to '15 or more minute(s)'
# In simpler terms: This setting controls how long an account stays locked out after too many failed login attempts.

# Define the security policy setting and desired value
$policyName = "Account lockout duration"
$desiredValue = 15 # Value is in minutes

# Function to get the current security policy setting
function Get-SecurityPolicySetting {
    param($policyName)

    try {
        $currentPolicy = Get-LocalSecurityPolicy -Name $policyName -ErrorAction Stop
        return $currentPolicy.EffectiveValue
    } catch {
        return $null
    }
}

# Function to set the security policy setting
function Set-SecurityPolicySetting {
    param($policyName, $value)

    Set-LocalSecurityPolicy -Name $policyName -Value $value
}

# Get the current setting
$currentValue = Get-SecurityPolicySetting -policyName $policyName

Write-Host "  Current Value: $currentValue (minutes)"

# Set the desired value if it's less than 15 or doesn't exist
if ($currentValue -lt $desiredValue -or $currentValue -eq $null) {
    Set-SecurityPolicySetting -policyName $policyName -value $desiredValue
    Write-Host "  CIS 1.2.1: 'Account lockout duration' set to $desiredValue minutes" -ForegroundColor Green
} else {
    Write-Host "  CIS 1.2.1: 'Account lockout duration' is already set to $desiredValue minutes or more" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-SecurityPolicySetting -policyName $policyName

Write-Host "  New Value: $newValue (minutes)"


# CIS Control: 1.1.7. (L1) Ensure 'Store passwords using reversible encryption' is set to 'Disabled'
# In simpler terms: This setting makes sure Windows doesn't store passwords in a way that can be easily turned back into the original password.

# Define the security policy setting and desired value
$policyName = "Store passwords using reversible encryption for all users in the domain"
$desiredValue = 0 # 0 = Disabled, 1 = Enabled

# Function to get the current security policy setting
function Get-SecurityPolicySetting {
    param($policyName)

    try {
        $currentPolicy = Get-LocalSecurityPolicy -Name $policyName -ErrorAction Stop
        return $currentPolicy.EffectiveValue
    } catch {
        return $null
    }
}

# Function to set the security policy setting
function Set-SecurityPolicySetting {
    param($policyName, $value)

    Set-LocalSecurityPolicy -Name $policyName -Value $value
}

# Get the current setting
$currentValue = Get-SecurityPolicySetting -policyName $policyName

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's not disabled or doesn't exist
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-SecurityPolicySetting -policyName $policyName -value $desiredValue
    Write-Host "  CIS 1.1.7: 'Store passwords using reversible encryption' set to Disabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 1.1.7: 'Store passwords using reversible encryption' is already Disabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-SecurityPolicySetting -policyName $policyName

Write-Host "  New Value: $newValue"


# CIS Control: 1.1.5. (L1) Ensure 'Password must meet complexity requirements' is set to 'Enabled'
# In simpler terms: This setting forces users to create strong passwords that are hard to guess.

# Define the security policy setting and desired value
$policyName = "PasswordComplexity"
$desiredValue = 1 # 1 = Enabled, 0 = Disabled

# Function to get the current security policy setting
function Get-SecurityPolicySetting {
    param($policyName)

    try {
        $currentPolicy = Get-LocalSecurityPolicy -Name $policyName -ErrorAction Stop
        return $currentPolicy.EffectiveValue
    } catch {
        return $null
    }
}

# Function to set the security policy setting
function Set-SecurityPolicySetting {
    param($policyName, $value)

    Set-LocalSecurityPolicy -Name $policyName -Value $value
}

# Get the current setting
$currentValue = Get-SecurityPolicySetting -policyName $policyName

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's not enabled or doesn't exist
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-SecurityPolicySetting -policyName $policyName -value $desiredValue
    Write-Host "  CIS 1.1.5: 'Password must meet complexity requirements' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 1.1.5: 'Password must meet complexity requirements' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-SecurityPolicySetting -policyName $policyName

Write-Host "  New Value: $newValue"


# CIS Control: 1.1.1. (L1) Ensure 'Enforce password history' is set to '24 or more password(s)'
# In simpler terms: This setting makes sure users can't reuse their old passwords for a certain number of changes.

# Define the security policy setting and desired value
$policyName = "Enforce password history"
$desiredValue = 24 # Number of passwords to remember

# Function to get the current security policy setting
function Get-SecurityPolicySetting {
    param($policyName)

    try {
        $currentPolicy = Get-LocalSecurityPolicy -Name $policyName -ErrorAction Stop
        return $currentPolicy.EffectiveValue
    } catch {
        return $null
    }
}

# Function to set the security policy setting
function Set-SecurityPolicySetting {
    param($policyName, $value)

    Set-LocalSecurityPolicy -Name $policyName -Value $value
}

# Get the current setting
$currentValue = Get-SecurityPolicySetting -policyName $policyName

Write-Host "  Current Value: $currentValue (passwords)"

# Set the desired value if it's less than 24 or doesn't exist
if ($currentValue -lt $desiredValue -or $currentValue -eq $null) {
    Set-SecurityPolicySetting -policyName $policyName -value $desiredValue
    Write-Host "  CIS 1.1.1: 'Enforce password history' set to $desiredValue passwords" -ForegroundColor Green
} else {
    Write-Host "  CIS 1.1.1: 'Enforce password history' is already set to $desiredValue or more passwords" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-SecurityPolicySetting -policyName $policyName

Write-Host "  New Value: $newValue (passwords)"


