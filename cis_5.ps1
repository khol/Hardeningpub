# CIS Control: 5.3. (L1) Ensure 'Computer Browser (Browser)' is set to 'Disabled' or 'Not Installed'
# In simpler terms: This setting turns off the service that maintains a list of computers on the network (often not needed in modern networks).
# Check if service exists, stop if running, set to disabled, and report
if (Get-Service -Name "Browser" -ErrorAction SilentlyContinue) {
    # Get current state and StartupType
    $originalService = Get-Service -Name "Browser"
    $originalState = $originalService.State
    $originalStartupType = $originalService.StartType

    Write-Host "  Original State: $originalState"
    Write-Host "  Original StartupType: $originalStartupType"

    if ($originalState -eq "Running") { Stop-Service -Name "Browser" -Force }
    Set-Service -Name "Browser" -StartupType Disabled;
    Write-Host "  CIS 5.3: Browser set to Disabled" -ForegroundColor Green

    # Verification (output new state)
    $newState = (Get-Service -Name "Browser").State
    $newStartupType = (Get-Service -Name "Browser").StartType
    Write-Host "  New State: $newState"
    Write-Host "  New StartupType: $newStartupType"

} else { Write-Host "CIS 5.3: Browser not installed" -ForegroundColor Green }

# CIS Control: 5.6. (L1) Ensure 'IIS Admin Service (IISADMIN)' is set to 'Disabled' or 'Not Installed'
# In simpler terms: This setting turns off the service that manages Internet Information Services (IIS), Microsoft's web server.
# Check if service exists, stop if running, set to disabled, and report
if (Get-Service -Name "IISADMIN" -ErrorAction SilentlyContinue) {
    # Get current state and StartupType
    $originalService = Get-Service -Name "IISADMIN"
    $originalState = $originalService.State
    $originalStartupType = $originalService.StartType

    Write-Host "  Original State: $originalState"
    Write-Host "  Original StartupType: $originalStartupType"

    if ($originalState -eq "Running") { Stop-Service -Name "IISADMIN" -Force }
    Set-Service -Name "IISADMIN" -StartupType Disabled;
    Write-Host "  CIS 5.6: IISADMIN set to Disabled" -ForegroundColor Green

    # Verification (output new state)
    $newState = (Get-Service -Name "IISADMIN").State
    $newStartupType = (Get-Service -Name "IISADMIN").StartType
    Write-Host "  New State: $newState"
    Write-Host "  New StartupType: $newStartupType"

} else { Write-Host "CIS 5.6: IISADMIN not installed" -ForegroundColor Green }

# CIS Control: 5.7. (L1) Ensure 'Infrared monitor service (irmon)' is set to 'Disabled' or 'Not Installed'
# In simpler terms: This setting turns off the service that supports older infrared devices.
# Check if service exists, stop if running, set to disabled, and report
if (Get-Service -Name "irmon" -ErrorAction SilentlyContinue) {
    # Get current state and StartupType
    $originalService = Get-Service -Name "irmon"
    $originalState = $originalService.State
    $originalStartupType = $originalService.StartType

    Write-Host "  Original State: $originalState"
    Write-Host "  Original StartupType: $originalStartupType"

    if ($originalState -eq "Running") { Stop-Service -Name "irmon" -Force }
    Set-Service -Name "irmon" -StartupType Disabled;
    Write-Host "  CIS 5.7: irmon set to Disabled" -ForegroundColor Green

    # Verification (output new state)
    $newState = (Get-Service -Name "irmon").State
    $newStartupType = (Get-Service -Name "irmon").StartType
    Write-Host "  New State: $newState"
    Write-Host "  New StartupType: $newStartupType"

} else { Write-Host "CIS 5.7: irmon not installed" -ForegroundColor Green }

# CIS Control: 5.9. (L1) Ensure 'LxssManager (LxssManager)' is set to 'Disabled' or 'Not Installed'
# In simpler terms: This setting turns off the service that runs the Linux subsystem in Windows.
# Check if service exists, stop if running, set to disabled, and report
if (Get-Service -Name "LxssManager" -ErrorAction SilentlyContinue) {
    # Get current state and StartupType
    $originalService = Get-Service -Name "LxssManager"
    $originalState = $originalService.State
    $originalStartupType = $originalService.StartType

    Write-Host "  Original State: $originalState"
    Write-Host "  Original StartupType: $originalStartupType"

    if ($originalState -eq "Running") { Stop-Service -Name "LxssManager" -Force }
    Set-Service -Name "LxssManager" -StartupType Disabled;
    Write-Host "  CIS 5.9: LxssManager set to Disabled" -ForegroundColor Green

    # Verification (output new state)
    $newState = (Get-Service -Name "LxssManager").State
    $newStartupType = (Get-Service -Name "LxssManager").StartType
    Write-Host "  New State: $newState"
    Write-Host "  New StartupType: $newStartupType"

} else { Write-Host "CIS 5.9: LxssManager not installed" -ForegroundColor Green }

# CIS Control: 5.10. (L1) Ensure 'Microsoft FTP Service (FTPSVC)' is set to 'Disabled' or 'Not Installed'
# In simpler terms: This setting turns off the service that allows file transfer using the FTP protocol (often insecure).
# Check if service exists, stop if running, set to disabled, and report
if (Get-Service -Name "FTPSVC" -ErrorAction SilentlyContinue) {
    # Get current state and StartupType
    $originalService = Get-Service -Name "FTPSVC"
    $originalState = $originalService.State
    $originalStartupType = $originalService.StartType

    Write-Host "  Original State: $originalState"
    Write-Host "  Original StartupType: $originalStartupType"

    if ($originalState -eq "Running") { Stop-Service -Name "FTPSVC" -Force }
    Set-Service -Name "FTPSVC" -StartupType Disabled;
    Write-Host "  CIS 5.10: FTPSVC set to Disabled" -ForegroundColor Green

    # Verification (output new state)
    $newState = (Get-Service -Name "FTPSVC").State
    $newStartupType = (Get-Service -Name "FTPSVC").StartType
    Write-Host "  New State: $newState"
    Write-Host "  New StartupType: $newStartupType"

} else { Write-Host "CIS 5.10: FTPSVC not installed" -ForegroundColor Green }

# CIS Control: 5.12. (L1) Ensure 'OpenSSH SSH Server (sshd)' is set to 'Disabled' or 'Not Installed'
# In simpler terms: This setting turns off the service that allows remote access to the computer using the SSH protocol.
# Check if service exists, stop if running, set to disabled, and report
if (Get-Service -Name "sshd" -ErrorAction SilentlyContinue) {
    # Get current state and StartupType
    $originalService = Get-Service -Name "sshd"
    $originalState = $originalService.State
    $originalStartupType = $originalService.StartType

    Write-Host "  Original State: $originalState"
    Write-Host "  Original StartupType: $originalStartupType"

    if ($originalState -eq "Running") { Stop-Service -Name "sshd" -Force }
    Set-Service -Name "sshd" -StartupType Disabled;
    Write-Host "  CIS 5.12: sshd set to Disabled" -ForegroundColor Green

    # Verification (output new state)
    $newState = (Get-Service -Name "sshd").State
    $newStartupType = (Get-Service -Name "sshd").StartType
    Write-Host "  New State: $newState"
    Write-Host "  New StartupType: $newStartupType"

} else { Write-Host "CIS 5.12: sshd not installed" -ForegroundColor Green }

# CIS Control: 5.25. (L1) Ensure 'Routing and Remote Access (RemoteAccess)' is set to 'Disabled'
# In simpler terms: This setting turns off the service that allows a Windows computer to act as a router or VPN server.
# Check if service exists, stop if running, set to disabled, and report
if (Get-Service -Name "RemoteAccess" -ErrorAction SilentlyContinue) {
    # Get current state and StartupType
    $originalService = Get-Service -Name "RemoteAccess"
    $originalState = $originalService.State
    $originalStartupType = $originalService.StartType

    Write-Host "  Original State: $originalState"
    Write-Host "  Original StartupType: $originalStartupType"

    if ($originalState -eq "Running") { Stop-Service -Name "RemoteAccess" -Force }
    Set-Service -Name "RemoteAccess" -StartupType Disabled;
    Write-Host "  CIS 5.25: RemoteAccess set to Disabled" -ForegroundColor Green

    # Verification (output new state)
    $newState = (Get-Service -Name "RemoteAccess").State
    $newStartupType = (Get-Service -Name "RemoteAccess").StartType
    Write-Host "  New State: $newState"
    Write-Host "  New StartupType: $newStartupType"

} else { Write-Host "CIS 5.25: RemoteAccess not installed" -ForegroundColor Green }

# CIS Control: 5.27. (L1) Ensure 'Simple TCP/IP Services (simptcp)' is set to 'Disabled' or 'Not Installed'
# In simpler terms: This setting turns off a set of very old and insecure network services.
# Check if service exists, stop if running, set to disabled, and report
if (Get-Service -Name "simptcp" -ErrorAction SilentlyContinue) {
    # Get current state and StartupType
    $originalService = Get-Service -Name "simptcp"
    $originalState = $originalService.State
    $originalStartupType = $originalService.StartType

    Write-Host "  Original State: $originalState"
    Write-Host "  Original StartupType: $originalStartupType"

    if ($originalState -eq "Running") { Stop-Service -Name "simptcp" -Force }
    Set-Service -Name "simptcp" -StartupType Disabled;
    Write-Host "  CIS 5.27: simptcp set to Disabled" -ForegroundColor Green

    # Verification (output new state)
    $newState = (Get-Service -Name "simptcp").State
    $newStartupType = (Get-Service -Name "simptcp").StartType
    Write-Host "  New State: $newState"
    Write-Host "  New StartupType: $newStartupType"

} else { Write-Host "CIS 5.27: simptcp not installed" -ForegroundColor Green }

# CIS Control: 5.29. (L1) Ensure 'Special Administration Console Helper (sacsvr)' is set to 'Disabled' or 'Not Installed'
# In simpler terms: This setting turns off a service used for emergency remote access to a server (rarely needed on regular workstations).
# Check if service exists, stop if running, set to disabled, and report
if (Get-Service -Name "sacsvr" -ErrorAction SilentlyContinue) {
    # Get current state and StartupType
    $originalService = Get-Service -Name "sacsvr"
    $originalState = $originalService.State
    $originalStartupType = $originalService.StartType

    Write-Host "  Original State: $originalState"
    Write-Host "  Original StartupType: $originalStartupType"

    if ($originalState -eq "Running") { Stop-Service -Name "sacsvr" -Force }
    Set-Service -Name "sacsvr" -StartupType Disabled;
    Write-Host "  CIS 5.29: sacsvr set to Disabled" -ForegroundColor Green

    # Verification (output new state)
    $newState = (Get-Service -Name "sacsvr").State
    $newStartupType = (Get-Service -Name "sacsvr").StartType
    Write-Host "  New State: $newState"
    Write-Host "  New StartupType: $newStartupType"

} else { Write-Host "CIS 5.29: sacsvr not installed" -ForegroundColor Green }

# CIS Control: 5.32. (L1) Ensure 'Web Management Service (WMSvc)' is set to 'Disabled' or 'Not Installed'
# In simpler terms: This setting turns off the service that allows you to manage the web server (IIS) remotely.
# Check if service exists, stop if running, set to disabled, and report
if (Get-Service -Name "WMSvc" -ErrorAction SilentlyContinue) {
    # Get current state and StartupType
    $originalService = Get-Service -Name "WMSvc"
    $originalState = $originalService.State
    $originalStartupType = $originalService.StartType

    Write-Host "  Original State: $originalState"
    Write-Host "  Original StartupType: $originalStartupType"

    if ($originalState -eq "Running") { Stop-Service -Name "WMSvc" -Force }
    Set-Service -Name "WMSvc" -StartupType Disabled;
    Write-Host "  CIS 5.32: WMSvc set to Disabled" -ForegroundColor Green

    # Verification (output new state)
    $newState = (Get-Service -Name "WMSvc").State
    $newStartupType = (Get-Service -Name "WMSvc").StartType
    Write-Host "  New State: $newState"
    Write-Host "  New StartupType: $newStartupType"

} else { Write-Host "CIS 5.32: WMSvc not installed" -ForegroundColor Green }

# CIS Control: 5.40. (L1) Ensure 'World Wide Web Publishing Service (W3SVC)' is set to 'Disabled' or 'Not Installed'
# In simpler terms: This setting turns off the main service that runs websites on a Windows server (part of IIS).
# Check if service exists, stop if running, set to disabled, and report
if (Get-Service -Name "W3SVC" -ErrorAction SilentlyContinue) {
    # Get current state and StartupType
    $originalService = Get-Service -Name "W3SVC"
    $originalState = $originalService.State
    $originalStartupType = $originalService.StartType

    Write-Host "  Original State: $originalState"
    Write-Host "  Original StartupType: $originalStartupType"

    if ($originalState -eq "Running") { Stop-Service -Name "W3SVC" -Force }
    Set-Service -Name "W3SVC" -StartupType Disabled;
    Write-Host "  CIS 5.40: W3SVC set to Disabled" -ForegroundColor Green

    # Verification (output new state)
    $newState = (Get-Service -Name "W3SVC").State
    $newStartupType = (Get-Service -Name "W3SVC").StartType
    Write-Host "  New State: $newState"
    Write-Host "  New StartupType: $newStartupType"

} else { Write-Host "CIS 5.40: W3SVC not installed" -ForegroundColor Green }

