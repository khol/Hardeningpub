#Remove-Item -Path $seceditDBPath -ErrorAction SilentlyContinue

# CIS Control 2.2.9: Ensure 'Change the time zone' is set to 'Administrators, LOCAL SERVICE, Users'
# -----------------------------------------------------------
# Description: This control ensures that specific groups have the necessary permissions to change the time zone.
# In simpler terms: We are granting the "SeTimeZonePrivilege" to Administrators, LOCAL SERVICE, and Users to allow changes to the system time zone.
# Recommended Value: Administrators, LOCAL SERVICE, Users
# Possible Values: List of group SIDs that should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll
Copy-Item "C:\Windows\Security\Database\secedit.sdb" "C:\Users\test\secedit_backup.sdb"

$infPath = "C:\Users\test\cis_2_2_9_timezone.inf"
$infContent = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeTimeZonePrivilege = *S-1-5-32-544,*S-1-5-19,*S-1-5-32-545
"@

# Skapa INF-filen med ovanstående innehåll
Set-Content -Path $infPath -Value $infContent -Encoding Unicode
Write-Host "INF path is: $infPath"
Get-Content $infPath

# Loggfil (skrivs till user profile path)
$seceditLogPath = "C:\Users\test\cis_2_2_9_timezone.log"

# Använd den centrala SDB-filen
$seceditDBPath = "C:\Windows\Security\Database\secedit.sdb"

# Rensa tidigare logg om den finns
if (Test-Path $seceditLogPath) {
    Remove-Item $seceditLogPath -Force
}

# Kör secedit mot systemets SDB-databas
try {
    secedit /configure /db $seceditDBPath /cfg $infPath /areas USER_RIGHTS /overwrite /log $seceditLogPath /quiet
    Write-Host "✅ CIS 2.2.9 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.9 via secedit: $_" -ForegroundColor Red
}

# Läs loggen direkt och skriv ut till konsolen för att debugga
#Get-Content $seceditLogPath -Tail 10
#SeTimeZonePrivilege = *S-1-5-19,*S-1-5-32-544,*S-1-5-32-545
# Kör 'whoami /priv' för att hämta privilegier
$privileges = whoami /priv
$privileges | Select-String "Time Zone"



Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
# CIS Control 2.2.8: Ensure 'Change the system time' is set to 'Administrators, LOCAL SERVICE'
# -----------------------------------------------------------
# Description: This control ensures that specific groups have the necessary permissions to change the system time.
# In simpler terms: We are granting the "SeSystemTimePrivilege" to Administrators and LOCAL SERVICE to allow changes to the system time.
# Recommended Value: Administrators, LOCAL SERVICE
# Possible Values: List of group SIDs that should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.8
$infPath_228 = "C:\Users\test\cis_2_2_8_systime.inf"
$infContent_228 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeSystemTimePrivilege = *S-1-5-32-544,*S-1-5-19
"@

# Skapa INF-filen för CIS 2.2.8 med ovanstående innehåll
Set-Content -Path $infPath_228 -Value $infContent_228 -Encoding UTF8
Write-Host "CIS 2.2.8 INF file created: $infPath_228"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_228 = "C:\Users\test\cis_2_2_8_systime.log"
#$seceditDBPath_228 = "C:\Users\test\cis_2_2_8_systime.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_228 = "C:\Windows\Security\Database\secedit.sdb"

# Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_228) {
#    Remove-Item $seceditDBPath_228 -Force
#}

if (Test-Path $seceditLogPath_228) {
    Remove-Item $seceditLogPath_228 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_228)) {
#    secedit /initialize /db $seceditDBPath_228
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.8
try {
    secedit /configure /db $seceditDBPath_228 /cfg $infPath_228 /areas USER_RIGHTS /log $seceditLogPath_228 /quiet
    Write-Host "✅ CIS 2.2.8 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.8 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_228) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_228) {
    Write-Host "✅ CIS 2.2.8 applied."
    #Get-Content $seceditLogPath_228 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.8. Log file not found." -ForegroundColor Red
}


Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
# CIS Control 2.2.6: Ensure 'Allow log on through Remote Desktop Services' is set to 'Administrators, Remote Desktop Users'
# -----------------------------------------------------------
# Description: This control ensures that only specific groups (Administrators and Remote Desktop Users) are allowed to log in through Remote Desktop Services.
# In simpler terms: We are granting "Allow log on through Remote Desktop Services" privilege to Administrators and Remote Desktop Users to allow access via RDP.
# Recommended Value: Administrators, Remote Desktop Users
# Possible Values: List of group SIDs that should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.6
$infPath_226 = "C:\Users\test\cis_2_2_6_rdp.inf"
$infContent_226 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeRemoteInteractiveLogonPrivilege = *S-1-5-32-544,*S-1-5-32-555
"@

# Skapa INF-filen för CIS 2.2.6 med ovanstående innehåll
Set-Content -Path $infPath_226 -Value $infContent_226 -Encoding UTF8
Write-Host "CIS 2.2.6 INF file created: $infPath_226"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_226 = "C:\Users\test\cis_2_2_6_rdp.log"
$seceditDBPath = "C:\Windows\Security\Database\secedit.sdb"

# Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_226) {
#    Remove-Item $seceditDBPath_226 -Force
#}

if (Test-Path $seceditLogPath_226) {
    Remove-Item $seceditLogPath_226 -Force
}

# Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_226)) {
#    Write-Host "Initializing new SDB database..."
#    secedit /initialize /db $seceditDBPath_226
#} else {
#    Write-Host "SDB database already exists: $seceditDBPath_226"
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.6
try {
    secedit /configure /db $seceditDBPath /cfg $infPath_226 /areas USER_RIGHTS /log $seceditLogPath_226 /quiet
    Write-Host "✅ CIS 2.2.6 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.6 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_226) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
# Om du inte vill läsa loggen efteråt, kan du ta bort eller kommentera bort dessa rader
# Get-Content $seceditLogPath_226 -Tail 10
# Kontrollera inställningen för 'Allow log on through Remote Desktop Services'
$policy = Get-LocalGroupMember -Group "Remote Desktop Users"
$policy | Select-Object Name, Group


Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------

#---------------------
# CIS Control 2.2.4: Ensure 'Adjust memory quotas for a process' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE'
# -----------------------------------------------------------
# Description: This control ensures that specific groups have the necessary permissions to adjust memory quotas for processes.
# In simpler terms: We are granting the "SeIncreaseQuotaPrivilege" to Administrators, LOCAL SERVICE, and NETWORK SERVICE to allow the adjustment of memory quotas for processes.
# Recommended Value: Administrators, LOCAL SERVICE, NETWORK SERVICE
# Possible Values: List of group SIDs that should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.4
$infPath_224 = "C:\Users\test\cis_2_2_4_memoryquota.inf"
$infContent_224 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeIncreaseQuotaPrivilege = *S-1-5-32-544,*S-1-5-19,*S-1-5-20
"@

# Skapa INF-filen för CIS 2.2.4 med ovanstående innehåll
Set-Content -Path $infPath_224 -Value $infContent_224 -Encoding UTF8
Write-Host "CIS 2.2.4 INF file created: $infPath_224"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_224 = "C:\Users\test\cis_2_2_4_memoryquota.log"
#$seceditDBPath_224 = "C:\Users\test\cis_2_2_4_memoryquota.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_224 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_224) {
#    Remove-Item $seceditDBPath_224 -Force
#}

if (Test-Path $seceditLogPath_224) {
    Remove-Item $seceditLogPath_224 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_224)) {
#    secedit /initialize /db $seceditDBPath_224
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.4
try {
    secedit /configure /db $seceditDBPath_224 /cfg $infPath_224 /areas USER_RIGHTS /log $seceditLogPath_224 /quiet
    Write-Host "✅ CIS 2.2.4 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.4 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_224) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_224) {
    Write-Host "✅ CIS 2.2.4 applied."
    #Get-Content $seceditLogPath_224 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.4. Log file not found." -ForegroundColor Red
}

Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

#---------------------
#---------------------
# CIS Control 2.2.39: Ensure 'Take ownership of files or other objects' is set to 'Administrators'
# -----------------------------------------------------------
# Description: This control ensures that only Administrators have the necessary permissions to take ownership of files or other objects.
# In simpler terms: We are granting the "SeTakeOwnershipPrivilege" to Administrators to allow taking ownership of files or other objects.
# Recommended Value: Administrators
# Possible Values: List of group SIDs that should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.39
$infPath_239 = "C:\Users\test\cis_2_2_39_takeownership.inf"
$infContent_239 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeTakeOwnershipPrivilege = *S-1-5-32-544
"@

# Skapa INF-filen för CIS 2.2.39 med ovanstående innehåll
Set-Content -Path $infPath_239 -Value $infContent_239 -Encoding UTF8
Write-Host "CIS 2.2.39 INF file created: $infPath_239"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_239 = "C:\Users\test\cis_2_2_39_takeownership.log"
#$seceditDBPath_239 = "C:\Users\test\cis_2_2_39_takeownership.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_239 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_239) {
#    Remove-Item $seceditDBPath_239 -Force
#}

if (Test-Path $seceditLogPath_239) {
    Remove-Item $seceditLogPath_239 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_239)) {
#    secedit /initialize /db $seceditDBPath_239
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.39
try {
    secedit /configure /db $seceditDBPath_239 /cfg $infPath_239 /areas USER_RIGHTS /log $seceditLogPath_239 /quiet
    Write-Host "✅ CIS 2.2.39 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.39 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_239) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_239) {
    Write-Host "✅ CIS 2.2.39 applied."
    #Get-Content $seceditLogPath_239 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.39. Log file not found." -ForegroundColor Red
}

Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.36: Ensure 'Replace a process level token' is set to 'LOCAL SERVICE, NETWORK SERVICE'
# -----------------------------------------------------------
# Description: This control ensures that LOCAL SERVICE and NETWORK SERVICE have the necessary permissions to replace a process level token.
# In simpler terms: We are granting the "SeReplaceProcessPrivilege" to LOCAL SERVICE and NETWORK SERVICE to allow replacing process level tokens.
# Recommended Value: LOCAL SERVICE, NETWORK SERVICE
# Possible Values: List of group SIDs that should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.36
$infPath_236 = "C:\Users\test\cis_2_2_36_replaceprocesstoken.inf"
$infContent_236 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeReplaceProcessPrivilege = *S-1-5-19,*S-1-5-20
"@

# Skapa INF-filen för CIS 2.2.36 med ovanstående innehåll
Set-Content -Path $infPath_236 -Value $infContent_236 -Encoding UTF8
Write-Host "CIS 2.2.36 INF file created: $infPath_236"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_236 = "C:\Users\test\cis_2_2_36_replaceprocesstoken.log"
#$seceditDBPath_236 = "C:\Users\test\cis_2_2_36_replaceprocesstoken.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_236 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_236) {
#    Remove-Item $seceditDBPath_236 -Force
#}

if (Test-Path $seceditLogPath_236) {
    Remove-Item $seceditLogPath_236 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_236)) {
#    secedit /initialize /db $seceditDBPath_236
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.36
try {
    secedit /configure /db $seceditDBPath_236 /cfg $infPath_236 /areas USER_RIGHTS /log $seceditLogPath_236 /quiet
    Write-Host "✅ CIS 2.2.36 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.36 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_236) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_236) {
    Write-Host "✅ CIS 2.2.36 applied."
    #Get-Content $seceditLogPath_236 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.36. Log file not found." -ForegroundColor Red
}

Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.35: Ensure 'Profile system performance' is set to 'Administrators, NT SERVICE\WdiServiceHost'
# -----------------------------------------------------------
# Description: This control ensures that Administrators and NT SERVICE\WdiServiceHost have the necessary permissions to profile system performance.
# In simpler terms: We are granting the "SeSystemProfilePrivilege" to Administrators and NT SERVICE\WdiServiceHost to allow profiling system performance.
# Recommended Value: Administrators, NT SERVICE\WdiServiceHost
# Possible Values: List of group SIDs that should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.35
$infPath_235 = "C:\Users\test\cis_2_2_35_profilesystemperformance.inf"
$infContent_235 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeSystemProfilePrivilege = *S-1-5-32-544,*S-1-5-80-257
"@

# Skapa INF-filen för CIS 2.2.35 med ovanstående innehåll
Set-Content -Path $infPath_235 -Value $infContent_235 -Encoding UTF8
Write-Host "CIS 2.2.35 INF file created: $infPath_235"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_235 = "C:\Users\test\cis_2_2_35_profilesystemperformance.log"
#$seceditDBPath_235 = "C:\Users\test\cis_2_2_35_profilesystemperformance.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_235 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_235) {
#    Remove-Item $seceditDBPath_235 -Force
#}

if (Test-Path $seceditLogPath_235) {
    Remove-Item $seceditLogPath_235 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_235)) {
#    secedit /initialize /db $seceditDBPath_235
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.35
try {
    secedit /configure /db $seceditDBPath_235 /cfg $infPath_235 /areas USER_RIGHTS /log $seceditLogPath_235 /quiet
    Write-Host "✅ CIS 2.2.35 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.35 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_235) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_235) {
    Write-Host "✅ CIS 2.2.35 applied."
    #Get-Content $seceditLogPath_235 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.35. Log file not found." -ForegroundColor Red
}



Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.34: Ensure 'Profile single process' is set to 'Administrators'
# -----------------------------------------------------------
# Description: This control ensures that Administrators have the necessary permissions to profile a single process.
# In simpler terms: We are granting the "SeProfileSingleProcessPrivilege" to Administrators to allow profiling of a single process.
# Recommended Value: Administrators
# Possible Values: List of group SIDs that should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.34
$infPath_234 = "C:\Users\test\cis_2_2_34_profileprocess.inf"
$infContent_234 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeProfileSingleProcessPrivilege = *S-1-5-32-544
"@

# Skapa INF-filen för CIS 2.2.34 med ovanstående innehåll
Set-Content -Path $infPath_234 -Value $infContent_234 -Encoding UTF8
Write-Host "CIS 2.2.34 INF file created: $infPath_234"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_234 = "C:\Users\test\cis_2_2_34_profileprocess.log"
#$seceditDBPath_234 = "C:\Users\test\cis_2_2_34_profileprocess.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_234 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_234) {
#    Remove-Item $seceditDBPath_234 -Force
#}

if (Test-Path $seceditLogPath_234) {
    Remove-Item $seceditLogPath_234 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_234)) {
#    secedit /initialize /db $seceditDBPath_234
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.34
try {
    secedit /configure /db $seceditDBPath_234 /cfg $infPath_234 /areas USER_RIGHTS /log $seceditLogPath_234 /quiet
    Write-Host "✅ CIS 2.2.34 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.34 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_234) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_234) {
    Write-Host "✅ CIS 2.2.34 applied."
    #Get-Content $seceditLogPath_234 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.34. Log file not found." -ForegroundColor Red
}


Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.33: Ensure 'Perform volume maintenance tasks' is set to 'Administrators'
# -----------------------------------------------------------
# Description: This control ensures that Administrators have the necessary permissions to perform volume maintenance tasks.
# In simpler terms: We are granting the "SeManageVolumePrivilege" to Administrators to allow volume maintenance operations.
# Recommended Value: Administrators
# Possible Values: List of group SIDs that should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.33
$infPath_233 = "C:\Users\test\cis_2_2_33_volumemaintenance.inf"
$infContent_233 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeManageVolumePrivilege = *S-1-5-32-544
"@

# Skapa INF-filen för CIS 2.2.33 med ovanstående innehåll
Set-Content -Path $infPath_233 -Value $infContent_233 -Encoding UTF8
Write-Host "CIS 2.2.33 INF file created: $infPath_233"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_233 = "C:\Users\test\cis_2_2_33_volumemaintenance.log"
#$seceditDBPath_233 = "C:\Users\test\cis_2_2_33_volumemaintenance.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_233 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_233) {
#    Remove-Item $seceditDBPath_233 -Force
#}

if (Test-Path $seceditLogPath_233) {
    Remove-Item $seceditLogPath_233 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_233)) {
#    secedit /initialize /db $seceditDBPath_233
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.33
try {
    secedit /configure /db $seceditDBPath_233 /cfg $infPath_233 /areas USER_RIGHTS /log $seceditLogPath_233 /quiet
    Write-Host "✅ CIS 2.2.33 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.33 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_233) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_233) {
    Write-Host "✅ CIS 2.2.33 applied."
    #Get-Content $seceditLogPath_233 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.33. Log file not found." -ForegroundColor Red
}


Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.32: Ensure 'Modify firmware environment values' is set to 'Administrators'
# -----------------------------------------------------------
# Description: This control ensures that Administrators have the necessary permissions to modify firmware environment values.
# In simpler terms: We are granting the "SeSystemEnvironmentPrivilege" to Administrators to allow modifications to firmware settings.
# Recommended Value: Administrators
# Possible Values: List of group SIDs that should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.32
$infPath_232 = "C:\Users\test\cis_2_2_32_firmware.inf"
$infContent_232 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeSystemEnvironmentPrivilege = *S-1-5-32-544
"@

# Skapa INF-filen för CIS 2.2.32 med ovanstående innehåll
Set-Content -Path $infPath_232 -Value $infContent_232 -Encoding UTF8
Write-Host "CIS 2.2.32 INF file created: $infPath_232"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_232 = "C:\Users\test\cis_2_2_32_firmware.log"
#$seceditDBPath_232 = "C:\Users\test\cis_2_2_32_firmware.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_232 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_232) {
#    Remove-Item $seceditDBPath_232 -Force
#}

if (Test-Path $seceditLogPath_232) {
    Remove-Item $seceditLogPath_232 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_232)) {
#    secedit /initialize /db $seceditDBPath_232
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.32
try {
    secedit /configure /db $seceditDBPath_232 /cfg $infPath_232 /areas USER_RIGHTS /log $seceditLogPath_232 /quiet
    Write-Host "✅ CIS 2.2.32 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.32 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_232) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_232) {
    Write-Host "✅ CIS 2.2.32 applied."
    #Get-Content $seceditLogPath_232 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.32. Log file not found." -ForegroundColor Red
}


Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.31: Ensure 'Modify an object label' is set to 'No One'
# -----------------------------------------------------------
# Description: This control ensures that no one has the permission to modify object labels.
# In simpler terms: We are removing the "SeSystemLabelPrivilege" from all users to prevent modifying object labels.
# Recommended Value: No One
# Possible Values: No one should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.31
$infPath_231 = "C:\Users\test\cis_2_2_31_label.inf"
$infContent_231 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeSystemLabelPrivilege = 
"@

# Skapa INF-filen för CIS 2.2.31 med ovanstående innehåll
Set-Content -Path $infPath_231 -Value $infContent_231 -Encoding UTF8
Write-Host "CIS 2.2.31 INF file created: $infPath_231"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_231 = "C:\Users\test\cis_2_2_31_label.log"
#$seceditDBPath_231 = "C:\Users\test\cis_2_2_31_label.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_231 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_231) {
#    Remove-Item $seceditDBPath_231 -Force
#}

if (Test-Path $seceditLogPath_231) {
    Remove-Item $seceditLogPath_231 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_231)) {
#    secedit /initialize /db $seceditDBPath_231
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.31
try {
    secedit /configure /db $seceditDBPath_231 /cfg $infPath_231 /areas USER_RIGHTS /log $seceditLogPath_231 /quiet
    Write-Host "✅ CIS 2.2.31 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.31 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_231) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_231) {
    Write-Host "✅ CIS 2.2.31 applied."
    #Get-Content $seceditLogPath_231 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.31. Log file not found." -ForegroundColor Red
}


Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.30: Ensure 'Manage auditing and security log' is set to 'Administrators'
# -----------------------------------------------------------
# Description: This control ensures that only Administrators can manage the auditing and security log.
# In simpler terms: We are granting the "SeSecurityPrivilege" to Administrators only to allow managing the security log.
# Recommended Value: Administrators
# Possible Values: Only Administrators should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.30
$infPath_230 = "C:\Users\test\cis_2_2_30_auditlog.inf"
$infContent_230 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeSecurityPrivilege = *S-1-5-32-544
"@

# Skapa INF-filen för CIS 2.2.30 med ovanstående innehåll
Set-Content -Path $infPath_230 -Value $infContent_230 -Encoding UTF8
Write-Host "CIS 2.2.30 INF file created: $infPath_230"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_230 = "C:\Users\test\cis_2_2_30_auditlog.log"
#$seceditDBPath_230 = "C:\Users\test\cis_2_2_30_auditlog.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_230 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_230) {
#    Remove-Item $seceditDBPath_230 -Force
#}

if (Test-Path $seceditLogPath_230) {
    Remove-Item $seceditLogPath_230 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_230)) {
#    secedit /initialize /db $seceditDBPath_230
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.30
try {
    secedit /configure /db $seceditDBPath_230 /cfg $infPath_230 /areas USER_RIGHTS /log $seceditLogPath_230 /quiet
    Write-Host "✅ CIS 2.2.30 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.30 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_230) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_230) {
    Write-Host "✅ CIS 2.2.30 applied."
    #Get-Content $seceditLogPath_230 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.30. Log file not found." -ForegroundColor Red
}


Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.3: Ensure 'Act as part of the operating system' is set to 'No One'
# -----------------------------------------------------------
# Description: This control ensures that no one has the permission to act as part of the operating system.
# In simpler terms: We are removing the "SeTakeOwnershipPrivilege" from all users to prevent acting as part of the operating system.
# Recommended Value: No One
# Possible Values: No one should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.3
$infPath_203 = "C:\Users\test\cis_2_2_3_operating_system.inf"
$infContent_203 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeTcbPrivilege = 
"@

# Skapa INF-filen för CIS 2.2.3 med ovanstående innehåll
Set-Content -Path $infPath_203 -Value $infContent_203 -Encoding UTF8
Write-Host "CIS 2.2.3 INF file created: $infPath_203"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_203 = "C:\Users\test\cis_2_2_3_operating_system.log"
#$seceditDBPath_203 = "C:\Users\test\cis_2_2_3_operating_system.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_203 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_203) {
#    Remove-Item $seceditDBPath_203 -Force
#}

if (Test-Path $seceditLogPath_203) {
    Remove-Item $seceditLogPath_203 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_203)) {
#    secedit /initialize /db $seceditDBPath_203
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.3
try {
    secedit /configure /db $seceditDBPath_203 /cfg $infPath_203 /areas USER_RIGHTS /log $seceditLogPath_203 /quiet
    Write-Host "✅ CIS 2.2.3 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.3 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_203) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_203) {
    Write-Host "✅ CIS 2.2.3 applied."
    #Get-Content $seceditLogPath_203 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.3. Log file not found." -ForegroundColor Red
}


Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.27: Ensure 'Lock pages in memory' is set to 'No One'
# -----------------------------------------------------------
# Description: This control ensures that no one has the permission to lock pages in memory.
# In simpler terms: We are removing the "SeLockMemoryPrivilege" from all users to prevent locking memory pages.
# Recommended Value: No One
# Possible Values: No one should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.27
$infPath_227 = "C:\Users\test\cis_2_2_27_lock_memory.inf"
$infContent_227 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeLockMemoryPrivilege = 
"@

# Skapa INF-filen för CIS 2.2.27 med ovanstående innehåll
Set-Content -Path $infPath_227 -Value $infContent_227 -Encoding UTF8
Write-Host "CIS 2.2.27 INF file created: $infPath_227"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_227 = "C:\Users\test\cis_2_2_27_lock_memory.log"
#$seceditDBPath_227 = "C:\Users\test\cis_2_2_27_lock_memory.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_227 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_227) {
#    Remove-Item $seceditDBPath_227 -Force
#}

if (Test-Path $seceditLogPath_227) {
    Remove-Item $seceditLogPath_227 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_227)) {
#    secedit /initialize /db $seceditDBPath_227
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.27
try {
    secedit /configure /db $seceditDBPath_227 /cfg $infPath_227 /areas USER_RIGHTS /log $seceditLogPath_227 /quiet
    Write-Host "✅ CIS 2.2.27 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.27 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_227) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_227) {
    Write-Host "✅ CIS 2.2.27 applied."
    #Get-Content $seceditLogPath_227 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.27. Log file not found." -ForegroundColor Red
}



Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.26: Ensure 'Load and unload device drivers' is set to 'Administrators'
# -----------------------------------------------------------
# Description: This control ensures that only administrators have the permission to load and unload device drivers.
# In simpler terms: We are granting the "SeLoadDriverPrivilege" to Administrators to allow them to load and unload device drivers.
# Recommended Value: Administrators
# Possible Values: Only Administrators should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.26
$infPath_226 = "C:\Users\test\cis_2_2_26_load_unload_driver.inf"
$infContent_226 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeLoadDriverPrivilege = *S-1-5-32-544
"@

# Skapa INF-filen för CIS 2.2.26 med ovanstående innehåll
Set-Content -Path $infPath_226 -Value $infContent_226 -Encoding UTF8
Write-Host "CIS 2.2.26 INF file created: $infPath_226"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_226 = "C:\Users\test\cis_2_2_26_load_unload_driver.log"
#$seceditDBPath_226 = "C:\Users\test\cis_2_2_26_load_unload_driver.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_226 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_226) {
#    Remove-Item $seceditDBPath_226 -Force
#}

if (Test-Path $seceditLogPath_226) {
    Remove-Item $seceditLogPath_226 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_226)) {
#    secedit /initialize /db $seceditDBPath_226
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.26
try {
    secedit /configure /db $seceditDBPath_226 /cfg $infPath_226 /areas USER_RIGHTS /log $seceditLogPath_226 /quiet
    Write-Host "✅ CIS 2.2.26 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.26 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_226) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_226) {
    Write-Host "✅ CIS 2.2.26 applied."
    #Get-Content $seceditLogPath_226 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.26. Log file not found." -ForegroundColor Red
}


Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.24: Ensure 'Impersonate a client after authentication' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'
# -----------------------------------------------------------
# Description: This control ensures that only Administrators, LOCAL SERVICE, NETWORK SERVICE, and SERVICE have the permission to impersonate a client after authentication.
# In simpler terms: We are granting the "SeImpersonatePrivilege" to Administrators, LOCAL SERVICE, NETWORK SERVICE, and SERVICE to allow them to impersonate users.
# Recommended Value: Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE
# Possible Values: Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.24
$infPath_224 = "C:\Users\test\cis_2_2_24_impersonate.inf"
$infContent_224 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeImpersonatePrivilege = *S-1-5-32-544,*S-1-5-19,*S-1-5-20,*S-1-5-6
"@

# Skapa INF-filen för CIS 2.2.24 med ovanstående innehåll
Set-Content -Path $infPath_224 -Value $infContent_224 -Encoding UTF8
Write-Host "CIS 2.2.24 INF file created: $infPath_224"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_224 = "C:\Users\test\cis_2_2_24_impersonate.log"
#$seceditDBPath_224 = "C:\Users\test\cis_2_2_24_impersonate.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_224 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_224) {
#    Remove-Item $seceditDBPath_224 -Force
#}

if (Test-Path $seceditLogPath_224) {
    Remove-Item $seceditLogPath_224 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_224)) {
#    secedit /initialize /db $seceditDBPath_224
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.24
try {
    secedit /configure /db $seceditDBPath_224 /cfg $infPath_224 /areas USER_RIGHTS /log $seceditLogPath_224 /quiet
    Write-Host "✅ CIS 2.2.24 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.24 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_224) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_224) {
    Write-Host "✅ CIS 2.2.24 applied."
    #Get-Content $seceditLogPath_224 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.24. Log file not found." -ForegroundColor Red
}


Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.23: Ensure 'Generate security audits' is set to 'LOCAL SERVICE, NETWORK SERVICE'
# -----------------------------------------------------------
# Description: This control ensures that only LOCAL SERVICE and NETWORK SERVICE have the permission to generate security audits.
# In simpler terms: We are granting the "SeAuditPrivilege" to LOCAL SERVICE and NETWORK SERVICE to allow them to generate security audits.
# Recommended Value: LOCAL SERVICE, NETWORK SERVICE
# Possible Values: LOCAL SERVICE, NETWORK SERVICE

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.23
$infPath_223 = "C:\Users\test\cis_2_2_23_security_audit.inf"
$infContent_223 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeAuditPrivilege = *S-1-5-19,*S-1-5-20
"@

# Skapa INF-filen för CIS 2.2.23 med ovanstående innehåll
Set-Content -Path $infPath_223 -Value $infContent_223 -Encoding UTF8
Write-Host "CIS 2.2.23 INF file created: $infPath_223"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_223 = "C:\Users\test\cis_2_2_23_security_audit.log"
#$seceditDBPath_223 = "C:\Users\test\cis_2_2_23_security_audit.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_223 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_223) {
#    Remove-Item $seceditDBPath_223 -Force
#}

if (Test-Path $seceditLogPath_223) {
    Remove-Item $seceditLogPath_223 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_223)) {
#    secedit /initialize /db $seceditDBPath_223
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.23
try {
    secedit /configure /db $seceditDBPath_223 /cfg $infPath_223 /areas USER_RIGHTS /log $seceditLogPath_223 /quiet
    Write-Host "✅ CIS 2.2.23 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.23 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_223) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_223) {
    Write-Host "✅ CIS 2.2.23 applied."
    #Get-Content $seceditLogPath_223 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.23. Log file not found." -ForegroundColor Red
}



Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.22: Ensure 'Force shutdown from a remote system' is set to 'Administrators'
# -----------------------------------------------------------
# Description: This control ensures that only Administrators have the permission to force shutdown from a remote system.
# In simpler terms: We are granting the "SeRemoteShutdownPrivilege" only to Administrators to prevent unauthorized shutdown attempts.
# Recommended Value: Administrators
# Possible Values: Administrators

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.22
$infPath_222 = "C:\Users\test\cis_2_2_22_shutdown.inf"
$infContent_222 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeRemoteShutdownPrivilege = *S-1-5-32-544
"@

# Skapa INF-filen för CIS 2.2.22 med ovanstående innehåll
Set-Content -Path $infPath_222 -Value $infContent_222 -Encoding UTF8
Write-Host "CIS 2.2.22 INF file created: $infPath_222"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_222 = "C:\Users\test\cis_2_2_22_shutdown.log"
#$seceditDBPath_222 = "C:\Users\test\cis_2_2_22_shutdown.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_222 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_222) {
#    Remove-Item $seceditDBPath_222 -Force
#}

if (Test-Path $seceditLogPath_222) {
    Remove-Item $seceditLogPath_222 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_222)) {
#    secedit /initialize /db $seceditDBPath_222
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.22
try {
    secedit /configure /db $seceditDBPath_222 /cfg $infPath_222 /areas USER_RIGHTS /log $seceditLogPath_222 /quiet
    Write-Host "✅ CIS 2.2.22 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.22 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_222) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_222) {
    Write-Host "✅ CIS 2.2.22 applied."
    #Get-Content $seceditLogPath_222 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.22. Log file not found." -ForegroundColor Red
}


Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
#---------------------
# CIS Control 2.2.21: Ensure 'Enable computer and user accounts to be trusted for delegation' is set to 'No One'
# -----------------------------------------------------------
# Description: This control ensures that no user or computer account is trusted for delegation.
# In simpler terms: We are disabling the "Trusted for delegation" setting on all accounts to avoid potential security risks.
# Recommended Value: No One
# Possible Values: No one should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.21
$infPath_221 = "C:\Users\test\cis_2_2_21_delegation.inf"
$infContent_221 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeDelegatePrivilege = 
"@

# Skapa INF-filen för CIS 2.2.21 med ovanstående innehåll
Set-Content -Path $infPath_221 -Value $infContent_221 -Encoding UTF8
Write-Host "CIS 2.2.21 INF file created: $infPath_221"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_221 = "C:\Users\test\cis_2_2_21_delegation.log"
#$seceditDBPath_221 = "C:\Users\test\cis_2_2_21_delegation.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_221 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_221) {
#    Remove-Item $seceditDBPath_221 -Force
#}

if (Test-Path $seceditLogPath_221) {
    Remove-Item $seceditLogPath_221 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_221)) {
#    secedit /initialize /db $seceditDBPath_221
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.21
try {
    secedit /configure /db $seceditDBPath_221 /cfg $infPath_221 /areas USER_RIGHTS /log $seceditLogPath_221 /quiet
    Write-Host "✅ CIS 2.2.21 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.21 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_221) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_221) {
    Write-Host "✅ CIS 2.2.21 applied."
    #Get-Content $seceditLogPath_221 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.21. Log file not found." -ForegroundColor Red
}



Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.15: Ensure 'Debug programs' is set to 'Administrators'
# -----------------------------------------------------------
# Description: This control ensures that only Administrators have the privilege to debug programs.
# In simpler terms: We are restricting the "SeDebugPrivilege" to Administrators only.
# Recommended Value: Administrators
# Possible Values: Only Administrators should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.15
$infPath_215 = "C:\Users\test\cis_2_2_15_debug.inf"
$infContent_215 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeDebugPrivilege = *S-1-5-32-544
"@

# Skapa INF-filen för CIS 2.2.15 med ovanstående innehåll
Set-Content -Path $infPath_215 -Value $infContent_215 -Encoding UTF8
Write-Host "CIS 2.2.15 INF file created: $infPath_215"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_215 = "C:\Users\test\cis_2_2_15_debug.log"
#$seceditDBPath_215 = "C:\Users\test\cis_2_2_15_debug.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_215 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_215) {
#    Remove-Item $seceditDBPath_215 -Force
#}

if (Test-Path $seceditLogPath_215) {
    Remove-Item $seceditLogPath_215 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_215)) {
#    secedit /initialize /db $seceditDBPath_215
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.15
try {
    secedit /configure /db $seceditDBPath_215 /cfg $infPath_215 /areas USER_RIGHTS /log $seceditLogPath_215 /quiet
    Write-Host "✅ CIS 2.2.15 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.15 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_215) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_215) {
    Write-Host "✅ CIS 2.2.15 applied."
    #Get-Content $seceditLogPath_215 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.15. Log file not found." -ForegroundColor Red
}


Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.14: Ensure 'Create symbolic links' is set to 'Administrators'
# -----------------------------------------------------------
# Description: This control ensures that only Administrators have the privilege to create symbolic links.
# In simpler terms: We are restricting the "SeCreateSymbolicLinkPrivilege" to Administrators only.
# Recommended Value: Administrators
# Possible Values: Only Administrators should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.14
$infPath_214 = "C:\Users\test\cis_2_2_14_symlink.inf"
$infContent_214 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeCreateSymbolicLinkPrivilege = *S-1-5-32-544
"@

# Skapa INF-filen för CIS 2.2.14 med ovanstående innehåll
Set-Content -Path $infPath_214 -Value $infContent_214 -Encoding UTF8
Write-Host "CIS 2.2.14 INF file created: $infPath_214"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_214 = "C:\Users\test\cis_2_2_14_symlink.log"
#$seceditDBPath_214 = "C:\Users\test\cis_2_2_14_symlink.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_214 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_214) {
#    Remove-Item $seceditDBPath_214 -Force
#}

if (Test-Path $seceditLogPath_214) {
    Remove-Item $seceditLogPath_214 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_214)) {
#    secedit /initialize /db $seceditDBPath_214
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.14
try {
    secedit /configure /db $seceditDBPath_214 /cfg $infPath_214 /areas USER_RIGHTS /log $seceditLogPath_214 /quiet
    Write-Host "✅ CIS 2.2.14 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.14 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_214) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_214) {
    Write-Host "✅ CIS 2.2.14 applied."
    #Get-Content $seceditLogPath_214 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.14. Log file not found." -ForegroundColor Red
}


Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.13: Ensure 'Create permanent shared objects' is set to 'No One'
# -----------------------------------------------------------
# Description: This control ensures that no one has the privilege to create permanent shared objects.
# In simpler terms: We are removing the "SeCreatePermanentSharedObjectPrivilege" from all users to prevent creating shared objects.
# Recommended Value: No One
# Possible Values: No one should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.13
$infPath_213 = "C:\Users\test\cis_2_2_13_sharedobj.inf"
$infContent_213 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeCreatePermanentSharedObjectPrivilege = 
"@

# Skapa INF-filen för CIS 2.2.13 med ovanstående innehåll
Set-Content -Path $infPath_213 -Value $infContent_213 -Encoding UTF8
Write-Host "CIS 2.2.13 INF file created: $infPath_213"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_213 = "C:\Users\test\cis_2_2_13_sharedobj.log"
#$seceditDBPath_213 = "C:\Users\test\cis_2_2_13_sharedobj.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_213 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_213) {
#    Remove-Item $seceditDBPath_213 -Force
#}

if (Test-Path $seceditLogPath_213) {
    Remove-Item $seceditLogPath_213 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_213)) {
#    secedit /initialize /db $seceditDBPath_213
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.13
try {
    secedit /configure /db $seceditDBPath_213 /cfg $infPath_213 /areas USER_RIGHTS /log $seceditLogPath_213 /quiet
    Write-Host "✅ CIS 2.2.13 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.13 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_213) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_213) {
    Write-Host "✅ CIS 2.2.13 applied."
    #Get-Content $seceditLogPath_213 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.13. Log file not found." -ForegroundColor Red
}



Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.12: Ensure 'Create global objects' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'
# -----------------------------------------------------------
# Description: This control ensures that only the specific groups have the privilege to create global objects.
# In simpler terms: We are granting the "SeCreateGlobalPrivilege" to Administrators, LOCAL SERVICE, NETWORK SERVICE, and SERVICE.
# Recommended Value: Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE
# Possible Values: The above groups should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.12
$infPath_212 = "C:\Users\test\cis_2_2_12_globalobjects.inf"
$infContent_212 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeCreateGlobalPrivilege = *S-1-5-32-544,*S-1-5-19,*S-1-5-20,*S-1-5-6
"@

# Skapa INF-filen för CIS 2.2.12 med ovanstående innehåll
Set-Content -Path $infPath_212 -Value $infContent_212 -Encoding UTF8
Write-Host "CIS 2.2.12 INF file created: $infPath_212"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_212 = "C:\Users\test\cis_2_2_12_globalobjects.log"
#$seceditDBPath_212 = "C:\Users\test\cis_2_2_12_globalobjects.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_212 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_212) {
#    Remove-Item $seceditDBPath_212 -Force
#}

if (Test-Path $seceditLogPath_212) {
    Remove-Item $seceditLogPath_212 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_212)) {
#    secedit /initialize /db $seceditDBPath_212
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.12
try {
    secedit /configure /db $seceditDBPath_212 /cfg $infPath_212 /areas USER_RIGHTS /log $seceditLogPath_212 /quiet
    Write-Host "✅ CIS 2.2.12 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.12 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_212) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_212) {
    Write-Host "✅ CIS 2.2.12 applied."
    #Get-Content $seceditLogPath_212 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.12. Log file not found." -ForegroundColor Red
}


Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.11: Ensure 'Create a token object' is set to 'No One'
# -----------------------------------------------------------
# Description: This control ensures that no one has the privilege to create a token object.
# In simpler terms: We are removing the "SeCreateTokenPrivilege" from all users to prevent them from creating token objects.
# Recommended Value: No One
# Possible Values: No one should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.11
$infPath_211 = "C:\Users\test\cis_2_2_11_token.inf"
$infContent_211 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeCreateTokenPrivilege = 
"@

# Skapa INF-filen för CIS 2.2.11 med ovanstående innehåll
Set-Content -Path $infPath_211 -Value $infContent_211 -Encoding UTF8
Write-Host "CIS 2.2.11 INF file created: $infPath_211"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_211 = "C:\Users\test\cis_2_2_11_token.log"
#$seceditDBPath_211 = "C:\Users\test\cis_2_2_11_token.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_211 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_211) {
#    Remove-Item $seceditDBPath_211 -Force
#}

if (Test-Path $seceditLogPath_211) {
    Remove-Item $seceditLogPath_211 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_211)) {
#    secedit /initialize /db $seceditDBPath_211
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.11
try {
    secedit /configure /db $seceditDBPath_211 /cfg $infPath_211 /areas USER_RIGHTS /log $seceditLogPath_211 /quiet
    Write-Host "✅ CIS 2.2.11 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.11 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_211) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_211) {
    Write-Host "✅ CIS 2.2.11 applied."
    #Get-Content $seceditLogPath_211 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.11. Log file not found." -ForegroundColor Red
}


Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.10: Ensure 'Create a pagefile' is set to 'Administrators'
# -----------------------------------------------------------
# Description: This control ensures that only Administrators have the privilege to create a pagefile.
# In simpler terms: We are granting the "SeCreatePagefilePrivilege" to the Administrators group to allow them to create a pagefile.
# Recommended Value: Administrators
# Possible Values: Administrators should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.10
$infPath_210 = "C:\Users\test\cis_2_2_10_pagefile.inf"
$infContent_210 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeCreatePagefilePrivilege = *S-1-5-32-544
"@

# Skapa INF-filen för CIS 2.2.10 med ovanstående innehåll
Set-Content -Path $infPath_210 -Value $infContent_210 -Encoding UTF8
Write-Host "CIS 2.2.10 INF file created: $infPath_210"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_210 = "C:\Users\test\cis_2_2_10_pagefile.log"
#$seceditDBPath_210 = "C:\Users\test\cis_2_2_10_pagefile.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_210 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_210) {
#    Remove-Item $seceditDBPath_210 -Force
#}

if (Test-Path $seceditLogPath_210) {
    Remove-Item $seceditLogPath_210 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_210)) {
#    secedit /initialize /db $seceditDBPath_210
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.10
try {
    secedit /configure /db $seceditDBPath_210 /cfg $infPath_210 /areas USER_RIGHTS /log $seceditLogPath_210 /quiet
    Write-Host "✅ CIS 2.2.10 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.10 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_210) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_210) {
    Write-Host "✅ CIS 2.2.10 applied."
    #Get-Content $seceditLogPath_210 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.10. Log file not found." -ForegroundColor Red
}


Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
#---------------------
# CIS Control 2.2.1: Ensure 'Access Credential Manager as a trusted caller' is set to 'No One'
# -----------------------------------------------------------
# Description: This control ensures that no user or service has the privilege to access Credential Manager as a trusted caller.
# In simpler terms: We are removing the "SeTrustCredManAccessPrivilege" from all users to prevent unauthorized access to Credential Manager.
# Recommended Value: No One
# Possible Values: No one should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll för CIS Control 2.2.1
$infPath_201 = "C:\Users\test\cis_2_2_1_credman.inf"
$infContent_201 = @"
[Unicode]
Unicode=yes

[Version]
signature="\$STOCKHOLM\$"
Revision=1

[Privilege Rights]
SeTrustCredManAccessPrivilege = 
"@

# Skapa INF-filen för CIS 2.2.1 med ovanstående innehåll
Set-Content -Path $infPath_201 -Value $infContent_201 -Encoding UTF8
Write-Host "CIS 2.2.1 INF file created: $infPath_201"

# Skapa loggfil och databasfilvägar för secedit
$seceditLogPath_201 = "C:\Users\test\cis_2_2_1_credman.log"
#$seceditDBPath_201 = "C:\Users\test\cis_2_2_1_credman.sdb"
# Använd den centrala SDB-filen
$seceditDBPath_201 = "C:\Windows\Security\Database\secedit.sdb"

## Ta bort befintliga filer om de finns för att undvika konflikter
#if (Test-Path $seceditDBPath_201) {
#    Remove-Item $seceditDBPath_201 -Force
#}

if (Test-Path $seceditLogPath_201) {
    Remove-Item $seceditLogPath_201 -Force
}

## Initialisera SDB-databasen om den inte finns
#if (-not (Test-Path $seceditDBPath_201)) {
#    secedit /initialize /db $seceditDBPath_201
#}

# Kör secedit med mer detaljerad loggning för CIS 2.2.1
try {
    secedit /configure /db $seceditDBPath_201 /cfg $infPath_201 /areas USER_RIGHTS /log $seceditLogPath_201 /quiet
    Write-Host "✅ CIS 2.2.1 successfully applied using secedit." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CIS 2.2.1 via secedit: $_" -ForegroundColor Red
}

# Vänta tills loggfilen finns
$timeout = 10
$elapsed = 0
while (-not (Test-Path $seceditLogPath_201) -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
}

# Extra säkerhetsmarginal
Start-Sleep -Seconds 2

# Läs loggen direkt och skriv ut till konsolen för att debugga
if (Test-Path $seceditLogPath_201) {
    Write-Host "✅ CIS 2.2.1 applied."
    #Get-Content $seceditLogPath_201 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.1. Log file not found." -ForegroundColor Red
}



Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------



Write-Host "#---------------------"
Write-Host "#---------------------"
# Extra säkerhetsmarginal
Start-Sleep -Seconds 2
#---------------------
