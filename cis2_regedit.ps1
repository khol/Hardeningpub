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



# CIS Control: 2.3.9.4. (L1) Ensure 'Microsoft network server: Disconnect clients when logon hours expire' is set to 'Enabled'
# In simpler terms: This setting forces users to be disconnected from the server when the times they're allowed to be logged in are over.
# Recommended Value: Enabled
# Possible Values: Enabled, Disabled

$cisControl_2_3_9_4 = @{
    "ID" = "2.3.9.4"
    "Description" = "Ensure 'Microsoft network server: Disconnect clients when logon hours expire' is set to 'Enabled'"
    "SimpleTerms" = "This setting forces users to be disconnected from the server when the times they're allowed to be logged in are over."
    "RecommendedValue" = "Enabled"
    "PossibleValues" = "Enabled, Disabled"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" = @{
            "EnableForcedLogoff" = 1 # 1 = Enabled, 0 = Disabled
        }
    }
}

# CIS Control: 2.3.9.1. (L1) Ensure 'Microsoft network server: Amount of idle time required before suspending session' is set to '15 or fewer minute(s)'
# In simpler terms: This setting makes the server disconnect inactive users after 15 minutes or less of inactivity.
# Recommended Value: 15 minutes
# Possible Values: Any integer greater than 0

$cisControl_2_3_9_1 = @{
    "ID" = "2.3.9.1"
    "Description" = "Ensure 'Microsoft network server: Amount of idle time required before suspending session' is set to '15 or fewer minute(s)'"
    "SimpleTerms" = "This setting makes the server disconnect inactive users after 15 minutes or less of inactivity."
    "RecommendedValue" = "15 minutes"
    "PossibleValues" = "Any integer greater than 0"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" = @{
            "Autodisconnect" = 15 # Value in minutes
        }
    }
}


# CIS Control: 2.3.8.3. (L1) Ensure 'Microsoft network client: Send unencrypted password to third-party SMB servers' is set to 'Disabled'
# In simpler terms: This setting prevents your computer from sending your password without encryption to some older file servers.
# Recommended Value: Disabled
# Possible Values: Enabled, Disabled

$cisControl_2_3_8_3 = @{
    "ID" = "2.3.8.3"
    "Description" = "Ensure 'Microsoft network client: Send unencrypted password to third-party SMB servers' is set to 'Disabled'"
    "SimpleTerms" = "This setting prevents your computer from sending your password without encryption to some older file servers."
    "RecommendedValue" = "Disabled"
    "PossibleValues" = "Enabled, Disabled"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" = @{
            "EnablePlainTextPassword" = 0 # 0 = Disabled, 1 = Enabled
        }
    }
}


# CIS Control: 2.3.8.2. (L1) Ensure 'Microsoft network client: Digitally sign communications (if server agrees)' is set to 'Enabled'
# In simpler terms: This setting tells your computer to use digital signatures to verify data sent to file servers, if the server supports it.
# Recommended Value: Enabled
# Possible Values: Enabled, Disabled

$cisControl_2_3_8_2 = @{
    "ID" = "2.3.8.2"
    "Description" = "Ensure 'Microsoft network client: Digitally sign communications (if server agrees)' is set to 'Enabled'"
    "SimpleTerms" = "This setting tells your computer to use digital signatures to verify data sent to file servers, if the server supports it."
    "RecommendedValue" = "Enabled"
    "PossibleValues" = "Enabled, Disabled"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" = @{
            "RequireSecureNegotiate" = 1 # 1 = Enabled, 0 = Disabled
        }
    }
}

# CIS Control: 2.3.7.8. (L1) Ensure 'Interactive logon: Prompt user to change password before expiration' is set to 'between 5 and 14 days'
# In simpler terms: This setting makes Windows warn users to change their password a few days before it expires.
# Recommended Value: 14 days (or another value within the 5-14 day range)
# Possible Values: Any integer between 0 and 999 (but CIS recommends 5-14)

$cisControl_2_3_7_8 = @{
    "ID" = "2.3.7.8"
    "Description" = "Ensure 'Interactive logon: Prompt user to change password before expiration' is set to 'between 5 and 14 days'"
    "SimpleTerms" = "This setting makes Windows warn users to change their password a few days before it expires."
    "RecommendedValue" = "14 days"
    "PossibleValues" = "Any integer between 0 and 999 (but CIS recommends 5-14)"
    "RegistryChanges" = @{
        "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" = @{
            "PasswordExpiryWarning" = 14 # Value in days (example: 14)
        }
    }
}


# CIS Control: 2.3.6.6. (L1) Ensure 'Domain member: Require strong (Windows 2000 or later) session key' is set to 'Enabled'
# In simpler terms: This setting makes sure your computer uses strong encryption when talking to domain controllers.
# Recommended Value: Enabled (value 5)
# Possible Values: 0, 1, 2, 3, 5 (5 is the strongest)

$cisControl_2_3_6_6 = @{
    "ID" = "2.3.6.6"
    "Description" = "Ensure 'Domain member: Require strong (Windows 2000 or later) session key' is set to 'Enabled'"
    "SimpleTerms" = "This setting makes sure your computer uses strong encryption when talking to domain controllers."
    "RecommendedValue" = "Enabled (value 5)"
    "PossibleValues" = "0, 1, 2, 3, 5 (5 is the strongest)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\LMCompatibility Level" = @{
            "LmCompatibilityLevel" = 5 # 5 is the strongest
        }
    }
}

# CIS Control: 2.3.6.5. (L1) Ensure 'Domain member: Maximum machine account password age' is set to '30 or fewer days, but not 0'
# In simpler terms: This setting forces domain-joined computers to change their passwords regularly.
# Recommended Value: 30 days
# Possible Values: Any integer between 1 and 365

$cisControl_2_3_6_5 = @{
    "ID" = "2.3.6.5"
    "Description" = "Ensure 'Domain member: Maximum machine account password age' is set to '30 or fewer days, but not 0'"
    "SimpleTerms" = "This setting forces domain-joined computers to change their passwords regularly."
    "RecommendedValue" = "30 days"
    "PossibleValues" = "Any integer between 1 and 365"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" = @{
            "MaximumPasswordAge" = 30 # Value in days
        }
    }
}

# CIS Control: 2.3.6.4. (L1) Ensure 'Domain member: Disable machine account password changes' is set to 'Disabled'
# In simpler terms: This setting makes sure that computers in a domain *are allowed* to change their passwords automatically.
# Recommended Value: Disabled (value 0)
# Possible Values: 0 (Disabled), 1 (Enabled)

$cisControl_2_3_6_4 = @{
    "ID" = "2.3.6.4"
    "Description" = "Ensure 'Domain member: Disable machine account password changes' is set to 'Disabled'"
    "SimpleTerms" = "This setting makes sure that computers in a domain *are allowed* to change their passwords automatically."
    "RecommendedValue" = "Disabled (value 0)"
    "PossibleValues" = "0 (Disabled), 1 (Enabled)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" = @{
            "DisablePasswordChange" = 0 # 0 = Disabled (allowed), 1 = Enabled (disallowed)
        }
    }
}

# CIS Control: 2.3.6.3. (L1) Ensure 'Domain member: Digitally sign secure channel data (when possible)' is set to 'Enabled'
# In simpler terms: This setting tells your computer to use digital signatures to verify data when talking to the domain controller, if it can.
# Recommended Value: Enabled (value 1)
# Possible Values: 0 (Disabled), 1 (Enabled)

$cisControl_2_3_6_3 = @{
    "ID" = "2.3.6.3"
    "Description" = "Ensure 'Domain member: Digitally sign secure channel data (when possible)' is set to 'Enabled'"
    "SimpleTerms" = "This setting tells your computer to use digital signatures to verify data when talking to the domain controller, if it can."
    "RecommendedValue" = "Enabled (value 1)"
    "PossibleValues" = "0 (Disabled), 1 (Enabled)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" = @{
            "RequireSignOrSeal" = 1 # 1 = Enabled, 0 = Disabled
        }
    }
}

# CIS Control: 2.3.6.2. (L1) Ensure 'Domain member: Digitally encrypt secure channel data (when possible)' is set to 'Enabled'
# In simpler terms: This setting tells your computer to encrypt the data it sends to the domain controller, if it can.
# Recommended Value: Enabled (value 1)
# Possible Values: 0 (Disabled), 1 (Enabled)

$cisControl_2_3_6_2 = @{
    "ID" = "2.3.6.2"
    "Description" = "Ensure 'Domain member: Digitally encrypt secure channel data (when possible)' is set to 'Enabled'"
    "SimpleTerms" = "This setting tells your computer to encrypt the data it sends to the domain controller, if it can."
    "RecommendedValue" = "Enabled (value 1)"
    "PossibleValues" = "0 (Disabled), 1 (Enabled)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" = @{
            "RequireSeal" = 1 # 1 = Enabled, 0 = Disabled
        }
    }
}


# CIS Control: 2.3.6.1. (L1) Ensure 'Domain member: Digitally encrypt or sign secure channel data (always)' is set to 'Enabled'
# In simpler terms: This setting forces your computer to *always* encrypt or sign the data it sends to the domain controller.
# Recommended Value: Enabled (value 1)
# Possible Values: 0 (Disabled), 1 (Enabled)

$cisControl_2_3_6_1 = @{
    "ID" = "2.3.6.1"
    "Description" = "Ensure 'Domain member: Digitally encrypt or sign secure channel data (always)' is set to 'Enabled'"
    "SimpleTerms" = "This setting forces your computer to *always* encrypt or sign the data it sends to the domain controller."
    "RecommendedValue" = "Enabled (value 1)"
    "PossibleValues" = "0 (Disabled), 1 (Enabled)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" = @{
            "RequireStrongKey" = 1 # 1 = Enabled, 0 = Disabled
        }
    }
}

# CIS Control: 2.3.2.2. (L1) Ensure 'Audit: Shut down system immediately if unable to log security audits' is set to 'Disabled'
# In simpler terms: This setting controls whether the computer shuts down if it can't save security logs. We want it disabled so the computer doesn't shut down unexpectedly.
# Recommended Value: Disabled (value 0)
# Possible Values: 0 (Disabled), 1 (Enabled)

$cisControl_2_3_2_2 = @{
    "ID" = "2.3.2.2"
    "Description" = "Ensure 'Audit: Shut down system immediately if unable to log security audits' is set to 'Disabled'"
    "SimpleTerms" = "This setting controls whether the computer shuts down if it can't save security logs. We want it disabled so the computer doesn't shut down unexpectedly."
    "RecommendedValue" = "Disabled (value 0)"
    "PossibleValues" = "0 (Disabled), 1 (Enabled)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" = @{
            "CrashOnAuditFail" = 0 # 0 = Disabled, 1 = Enabled
        }
    }
}

# CIS Control: 2.3.17.8. (L1) Ensure 'User Account Control: Virtualize file and registry write failures to per-user locations' is set to 'Enabled'
# In simpler terms: This setting makes sure that when programs try to save files or settings to protected areas, Windows saves them to a special folder for that user instead, so the program doesn't break.
# Recommended Value: Enabled (value 1)
# Possible Values: 0 (Disabled), 1 (Enabled)

$cisControl_2_3_17_8 = @{
    "ID" = "2.3.17.8"
    "Description" = "Ensure 'User Account Control: Virtualize file and registry write failures to per-user locations' is set to 'Enabled'"
    "SimpleTerms" = "This setting makes sure that when programs try to save files or settings to protected areas, Windows saves them to a special folder for that user instead, so the program doesn't break."
    "RecommendedValue" = "Enabled (value 1)"
    "PossibleValues" = "0 (Disabled), 1 (Enabled)"
    "RegistryChanges" = @{
        "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" = @{
            "EnableVirtualization" = 1 # 1 = Enabled, 0 = Disabled
        }
    }
}

# CIS Control: 2.3.17.7. (L1) Ensure 'User Account Control: Switch to the secure desktop when prompting for elevation' is set to 'Enabled'
# In simpler terms: This setting makes Windows show the UAC (User Account Control) prompt on a special, safer version of your desktop.
# Recommended Value: Enabled (value 1)
# Possible Values: 0 (Disabled), 1 (Enabled)

$cisControl_2_3_17_7 = @{
    "ID" = "2.3.17.7"
    "Description" = "Ensure 'User Account Control: Switch to the secure desktop when prompting for elevation' is set to 'Enabled'"
    "SimpleTerms" = "This setting makes Windows show the UAC (User Account Control) prompt on a special, safer version of your desktop."
    "RecommendedValue" = "Enabled (value 1)"
    "PossibleValues" = "0 (Disabled), 1 (Enabled)"
    "RegistryChanges" = @{
        "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" = @{
            "PromptOnSecureDesktop" = 1 # 1 = Enabled, 0 = Disabled
        }
    }
}


# CIS Control: 2.3.17.6. (L1) Ensure 'User Account Control: Run all administrators in Admin Approval Mode' is set to 'Enabled'
# In simpler terms: This setting makes even administrators use User Account Control (UAC) prompts, just like regular users.
# Recommended Value: Enabled (value 1)
# Possible Values: 0 (Disabled), 1 (Enabled)

$cisControl_2_3_17_6 = @{
    "ID" = "2.3.17.6"
    "Description" = "Ensure 'User Account Control: Run all administrators in Admin Approval Mode' is set to 'Enabled'"
    "SimpleTerms" = "This setting makes even administrators use User Account Control (UAC) prompts, just like regular users."
    "RecommendedValue" = "Enabled (value 1)"
    "PossibleValues" = "0 (Disabled), 1 (Enabled)"
    "RegistryChanges" = @{
        "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" = @{
            "EnableLUA" = 1 # 1 = Enabled, 0 = Disabled
        }
    }
}


# CIS Control: 2.3.17.5. (L1) Ensure 'User Account Control: Only elevate UIAccess applications that are installed in secure locations' is set to 'Enabled'
# In simpler terms: This setting makes sure that only programs designed to help people with disabilities (UIAccess applications) can bypass some UAC security if they're installed in a safe place on your computer.
# Recommended Value: Enabled (value 1)
# Possible Values: 0 (Disabled), 1 (Enabled)

$cisControl_2_3_17_5 = @{
    "ID" = "2.3.17.5"
    "Description" = "Ensure 'User Account Control: Only elevate UIAccess applications that are installed in secure locations' is set to 'Enabled'"
    "SimpleTerms" = "This setting makes sure that only programs designed to help people with disabilities (UIAccess applications) can bypass some UAC security if they're installed in a safe place on your computer."
    "RecommendedValue" = "Enabled (value 1)"
    "PossibleValues" = "0 (Disabled), 1 (Enabled)"
    "RegistryChanges" = @{
        "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" = @{
            "UIAccessControl" = 1 # 1 = Enabled, 0 = Disabled
        }
    }
}


# CIS Control: 2.3.17.4. (L1) Ensure 'User Account Control: Detect application installations and prompt for elevation' is set to 'Enabled'
# In simpler terms: This setting makes User Account Control (UAC) show a prompt and ask for permission when you try to install a program.
# Recommended Value: Enabled (value 1)
# Possible Values: 0 (Disabled), 1 (Enabled)

$cisControl_2_3_17_4 = @{
    "ID" = "2.3.17.4"
    "Description" = "Ensure 'User Account Control: Detect application installations and prompt for elevation' is set to 'Enabled'"
    "SimpleTerms" = "This setting makes User Account Control (UAC) show a prompt and ask for permission when you try to install a program."
    "RecommendedValue" = "Enabled (value 1)"
    "PossibleValues" = "0 (Disabled), 1 (Enabled)"
    "RegistryChanges" = @{
        "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" = @{
            "PromptOnInstall" = 1 # 1 = Enabled, 0 = Disabled
        }
    }
}


# CIS Control: 2.3.15.2. (L1) Ensure 'System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)' is set to 'Enabled'
# In simpler terms: This setting makes Windows apply stricter security rules to important internal parts of the system, like symbolic links, to make it harder for attackers to exploit them.
# Recommended Value: Enabled (value 1)
# Possible Values: 0 (Disabled), 1 (Enabled)

$cisControl_2_3_15_2 = @{
    "ID" = "2.3.15.2"
    "Description" = "Ensure 'System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)' is set to 'Enabled'"
    "SimpleTerms" = "This setting makes Windows apply stricter security rules to important internal parts of the system, like symbolic links, to make it harder for attackers to exploit them."
    "RecommendedValue" = "Enabled (value 1)"
    "PossibleValues" = "0 (Disabled), 1 (Enabled)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\ProtectionMode" = @{
            "EnableObjectDirectoryHardening" = 1 # 1 = Enabled, 0 = Disabled
        }
    }
}

# CIS Control: 2.3.15.1. (L1) Ensure 'System objects: Require case insensitivity for non-Windows subsystems' is set to 'Enabled'
# In simpler terms: This setting makes Windows treat uppercase and lowercase letters the same way when programs from other operating systems (like Linux) try to access files.
# Recommended Value: Enabled (value 1)
# Possible Values: 0 (Disabled), 1 (Enabled)

$cisControl_2_3_15_1 = @{
    "ID" = "2.3.15.1"
    "Description" = "Ensure 'System objects: Require case insensitivity for non-Windows subsystems' is set to 'Enabled'"
    "SimpleTerms" = "This setting makes Windows treat uppercase and lowercase letters the same way when programs from other operating systems (like Linux) try to access files."
    "RecommendedValue" = "Enabled (value 1)"
    "PossibleValues" = "0 (Disabled), 1 (Enabled)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" = @{
            "obcaseinsensitive" = 1 # 1 = Enabled, 0 = Disabled
        }
    }
}

# CIS Control: 2.3.11.8. (L1) Ensure 'Network security: LDAP client signing requirements' is set to 'Negotiate signing' or higher
# In simpler terms: This setting tells your computer how strongly it needs to verify the data it receives from servers using the LDAP protocol (which is used for things like Active Directory).
# Recommended Value: Negotiate signing (value 1)
# Possible Values: 2 (Require signing), 1 (Negotiate signing), 0 (None)

$cisControl_2_3_11_8 = @{
    "ID" = "2.3.11.8"
    "Description" = "Ensure 'Network security: LDAP client signing requirements' is set to 'Negotiate signing' or higher"
    "SimpleTerms" = "This setting tells your computer how strongly it needs to verify the data it receives from servers using the LDAP protocol (which is used for things like Active Directory)."
    "RecommendedValue" = "Negotiate signing (value 1)"
    "PossibleValues" = "2 (Require signing), 1 (Negotiate signing), 0 (None)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Services\LDAP" = @{
            "LDAPClientIntegrity" = 1 # 1 = Negotiate signing
        }
    }
}


# CIS Control: 2.3.11.7. (L1) Ensure 'Network security: LAN Manager authentication level' is set to 'Send NTLMv2 response only. Refuse LM & NTLM'
# In simpler terms: This setting tells your computer to use the most secure way of proving your identity when connecting to other computers on the network.
# Recommended Value: Send NTLMv2 response only. Refuse LM & NTLM (value 5)
# Possible Values: 0, 1, 2, 3, 5 (5 is the strongest)

$cisControl_2_3_11_7 = @{
    "ID" = "2.3.11.7"
    "Description" = "Ensure 'Network security: LAN Manager authentication level' is set to 'Send NTLMv2 response only. Refuse LM & NTLM'"
    "SimpleTerms" = "This setting tells your computer to use the most secure way of proving your identity when connecting to other computers on the network."
    "RecommendedValue" = "Send NTLMv2 response only. Refuse LM & NTLM (value 5)"
    "PossibleValues" = "0, 1, 2, 3, 5 (5 is the strongest)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\LMCompatibility Level" = @{
            "LmCompatibilityLevel" = 5 # 5 is the strongest
        }
    }
}

# CIS Control: 2.3.11.6. (L1) Ensure 'Network security: Force logoff when logon hours expire' is set to 'Enabled'
# In simpler terms: This setting makes Windows automatically log users off when the times they're allowed to be logged in are over.
# Recommended Value: Enabled (value 1)
# Possible Values: 0 (Disabled), 1 (Enabled)

$cisControl_2_3_11_6 = @{
    "ID" = "2.3.11.6"
    "Description" = "Ensure 'Network security: Force logoff when logon hours expire' is set to 'Enabled'"
    "SimpleTerms" = "This setting makes Windows automatically log users off when the times they're allowed to be logged in are over."
    "RecommendedValue" = "Enabled (value 1)"
    "PossibleValues" = "0 (Disabled), 1 (Enabled)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" = @{
            "ForceLogoffWhenLogonHoursExpire" = 1 # 1 = Enabled, 0 = Disabled
        }
    }
}

# CIS Control: 2.3.11.5. (L1) Ensure 'Network security: Do not store LAN Manager hash value on next password change' is set to 'Enabled'
# In simpler terms: This setting stops your computer from saving a very old and weak version of your password when you change it.
# Recommended Value: Enabled (value 1)
# Possible Values: 0 (Disabled), 1 (Enabled)

$cisControl_2_3_11_5 = @{
    "ID" = "2.3.11.5"
    "Description" = "Ensure 'Network security: Do not store LAN Manager hash value on next password change' is set to 'Enabled'"
    "SimpleTerms" = "This setting stops your computer from saving a very old and weak version of your password when you change it."
    "RecommendedValue" = "Enabled (value 1)"
    "PossibleValues" = "0 (Disabled), 1 (Enabled)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" = @{
            "NoLMHash" = 1 # 1 = Enabled, 0 = Disabled
        }
    }
}


# CIS Control: 2.3.10.9. (L1) Ensure 'Network access: Restrict anonymous access to Named Pipes and Shares' is set to 'Enabled'
# In simpler terms: This setting stops people from accessing certain computer resources over the network without logging in.
# Recommended Value: Enabled (requires setting two registry values)
# Possible Values: 0 (Disabled), 1 (Enabled)

$cisControl_2_3_10_9 = @{
    "ID" = "2.3.10.9"
    "Description" = "Ensure 'Network access: Restrict anonymous access to Named Pipes and Shares' is set to 'Enabled'"
    "SimpleTerms" = "This setting stops people from accessing certain computer resources over the network without logging in."
    "RecommendedValue" = "Enabled (requires setting two registry values)"
    "PossibleValues" = "0 (Disabled), 1 (Enabled)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" = @{
            "NullSessionPipes" = 0 # 0 = Enabled (restrict), 1 = Disabled (allow)
            "NullSessionShares" = 0 # 0 = Enabled (restrict), 1 = Disabled (allow)
        }
    }
}

# CIS Control: 2.3.10.8. (L1) Ensure 'Network access: Remotely accessible registry paths and sub-paths' is configured
# In simpler terms: This setting controls which parts of your computer's settings (the registry) can be accessed from other computers on the network.
# Recommended Value: See $desiredRegistryPaths array for the list of allowed paths
# Possible Values: A list of registry paths

$cisControl_2_3_10_8 = @{
    "ID" = "2.3.10.8"
    "Description" = "Ensure 'Network access: Remotely accessible registry paths and sub-paths' is configured"
    "SimpleTerms" = "This setting controls which parts of your computer's settings (the registry) can be accessed from other computers on the network."
    "RecommendedValue" = "See RegistryChanges for allowed paths"
    "PossibleValues" = "A list of registry paths"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" = @{
            "NullSessionRegistry" = @(
                "MACHINE\System\CurrentControlSet\Control\Lsa\Data",
                "MACHINE\System\CurrentControlSet\Control\ProductOptions",
                "MACHINE\System\CurrentControlSet\Control\Print",
                "MACHINE\System\CurrentControlSet\Services\EventLog",
                "MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
            )
        }
    }
}


# Process CIS controls
$cisControls = @($cisControl_2_3_9_4, 
                $cisControl_2_3_9_1, 
                $cisControl_2_3_8_3,
                $cisControl_2_3_8_2,
                $cisControl_2_3_7_8,
                $cisControl_2_3_6_6,
                $cisControl_2_3_6_5,
                $cisControl_2_3_6_4,
                $cisControl_2_3_6_3,
                $cisControl_2_3_6_2,
                $cisControl_2_3_6_1,
                $cisControl_2_3_2_2,
                $cisControl_2_3_17_8,
                $cisControl_2_3_17_7,
                $cisControl_2_3_17_6,
                $cisControl_2_3_17_5,
                $cisControl_2_3_17_4,
                $cisControl_2_3_15_2,
                $cisControl_2_3_15_1,
                $cisControl_2_3_11_8,
                $cisControl_2_3_11_7, 
                $cisControl_2_3_11_6,
                $cisControl_2_3_11_5, 
                $cisControl_2_3_10_9,
                $cisControl_2_3_10_8
               )

foreach ($cisControl in $cisControls) {
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
