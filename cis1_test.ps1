
# CIS Control: 1.2.4. (L1) Ensure 'Reset account lockout counter after' is set to '15 or more minute(s)'
# In simpler terms: This setting controls how long a user's account stays locked out after too many failed login attempts.

$policyName = "Reset account lockout counter after"
$desiredValue = 15

# Get current value (secedit)
secedit /export /cfg "C:\temp\securitypolicy.inf" /areas "SECURITYPOLICY"
$currentValue = (Get-Content "C:\temp\securitypolicy.inf" | Select-String -Pattern "$policyName" | ForEach-Object { ($_ -split "=")[1].Trim() }) -as [int]
Remove-Item "C:\temp\securitypolicy.inf"

Write-Host "  Current Value: $currentValue (minutes)"

# Set desired value (secedit) if needed
if ($currentValue -lt $desiredValue -or $currentValue -eq $null) {
    secedit /export /cfg "C:\temp\securitypolicy.inf" /areas "SECURITYPOLICY"
    (Get-Content "C:\temp\securitypolicy.inf") -replace "$policyName =.*", "$policyName = $desiredValue" | Set-Content "C:\temp\securitypolicy.inf"
    secedit /configure /db "C:\WINDOWS\security\database\secedit.sdb" /cfg "C:\temp\securitypolicy.inf" /areas "SECURITYPOLICY"
    Remove-Item "C:\temp\securitypolicy.inf"
    Write-Host "  CIS 1.2.4: '$policyName' set to $desiredValue minutes" -ForegroundColor Green
} else {
    Write-Host "  CIS 1.2.4: '$policyName' is already set to $desiredValue minutes or more" -ForegroundColor Green
}

# Verify new value (secedit)
secedit /export /cfg "C:\temp\securitypolicy.inf" /areas "SECURITYPOLICY"
$newValue = (Get-Content "C:\temp\securitypolicy.inf" | Select-String -Pattern "$policyName" | ForEach-Object { ($_ -split "=")[1].Trim() }) -as [int]
Remove-Item "C:\temp\securitypolicy.inf"

Write-Host "  New Value: $newValue (minutes)"
