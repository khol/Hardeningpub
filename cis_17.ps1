# CIS Control: 17.9.5. (L1) Ensure 'Audit System Integrity' is set to 'Success and Failure'
# In simpler terms: This setting makes Windows record in the security logs when important system files or settings are changed, both when it works and when it fails.

# Define the policy name and desired value
$policyName = "System Integrity"
# Values:
# 3 = Success and Failure
# 1 = Success
# 2 = Failure
# 0 = No Auditing
$desiredValue = "SuccessAndFailure"

# Function to get the current audit policy
function Get-AuditPolicySetting {
    param($policyName)

    try {
        $currentPolicy = Get-AuditPolicy -SubCategory:$policyName -ErrorAction Stop
        return $currentPolicy.Failure, $currentPolicy.Success
    } catch {
        return $null, $null
    }
}

# Function to set the audit policy
function Set-AuditPolicySetting {
    param($policyName, [bool]$auditSuccess, [bool]$auditFailure)

    Set-AuditPolicy -SubCategory:$policyName -Success:$auditSuccess -Failure:$auditFailure
}

# Get the current audit policy
$currentFailure, $currentSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  Current Failure: $($currentFailure)"
Write-Host "  Current Success: $($currentSuccess)"

# Determine if the desired value matches the current value
$desiredSuccess = $desiredValue -in @("Success", "SuccessAndFailure")
$desiredFailure = $desiredValue -in @("Failure", "SuccessAndFailure")

# Set the audit policy if it's different
if ($currentFailure -ne $desiredFailure -or $currentSuccess -ne $desiredSuccess -or $currentFailure -eq $null -or $currentSuccess -eq $null) {
    Set-AuditPolicySetting -policyName $policyName -auditSuccess $desiredSuccess -auditFailure $desiredFailure
    Write-Host "  CIS 17.9.5: 'Audit System Integrity' set to $desiredValue" -ForegroundColor Green
} else {
    Write-Host "  CIS 17.9.5: 'Audit System Integrity' is already set to $desiredValue" -ForegroundColor Green
}

# Verify the change (output new audit policy)
$newFailure, $newSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  New Failure: $($newFailure)"
Write-Host "  New Success: $($newSuccess)"




# CIS Control: 17.9.4. (L1) Ensure 'Audit Security System Extension' is set to include 'Success'
# In simpler terms: This setting makes Windows record in the security logs when certain security-related system extensions are used successfully.

# Define the policy name and desired value
$policyName = "Security System Extension"
# Values:
# 3 = Success and Failure
# 1 = Success (This is the minimum acceptable for CIS)
# 2 = Failure
# 0 = No Auditing
$desiredValue = "Success"

# Function to get the current audit policy
function Get-AuditPolicySetting {
    param($policyName)

    try {
        $currentPolicy = Get-AuditPolicy -SubCategory:$policyName -ErrorAction Stop
        return $currentPolicy.Failure, $currentPolicy.Success
    } catch {
        return $null, $null
    }
}

# Function to set the audit policy
function Set-AuditPolicySetting {
    param($policyName, [bool]$auditSuccess, [bool]$auditFailure)

    Set-AuditPolicy -SubCategory:$policyName -Success:$auditSuccess -Failure:$auditFailure
}

# Get the current audit policy
$currentFailure, $currentSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  Current Failure: $($currentFailure)"
Write-Host "  Current Success: $($currentSuccess)"

# Determine if the desired value matches the current value
$desiredSuccess = $desiredValue -in @("Success", "SuccessAndFailure")

# Set the audit policy if it's different
if ($currentSuccess -ne $desiredSuccess -or $currentSuccess -eq $null) {
    Set-AuditPolicySetting -policyName $policyName -auditSuccess $desiredSuccess -auditFailure $currentFailure # Preserve current failure setting
    Write-Host "  CIS 17.9.4: 'Audit Security System Extension' set to include Success" -ForegroundColor Green
} else {
    Write-Host "  CIS 17.9.4: 'Audit Security System Extension' is already set to include Success" -ForegroundColor Green
}

# Verify the change (output new audit policy)
$newFailure, $newSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  New Failure: $($newFailure)"
Write-Host "  New Success: $($newSuccess)"


# CIS Control: 17.9.3. (L1) Ensure 'Audit Security State Change' is set to include 'Success'
# In simpler terms: This setting makes Windows record in the security logs when changes are made to the system's security settings successfully.

# Define the policy name and desired value
$policyName = "Security State Change"
# Values:
# 3 = Success and Failure
# 1 = Success (This is the minimum acceptable for CIS)
# 2 = Failure
# 0 = No Auditing
$desiredValue = "Success"

# Function to get the current audit policy
function Get-AuditPolicySetting {
    param($policyName)

    try {
        $currentPolicy = Get-AuditPolicy -SubCategory:$policyName -ErrorAction Stop
        return $currentPolicy.Failure, $currentPolicy.Success
    } catch {
        return $null, $null
    }
}

# Function to set the audit policy
function Set-AuditPolicySetting {
    param($policyName, [bool]$auditSuccess, [bool]$auditFailure)

    Set-AuditPolicy -SubCategory:$policyName -Success:$auditSuccess -Failure:$auditFailure
}

# Get the current audit policy
$currentFailure, $currentSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  Current Failure: $($currentFailure)"
Write-Host "  Current Success: $($currentSuccess)"

# Determine if the desired value matches the current value
$desiredSuccess = $desiredValue -in @("Success", "SuccessAndFailure")

# Set the audit policy if it's different
if ($currentSuccess -ne $desiredSuccess -or $currentSuccess -eq $null) {
    Set-AuditPolicySetting -policyName $policyName -auditSuccess $desiredSuccess -auditFailure $currentFailure # Preserve current failure setting
    Write-Host "  CIS 17.9.3: 'Audit Security State Change' is set to include Success" -ForegroundColor Green
} else {
    Write-Host "  CIS 17.9.3: 'Audit Security State Change' is already set to include Success" -ForegroundColor Green
}

# Verify the change (output new audit policy)
$newFailure, $newSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  New Failure: $($newFailure)"
Write-Host "  New Success: $($newSuccess)"



# CIS Control: 17.9.1. (L1) Ensure 'Audit IPsec Driver' is set to 'Success and Failure'
# In simpler terms: This setting makes Windows record in the security logs when the IPsec driver (which secures network communication) is used, both when it works and when it fails.

# Define the policy name and desired value
$policyName = "IPsec Driver"
# Values:
# 3 = Success and Failure
# 1 = Success
# 2 = Failure
# 0 = No Auditing
$desiredValue = "SuccessAndFailure"

# Function to get the current audit policy
function Get-AuditPolicySetting {
    param($policyName)

    try {
        $currentPolicy = Get-AuditPolicy -SubCategory:$policyName -ErrorAction Stop
        return $currentPolicy.Failure, $currentPolicy.Success
    } catch {
        return $null, $null
    }
}

# Function to set the audit policy
function Set-AuditPolicySetting {
    param($policyName, [bool]$auditSuccess, [bool]$auditFailure)

    Set-AuditPolicy -SubCategory:$policyName -Success:$auditSuccess -Failure:$auditFailure
}

# Get the current audit policy
$currentFailure, $currentSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  Current Failure: $($currentFailure)"
Write-Host "  Current Success: $($currentSuccess)"

# Determine if the desired value matches the current value
$desiredSuccess = $desiredValue -in @("Success", "SuccessAndFailure")
$desiredFailure = $desiredValue -in @("Failure", "SuccessAndFailure")

# Set the audit policy if it's different
if ($currentFailure -ne $desiredFailure -or $currentSuccess -ne $desiredSuccess -or $currentFailure -eq $null -or $currentSuccess -eq $null) {
    Set-AuditPolicySetting -policyName $policyName -auditSuccess $desiredSuccess -auditFailure $desiredFailure
    Write-Host "  CIS 17.9.1: 'Audit IPsec Driver' is set to $desiredValue" -ForegroundColor Green
} else {
    Write-Host "  CIS 17.9.1: 'Audit IPsec Driver' is already set to $desiredValue" -ForegroundColor Green
}

# Verify the change (output new audit policy)
$newFailure, $newSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  New Failure: $($newFailure)"
Write-Host "  New Success: $($newSuccess)"


# CIS Control: 17.7.2. (L1) Ensure 'Audit Authentication Policy Change' is set to include 'Success'
# In simpler terms: This setting makes Windows record in the security logs when changes are made to how the system verifies users (like password policies), and it focuses on recording when those changes are successful.

# Define the policy name and desired value
$policyName = "Authentication Policy Change"
# Values:
# 3 = Success and Failure
# 1 = Success (This is the minimum acceptable for CIS)
# 2 = Failure
# 0 = No Auditing
$desiredValue = "Success"

# Function to get the current audit policy
function Get-AuditPolicySetting {
    param($policyName)

    try {
        $currentPolicy = Get-AuditPolicy -SubCategory:$policyName -ErrorAction Stop
        return $currentPolicy.Failure, $currentPolicy.Success
    } catch {
        return $null, $null
    }
}

# Function to set the audit policy
function Set-AuditPolicySetting {
    param($policyName, [bool]$auditSuccess, [bool]$auditFailure)

    Set-AuditPolicy -SubCategory:$policyName -Success:$auditSuccess -Failure:$auditFailure
}

# Get the current audit policy
$currentFailure, $currentSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  Current Failure: $($currentFailure)"
Write-Host "  Current Success: $($currentSuccess)"

# Determine if the desired value matches the current value
$desiredSuccess = $desiredValue -in @("Success", "SuccessAndFailure")

# Set the audit policy if it's different
if ($currentSuccess -ne $desiredSuccess -or $currentSuccess -eq $null) {
    Set-AuditPolicySetting -policyName $policyName -auditSuccess $desiredSuccess -auditFailure $currentFailure # Preserve current failure setting
    Write-Host "  CIS 17.7.2: 'Audit Authentication Policy Change' is set to include Success" -ForegroundColor Green
} else {
    Write-Host "  CIS 17.7.2: 'Audit Authentication Policy Change' is already set to include Success" -ForegroundColor Green
}

# Verify the change (output new audit policy)
$newFailure, $newSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  New Failure: $($newFailure)"
Write-Host "  New Success: $($newSuccess)"


# CIS Control: 17.7.1. (L1) Ensure 'Audit Audit Policy Change' is set to include 'Success'
# In simpler terms: This setting makes Windows record in the security logs when changes are made to the system's auditing settings, and it focuses on recording when those changes are successful.

# Define the policy name and desired value
$policyName = "Audit Policy Change"
# Values:
# 3 = Success and Failure
# 1 = Success (This is the minimum acceptable for CIS)
# 2 = Failure
# 0 = No Auditing
$desiredValue = "Success"

# Function to get the current audit policy
function Get-AuditPolicySetting {
    param($policyName)

    try {
        $currentPolicy = Get-AuditPolicy -SubCategory:$policyName -ErrorAction Stop
        return $currentPolicy.Failure, $currentPolicy.Success
    } catch {
        return $null, $null
    }
}

# Function to set the audit policy
function Set-AuditPolicySetting {
    param($policyName, [bool]$auditSuccess, [bool]$auditFailure)

    Set-AuditPolicy -SubCategory:$policyName -Success:$auditSuccess -Failure:$auditFailure
}

# Get the current audit policy
$currentFailure, $currentSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  Current Failure: $($currentFailure)"
Write-Host "  Current Success: $($currentSuccess)"

# Determine if the desired value matches the current value
$desiredSuccess = $desiredValue -in @("Success", "SuccessAndFailure")

# Set the audit policy if it's different
if ($currentSuccess -ne $desiredSuccess -or $currentSuccess -eq $null) {
    Set-AuditPolicySetting -policyName $policyName -auditSuccess $desiredSuccess -auditFailure $currentFailure # Preserve current failure setting
    Write-Host "  CIS 17.7.1: 'Audit Audit Policy Change' is set to include Success" -ForegroundColor Green
} else {
    Write-Host "  CIS 17.7.1: 'Audit Audit Policy Change' is already set to include Success" -ForegroundColor Green
}

# Verify the change (output new audit policy)
$newFailure, $newSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  New Failure: $($newFailure)"
Write-Host "  New Success: $($newSuccess)"


# CIS Control: 17.5.6. (L1) Ensure 'Audit Special Logon' is set to include 'Success'
# In simpler terms: This setting makes Windows record in the security logs when special types of logins happen successfully.

# Define the policy name and desired value
$policyName = "Special Logon"
# Values:
#   3 = Success and Failure
#   1 = Success (This is the minimum acceptable for CIS)
#   2 = Failure
#   0 = No Auditing
$desiredValue = "Success"

# Function to get the current audit policy
function Get-AuditPolicySetting {
    param($policyName)

    try {
        $currentPolicy = Get-AuditPolicy -SubCategory:$policyName -ErrorAction Stop
        return $currentPolicy.Failure, $currentPolicy.Success
    } catch {
        return $null, $null
    }
}

# Function to set the audit policy
function Set-AuditPolicySetting {
    param($policyName, [bool]$auditSuccess, [bool]$auditFailure)

    Set-AuditPolicy -SubCategory:$policyName -Success:$auditSuccess -Failure:$auditFailure
}

# Get the current audit policy
$currentFailure, $currentSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  Current Failure: $($currentFailure)"
Write-Host "  Current Success: $($currentSuccess)"

# Determine if the desired value matches the current value
$desiredSuccess = $desiredValue -in @("Success", "SuccessAndFailure")

# Set the audit policy if it's different
if ($currentSuccess -ne $desiredSuccess -or $currentSuccess -eq $null) {
    Set-AuditPolicySetting -policyName $policyName -auditSuccess $desiredSuccess -auditFailure $currentFailure # Preserve current failure setting
    Write-Host "  CIS 17.5.6: 'Audit Special Logon' is set to include Success" -ForegroundColor Green
} else {
    Write-Host "  CIS 17.5.6: 'Audit Special Logon' is already set to include Success" -ForegroundColor Green
}

# Verify the change (output new audit policy)
$newFailure, $newSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  New Failure: $($newFailure)"
Write-Host "  New Success: $($newSuccess)"


# CIS Control: 17.5.4. (L1) Ensure 'Audit Logon' is set to 'Success and Failure'
# In simpler terms: This setting makes Windows record in the security logs when someone tries to log on to the computer, whether they succeed or fail.

# Define the policy name and desired value
$policyName = "Logon"
# Values:
#   3 = Success and Failure
#   1 = Success
#   2 = Failure
#   0 = No Auditing
$desiredValue = "SuccessAndFailure"

# Function to get the current audit policy
function Get-AuditPolicySetting {
    param($policyName)

    try {
        $currentPolicy = Get-AuditPolicy -SubCategory:$policyName -ErrorAction Stop
        return $currentPolicy.Failure, $currentPolicy.Success
    } catch {
        return $null, $null
    }
}

# Function to set the audit policy
function Set-AuditPolicySetting {
    param($policyName, [bool]$auditSuccess, [bool]$auditFailure)

    Set-AuditPolicy -SubCategory:$policyName -Success:$auditSuccess -Failure:$auditFailure
}

# Get the current audit policy
$currentFailure, $currentSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  Current Failure: $($currentFailure)"
Write-Host "  Current Success: $($currentSuccess)"

# Determine if the desired value matches the current value
$desiredSuccess = $desiredValue -in @("Success", "SuccessAndFailure")
$desiredFailure = $desiredValue -in @("Failure", "SuccessAndFailure")

# Set the audit policy if it's different
if ($currentFailure -ne $desiredFailure -or $currentSuccess -ne $desiredSuccess -or $currentFailure -eq $null -or $currentSuccess -eq $null) {
    Set-AuditPolicySetting -policyName $policyName -auditSuccess $desiredSuccess -auditFailure $desiredFailure
    Write-Host "  CIS 17.5.4: 'Audit Logon' is set to $desiredValue" -ForegroundColor Green
} else {
    Write-Host "  CIS 17.5.4: 'Audit Logon' is already set to $desiredValue" -ForegroundColor Green
}

# Verify the change (output new audit policy)
$newFailure, $newSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  New Failure: $($newFailure)"
Write-Host "  New Success: $($newSuccess)"


# CIS Control: 17.5.3. (L1) Ensure 'Audit Logoff' is set to include 'Success'
# In simpler terms: This setting makes Windows record in the security logs when someone successfully logs off from the computer.

# Define the policy name and desired value
$policyName = "Logoff"
# Values:
#   3 = Success and Failure
#   1 = Success (This is the minimum acceptable for CIS)
#   2 = Failure
#   0 = No Auditing
$desiredValue = "Success"

# Function to get the current audit policy
function Get-AuditPolicySetting {
    param($policyName)

    try {
        $currentPolicy = Get-AuditPolicy -SubCategory:$policyName -ErrorAction Stop
        return $currentPolicy.Failure, $currentPolicy.Success
    } catch {
        return $null, $null
    }
}

# Function to set the audit policy
function Set-AuditPolicySetting {
    param($policyName, [bool]$auditSuccess, [bool]$auditFailure)

    Set-AuditPolicy -SubCategory:$policyName -Success:$auditSuccess -Failure:$auditFailure
}

# Get the current audit policy
$currentFailure, $currentSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  Current Failure: $($currentFailure)"
Write-Host "  Current Success: $($currentSuccess)"

# Determine if the desired value matches the current value
$desiredSuccess = $desiredValue -in @("Success", "SuccessAndFailure")

# Set the audit policy if it's different
if ($currentSuccess -ne $desiredSuccess -or $currentSuccess -eq $null) {
    Set-AuditPolicySetting -policyName $policyName -auditSuccess $desiredSuccess -auditFailure $currentFailure # Preserve current failure setting
    Write-Host "  CIS 17.5.3: 'Audit Logoff' is set to include Success" -ForegroundColor Green
} else {
    Write-Host "  CIS 17.5.3: 'Audit Logoff' is already set to include Success" -ForegroundColor Green
}

# Verify the change (output new audit policy)
$newFailure, $newSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  New Failure: $($newFailure)"
Write-Host "  New Success: $($newSuccess)"


# CIS Control: 17.3.2. (L1) Ensure 'Audit Process Creation' is set to include 'Success'
# In simpler terms: This setting makes Windows record in the security logs when a new program or process is started successfully.

# Define the policy name and desired value
$policyName = "Process Creation"
# Values:
#   3 = Success and Failure
#   1 = Success (This is the minimum acceptable for CIS)
#   2 = Failure
#   0 = No Auditing
$desiredValue = "Success"

# Function to get the current audit policy
function Get-AuditPolicySetting {
    param($policyName)

    try {
        $currentPolicy = Get-AuditPolicy -SubCategory:$policyName -ErrorAction Stop
        return $currentPolicy.Failure, $currentPolicy.Success
    } catch {
        return $null, $null
    }
}

# Function to set the audit policy
function Set-AuditPolicySetting {
    param($policyName, [bool]$auditSuccess, [bool]$auditFailure)

    Set-AuditPolicy -SubCategory:$policyName -Success:$auditSuccess -Failure:$auditFailure
}

# Get the current audit policy
$currentFailure, $currentSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  Current Failure: $($currentFailure)"
Write-Host "  Current Success: $($currentSuccess)"

# Determine if the desired value matches the current value
$desiredSuccess = $desiredValue -in @("Success", "SuccessAndFailure")

# Set the audit policy if it's different
if ($currentSuccess -ne $desiredSuccess -or $currentSuccess -eq $null) {
    Set-AuditPolicySetting -policyName $policyName -auditSuccess $desiredSuccess -auditFailure $currentFailure # Preserve current failure setting
    Write-Host "  CIS 17.3.2: 'Audit Process Creation' is set to include Success" -ForegroundColor Green
} else {
    Write-Host "  CIS 17.3.2: 'Audit Process Creation' is already set to include Success" -ForegroundColor Green
}

# Verify the change (output new audit policy)
$newFailure, $newSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  New Failure: $($newFailure)"
Write-Host "  New Success: $($newSuccess)"


# CIS Control: 17.2.3. (L1) Ensure 'Audit User Account Management' is set to 'Success and Failure'
# In simpler terms: This setting makes Windows record in the security logs when changes are made to user accounts (like creating, deleting, or changing passwords), both when those changes work and when they fail.

# Define the policy name and desired value
$policyName = "User Account Management"
# Values:
#   3 = Success and Failure
#   1 = Success
#   2 = Failure
#   0 = No Auditing
$desiredValue = "SuccessAndFailure"

# Function to get the current audit policy
function Get-AuditPolicySetting {
    param($policyName)

    try {
        $currentPolicy = Get-AuditPolicy -SubCategory:$policyName -ErrorAction Stop
        return $currentPolicy.Failure, $currentPolicy.Success
    } catch {
        return $null, $null
    }
}

# Function to set the audit policy
function Set-AuditPolicySetting {
    param($policyName, [bool]$auditSuccess, [bool]$auditFailure)

    Set-AuditPolicy -SubCategory:$policyName -Success:$auditSuccess -Failure:$auditFailure
}

# Get the current audit policy
$currentFailure, $currentSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  Current Failure: $($currentFailure)"
Write-Host "  Current Success: $($currentSuccess)"

# Determine if the desired value matches the current value
$desiredSuccess = $desiredValue -in @("Success", "SuccessAndFailure")
$desiredFailure = $desiredValue -in @("Failure", "SuccessAndFailure")

# Set the audit policy if it's different
if ($currentFailure -ne $desiredFailure -or $currentSuccess -ne $desiredSuccess -or $currentFailure -eq $null -or $currentSuccess -eq $null) {
    Set-AuditPolicySetting -policyName $policyName -auditSuccess $desiredSuccess -auditFailure $desiredFailure
    Write-Host "  CIS 17.2.3: 'Audit User Account Management' is set to $desiredValue" -ForegroundColor Green
} else {
    Write-Host "  CIS 17.2.3: 'Audit User Account Management' is already set to $desiredValue" -ForegroundColor Green
}

# Verify the change (output new audit policy)
$newFailure, $newSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  New Failure: $($newFailure)"
Write-Host "  New Success: $($newSuccess)"


# CIS Control: 17.2.2. (L1) Ensure 'Audit Security Group Management' is set to include 'Success'
# In simpler terms: This setting makes Windows record in the security logs when changes are made to security groups (like adding or removing members), and it focuses on recording when those changes are successful.

# Define the policy name and desired value
$policyName = "Security Group Management"
# Values:
#   3 = Success and Failure
#   1 = Success (This is the minimum acceptable for CIS)
#   2 = Failure
#   0 = No Auditing
$desiredValue = "Success"

# Function to get the current audit policy
function Get-AuditPolicySetting {
    param($policyName)

    try {
        $currentPolicy = Get-AuditPolicy -SubCategory:$policyName -ErrorAction Stop
        return $currentPolicy.Failure, $currentPolicy.Success
    } catch {
        return $null, $null
    }
}

# Function to set the audit policy
function Set-AuditPolicySetting {
    param($policyName, [bool]$auditSuccess, [bool]$auditFailure)

    Set-AuditPolicy -SubCategory:$policyName -Success:$auditSuccess -Failure:$auditFailure
}

# Get the current audit policy
$currentFailure, $currentSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  Current Failure: $($currentFailure)"
Write-Host "  Current Success: $($currentSuccess)"

# Determine if the desired value matches the current value
$desiredSuccess = $desiredValue -in @("Success", "SuccessAndFailure")

# Set the audit policy if it's different
if ($currentSuccess -ne $desiredSuccess -or $currentSuccess -eq $null) {
    Set-AuditPolicySetting -policyName $policyName -auditSuccess $desiredSuccess -auditFailure $currentFailure # Preserve current failure setting
    Write-Host "  CIS 17.2.2: 'Audit Security Group Management' is set to include Success" -ForegroundColor Green
} else {
    Write-Host "  CIS 17.2.2: 'Audit Security Group Management' is already set to include Success" -ForegroundColor Green
}

# Verify the change (output new audit policy)
$newFailure, $newSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  New Failure: $($newFailure)"
Write-Host "  New Success: $($newSuccess)"



# CIS Control: 17.1.1. (L1) Ensure 'Audit Credential Validation' is set to 'Success and Failure'
# In simpler terms: This setting makes Windows record in the security logs when the system tries to verify someone's login information (like a username and password), whether it works or not.

# Define the policy name and desired value
$policyName = "Credential Validation"
# Values:
#   3 = Success and Failure
#   1 = Success
#   2 = Failure
#   0 = No Auditing
$desiredValue = "SuccessAndFailure"

# Function to get the current audit policy
function Get-AuditPolicySetting {
    param($policyName)

    try {
        $currentPolicy = Get-AuditPolicy -SubCategory:$policyName -ErrorAction Stop
        return $currentPolicy.Failure, $currentPolicy.Success
    } catch {
        return $null, $null
    }
}

# Function to set the audit policy
function Set-AuditPolicySetting {
    param($policyName, [bool]$auditSuccess, [bool]$auditFailure)

    Set-AuditPolicy -SubCategory:$policyName -Success:$auditSuccess -Failure:$auditFailure
}

# Get the current audit policy
$currentFailure, $currentSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  Current Failure: $($currentFailure)"
Write-Host "  Current Success: $($currentSuccess)"

# Determine if the desired value matches the current value
$desiredSuccess = $desiredValue -in @("Success", "SuccessAndFailure")
$desiredFailure = $desiredValue -in @("Failure", "SuccessAndFailure")

# Set the audit policy if it's different
if ($currentFailure -ne $desiredFailure -or $currentSuccess -ne $desiredSuccess -or $currentFailure -eq $null -or $currentSuccess -eq $null) {
    Set-AuditPolicySetting -policyName $policyName -auditSuccess $desiredSuccess -auditFailure $desiredFailure
    Write-Host "  CIS 17.1.1: 'Audit Credential Validation' is set to $desiredValue" -ForegroundColor Green
} else {
    Write-Host "  CIS 17.1.1: 'Audit Credential Validation' is already set to $desiredValue" -ForegroundColor Green
}

# Verify the change (output new audit policy)
$newFailure, $newSuccess = Get-AuditPolicySetting -policyName $policyName

Write-Host "  New Failure: $($newFailure)"
Write-Host "  New Success: $($newSuccess)"

