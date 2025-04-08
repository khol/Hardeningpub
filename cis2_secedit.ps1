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
SeTimeZonePrivilege = *S-1-5-19,*S-1-5-32-544,*S-1-5-32-545


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
$seceditDBPath_228 = "C:\Users\test\cis_2_2_8_systime.sdb"

# Ta bort befintliga filer om de finns för att undvika konflikter
if (Test-Path $seceditDBPath_228) {
    Remove-Item $seceditDBPath_228 -Force
}

if (Test-Path $seceditLogPath_228) {
    Remove-Item $seceditLogPath_228 -Force
}

# Initialisera SDB-databasen om den inte finns
if (-not (Test-Path $seceditDBPath_228)) {
    secedit /initialize /db $seceditDBPath_228
}

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
    Get-Content $seceditLogPath_228 -Tail 10
} else {
    Write-Host "❌ Failed to apply CIS 2.2.8. Log file not found." -ForegroundColor Red
}


#---------------------
#---------------------
