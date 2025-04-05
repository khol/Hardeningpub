# CIS Control: 2.3.9.4. (L1) Ensure 'Microsoft network server: Disconnect clients when logon hours expire' is set to 'Enabled'
# In simpler terms: This setting forces users to be disconnected from the server when the times they're allowed to be logged in are over.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
$valueName = "EnableForcedLogoff"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.9.4: 'Disconnect clients when logon hours expire' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.9.4: 'Disconnect clients when logon hours expire' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"

# CIS Control: 2.3.9.1. (L1) Ensure 'Microsoft network server: Amount of idle time required before suspending session' is set to '15 or fewer minute(s)'
# In simpler terms: This setting makes the server disconnect inactive users after 15 minutes or less of inactivity.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
$valueName = "Autodisconnect"
# The value is in minutes. -1 means never disconnect.
$desiredValue = 15
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue (minutes)"

# Set the desired value if it's different or greater than 15
if ($currentValue -gt $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.9.1: 'Amount of idle time before suspending session' set to 15 minutes" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.9.1: 'Amount of idle time before suspending session' is already 15 minutes or less" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue (minutes)"

# CIS Control: 2.3.8.3. (L1) Ensure 'Microsoft network client: Send unencrypted password to third-party SMB servers' is set to 'Disabled'
# In simpler terms: This setting prevents your computer from sending your password without encryption to some older file servers.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"
$valueName = "EnablePlainTextPassword"
$desiredValue = 0  # 0 = Disabled, 1 = Enabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.8.3: 'Send unencrypted password to third-party SMB servers' set to Disabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.8.3: 'Send unencrypted password to third-party SMB servers' is already Disabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.8.2. (L1) Ensure 'Microsoft network client: Digitally sign communications (if server agrees)' is set to 'Enabled'
# In simpler terms: This setting tells your computer to use digital signatures to verify data sent to file servers, if the server supports it.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"
$valueName = "RequireSecureNegotiate"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.8.2: 'Digitally sign communications (if server agrees)' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.8.2: 'Digitally sign communications (if server agrees)' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.7.8. (L1) Ensure 'Interactive logon: Prompt user to change password before expiration' is set to 'between 5 and 14 days'
# In simpler terms: This setting makes Windows warn users to change their password a few days before it expires.

# Define the registry key and value
$registryKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$valueName = "PasswordExpiryWarning"
# The value is in days.
$minValue = 5
$maxValue = 14
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue (days)"

# Set the desired value if it's outside the acceptable range or doesn't exist
if ($currentValue -lt $minValue -or $currentValue -gt $maxValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $maxValue -Type $valueType -Force
    Write-Host "  CIS 2.3.7.8: 'Prompt user to change password before expiration' set to $maxValue days" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.7.8: 'Prompt user to change password before expiration' is already between 5 and 14 days" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue (days)"


# CIS Control: 2.3.6.6. (L1) Ensure 'Domain member: Require strong (Windows 2000 or later) session key' is set to 'Enabled'
# In simpler terms: This setting makes sure your computer uses strong encryption when talking to domain controllers.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\LMCompatibility Level"
$valueName = "LmCompatibilityLevel"
# The value 5 enforces strong session keys.
$desiredValue = 5
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.6.6: 'Require strong (Windows 2000 or later) session key' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.6.6: 'Require strong (Windows 2000 or later) session key' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.6.5. (L1) Ensure 'Domain member: Maximum machine account password age' is set to '30 or fewer days, but not 0'
# In simpler terms: This setting forces domain-joined computers to change their passwords regularly.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
$valueName = "MaximumPasswordAge"
# The value is in days.
$minValue = 1
$maxValue = 30
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue (days)"

# Set the desired value if it's outside the acceptable range or doesn't exist
if ($currentValue -gt $maxValue -or $currentValue -lt $minValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $maxValue -Type $valueType -Force
    Write-Host "  CIS 2.3.6.5: 'Maximum machine account password age' set to $maxValue days" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.6.5: 'Maximum machine account password age' is already between 1 and 30 days" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue (days)"


# CIS Control: 2.3.6.4. (L1) Ensure 'Domain member: Disable machine account password changes' is set to 'Disabled'
# In simpler terms: This setting makes sure that computers in a domain *are allowed* to change their passwords automatically.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
$valueName = "DisablePasswordChange"
$desiredValue = 0  # 0 = Disabled (allowed), 1 = Enabled (disallowed)
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.6.4: 'Disable machine account password changes' set to Disabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.6.4: 'Disable machine account password changes' is already Disabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.6.3. (L1) Ensure 'Domain member: Digitally sign secure channel data (when possible)' is set to 'Enabled'
# In simpler terms: This setting tells your computer to use digital signatures to verify data when talking to the domain controller, if it can.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
$valueName = "RequireSignOrSeal"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.6.3: 'Digitally sign secure channel data (when possible)' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.6.3: 'Digitally sign secure channel data (when possible)' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.6.2. (L1) Ensure 'Domain member: Digitally encrypt secure channel data (when possible)' is set to 'Enabled'
# In simpler terms: This setting tells your computer to encrypt the data it sends to the domain controller, if it can.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
$valueName = "RequireSeal"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.6.2: 'Digitally encrypt secure channel data (when possible)' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.6.2: 'Digitally encrypt secure channel data (when possible)' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.6.1. (L1) Ensure 'Domain member: Digitally encrypt or sign secure channel data (always)' is set to 'Enabled'
# In simpler terms: This setting forces your computer to *always* encrypt or sign the data it sends to the domain controller.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
$valueName = "RequireStrongKey"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.6.1: 'Digitally encrypt or sign secure channel data (always)' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.6.1: 'Digitally encrypt or sign secure channel data (always)' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.2.2. (L1) Ensure 'Audit: Shut down system immediately if unable to log security audits' is set to 'Disabled'
# In simpler terms: This setting controls whether the computer shuts down if it can't save security logs. We want it disabled so the computer doesn't shut down unexpectedly.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$valueName = "CrashOnAuditFail"
$desiredValue = 0  # 0 = Disabled, 1 = Enabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.2.2: 'Audit: Shut down system immediately if unable to log security audits' set to Disabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.2.2: 'Audit: Shut down system immediately if unable to log security audits' is already Disabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.17.8. (L1) Ensure 'User Account Control: Virtualize file and registry write failures to per-user locations' is set to 'Enabled'
# In simpler terms: This setting makes sure that when programs try to save files or settings to protected areas, Windows saves them to a special folder for that user instead, so the program doesn't break.

# Define the registry key and value
$registryKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$valueName = "EnableVirtualization"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.17.8: 'User Account Control: Virtualize file and registry write failures to per-user locations' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.17.8: 'User Account Control: Virtualize file and registry write failures to per-user locations' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.17.7. (L1) Ensure 'User Account Control: Switch to the secure desktop when prompting for elevation' is set to 'Enabled'
# In simpler terms: This setting makes Windows show the UAC (User Account Control) prompt on a special, safer version of your desktop.

# Define the registry key and value
$registryKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$valueName = "PromptOnSecureDesktop"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.17.7: 'User Account Control: Switch to the secure desktop when prompting for elevation' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.17.7: 'User Account Control: Switch to the secure desktop when prompting for elevation' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"



# CIS Control: 2.3.17.6. (L1) Ensure 'User Account Control: Run all administrators in Admin Approval Mode' is set to 'Enabled'
# In simpler terms: This setting makes even administrators use User Account Control (UAC) prompts, just like regular users.

# Define the registry key and value
$registryKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$valueName = "EnableLUA"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.17.6: 'User Account Control: Run all administrators in Admin Approval Mode' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.17.6: 'User Account Control: Run all administrators in Admin Approval Mode' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.17.5. (L1) Ensure 'User Account Control: Only elevate UIAccess applications that are installed in secure locations' is set to 'Enabled'
# In simpler terms: This setting makes sure that only programs designed to help people with disabilities (UIAccess applications) can bypass some UAC security if they're installed in a safe place on your computer.

# Define the registry key and value
$registryKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$valueName = "UIAccessControl"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.17.5: 'User Account Control: Only elevate UIAccess applications that are installed in secure locations' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.17.5: 'User Account Control: Only elevate UIAccess applications that are installed in secure locations' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.17.4. (L1) Ensure 'User Account Control: Detect application installations and prompt for elevation' is set to 'Enabled'
# In simpler terms: This setting makes User Account Control (UAC) show a prompt and ask for permission when you try to install a program.

# Define the registry key and value
$registryKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$valueName = "PromptOnInstall"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.17.4: 'User Account Control: Detect application installations and prompt for elevation' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.17.4: 'User Account Control: Detect application installations and prompt for elevation' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.15.2. (L1) Ensure 'System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)' is set to 'Enabled'
# In simpler terms: This setting makes Windows apply stricter security rules to important internal parts of the system, like symbolic links, to make it harder for attackers to exploit them.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\ProtectionMode"
$valueName = "EnableObjectDirectoryHardening"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.15.2: 'System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.15.2: 'System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.15.1. (L1) Ensure 'System objects: Require case insensitivity for non-Windows subsystems' is set to 'Enabled'
# In simpler terms: This setting makes Windows treat uppercase and lowercase letters the same way when programs from other operating systems (like Linux) try to access files.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel"
$valueName = "obcaseinsensitive"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.15.1: 'System objects: Require case insensitivity for non-Windows subsystems' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.15.1: 'System objects: Require case insensitivity for non-Windows subsystems' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.11.8. (L1) Ensure 'Network security: LDAP client signing requirements' is set to 'Negotiate signing' or higher
# In simpler terms: This setting tells your computer how strongly it needs to verify the data it receives from servers using the LDAP protocol (which is used for things like Active Directory).

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Services\LDAP"
$valueName = "LDAPClientIntegrity"
# Values:
# 2 = Require signing
# 1 = Negotiate signing (this is the minimum acceptable for CIS)
# 0 = None
$desiredValue = 1
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's lower than the minimum
if ($currentValue -lt $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.11.8: 'Network security: LDAP client signing requirements' set to Negotiate signing" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.11.8: 'Network security: LDAP client signing requirements' is already Negotiate signing or higher" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.11.7. (L1) Ensure 'Network security: LAN Manager authentication level' is set to 'Send NTLMv2 response only. Refuse LM & NTLM'
# In simpler terms: This setting tells your computer to use the most secure way of proving your identity when connecting to other computers on the network.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\LMCompatibility Level"
$valueName = "LmCompatibilityLevel"
# Values:
# 5 = Send NTLMv2 response only. Refuse LM & NTLM (This is the CIS recommended value)
# ... other values represent less secure settings ...
$desiredValue = 5
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.11.7: 'Network security: LAN Manager authentication level' set to Send NTLMv2 response only. Refuse LM & NTLM" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.11.7: 'Network security: LAN Manager authentication level' is already set to Send NTLMv2 response only. Refuse LM & NTLM" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.11.6. (L1) Ensure 'Network security: Force logoff when logon hours expire' is set to 'Enabled'
# In simpler terms: This setting makes Windows automatically log users off when the times they're allowed to be logged in are over.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$valueName = "ForceLogoffWhenLogonHoursExpire"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.11.6: 'Network security: Force logoff when logon hours expire' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.11.6: 'Network security: Force logoff when logon hours expire' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.11.5. (L1) Ensure 'Network security: Do not store LAN Manager hash value on next password change' is set to 'Enabled'
# In simpler terms: This setting stops your computer from saving a very old and weak version of your password when you change it.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$valueName = "NoLMHash"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.11.5: 'Network security: Do not store LAN Manager hash value on next password change' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.11.5: 'Network security: Do not store LAN Manager hash value on next password change' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.10.9. (L1) Ensure 'Network access: Restrict anonymous access to Named Pipes and Shares' is set to 'Enabled'
# In simpler terms: This setting stops people from accessing certain computer resources over the network without logging in.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
$valueName = "NullSessionPipes"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

$registryKey2 = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
$valueName2 = "NullSessionShares"
$desiredValue2 = 1  # 1 = Enabled, 0 = Disabled
$valueType2 = "DWORD"

# Get the current value for NullSessionPipes
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value for NullSessionPipes: $currentValue"

# Set the desired value for NullSessionPipes if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.10.9: 'Network access: Restrict anonymous access to Named Pipes' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.10.9: 'Network access: Restrict anonymous access to Named Pipes' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value) for NullSessionPipes
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value for NullSessionPipes: $newValue"

# Get the current value for NullSessionShares
$currentValue2 = Get-ItemPropertyValue -Path $registryKey2 -Name $valueName2 -ErrorAction SilentlyContinue

Write-Host "  Current Value for NullSessionShares: $currentValue2"

# Set the desired value for NullSessionShares if it's different
if ($currentValue2 -ne $desiredValue2 -or $currentValue2 -eq $null) {
    Set-ItemPropertyValue -Path $registryKey2 -Name $valueName2 -Value $desiredValue2 -Type $valueType2 -Force
    Write-Host "  CIS 2.3.10.9: 'Network access: Restrict anonymous access to Named Shares' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.10.9: 'Network access: Restrict anonymous access to Named Shares' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value) for NullSessionShares
$newValue2 = Get-ItemPropertyValue -Path $registryKey2 -Name $valueName2 -ErrorAction SilentlyContinue

Write-Host "  New Value for NullSessionShares: $newValue2"


# CIS Control: 2.3.10.8. (L1) Ensure 'Network access: Remotely accessible registry paths and sub-paths' is configured
# In simpler terms: This setting controls which parts of your computer's settings (the registry) can be accessed from other computers on the network.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$valueName = "NullSessionRegistry"
$valueType = "MultiString"

# Define the desired value (an array of registry paths that should be allowed)
$desiredValue = @(
    "MACHINE\System\CurrentControlSet\Control\Lsa\Data",
    "MACHINE\System\CurrentControlSet\Control\ProductOptions",
    "MACHINE\System\CurrentControlSet\Control\Print",
    "MACHINE\System\CurrentControlSet\Services\EventLog",
    "MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
)

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $($currentValue -join ', ')"

# Function to compare arrays (case-insensitive)
function Compare-Arrays {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array2.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Set the desired value if it's different
if (-not (Compare-Arrays $currentValue $desiredValue) -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.10.8: 'Network access: Remotely accessible registry paths and sub-paths' configured" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.10.8: 'Network access: Remotely accessible registry paths and sub-paths' is already configured correctly" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $($newValue -join ', ')"


# CIS Control: 2.3.10.7. (L1) Ensure 'Network access: Remotely accessible registry paths' is configured
# In simpler terms: This setting controls which parts of your computer's settings (the registry) can be accessed from other computers on the network.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$valueName = "AccessiblePaths"
$valueType = "MultiString"

# Define the desired value (an array of registry paths that should be allowed)
$desiredValue = @(
    "System\CurrentControlSet\Control\Lsa\Secrets",
    "System\CurrentControlSet\Control\SecurityProviders",
    "System\CurrentControlSet\Control\Terminal Server",
    "System\CurrentControlSet\Control\Terminal Server\WinStations",
    "System\CurrentControlSet\Services\LanmanServer",
    "System\CurrentControlSet\Services\LanmanWorkstation",
    "System\CurrentControlSet\Services\Netlogon",
    "System\CurrentControlSet\Services\RemoteAccess",
    "System\CurrentControlSet\Services\Sam"
)

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $($currentValue -join ', ')"

# Function to compare arrays (case-insensitive)
function Compare-Arrays {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array2.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Set the desired value if it's different
if (-not (Compare-Arrays $currentValue $desiredValue) -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.10.7: 'Network access: Remotely accessible registry paths' configured" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.10.7: 'Network access: Remotely accessible registry paths' is already configured correctly" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $($newValue -join ', ')"


# CIS Control: 2.3.10.6. (L1) Ensure 'Network access: Named Pipes that can be accessed anonymously' is set to 'None'
# In simpler terms: This setting controls which "Named Pipes" (a way for programs to talk to each other) can be accessed without someone logging in. We want to block this.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
$valueName = "NullSessionPipes"
$valueType = "MultiString"

# Define the desired value (an empty array, meaning no anonymous access)
$desiredValue = @()

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $($currentValue -join ', ')"

# Function to compare arrays (case-insensitive)
function Compare-Arrays {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array2.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Set the desired value if it's different
if (-not (Compare-Arrays $currentValue $desiredValue) -or $currentValue -ne $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.10.6: 'Network access: Named Pipes that can be accessed anonymously' set to None" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.10.6: 'Network access: Named Pipes that can be accessed anonymously' is already set to None" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $($newValue -join ', ')"


# CIS Control: 2.3.10.5. (L1) Ensure 'Network access: Let Everyone permissions apply to anonymous users' is set to 'Disabled'
# In simpler terms: This setting controls whether network permissions given to the "Everyone" group also apply to people who haven't logged in. We want to prevent this.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$valueName = "EveryoneIncludesAnonymous"
$desiredValue = 0  # 0 = Disabled, 1 = Enabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.10.5: 'Network access: Let Everyone permissions apply to anonymous users' set to Disabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.10.5: 'Network access: Let Everyone permissions apply to anonymous users' is already Disabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.10.2. (L1) Ensure 'Network access: Do not allow anonymous enumeration of SAM accounts' is set to 'Enabled'
# In simpler terms: This setting stops people from listing the names of user accounts on your computer without logging in.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$valueName = "RestrictAnonymousSAM"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.10.2: 'Network access: Do not allow anonymous enumeration of SAM accounts' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.10.2: 'Network access: Do not allow anonymous enumeration of SAM accounts' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.10.12. (L1) Ensure 'Network access: Sharing and security model for local accounts' is set to 'Classic - local users authenticate as themselves'
# In simpler terms: This setting controls how your computer handles security when people on the network try to access shared resources. "Classic" is the more secure option.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$valueName = "ForceGuest"
$desiredValue = 0  # 0 = Classic, 1 = Guest-only
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.10.12: 'Network access: Sharing and security model for local accounts' set to Classic" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.10.12: 'Network access: Sharing and security model for local accounts' is already set to Classic" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.10.11. (L1) Ensure 'Network access: Shares that can be accessed anonymously' is set to 'None'
# In simpler terms: This setting controls which shared folders on your computer can be accessed by people on the network without logging in. We want to block this.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
$valueName = "NullSessionShares"
$valueType = "MultiString"

# Define the desired value (an empty array, meaning no anonymous access)
$desiredValue = @()

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $($currentValue -join ', ')"

# Function to compare arrays (case-insensitive)
function Compare-Arrays {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array2.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Set the desired value if it's different
if (-not (Compare-Arrays $currentValue $desiredValue) -or $currentValue -ne $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.10.11: 'Network access: Shares that can be accessed anonymously' set to None" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.10.11: 'Network access: Shares that can be accessed anonymously' is already set to None" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $($newValue -join ', ')"


# CIS Control: 2.3.1.3. (L1) Ensure 'Accounts: Limit local account use of blank passwords to console logon only' is set to 'Enabled'
# In simpler terms: This setting stops local accounts (accounts created on this computer) from logging in without a password over the network.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$valueName = "LimitBlankPasswordUse"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.1.3: 'Accounts: Limit local account use of blank passwords to console logon only' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.1.3: 'Accounts: Limit local account use of blank passwords to console logon only' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.3.1.2. (L1) Ensure 'Accounts: Guest account status' is set to 'Disabled'
# In simpler terms: This setting turns off the "Guest" account, which is a special account that allows people to use the computer without logging in.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$valueName = "GuestAccountStatus"
$desiredValue = 0  # 0 = Disabled, 1 = Enabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.3.1.2: 'Accounts: Guest account status' set to Disabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.3.1.2: 'Accounts: Guest account status' is already Disabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 2.2.9. (L1) Ensure 'Change the time zone' is set to 'Administrators, LOCAL SERVICE, Users'
# In simpler terms: This setting controls who is allowed to change the computer's time zone.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"

# Define the desired permissions
$desiredPermissions = @(
    @{ Identity = "Administrators"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" },
    @{ Identity = "LOCAL SERVICE"; FileSystemRights = "Read"; InheritanceFlags = "None"; PropagationFlags = "None" },
    @{ Identity = "Users"; FileSystemRights = "Read"; InheritanceFlags = "None"; PropagationFlags = "None" }
)

# Function to compare ACLs
function Compare-Acls {
    param (
        [System.Security.AccessControl.ObjectAccessRule[]]$CurrentAcls,
        [hashtable[]]$DesiredAcls
    )

    if ($CurrentAcls.Count -ne $DesiredAcls.Count) {
        return $false
    }

    for ($i = 0; $i -lt $DesiredAcls.Count; $i++) {
        $desired = $DesiredAcls[$i]
        $found = $false
        foreach ($current in $CurrentAcls) {
            if ($current.IdentityReference.Value -ieq $desired.Identity -and
                $current.FileSystemRights -eq $desired.FileSystemRights -and
                $current.InheritanceFlags -eq $desired.InheritanceFlags -and
                $current.PropagationFlags -eq $desired.PropagationFlags) {
                $found = $true
                break
            }
        }
        if (-not $found) {
            return $false
        }
    }
    return $true
}

# Get the current ACL
$acl = Get-Acl -Path $registryKey
$currentAcls = $acl.Access

Write-Host "  Current Permissions:"
foreach ($ace in $currentAcls) {
    Write-Host "    $($ace.IdentityReference.Value) : $($ace.FileSystemRights)"
}

# Convert desired permissions to ObjectAccessRule objects
$desiredAccessRules = @()
foreach ($permission in $desiredPermissions) {
    $identity = New-Object System.Security.Principal.NTAccount($permission.Identity)
    $accessRule = New-Object System.Security.AccessControl.RegistryAccessRule(
        $identity,
        $permission.FileSystemRights,
        $permission.InheritanceFlags,
        $permission.PropagationFlags,
        "Allow"
    )
    $desiredAccessRules += $accessRule
}

# Set the desired ACL if it's different
if (-not (Compare-Acls $currentAcls $desiredAccessRules)) {
    $acl.SetAccessRulesProtect = $true  # Prevent inheritance
    $acl.Access.Clear()
    $acl.Access.Add($desiredAccessRules)
    Set-Acl -Path $registryKey -AclObject $acl
    Write-Host "  CIS 2.2.9: 'Change the time zone' permissions configured" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.9: 'Change the time zone' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new ACL)
$newAcl = Get-Acl -Path $registryKey
$newAcls = $newAcl.Access

Write-Host "  New Permissions:"
foreach ($ace in $newAcls) {
    Write-Host "    $($ace.IdentityReference.Value) : $($ace.FileSystemRights)"
}



# CIS Control: 2.2.8. (L1) Ensure 'Change the system time' is set to 'Administrators, LOCAL SERVICE'
# In simpler terms: This setting controls who is allowed to change the computer's time.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"

# Define the desired permissions
$desiredPermissions = @(
    @{ Identity = "Administrators"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" },
    @{ Identity = "LOCAL SERVICE"; FileSystemRights = "Read"; InheritanceFlags = "None"; PropagationFlags = "None" }
)

# Function to compare ACLs
function Compare-Acls {
    param (
        [System.Security.AccessControl.ObjectAccessRule[]]$CurrentAcls,
        [hashtable[]]$DesiredAcls
    )

    if ($CurrentAcls.Count -ne $DesiredAcls.Count) {
        return $false
    }

    for ($i = 0; $i -lt $DesiredAcls.Count; $i++) {
        $desired = $DesiredAcls[$i]
        $found = $false
        foreach ($current in $CurrentAcls) {
            if ($current.IdentityReference.Value -ieq $desired.Identity -and
                $current.FileSystemRights -eq $desired.FileSystemRights -and
                $current.InheritanceFlags -eq $desired.InheritanceFlags -and
                $current.PropagationFlags -eq $desired.PropagationFlags) {
                $found = $true
                break
            }
        }
        if (-not $found) {
            return $false
        }
    }
    return $true
}

# Get the current ACL
$acl = Get-Acl -Path $registryKey
$currentAcls = $acl.Access

Write-Host "  Current Permissions:"
foreach ($ace in $currentAcls) {
    Write-Host "    $($ace.IdentityReference.Value) : $($ace.FileSystemRights)"
}

# Convert desired permissions to ObjectAccessRule objects
$desiredAccessRules = @()
foreach ($permission in $desiredPermissions) {
    $identity = New-Object System.Security.Principal.NTAccount($permission.Identity)
    $accessRule = New-Object System.Security.AccessControl.RegistryAccessRule(
        $identity,
        $permission.FileSystemRights,
        $permission.InheritanceFlags,
        $permission.PropagationFlags,
        "Allow"
    )
    $desiredAccessRules += $accessRule
}

# Set the desired ACL if it's different
if (-not (Compare-Acls $currentAcls $desiredAccessRules)) {
    $acl.SetAccessRulesProtect = $true  # Prevent inheritance
    $acl.Access.Clear()
    $acl.Access.Add($desiredAccessRules)
    Set-Acl -Path $registryKey -AclObject $acl
    Write-Host "  CIS 2.2.8: 'Change the system time' permissions configured" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.8: 'Change the system time' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new ACL)
$newAcl = Get-Acl -Path $registryKey
$newAcls = $newAcl.Access

Write-Host "  New Permissions:"
foreach ($ace in $newAcls) {
    Write-Host "    $($ace.IdentityReference.Value) : $($ace.FileSystemRights)"
}


# CIS Control: 2.2.6. (L1) Ensure 'Allow log on through Remote Desktop Services' is set to 'Administrators, Remote Desktop Users'
# In simpler terms: This setting controls who is allowed to connect to the computer using Remote Desktop.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
$valueName = "UserAuthentication"
$desiredValue = 1  # 1 = Enabled (required authentication)
$valueType = "DWORD"

# First, ensure that UserAuthentication is enabled (a prerequisite for correctly setting permissions)
# Get the current value for UserAuthentication
$currentUserAuthentication = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value for UserAuthentication: $currentUserAuthentication"

# Set UserAuthentication to 1 (Enabled) if it's not already
if ($currentUserAuthentication -ne $desiredValue -or $currentUserAuthentication -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 2.2.6: UserAuthentication set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.6: UserAuthentication is already Enabled" -ForegroundColor Green
}

# Verify the change for UserAuthentication
$newUserAuthentication = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
Write-Host "  New Value for UserAuthentication: $newUserAuthentication"

# Define the security descriptor (SD) for the RDP-Tcp connection
$desiredSDDL = "D:(D;;DCL;;;WD)(D;;DCCA;;;IU)(A;;CCLCRPWDTLOCRRC;;;BA)(A;;CCLCRPWDTLOCRRC;;;SY)(A;;CCLCRPWLOCR;;;LS)(A;;CCLCRPWLOCR;;;S-1-5-32-555)"

# Function to get the current security descriptor
function Get-RdpSecurityDescriptor {
    param($registryKey)

    $sdValue = Get-ItemPropertyValue -Path $registryKey -Name "SecurityLayer" -ErrorAction SilentlyContinue
    if ($sdValue) {
        return $sdValue
    } else {
        return "" # Return an empty string if the value is not found
    }
}

# Function to set the security descriptor
function Set-RdpSecurityDescriptor {
    param($registryKey, $sddl)

    Set-ItemPropertyValue -Path $registryKey -Name "SecurityLayer" -Value $sddl -Type "String" -Force
}

# Get the current security descriptor
$currentSDDL = Get-RdpSecurityDescriptor -registryKey $registryKey

Write-Host "  Current Security Descriptor: $currentSDDL"

# Set the security descriptor if it's different
if ($currentSDDL -ne $desiredSDDL -or -not $currentSDDL) { # Check for null or empty
    Set-RdpSecurityDescriptor -registryKey $registryKey -sddl $desiredSDDL
    Write-Host "  CIS 2.2.6: 'Allow log on through Remote Desktop Services' permissions configured" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.6: 'Allow log on through Remote Desktop Services' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new security descriptor)
$newSDDL = Get-RdpSecurityDescriptor -registryKey $registryKey

Write-Host "  New Security Descriptor: $newSDDL"


# CIS Control: 2.2.4. (L1) Ensure 'Adjust memory quotas for a process' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE'
# In simpler terms: This setting controls who is allowed to change how much memory a program can use.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identities
$valueName = "SeIncreaseQuotaPrivilege"
$desiredIdentities = @("BUILTIN\Administrators", "NT AUTHORITY\LOCAL SERVICE", "NT AUTHORITY\NETWORK SERVICE")

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array2.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentities) -or !$currentAccounts) { # Check for null or empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentities
    Write-Host "  CIS 2.2.4: 'Adjust memory quotas for a process' permissions configured" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.4: 'Adjust memory quotas for a process' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.39. (L1) Ensure 'Take ownership of files or other objects' is set to 'Administrators'
# In simpler terms: This setting controls who is allowed to become the owner of files and folders. We want to limit this to administrators.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identity
$valueName = "SeTakeOwnershipPrivilege"
$desiredIdentity = @("BUILTIN\Administrators")

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array2.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentity) -or !$currentAccounts) { # Check for null or empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentity
    Write-Host "  CIS 2.2.39: 'Take ownership of files or other objects' permissions configured" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.39: 'Take ownership of files or other objects' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.36. (L1) Ensure 'Replace a process level token' is set to 'LOCAL SERVICE, NETWORK SERVICE'
# In simpler terms: This setting controls which system services are allowed to use a special way of getting access to resources. We want to limit this to specific, trusted services.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identities
$valueName = "SeAssignPrimaryTokenPrivilege"
$desiredIdentities = @("NT AUTHORITY\LOCAL SERVICE", "NT AUTHORITY\NETWORK SERVICE")

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentities) -or !$currentAccounts) { # Check for null or empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentities
    Write-Host "  CIS 2.2.36: 'Replace a process level token' permissions configured" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.36: 'Replace a process level token' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.35. (L1) Ensure 'Profile system performance' is set to 'Administrators, NT SERVICE\WdiServiceHost'
# In simpler terms: This setting controls who is allowed to collect detailed information about how the system is performing.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identities
$valueName = "SeSystemProfilePrivilege"
$desiredIdentities = @("BUILTIN\Administrators", "NT SERVICE\WdiServiceHost")

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentities) -or !$currentAccounts) { # Check for null or empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentities
    Write-Host "  CIS 2.2.35: 'Profile system performance' permissions configured" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.35: 'Profile system performance' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.34. (L1) Ensure 'Profile single process' is set to 'Administrators'
# In simpler terms: This setting controls who is allowed to collect detailed information about how a single program is running.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identity
$valueName = "SeProfileSingleProcessPrivilege"
$desiredIdentity = @("BUILTIN\Administrators")

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentity) -or !$currentAccounts) { # Check for null or empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentity
    Write-Host "  CIS 2.2.34: 'Profile single process' permissions configured" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.34: 'Profile single process' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.33. (L1) Ensure 'Perform volume maintenance tasks' is set to 'Administrators'
# In simpler terms: This setting controls who is allowed to do things like defragmenting hard drives or checking them for errors.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identity
$valueName = "SeManageVolumePrivilege"
$desiredIdentity = @("BUILTIN\Administrators")

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentity) -or !$currentAccounts) { # Check for null or empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentity
    Write-Host "  CIS 2.2.33: 'Perform volume maintenance tasks' permissions configured" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.33: 'Perform volume maintenance tasks' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.32. (L1) Ensure 'Modify firmware environment values' is set to 'Administrators'
# In simpler terms: This setting controls who is allowed to change settings in the computer's firmware (the software that starts the computer).

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identity
$valueName = "SeSystemEnvironmentPrivilege"
$desiredIdentity = @("BUILTIN\Administrators")

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentity) -or !$currentAccounts) { # Check for null or empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentity
    Write-Host "  CIS 2.2.32: 'Modify firmware environment values' permissions configured" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.32: 'Modify firmware environment values' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"



# CIS Control: 2.2.31. (L1) Ensure 'Modify an object label' is set to 'No One'
# In simpler terms: This setting controls who is allowed to change the security labels on files and other system objects. We want to prevent anyone from doing this.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identity (empty array for "No One")
$valueName = "SeRelabelPrivilege"
$desiredIdentity = @()

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentity) -or $currentAccounts) { # Check if not empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentity
    Write-Host "  CIS 2.2.31: 'Modify an object label' permissions configured to No One" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.31: 'Modify an object label' permissions are already configured to No One" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.30. (L1) Ensure 'Manage auditing and security log' is set to 'Administrators'
# In simpler terms: This setting controls who is allowed to manage the security log, where important security events are recorded.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identity
$valueName = "SeSecurityPrivilege"
$desiredIdentity = @("BUILTIN\Administrators")

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentity) -or !$currentAccounts) { # Check for null or empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentity
    Write-Host "  CIS 2.2.30: 'Manage auditing and security log' permissions configured" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.30: 'Manage auditing and security log' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.3. (L1) Ensure 'Act as part of the operating system' is set to 'No One'
# In simpler terms: This setting controls which accounts are allowed to act as a core part of Windows itself, which is a very powerful ability. We want to prevent anyone from doing this.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identity (empty array for "No One")
$valueName = "SeTcbPrivilege"
$desiredIdentity = @()

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentity) -or $currentAccounts) { # Check if not empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentity
    Write-Host "  CIS 2.2.3: 'Act as part of the operating system' permissions configured to No One" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.3: 'Act as part of the operating system' permissions are already configured to No One" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.27. (L1) Ensure 'Lock pages in memory' is set to 'No One'
# In simpler terms: This setting controls who is allowed to keep data in the computer's memory, preventing it from being swapped to the hard drive. We want to prevent anyone from doing this.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identity (empty array for "No One")
$valueName = "SeLockMemoryPrivilege"
$desiredIdentity = @()

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentity) -or $currentAccounts) { # Check if not empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentity
    Write-Host "  CIS 2.2.27: 'Lock pages in memory' permissions configured to No One" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.27: 'Lock pages in memory' permissions are already configured to No One" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.26. (L1) Ensure 'Load and unload device drivers' is set to 'Administrators'
# In simpler terms: This setting controls who is allowed to install and remove the software that makes your computer work with hardware (like printers or graphics cards).

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identity
$valueName = "SeLoadDriverPrivilege"
$desiredIdentity = @("BUILTIN\Administrators")

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentity) -or !$currentAccounts) { # Check for null or empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentity
    Write-Host "  CIS 2.2.26: 'Load and unload device drivers' permissions configured" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.26: 'Load and unload device drivers' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.25. (L1) Ensure 'Increase scheduling priority' is set to 'Administrators, Window Manager\Window Manager Group'
# In simpler terms: This setting controls who is allowed to make programs run faster than normal.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identities
$valueName = "SeIncreaseBasePriorityPrivilege"
$desiredIdentities = @("BUILTIN\Administrators", "NT SERVICE\Winmgmt")

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentities) -or !$currentAccounts) { # Check for null or empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentities
    Write-Host "  CIS 2.2.25: 'Increase scheduling priority' permissions configured" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.25: 'Increase scheduling priority' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"



# CIS Control: 2.2.24. (L1) Ensure 'Impersonate a client after authentication' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'
# In simpler terms: This setting controls which accounts are allowed to temporarily "pretend" to be another user or service to access resources.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identities
$valueName = "SeImpersonatePrivilege"
$desiredIdentities = @("BUILTIN\Administrators", "NT AUTHORITY\LOCAL SERVICE", "NT AUTHORITY\NETWORK SERVICE", "NT AUTHORITY\SERVICE")

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentities) -or !$currentAccounts) { # Check for null or empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentities
    Write-Host "  CIS 2.2.24: 'Impersonate a client after authentication' permissions configured" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.24: 'Impersonate a client after authentication' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"



# CIS Control: 2.2.23. (L1) Ensure 'Generate security audits' is set to 'LOCAL SERVICE, NETWORK SERVICE'
# In simpler terms: This setting controls which system services are allowed to create records in the security log, which tracks important security events.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identities
$valueName = "SeAuditPrivilege"
$desiredIdentities = @("NT AUTHORITY\LOCAL SERVICE", "NT AUTHORITY\NETWORK SERVICE")

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentities) -or !$currentAccounts) { # Check for null or empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentities
    Write-Host "  CIS 2.2.23: 'Generate security audits' permissions configured" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.23: 'Generate security audits' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.22. (L1) Ensure 'Force shutdown from a remote system' is set to 'Administrators'
# In simpler terms: This setting controls who is allowed to shut down the computer from another computer over the network.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identity
$valueName = "SeRemoteShutdownPrivilege"
$desiredIdentity = @("BUILTIN\Administrators")

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentity) -or !$currentAccounts) { # Check for null or empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentity
    Write-Host "  CIS 2.2.22: 'Force shutdown from a remote system' permissions configured" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.22: 'Force shutdown from a remote system' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.21. (L1) Ensure 'Enable computer and user accounts to be trusted for delegation' is set to 'No One'
# In simpler terms: This setting controls who is allowed to let a computer or user account act on their behalf to access resources on other computers. We want to prevent anyone from doing this.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identity (empty array for "No One")
$valueName = "SeEnableDelegationPrivilege"
$desiredIdentity = @()

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentity) -or $currentAccounts) { # Check if not empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentity
    Write-Host "  CIS 2.2.21: 'Enable computer and user accounts to be trusted for delegation' permissions configured to No One" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.21: 'Enable computer and user accounts to be trusted for delegation' permissions are already configured to No One" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.15. (L1) Ensure 'Debug programs' is set to 'Administrators'
# In simpler terms: This setting controls who is allowed to examine and modify the inner workings of running programs, which is a powerful debugging capability.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identity
$valueName = "SeDebugPrivilege"
$desiredIdentity = @("BUILTIN\Administrators")

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentity) -or !$currentAccounts) { # Check for null or empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentity
    Write-Host "  CIS 2.2.15: 'Debug programs' permissions configured" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.15: 'Debug programs' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.14. (L1) Configure 'Create symbolic links'
# In simpler terms: This setting controls who is allowed to create special types of shortcuts that can point to files or folders in other locations.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identity
$valueName = "SeCreateSymbolicLinkPrivilege"
$desiredIdentity = @("BUILTIN\Administrators")

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentity) -or !$currentAccounts) { # Check for null or empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentity
    Write-Host "  CIS 2.2.14: Configure 'Create symbolic links' permissions" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.14: Configure 'Create symbolic links' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.13. (L1) Ensure 'Create permanent shared objects' is set to 'No One'
# In simpler terms: This setting controls who is allowed to create special objects in the system that can be accessed by multiple programs. We want to prevent anyone from doing this.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identity (empty array for "No One")
$valueName = "SeCreatePermanentPrivilege"
$desiredIdentity = @()

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentity) -or $currentAccounts) { # Check if not empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentity
    Write-Host "  CIS 2.2.13: Ensure 'Create permanent shared objects' is set to 'No One'" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.13: Ensure 'Create permanent shared objects' permissions are already configured to No One" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.12. (L1) Ensure 'Create global objects' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'
# In simpler terms: This setting controls which accounts are allowed to create objects that can be accessed by any program on the computer.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identities
$valueName = "SeCreateGlobalPrivilege"
$desiredIdentities = @("BUILTIN\Administrators", "NT AUTHORITY\LOCAL SERVICE", "NT AUTHORITY\NETWORK SERVICE", "NT AUTHORITY\SERVICE")

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentities) -or !$currentAccounts) { # Check for null or empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentities
    Write-Host "  CIS 2.2.12: Ensure 'Create global objects' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.12: Ensure 'Create global objects' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.11. (L1) Ensure 'Create a token object' is set to 'No One'
# In simpler terms: This setting controls who is allowed to create special security objects called "tokens," which are used to control access to resources. We want to prevent anyone from doing this.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identity (empty array for "No One")
$valueName = "SeCreateTokenPrivilege"
$desiredIdentity = @()

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentity) -or $currentAccounts) { # Check if not empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentity
    Write-Host "  CIS 2.2.11: Ensure 'Create a token object' is set to 'No One'" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.11: Ensure 'Create a token object' permissions are already configured to No One" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.10. (L1) Ensure 'Create a pagefile' is set to 'Administrators'
# In simpler terms: This setting controls who is allowed to create the "pagefile," which is a special file on your hard drive that Windows uses as extra memory.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identity
$valueName = "SeCreatePagefilePrivilege"
$desiredIdentity = @("BUILTIN\Administrators")

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $value -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentity) -or !$currentAccounts) { # Check for null or empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentity
    Write-Host "  CIS 2.2.10: Ensure 'Create a pagefile' is set to 'Administrators'" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.10: Ensure 'Create a pagefile' permissions are already configured correctly" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"


# CIS Control: 2.2.1. (L1) Ensure 'Access Credential Manager as a trusted caller' is set to 'No One'
# In simpler terms: This setting controls which accounts are allowed to ask Credential Manager (where Windows stores passwords and other credentials) for information. We want to prevent anyone from doing this.

# Define the registry key
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment"

# Define the value name and desired identity (empty array for "No One")
$valueName = "SeTrustedCredManAccessPrivilege"
$desiredIdentity = @()

# Function to get the current accounts with the privilege
function Get-PrivilegeAccounts {
    param($registryKey, $valueName)

    $currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue
    if ($currentValue) {
        return $currentValue.Split("`0") | Where-Object { $_ } # Split by null character and filter out empty strings
    } else {
        return @()
    }
}

# Function to compare accounts (case-insensitive)
function Compare-Accounts {
    param (
        [string[]]$Array1,
        [string[]]$Array2
    )

    if ($Array1.Count -ne $Array1.Count) {
        return $false
    }

    for ($i = 0; $i -lt $Array1.Count; $i++) {
        if ($Array1[$i].ToLower() -ne $Array2[$i].ToLower()) {
            return $false
        }
    }

    return $true
}

# Function to set the privilege
function Set-PrivilegeAccounts {
    param($registryKey, $valueName, [string[]]$accounts)

    $value = $accounts -join "`0" # Join accounts with null character
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $value -Type MultiString -Force
}

# Get the current accounts with the privilege
$currentAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  Current Accounts: $($currentAccounts -join ', ')"

# Set the privilege if it's different
if (-not (Compare-Accounts $currentAccounts $desiredIdentity) -or $currentAccounts) { # Check if not empty
    Set-PrivilegeAccounts -registryKey $registryKey -valueName $valueName -accounts $desiredIdentity
    Write-Host "  CIS 2.2.1: Ensure 'Access Credential Manager as a trusted caller' is set to 'No One'" -ForegroundColor Green
} else {
    Write-Host "  CIS 2.2.1: Ensure 'Access Credential Manager as a trusted caller' permissions are already configured to No One" -ForegroundColor Green
}

# Verify the change (output new accounts)
$newAccounts = Get-PrivilegeAccounts -registryKey $registryKey -valueName $valueName

Write-Host "  New Accounts: $($newAccounts -join ', ')"
