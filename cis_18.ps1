# CIS Control: 18.9.5.6. (L1) Ensure 'Turn On Virtualization Based Security: Secure Launch Configuration' is set to 'Enabled'
# In simpler terms: This setting turns on a security feature that helps protect the computer's startup process using virtualization.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\SystemGuard\HyperVConfig"
$valueName = "SecureLaunchConfigured"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 18.9.5.6: 'Turn On Virtualization Based Security: Secure Launch Configuration' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 18.9.5.6: 'Turn On Virtualization Based Security: Secure Launch Configuration' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 18.9.5.2. (L1) Ensure 'Turn On Virtualization Based Security: Select Platform Security Level' is set to 'Secure Boot' or higher
# In simpler terms: This setting tells Windows what security features the computer's hardware must support to use Virtualization Based Security (VBS).

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard"
$valueName = "HVCBPlatformLevel"
# Values:
# 2 = Secure Boot and DMA Protection
# 1 = Secure Boot (This is the minimum acceptable for CIS)
# 0 = None
$desiredValue = 1
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's lower than the minimum
if ($currentValue -lt $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 18.9.5.2: 'Turn On Virtualization Based Security: Select Platform Security Level' set to Secure Boot" -ForegroundColor Green
} else {
    Write-Host "  CIS 18.9.5.2: 'Turn On Virtualization Based Security: Select Platform Security Level' is already Secure Boot or higher" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 18.9.5.1. (L1) Ensure 'Turn On Virtualization Based Security' is set to 'Enabled'
# In simpler terms: This setting turns on a major security feature in Windows that uses virtualization to protect sensitive parts of the system.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard"
$valueName = "EnableVirtualizationBasedSecurity"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 18.9.5.1: 'Turn On Virtualization Based Security' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 18.9.5.1: 'Turn On Virtualization Based Security' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 18.9.35.2. (L1) Ensure 'Configure Solicited Remote Assistance' is set to 'Disabled'
# In simpler terms: This setting turns off the ability for users to request help by allowing someone to remotely control their computer.

# Define the registry key and value
$registryKey = "HKLM:\SOFTWARE\Policies\Microsoft\Control Panel\RemoteAssistance"
$valueName = "fAllowFullControl"
$desiredValue = 0  # 0 = Disabled, 1 = Enabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 18.9.35.2: 'Configure Solicited Remote Assistance' set to Disabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 18.9.35.2: 'Configure Solicited Remote Assistance' is already Disabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 18.9.3.1. (L1) Ensure 'Include command line in process creation events' is set to 'Enabled'
# In simpler terms: This setting makes Windows record the full command used to start a program in the security logs, which is helpful for security investigations.

# Define the registry key and value
$registryKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit"
$valueName = "ProcessCreationIncludeCmdLine_optout"
$desiredValue = 0  # 0 = Enabled, 1 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 18.9.3.1: 'Include command line in process creation events' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 18.9.3.1: 'Include command line in process creation events' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 18.9.19.7. (L1) Ensure 'Turn off background refresh of Group Policy' is set to 'Disabled'
# In simpler terms: This setting makes sure that Group Policy settings are updated automatically in the background. "Disabled" here means the *automatic update is on*.

# Define the registry key and value
$registryKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$valueName = "DisableBkGndGroupPolicy"
$desiredValue = 0  # 0 = Disabled (automatic refresh ON), 1 = Enabled (automatic refresh OFF)
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 18.9.19.7: 'Turn off background refresh of Group Policy' set to Disabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 18.9.19.7: 'Turn off background refresh of Group Policy' is already Disabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 18.5.1. (L1) Ensure 'MSS: (AutoAdminLogon) Enable Automatic Logon' is set to 'Disabled'
# In simpler terms: This setting makes sure that Windows doesn't automatically log in a user when the computer starts.

# Define the registry key and value
$registryKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$valueName = "AutoAdminLogon"
$desiredValue = 0  # 0 = Disabled, 1 = Enabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 18.5.1: 'MSS: (AutoAdminLogon) Enable Automatic Logon' set to Disabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 18.5.1: 'MSS: (AutoAdminLogon) Enable Automatic Logon' is already Disabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 18.4.4. (L1) Ensure 'Configure SMB v1 server' is set to 'Disabled'
# In simpler terms: This setting turns off the oldest and most insecure version of the file-sharing protocol that Windows uses.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
$valueName = "SMB1"
$desiredValue = 0  # 0 = Disabled, 1 = Enabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different or doesn't exist
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 18.4.4: 'Configure SMB v1 server' set to Disabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 18.4.4: 'Configure SMB v1 server' is already Disabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 18.4.3. (L1) Ensure 'Configure SMB v1 client driver' is set to 'Enabled: Disable driver (recommended)'
# In simpler terms: This setting completely turns off the part of Windows that allows it to connect to older file servers using the insecure SMB v1 protocol.

# Define the registry key and value
$registryKey = "HKLM:\SYSTEM\CurrentControlSet\Services\MRxSmb10"
$valueName = "Start"
$desiredValue = 4  # 4 = Disabled, 3 = Manual, 2 = Automatic, 1 = Boot
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different or doesn't exist
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 18.4.3: 'Configure SMB v1 client driver' set to Disabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 18.4.3: 'Configure SMB v1 client driver' is already Disabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 18.10.92.2.1. (L1) Ensure 'Configure Automatic Updates' is set to 'Enabled'
# In simpler terms: This setting makes sure that Windows is set to automatically download and install updates.

# Define the registry key and value
$registryKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
$valueName = "UseWUServer"
$desiredValue = 0  # 0 = Enabled, 1 = Disabled

$registryKey2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
$valueName2 = "NoAutoUpdate"
$desiredValue2 = 0  # 0 = Enabled, 1 = Disabled
$valueType = "DWORD"

# Get the current value for UseWUServer
$currentValue1 = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value for UseWUServer: $currentValue1"

# Set the desired value for UseWUServer if it's different or doesn't exist
if ($currentValue1 -ne $desiredValue -or $currentValue1 -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 18.10.92.2.1: 'Configure Automatic Updates: UseWUServer' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 18.10.92.2.1: 'Configure Automatic Updates: UseWUServer' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value) for UseWUServer
$newValue1 = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value for UseWUServer: $newValue1"

# Get the current value for NoAutoUpdate
$currentValue2 = Get-ItemPropertyValue -Path $registryKey2 -Name $valueName2 -ErrorAction SilentlyContinue

Write-Host "  Current Value for NoAutoUpdate: $currentValue2"

# Set the desired value for NoAutoUpdate if it's different or doesn't exist
if ($currentValue2 -ne $desiredValue2 -or $currentValue2 -eq $null) {
    Set-ItemPropertyValue -Path $registryKey2 -Name $valueName2 -Value $desiredValue2 -Type $valueType -Force
    Write-Host "  CIS 18.10.92.2.1: 'Configure Automatic Updates: NoAutoUpdate' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 18.10.92.2.1: 'Configure Automatic Updates: NoAutoUpdate' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value) for NoAutoUpdate
$newValue2 = Get-ItemPropertyValue -Path $registryKey2 -Name $valueName2 -ErrorAction SilentlyContinue

Write-Host "  New Value for NoAutoUpdate: $newValue2"


# CIS Control: 18.10.92.1.1. (L1) Ensure 'No auto-restart with logged on users for scheduled automatic updates installations' is set to 'Disabled'
# In simpler terms: This setting makes sure that Windows *doesn't* automatically restart your computer to finish installing updates while you're still logged in.

# Define the registry key and value
$registryKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
$valueName = "NoAutoRebootWithLoggedOnUsers"
$desiredValue = 0  # 0 = Disabled (no auto-restart), 1 = Enabled (auto-restart)
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different or doesn't exist
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 18.10.92.1.1: 'No auto-restart with logged on users for scheduled automatic updates installations' set to Disabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 18.10.92.1.1: 'No auto-restart with logged on users for scheduled automatic updates installations' is already Disabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"


# CIS Control: 18.10.7.3. (L1) Ensure 'Turn off Autoplay' is set to 'Enabled: All drives'
# In simpler terms: This setting completely turns off the feature that automatically starts programs or plays media when you insert a CD, DVD, or USB drive.

# Define the registry key and value
$registryKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$valueName = "NoDriveTypeAutoRun"
# This value disables Autoplay on all drives.
$desiredValue = 0xFF
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different or doesn't exist
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 18.10.7.3: 'Turn off Autoplay' set to Enabled: All drives" -ForegroundColor Green
} else {
    Write-Host "  CIS 18.10.7.3: 'Turn off Autoplay' is already Enabled: All drives" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"

# Define the registry key and value (for HKLM)
$registryKey2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$valueName2 = "NoDriveTypeAutoRun"

# Get the current value for HKLM
$currentValue2 = Get-ItemPropertyValue -Path $registryKey2 -Name $valueName2 -ErrorAction SilentlyContinue

Write-Host "  Current Value (HKLM): $currentValue2"

# Set the desired value if it's different or doesn't exist (for HKLM)
if ($currentValue2 -ne $desiredValue -or $currentValue2 -eq $null) {
    Set-ItemPropertyValue -Path $registryKey2 -Name $valueName2 -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 18.10.7.3: 'Turn off Autoplay' (HKLM) set to Enabled: All drives" -ForegroundColor Green
} else {
    Write-Host "  CIS 18.10.7.3: 'Turn off Autoplay' (HKLM) is already Enabled: All drives" -ForegroundColor Green
}

# Verify the change (output new value) for HKLM
$newValue2 = Get-ItemPropertyValue -Path $registryKey2 -Name $valueName2 -ErrorAction SilentlyContinue

Write-Host "  New Value (HKLM): $newValue2"


# CIS Control: 18.10.12.3. (L1) Ensure 'Turn off Microsoft consumer experiences' is set to 'Enabled'
# In simpler terms: This setting stops Windows from showing you suggestions or advertisements for Microsoft products and services.

# Define the registry key and value
$registryKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$valueName = "DisableWindowsConsumerFeatures"
$desiredValue = 1  # 1 = Enabled, 0 = Disabled
$valueType = "DWORD"

# Get the current value
$currentValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  Current Value: $currentValue"

# Set the desired value if it's different or doesn't exist
if ($currentValue -ne $desiredValue -or $currentValue -eq $null) {
    Set-ItemPropertyValue -Path $registryKey -Name $valueName -Value $desiredValue -Type $valueType -Force
    Write-Host "  CIS 18.10.12.3: 'Turn off Microsoft consumer experiences' set to Enabled" -ForegroundColor Green
} else {
    Write-Host "  CIS 18.10.12.3: 'Turn off Microsoft consumer experiences' is already Enabled" -ForegroundColor Green
}

# Verify the change (output new value)
$newValue = Get-ItemPropertyValue -Path $registryKey -Name $valueName -ErrorAction SilentlyContinue

Write-Host "  New Value: $newValue"
