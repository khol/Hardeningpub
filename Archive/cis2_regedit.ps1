# Helper function to check if running as admin
function Is-Admin {
    return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

# Hjälpfunktion för att konvertera strängar till RegistryRights
function Convert-ToRegistryRights {
    param (
        [string]$permissionString
    )

    # Skapa en hashtable för att konvertera strängarna till RegistryRights
    $permissionsMap = @{
        "QueryValues"        = [System.Security.AccessControl.RegistryRights]::QueryValues
        "SetValue"           = [System.Security.AccessControl.RegistryRights]::SetValue
        "CreateSubKey"       = [System.Security.AccessControl.RegistryRights]::CreateSubKey
        "EnumerateSubKeys"   = [System.Security.AccessControl.RegistryRights]::EnumerateSubKeys
        "Notify"             = [System.Security.AccessControl.RegistryRights]::Notify
        "CreateLink"         = [System.Security.AccessControl.RegistryRights]::CreateLink
        "Delete"             = [System.Security.AccessControl.RegistryRights]::Delete
        "ReadPermissions"    = [System.Security.AccessControl.RegistryRights]::ReadPermissions
        "WriteKey"           = [System.Security.AccessControl.RegistryRights]::WriteKey
        "ExecuteKey"         = [System.Security.AccessControl.RegistryRights]::ExecuteKey
        "ReadKey"            = [System.Security.AccessControl.RegistryRights]::ReadKey
        "ChangePermissions"  = [System.Security.AccessControl.RegistryRights]::ChangePermissions
        "TakeOwnership"      = [System.Security.AccessControl.RegistryRights]::TakeOwnership
        "FullControl"        = [System.Security.AccessControl.RegistryRights]::FullControl
    }

    # Returnera rättigheten som en enumerator
    if ($permissionsMap.ContainsKey($permissionString)) {
        return $permissionsMap[$permissionString]
    } else {
        Write-Error "Invalid permission string '$permissionString'. Valid options are: " + ($permissionsMap.Keys -join ', ')
        return $null
    }
}

# Funktion för att sätta registry key permissions
function Set-RegistryKeyPermissions {
    param (
        [Parameter(Mandatory = $true)]
        [string]$KeyPath,
        [Parameter(Mandatory = $true)]
        [array]$DesiredPermissions
    )

    try {
        # Hämta ACL (Access Control List) för registernyckeln
        $acl = Get-Acl -Path $KeyPath
        $acl.SetAccessRuleProtection($true, $false)  # Skydda ACL från ärvda regler

        # Lägg till de önskade behörigheterna
        foreach ($permission in $DesiredPermissions) {
            $identity = New-Object System.Security.Principal.NTAccount($permission.Identity)
            
            # Kontrollera om permission har en giltig RegistryRights
            $rights = Convert-ToRegistryRights -permissionString $permission.FileSystemRights
            if ($rights -eq $null) {
                Write-Error "Invalid permission string '$($permission.FileSystemRights)' for identity '$($permission.Identity)'"
                return
            }

            # Skapa en ny RegistryAccessRule
            $accessRule = New-Object System.Security.AccessControl.RegistryAccessRule(
                $identity,
                $rights,
                $permission.InheritanceFlags,
                $permission.PropagationFlags,
                "Allow"
            )

            # Lägg till åtkomstregeln på ACL
            $acl.AddAccessRule($accessRule)
        }

        # Använd den uppdaterade ACL:n på registernyckeln
        Set-Acl -Path $KeyPath -AclObject $acl
        Write-Host "Successfully set permissions for key '$KeyPath'" -ForegroundColor Green
    } catch {
        Write-Error "Failed to set permissions for key '$KeyPath': $_"
    }
}


# Funktion för att applicera ACL och inställningar i registret
function Set-RegistryPermissions {
    param (
        [string]$keyPath,
        [array]$permissions,
        [int]$userAuthentication
    )

    # Hämta nuvarande ACL för registernyckeln
    $acl = Get-Acl -Path "Registry::$keyPath"

    # Skapa och lägg till rättigheterna
    foreach ($permission in $permissions) {
        $identity = New-Object System.Security.Principal.NTAccount($permission.Identity)
        $accessRule = New-Object System.Security.AccessControl.RegistryAccessRule(
            $identity,
            [System.Security.AccessControl.RegistryRights]::$($permission.FileSystemRights),
            $permission.InheritanceFlags,
            $permission.PropagationFlags,
            "Allow"
        )
        
        # Lägg till accessregeln i ACL
        $acl.AddAccessRule($accessRule)
    }

    # Tillämpa den uppdaterade ACL på registernyckeln
    Set-Acl -Path "Registry::$keyPath" -AclObject $acl

    # Uppdatera UserAuthentication-värdet i registret om det behövs
    Set-ItemProperty -Path "Registry::$keyPath" -Name "UserAuthentication" -Value $userAuthentication

    Write-Host "Changes applied successfully for registry key: $keyPath"
}



# Function to set registry keys
function Set-RegistryKeys {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable]$table,
        [switch]$RunAsAdmin
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

                # Handle Permissions separately
                if ($valueName -eq "Permissions") {
                    Set-RegistryKeyPermissions -KeyPath $fullPath -DesiredPermissions $value
                }
                # Set the value only if it's different or doesn't exist
                elseif ($currentValue -ne $value -or $currentValue -eq $null) {
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


function Get-SID {
    param (
        [string]$accountName
    )
    
    try {
        $account = New-Object System.Security.Principal.NTAccount($accountName)
        $sid = $account.Translate([System.Security.Principal.SecurityIdentifier])
        return $sid.Value
    }
    catch {
        Write-Error "Failed to retrieve SID for ${accountName}: $_"
    }
}

function Set-TimeZonePrivilege {
    Write-Host "  Configuring SeTimeZonePrivilege using secedit..." -ForegroundColor Yellow

    # Hämta SID för användarna och grupperna
    $administratorsSID = Get-SID -accountName "Administrators"
    $localServiceSID = Get-SID -accountName "LOCAL SERVICE"
    $usersSID = Get-SID -accountName "Users"

    # Kontrollera att vi har hämtat SID korrekt
    if (-not $administratorsSID -or -not $localServiceSID -or -not $usersSID) {
        Write-Error "One or more SIDs could not be retrieved. Aborting..."
        return
    }

    # Skriv ut användare och SID
    Write-Host "  SID for Administrators: $administratorsSID"
    Write-Host "  SID for LOCAL SERVICE: $localServiceSID"
    Write-Host "  SID for Users: $usersSID"

    # Skapa INF-filen
    $infPath = "$env:TEMP\cis2.2.9_timezone.inf"
    $dbPath = "$env:TEMP\cis2.2.9_timezone.sdb"

    @"
[Unicode]
Unicode=yes

[Version]
signature=`"$STOCKHOLM$`
Revision=1

[Privilege Rights]
SeTimeZonePrivilege = $administratorsSID,$localServiceSID,$usersSID
"@ | Set-Content -Encoding ASCII -Path $infPath

    # Kör secedit
    secedit /configure /db $dbPath /cfg $infPath /areas USER_RIGHTS /quiet

    # Kontrollera om SDB-filen finns innan du tar bort den
    if (Test-Path $dbPath) {
        Remove-Item $dbPath -Force
    }

    # Ta bort INF-filen
    Remove-Item $infPath -Force

    Write-Host "  SeTimeZonePrivilege has been set successfully." -ForegroundColor Green
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

# CIS Control: 2.3.10.7. (L1) Ensure 'Network access: Remotely accessible registry paths' is configured
# In simpler terms: This setting controls which parts of your computer's settings (the registry) can be accessed from other computers on the network.
# Recommended Value: See RegistryChanges for allowed paths
# Possible Values: A list of registry paths

$cisControl_2_3_10_7 = @{
    "ID" = "2.3.10.7"
    "Description" = "Ensure 'Network access: Remotely accessible registry paths' is configured"
    "SimpleTerms" = "This setting controls which parts of your computer's settings (the registry) can be accessed from other computers on the network."
    "RecommendedValue" = "See RegistryChanges for allowed paths"
    "PossibleValues" = "A list of registry paths"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" = @{
            "AccessiblePaths" = @(
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
        }
    }
}

# CIS Control: 2.3.10.6. (L1) Ensure 'Network access: Named Pipes that can be accessed anonymously' is set to 'None'
# In simpler terms: This setting controls which "Named Pipes" (a way for programs to talk to each other) can be accessed without someone logging in. We want to block this.
# Recommended Value: None (empty list)
# Possible Values: A list of Named Pipe names

$cisControl_2_3_10_6 = @{
    "ID" = "2.3.10.6"
    "Description" = "Ensure 'Network access: Named Pipes that can be accessed anonymously' is set to 'None'"
    "SimpleTerms" = "This setting controls which 'Named Pipes' (a way for programs to talk to each other) can be accessed without someone logging in. We want to block this."
    "RecommendedValue" = "None (empty list)"
    "PossibleValues" = "A list of Named Pipe names"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" = @{
            "NullSessionPipes" = @() # Empty array for "None"
        }
    }
}

# CIS Control: 2.3.10.5. (L1) Ensure 'Network access: Let Everyone permissions apply to anonymous users' is set to 'Disabled'
# In simpler terms: This setting controls whether network permissions given to the "Everyone" group also apply to people who haven't logged in. We want to prevent this.
# Recommended Value: Disabled (value 0)
# Possible Values: 0 (Disabled), 1 (Enabled)

$cisControl_2_3_10_5 = @{
    "ID" = "2.3.10.5"
    "Description" = "Ensure 'Network access: Let Everyone permissions apply to anonymous users' is set to 'Disabled'"
    "SimpleTerms" = "This setting controls whether network permissions given to the 'Everyone' group also apply to people who haven't logged in. We want to prevent this."
    "RecommendedValue" = "Disabled (value 0)"
    "PossibleValues" = "0 (Disabled), 1 (Enabled)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" = @{
            "EveryoneIncludesAnonymous" = 0 # 0 = Disabled, 1 = Enabled
        }
    }
}


# CIS Control: 2.3.10.2. (L1) Ensure 'Network access: Do not allow anonymous enumeration of SAM accounts' is set to 'Enabled'
# In simpler terms: This setting stops people from listing the names of user accounts on your computer without logging in.
# Recommended Value: Enabled (value 1)
# Possible Values: 0 (Disabled), 1 (Enabled)

$cisControl_2_3_10_2 = @{
    "ID" = "2.3.10.2"
    "Description" = "Ensure 'Network access: Do not allow anonymous enumeration of SAM accounts' is set to 'Enabled'"
    "SimpleTerms" = "This setting stops people from listing the names of user accounts on your computer without logging in."
    "RecommendedValue" = "Enabled (value 1)"
    "PossibleValues" = "0 (Disabled), 1 (Enabled)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" = @{
            "RestrictAnonymousSAM" = 1 # 1 = Enabled, 0 = Disabled
        }
    }
}

# CIS Control: 2.3.10.12. (L1) Ensure 'Network access: Sharing and security model for local accounts' is set to 'Classic - local users authenticate as themselves'
# In simpler terms: This setting controls how your computer handles security when people on the network try to access shared resources. "Classic" is the more secure option.
# Recommended Value: Classic - local users authenticate as themselves (value 0)
# Possible Values: 0 (Classic), 1 (Guest only)

$cisControl_2_3_10_12 = @{
    "ID" = "2.3.10.12"
    "Description" = "Ensure 'Network access: Sharing and security model for local accounts' is set to 'Classic - local users authenticate as themselves'"
    "SimpleTerms" = "This setting controls how your computer handles security when people on the network try to access shared resources. 'Classic' is the more secure option."
    "RecommendedValue" = "Classic - local users authenticate as themselves (value 0)"
    "PossibleValues" = "0 (Classic), 1 (Guest only)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" = @{
            "ForceGuest" = 0 # 0 = Classic, 1 = Guest only
        }
    }
}


# CIS Control: 2.3.10.11. (L1) Ensure 'Network access: Shares that can be accessed anonymously' is set to 'None'
# In simpler terms: This setting controls which shared folders on your computer can be accessed by people on the network without logging in. We want to block this.
# Recommended Value: None (empty list)
# Possible Values: A list of share names

$cisControl_2_3_10_11 = @{
    "ID" = "2.3.10.11"
    "Description" = "Ensure 'Network access: Shares that can be accessed anonymously' is set to 'None'"
    "SimpleTerms" = "This setting controls which shared folders on your computer can be accessed by people on the network without logging in. We want to block this."
    "RecommendedValue" = "None (empty list)"
    "PossibleValues" = "A list of share names"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" = @{
            "NullSessionShares" = @() # Empty array for "None"
        }
    }
}

# CIS Control: 2.3.1.3. (L1) Ensure 'Accounts: Limit local account use of blank passwords to console logon only' is set to 'Enabled'
# In simpler terms: This setting stops local accounts (accounts created on this computer) from logging in without a password over the network.
# Recommended Value: Enabled (value 1)
# Possible Values: 0 (Disabled), 1 (Enabled)

$cisControl_2_3_1_3 = @{
    "ID" = "2.3.1.3"
    "Description" = "Ensure 'Accounts: Limit local account use of blank passwords to console logon only' is set to 'Enabled'"
    "SimpleTerms" = "This setting stops local accounts (accounts created on this computer) from logging in without a password over the network."
    "RecommendedValue" = "Enabled (value 1)"
    "PossibleValues" = "0 (Disabled), 1 (Enabled)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" = @{
            "LimitBlankPasswordUse" = 1 # 1 = Enabled, 0 = Disabled
        }
    }
}

# CIS Control: 2.3.1.2. (L1) Ensure 'Accounts: Guest account status' is set to 'Disabled'
# In simpler terms: This setting turns off the "Guest" account, which is a special account that allows people to use the computer without logging in.
# Recommended Value: Disabled (value 0)
# Possible Values: 0 (Disabled), 1 (Enabled)

$cisControl_2_3_1_2 = @{
    "ID" = "2.3.1.2"
    "Description" = "Ensure 'Accounts: Guest account status' is set to 'Disabled'"
    "SimpleTerms" = "This setting turns off the 'Guest' account, which is a special account that allows people to use the computer without logging in."
    "RecommendedValue" = "Disabled (value 0)"
    "PossibleValues" = "0 (Disabled), 1 (Enabled)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" = @{
            "GuestAccountStatus" = 0 # 0 = Disabled, 1 = Enabled
        }
    }
}


# CIS Control: 2.2.9. (L1) Ensure 'Change the time zone' is set to 'Administrators, LOCAL SERVICE, Users'
# In simpler terms: This setting controls who is allowed to change the computer's time zone.
# Recommended Value: Administrators, LOCAL SERVICE, Users
# Possible Values: (Complex - involves setting registry key permissions)
# Lägg till i din CIS-kontroll-struktur
$cisControl_2_2_9 = @{
    "ID" = "2.2.9"
    "Description" = "Ensure 'Change the time zone' is set to 'Administrators, LOCAL SERVICE, Users'"
    "SimpleTerms" = "Control who is allowed to change the computer's time zone."
    "RecommendedValue" = "Administrators, LOCAL SERVICE, Users"
    "PossibleValues" = "User rights assignment: SeTimeZonePrivilege"
    "Action" = { Write-Host "Processing CIS Control 2.2.9: Ensure 'Change the time zone' is set to 'Administrators, LOCAL SERVICE, Users'"
                # Hämta SID för användarna och grupperna
                $administratorsSID = Get-SID -accountName "Administrators"
                $localServiceSID = Get-SID -accountName "LOCAL SERVICE"
                $usersSID = Get-SID -accountName "Users"
                # Skriv ut användare och SID
                Write-Host "  SID for Administrators: $administratorsSID"
                Write-Host "  SID for LOCAL SERVICE: $localServiceSID"
                Write-Host "  SID for Users: $usersSID"
                Set-TimeZonePrivilege 
                }  # <-- viktig del
}
$cisControl_2_2_9ORG = @{
    "ID" = "2.2.9"
    "Description" = "Ensure 'Change the time zone' is set to 'Administrators, LOCAL SERVICE, Users'"
    "SimpleTerms" = "This setting controls who is allowed to change the computer's time zone."
    "RecommendedValue" = "Administrators, LOCAL SERVICE, Users"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                @{ Identity = "Administrators"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" },
                @{ Identity = "LOCAL SERVICE"; FileSystemRights = "Read"; InheritanceFlags = "None"; PropagationFlags = "None" },
                @{ Identity = "Users"; FileSystemRights = "Read"; InheritanceFlags = "None"; PropagationFlags = "None" }
            )
        }
    }
}

# CIS Control: 2.2.8. (L1) Ensure 'Change the system time' is set to 'Administrators, LOCAL SERVICE'
# In simpler terms: This setting controls who is allowed to change the computer's time.
# Recommended Value: Administrators, LOCAL SERVICE
# Possible Values: (Complex - involves setting registry key permissions)
$cisControl_2_2_8 = @{
    "ID" = "2.2.8"
    "Description" = "Ensure 'Change the system time' is set to 'Administrators, LOCAL SERVICE'"
    "SimpleTerms" = "This setting controls who is allowed to change the computer's time."
    "RecommendedValue" = "Administrators, LOCAL SERVICE"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" = @{
            "Permissions" = @( # Detta är ett exempel på behörigheter
                @{ Identity = "Administrators"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" },
                @{ Identity = "LOCAL SERVICE"; FileSystemRights = "ReadKey"; InheritanceFlags = "None"; PropagationFlags = "None" }
            )
        }
    }
}

# CIS Control: 2.2.6. (L1) Ensure 'Allow log on through Remote Desktop Services' is set to 'Administrators, Remote Desktop Users'
# In simpler terms: This setting controls who is allowed to connect to the computer using Remote Desktop.
# Recommended Value: Administrators, Remote Desktop Users
# Possible Values: (Complex - involves setting registry key permissions and a registry value)
$cisControl_2_2_6 = @{
    "ID" = "2.2.6"
    "Description" = "Ensure 'Allow log on through Remote Desktop Services' is set to 'Administrators, Remote Desktop Users'"
    "SimpleTerms" = "This setting controls who is allowed to connect to the computer using Remote Desktop."
    "RecommendedValue" = "Administrators, Remote Desktop Users"
    "PossibleValues" = "(Complex - involves setting registry key permissions and a registry value)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" = @{
            "UserAuthentication" = 1 # 1 = Enabled (required authentication)
            "permissions" = @(
                @{ Identity = "BUILTIN\Administrators"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" },
                @{ Identity = "BUILTIN\Remote Desktop Users"; FileSystemRights = "ReadKey"; InheritanceFlags = "None"; PropagationFlags = "None" }
            )
        }
    }
}


# CIS Control: 2.2.4. (L1) Ensure 'Adjust memory quotas for a process' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE'
# In simpler terms: This setting controls who is allowed to change how much memory a program can use.
# Recommended Value: Administrators, LOCAL SERVICE, NETWORK SERVICE
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_4 = @{
    "ID" = "2.2.4"
    "Description" = "Ensure 'Adjust memory quotas for a process' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE'"
    "SimpleTerms" = "This setting controls who is allowed to change how much memory a program can use."
    "RecommendedValue" = "Administrators, LOCAL SERVICE, NETWORK SERVICE"
    "PossibleValues" = "(Multi-String SID list in registry)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" = @{
            "SeIncreaseQuotaPrivilege" = @{
                "Type" = "MultiString"
                "Value" = @(
                    "S-1-5-32-544",  # Administrators
                    "S-1-5-19",      # LOCAL SERVICE
                    "S-1-5-20"       # NETWORK SERVICE
                )
            }
        }
    }
}


# CIS Control: 2.2.39. (L1) Ensure 'Take ownership of files or other objects' is set to 'Administrators'
# In simpler terms: This setting controls who is allowed to become the owner of files and folders. We want to limit this to administrators.
# Recommended Value: Administrators
# Possible Values: (Complex - involves setting registry key permissions)
$cisControl_2_2_39 = @{
    "ID" = "2.2.39"
    "Description" = "Ensure 'Take ownership of files or other objects' is set to 'Administrators'"
    "SimpleTerms" = "This setting controls who is allowed to become the owner of files and folders. We want to limit this to administrators."
    "RecommendedValue" = "Administrators"
    "PossibleValues" = "(Multi-String SID list in registry)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" = @{
            "SeTakeOwnershipPrivilege" = @{
                "Type" = "MultiString"
                "Value" = @(
                    "S-1-5-32-544"  # Administrators SID
                )
            }
        }
    }
}


# CIS Control: 2.2.36. (L1) Ensure 'Replace a process level token' is set to 'LOCAL SERVICE, NETWORK SERVICE'
# In simpler terms: This setting controls which system services are allowed to use a special way of getting access to resources. We want to limit this to specific, trusted services.
# Recommended Value: LOCAL SERVICE, NETWORK SERVICE
# Possible Values: A list of user or group names
$cisControl_2_2_36 = @{
    "ID" = "2.2.36"
    "Description" = "Ensure 'Replace a process level token' is set to 'LOCAL SERVICE, NETWORK SERVICE'"
    "SimpleTerms" = "This setting controls which system services are allowed to use a special way of getting access to resources. We want to limit this to specific, trusted services."
    "RecommendedValue" = "LOCAL SERVICE, NETWORK SERVICE"
    "PossibleValues" = "A list of user or group names"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Type" = "MultiString"
            "Name" = "Default"  # Lägg till Name här för MultiString-värdet
            "Value" = @(
                "S-1-5-19",  # LOCAL SERVICE
                "S-1-5-20"   # NETWORK SERVICE
            )
        }
    }
}


$cisControl_2_2_36ORG = @{
    "ID" = "2.2.36"
    "Description" = "Ensure 'Replace a process level token' is set to 'LOCAL SERVICE, NETWORK SERVICE'"
    "SimpleTerms" = "This setting controls which system services are allowed to use a special way of getting access to resources. We want to limit this to specific, trusted services."
    "RecommendedValue" = "LOCAL SERVICE, NETWORK SERVICE"
    "PossibleValues" = "A list of user or group names"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                @{ Identity = "NT AUTHORITY\LOCAL SERVICE"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" },
                @{ Identity = "NT AUTHORITY\NETWORK SERVICE"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" }
            )
        }
    }
}


# CIS Control: 2.2.35. (L1) Ensure 'Profile system performance' is set to 'Administrators, NT SERVICE\WdiServiceHost'
# In simpler terms: This setting controls who is allowed to collect detailed information about how the system is performing.
# Recommended Value: Administrators, NT SERVICE\WdiServiceHost
# Possible Values: (Complex - involves setting registry key permissions)
$cisControl_2_2_35 = @{
    "ID" = "2.2.35"
    "Description" = "Ensure 'Profile system performance' is set to 'Administrators, NT SERVICE\WdiServiceHost'"
    "SimpleTerms" = "This setting controls who is allowed to collect detailed information about how the system is performing."
    "RecommendedValue" = "Administrators, NT SERVICE\WdiServiceHost"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Type" = "MultiString"
            "Value" = @(
                "S-1-5-32-544",  # Administrators
                "S-1-5-80-0"     # NT SERVICE\WdiServiceHost
            )
        }
    }
}
$cisControl_2_2_35ORG = @{
    "ID" = "2.2.35"
    "Description" = "Ensure 'Profile system performance' is set to 'Administrators, NT SERVICE\WdiServiceHost'"
    "SimpleTerms" = "This setting controls who is allowed to collect detailed information about how the system is performing."
    "RecommendedValue" = "Administrators, NT SERVICE\WdiServiceHost"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                @{ Identity = "BUILTIN\Administrators"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" },
                @{ Identity = "NT SERVICE\WdiServiceHost"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" }
            )
        }
    }
}


# CIS Control: 2.2.34. (L1) Ensure 'Profile single process' is set to 'Administrators'
# In simpler terms: This setting controls who is allowed to collect detailed information about how a single program is running.
# Recommended Value: Administrators
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_34 = @{
    "ID" = "2.2.34"
    "Description" = "Ensure 'Profile single process' is set to 'Administrators'"
    "SimpleTerms" = "This setting controls who is allowed to collect detailed information about how a single program is running."
    "RecommendedValue" = "Administrators"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                @{ Identity = "BUILTIN\Administrators"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" }
            )
        }
    }
}


# CIS Control: 2.2.33. (L1) Ensure 'Perform volume maintenance tasks' is set to 'Administrators'
# In simpler terms: This setting controls who is allowed to do things like defragmenting hard drives or checking them for errors.
# Recommended Value: Administrators
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_33 = @{
    "ID" = "2.2.33"
    "Description" = "Ensure 'Perform volume maintenance tasks' is set to 'Administrators'"
    "SimpleTerms" = "This setting controls who is allowed to do things like defragmenting hard drives or checking them for errors."
    "RecommendedValue" = "Administrators"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                @{ Identity = "BUILTIN\Administrators"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" }
            )
        }
    }
}


# CIS Control: 2.2.32. (L1) Ensure 'Modify firmware environment values' is set to 'Administrators'
# In simpler terms: This setting controls who is allowed to change settings in the computer's firmware (the software that starts the computer).
# Recommended Value: Administrators
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_32 = @{
    "ID" = "2.2.32"
    "Description" = "Ensure 'Modify firmware environment values' is set to 'Administrators'"
    "SimpleTerms" = "This setting controls who is allowed to change settings in the computer's firmware (the software that starts the computer)."
    "RecommendedValue" = "Administrators"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                @{ Identity = "BUILTIN\Administrators"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" }
            )
        }
    }
}


# CIS Control: 2.2.31. (L1) Ensure 'Modify an object label' is set to 'No One'
# In simpler terms: This setting controls who is allowed to change the security labels on files and other system objects. We want to prevent anyone from doing this.
# Recommended Value: No One
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_31 = @{
    "ID" = "2.2.31"
    "Description" = "Ensure 'Modify an object label' is set to 'No One'"
    "SimpleTerms" = "This setting controls who is allowed to change the security labels on files and other system objects. We want to prevent anyone from doing this."
    "RecommendedValue" = "No One"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                # Setting this to "No One" requires removing all existing permissions, which is also a complex ACL operation.
            )
        }
    }
}


# CIS Control: 2.2.30. (L1) Ensure 'Manage auditing and security log' is set to 'Administrators'
# In simpler terms: This setting controls who is allowed to manage the security log, where important security events are recorded.
# Recommended Value: Administrators
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_30 = @{
    "ID" = "2.2.30"
    "Description" = "Ensure 'Manage auditing and security log' is set to 'Administrators'"
    "SimpleTerms" = "This setting controls who is allowed to manage the security log, where important security events are recorded."
    "RecommendedValue" = "Administrators"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                @{ Identity = "BUILTIN\Administrators"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" }
            )
        }
    }
}


# CIS Control: 2.2.3. (L1) Ensure 'Act as part of the operating system' is set to 'No One'
# In simpler terms: This setting controls which accounts are allowed to act as a core part of Windows itself, which is a very powerful ability. We want to prevent anyone from doing this.
# Recommended Value: No One
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_3 = @{
    "ID" = "2.2.3"
    "Description" = "Ensure 'Act as part of the operating system' is set to 'No One'"
    "SimpleTerms" = "This setting controls which accounts are allowed to act as a core part of Windows itself, which is a very powerful ability. We want to prevent anyone from doing this."
    "RecommendedValue" = "No One"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                # Setting this to "No One" requires removing all existing permissions, which is also a complex ACL operation.
            )
        }
    }
}


# CIS Control: 2.2.27. (L1) Ensure 'Lock pages in memory' is set to 'No One'
# In simpler terms: This setting controls who is allowed to keep data in the computer's memory, preventing it from being swapped to the hard drive. We want to prevent anyone from doing this.
# Recommended Value: No One
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_27 = @{
    "ID" = "2.2.27"
    "Description" = "Ensure 'Lock pages in memory' is set to 'No One'"
    "SimpleTerms" = "This setting controls who is allowed to keep data in the computer's memory, preventing it from being swapped to the hard drive. We want to prevent anyone from doing this."
    "RecommendedValue" = "No One"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                # Setting this to "No One" requires removing all existing permissions, which is also a complex ACL operation.
            )
        }
    }
}

# CIS Control: 2.2.26. (L1) Ensure 'Load and unload device drivers' is set to 'Administrators'
# In simpler terms: This setting controls who is allowed to install and remove the software that makes your computer work with hardware (like printers or graphics cards).
# Recommended Value: Administrators
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_26 = @{
    "ID" = "2.2.26"
    "Description" = "Ensure 'Load and unload device drivers' is set to 'Administrators'"
    "SimpleTerms" = "This setting controls who is allowed to install and remove the software that makes your computer work with hardware (like printers or graphics cards)."
    "RecommendedValue" = "Administrators"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                @{ Identity = "BUILTIN\Administrators"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" }
            )
        }
    }
}


# CIS Control: 2.2.25. (L1) Ensure 'Increase scheduling priority' is set to 'Administrators, Window Manager\Window Manager Group'
# In simpler terms: This setting controls who is allowed to make programs run faster than normal.
# Recommended Value: Administrators, NT SERVICE\Winmgmt
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_25 = @{
    "ID" = "2.2.25"
    "Description" = "Ensure 'Increase scheduling priority' is set to 'Administrators, Window Manager\Window Manager Group'"
    "SimpleTerms" = "This setting controls who is allowed to make programs run faster than normal."
    "RecommendedValue" = "Administrators, NT SERVICE\Winmgmt"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                @{ Identity = "BUILTIN\Administrators"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" },
                @{ Identity = "NT SERVICE\Winmgmt"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" }
            )
        }
    }
}


# CIS Control: 2.2.24. (L1) Ensure 'Impersonate a client after authentication' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'
# In simpler terms: This setting controls which accounts are allowed to temporarily "pretend" to be another user or service to access resources.
# Recommended Value: Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_24 = @{
    "ID" = "2.2.24"
    "Description" = "Ensure 'Impersonate a client after authentication' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'"
    "SimpleTerms" = "This setting controls which accounts are allowed to temporarily 'pretend' to be another user or service to access resources."
    "RecommendedValue" = "Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                @{ Identity = "BUILTIN\Administrators"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" },
                @{ Identity = "NT AUTHORITY\LOCAL SERVICE"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" },
                @{ Identity = "NT AUTHORITY\NETWORK SERVICE"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" },
                @{ Identity = "NT AUTHORITY\SERVICE"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" }
            )
        }
    }
}


# CIS Control: 2.2.23. (L1) Ensure 'Generate security audits' is set to 'LOCAL SERVICE, NETWORK SERVICE'
# In simpler terms: This setting controls which system services are allowed to create records in the security log, which tracks important security events.
# Recommended Value: LOCAL SERVICE, NETWORK SERVICE
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_23 = @{
    "ID" = "2.2.23"
    "Description" = "Ensure 'Generate security audits' is set to 'LOCAL SERVICE, NETWORK SERVICE'"
    "SimpleTerms" = "This setting controls which system services are allowed to create records in the security log, which tracks important security events."
    "RecommendedValue" = "LOCAL SERVICE, NETWORK SERVICE"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                @{ Identity = "NT AUTHORITY\LOCAL SERVICE"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" },
                @{ Identity = "NT AUTHORITY\NETWORK SERVICE"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" }
            )
        }
    }
}


# CIS Control: 2.2.22. (L1) Ensure 'Force shutdown from a remote system' is set to 'Administrators'
# In simpler terms: This setting controls who is allowed to shut down the computer from another computer over the network.
# Recommended Value: Administrators
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_22 = @{
    "ID" = "2.2.22"
    "Description" = "Ensure 'Force shutdown from a remote system' is set to 'Administrators'"
    "SimpleTerms" = "This setting controls who is allowed to shut down the computer from another computer over the network."
    "RecommendedValue" = "Administrators"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                @{ Identity = "BUILTIN\Administrators"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" }
            )
        }
    }
}


# CIS Control: 2.2.21. (L1) Ensure 'Enable computer and user accounts to be trusted for delegation' is set to 'No One'
# In simpler terms: This setting controls who is allowed to let a computer or user account act on their behalf to access resources on other computers. We want to prevent anyone from doing this.
# Recommended Value: No One (remove all permissions)
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_21 = @{
    "ID" = "2.2.21"
    "Description" = "Ensure 'Enable computer and user accounts to be trusted for delegation' is set to 'No One'"
    "SimpleTerms" = "This setting controls who is allowed to let a computer or user account act on their behalf to access resources on other computers. We want to prevent anyone from doing this."
    "RecommendedValue" = "No One (remove all permissions)"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                # Setting this to "No One" requires removing all existing permissions, which is also a complex ACL operation.
            )
        }
    }
}


# CIS Control: 2.2.15. (L1) Ensure 'Debug programs' is set to 'Administrators'
# In simpler terms: This setting controls who is allowed to examine and modify the inner workings of running programs, which is a powerful debugging capability.
# Recommended Value: Administrators
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_15 = @{
    "ID" = "2.2.15"
    "Description" = "Ensure 'Debug programs' is set to 'Administrators'"
    "SimpleTerms" = "This setting controls who is allowed to examine and modify the inner workings of running programs, which is a powerful debugging capability."
    "RecommendedValue" = "Administrators"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                @{ Identity = "BUILTIN\Administrators"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" }
            )
        }
    }
}


# CIS Control: 2.2.14. (L1) Ensure 'Create symbolic links' is set to 'Administrators'
# In simpler terms: This setting controls who is allowed to create special types of shortcuts that can point to files or folders in other locations.
# Recommended Value: Administrators
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_14 = @{
    "ID" = "2.2.14"
    "Description" = "Ensure 'Create symbolic links' is set to 'Administrators'"
    "SimpleTerms" = "This setting controls who is allowed to create special types of shortcuts that can point to files or folders in other locations."
    "RecommendedValue" = "Administrators"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                @{ Identity = "BUILTIN\Administrators"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" }
            )
        }
    }
}

# CIS Control: 2.2.13. (L1) Ensure 'Create permanent shared objects' is set to 'No One'
# In simpler terms: This setting controls who is allowed to create special objects in the system that can be accessed by multiple programs. We want to prevent anyone from doing this.
# Recommended Value: No One (remove all permissions)
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_13 = @{
    "ID" = "2.2.13"
    "Description" = "Ensure 'Create permanent shared objects' is set to 'No One'"
    "SimpleTerms" = "This setting controls who is allowed to create special objects in the system that can be accessed by multiple programs. We want to prevent anyone from doing this."
    "RecommendedValue" = "No One (remove all permissions)"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                # Setting this to "No One" requires removing all existing permissions, which is also a complex ACL operation.
            )
        }
    }
}


# CIS Control: 2.2.12. (L1) Ensure 'Create global objects' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'
# In simpler terms: This setting controls which accounts are allowed to create objects that can be accessed by any program on the computer.
# Recommended Value: Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_12 = @{
    "ID" = "2.2.12"
    "Description" = "Ensure 'Create global objects' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'"
    "SimpleTerms" = "This setting controls which accounts are allowed to create objects that can be accessed by any program on the computer."
    "RecommendedValue" = "Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                @{ Identity = "BUILTIN\Administrators"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" },
                @{ Identity = "NT AUTHORITY\LOCAL SERVICE"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" },
                @{ Identity = "NT AUTHORITY\NETWORK SERVICE"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" },
                @{ Identity = "NT AUTHORITY\SERVICE"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" }
            )
        }
    }
}

# CIS Control: 2.2.11. (L1) Ensure 'Create a token object' is set to 'No One'
# In simpler terms: This setting controls who is allowed to create special security objects called "tokens," which are used to control access to resources. We want to prevent anyone from doing this.
# Recommended Value: No One (remove all permissions)
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_11 = @{
    "ID" = "2.2.11"
    "Description" = "Ensure 'Create a token object' is set to 'No One'"
    "SimpleTerms" = "This setting controls who is allowed to create special security objects called 'tokens,' which are used to control access to resources. We want to prevent anyone from doing this."
    "RecommendedValue" = "No One (remove all permissions)"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                # Setting this to "No One" requires removing all existing permissions, which is also a complex ACL operation.
            )
        }
    }
}

# CIS Control: 2.2.10. (L1) Ensure 'Create a pagefile' is set to 'Administrators'
# In simpler terms: This setting controls who is allowed to create the "pagefile," which is a special file on your hard drive that Windows uses as extra memory.
# Recommended Value: Administrators
# Possible Values: (Complex - involves setting registry key permissions)

$cisControl_2_2_10 = @{
    "ID" = "2.2.10"
    "Description" = "Ensure 'Create a pagefile' is set to 'Administrators'"
    "SimpleTerms" = "This setting controls who is allowed to create the 'pagefile,' which is a special file on your hard drive that Windows uses as extra memory."
    "RecommendedValue" = "Administrators"
    "PossibleValues" = "(Complex - involves setting registry key permissions)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\SePrivilegeAssignment" = @{
            "Permissions" = @( # This is a placeholder - setting permissions is complex!
                @{ Identity = "BUILTIN\Administrators"; FileSystemRights = "FullControl"; InheritanceFlags = "None"; PropagationFlags = "None" }
            )
        }
    }
}


# CIS Control: 2.2.1. (L1) Ensure 'Access Credential Manager as a trusted caller' is set to 'No One'
# In simpler terms: This setting controls which accounts are allowed to ask Credential Manager (where Windows stores passwords and other credentials) for information. We want to prevent anyone from doing this.
# Recommended Value: No One (remove all permissions)
# Possible Values: (Complex - involves setting registry key permissions)
$cisControl_2_2_1 = @{
    "ID" = "2.2.1"
    "Description" = "Ensure 'Access Credential Manager as a trusted caller' is set to 'No One'"
    "SimpleTerms" = "This setting controls which accounts are allowed to ask Credential Manager (where Windows stores passwords and other credentials) for information. We want to prevent anyone from doing this."
    "RecommendedValue" = "No One (remove all permissions)"
    "PossibleValues" = "(Multi-String SID list in registry)"
    "RegistryChanges" = @{
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" = @{
            "SeTrustedCredManAccessPrivilege" = @{
                "Type" = "MultiString"
                "Value" = @()  # Tom lista = inga användare/grupper tilldelade
            }
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
                $cisControl_2_3_10_8,
                $cisControl_2_3_10_7,
                $cisControl_2_3_10_6,
                $cisControl_2_3_10_5,
                $cisControl_2_3_10_2,
                $cisControl_2_3_10_12,
                $cisControl_2_3_10_11,
                $cisControl_2_3_1_3,
                $cisControl_2_3_1_2,
                $cisControl_2_2_9, 
                $cisControl_2_2_8,
                #$cisControl_2_2_6, #RDP access
                $cisControl_2_2_4,
                $cisControl_2_2_39,
                $cisControl_2_2_36,
                $cisControl_2_2_35,
                #$cisControl_2_2_34,
                #$cisControl_2_2_33,
                #$cisControl_2_2_32,
                #$cisControl_2_2_31,
                #$cisControl_2_2_30,
                #$cisControl_2_2_3,
                #$cisControl_2_2_27,
                #$cisControl_2_2_26,
                #$cisControl_2_2_25,
                #$cisControl_2_2_24,
                #$cisControl_2_2_23,
                #$cisControl_2_2_22,
                #$cisControl_2_2_21,
                #$cisControl_2_2_15,
                #$cisControl_2_2_14,
                #$cisControl_2_2_13,
                #$cisControl_2_2_12,
                #$cisControl_2_2_11,
                #$cisControl_2_2_10,
                $cisControl_2_2_1
               )

# Loopa genom alla CIS-kontroller och applicera relevanta ändringar
foreach ($cisControl in $cisControls) {
    Write-Host "Processing CIS Control $($cisControl.ID)" -ForegroundColor Cyan
    Write-Host "###################################################################################" -ForegroundColor Cyan

    if ($cisControl.Description -and $cisControl.SimpleTerms -and $cisControl.RecommendedValue -and $cisControl.PossibleValues) {
        Write-Host "Processing CIS Control $($cisControl.ID): $($cisControl.Description)" -ForegroundColor Cyan
        Write-Host "  In simpler terms: $($cisControl.SimpleTerms)"
        Write-Host "  Recommended Value: $($cisControl.RecommendedValue)"
        Write-Host "  Possible Values: $($cisControl.PossibleValues)"
    } else {
        Write-Host "Missing information for CIS Control $($cisControl.ID). Skipping." -ForegroundColor Red
        continue
    }

    if ($cisControl.RegistryChanges) {
        foreach ($registryChange in $cisControl.RegistryChanges.GetEnumerator()) {
            $keyPath = $registryChange.Key
            $keyDetails = $registryChange.Value

            Write-Host "Registry Change for ${keyPath}:"

            # Om Permissions finns, hantera ACL
            if ($keyDetails.ContainsKey("Permissions")) {
                foreach ($permission in $keyDetails.Permissions) {
                    $sid = Get-SID -accountName $permission.Identity
                    Write-Host "  SID for $($permission.Identity): $sid"
                }

                try {
                    $acl = Get-Acl -Path "Registry::$keyPath"

                    foreach ($permission in $keyDetails.Permissions) {
                        $identity = New-Object System.Security.Principal.NTAccount($permission.Identity)
                        $rights = [System.Security.AccessControl.RegistryRights]::ReadKey
                        if ($permission.FileSystemRights -eq "FullControl") {
                            $rights = [System.Security.AccessControl.RegistryRights]::FullControl
                        }

                        $accessRule = New-Object System.Security.AccessControl.RegistryAccessRule(
                            $identity,
                            $rights,
                            $permission.InheritanceFlags,
                            $permission.PropagationFlags,
                            "Allow"
                        )
                        $acl.AddAccessRule($accessRule)
                    }

                    Set-Acl -Path "Registry::$keyPath" -AclObject $acl
                    Write-Host "Successfully set permissions for key '$keyPath'" -ForegroundColor Green

                } catch {
                    Write-Host "Failed to set permissions for key '$keyPath': $_" -ForegroundColor Red
                }
            }

            # Om MultiString-värde ska sättas
            if ($keyDetails.ContainsKey("Value") -and $keyDetails.Type -eq "MultiString") {
                $valueName = $keyDetails.Name  # Kontrollera om det finns ett namn för multi-string värdet
                $value = $keyDetails.Value

                # Se till att både Name och Value är definierade
                if (-not $valueName) {
                    Write-Host "No value name specified for multi-string. Skipping." -ForegroundColor Red
                    continue
                }
                if (-not $value) {
                    Write-Host "No value specified for multi-string. Skipping." -ForegroundColor Red
                    continue
                }

                try {
                    Set-ItemProperty -Path "Registry::$keyPath" -Name $valueName -Value $value
                    Write-Host "Successfully set multi-string value for $keyPath\$valueName" -ForegroundColor Green
                } catch {
                    Write-Host "Failed to set multi-string value for ${keyPath}\${valueName}: $_" -ForegroundColor Red
                }
            }


            # Om det är ett vanligt strängvärde som ska sättas
            if ($keyDetails.ContainsKey("Value") -and $keyDetails.Type -eq "String") {
                $valueName = $keyDetails.Name
                $value = $keyDetails.Value

                try {
                    Set-ItemProperty -Path "Registry::$keyPath" -Name $valueName -Value $value
                    Write-Host "Successfully set string value for $keyPath\$valueName" -ForegroundColor Green
                } catch {
                    Write-Host "Failed to set string value for ${keyPath}\${valueName}: $_" -ForegroundColor Red
                }
            }

            # Om det är en annan typ som ska hanteras (t.ex. andra specialfall)
            # Lägg till extra logik om det behövs för ytterligare typer av värden eller förändringar.
        }
    }

    Write-Host "###################################################################################" -ForegroundColor Cyan
}

