#Remove-Item -Path $seceditDBPath -ErrorAction SilentlyContinue

# CIS Control 2.2.9: Ensure 'Change the time zone' is set to 'Administrators, LOCAL SERVICE, Users'
# -----------------------------------------------------------
# Description: This control ensures that specific groups have the necessary permissions to change the time zone.
# In simpler terms: We are granting the "SeTimeZonePrivilege" to Administrators, LOCAL SERVICE, and Users to allow changes to the system time zone.
# Recommended Value: Administrators, LOCAL SERVICE, Users
# Possible Values: List of group SIDs that should have this privilege.

# Sätt sökvägen för den temporära INF-filen och skapa dess innehåll
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


#---------------------
#---------------------
#---------------------
