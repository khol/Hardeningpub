 $identity = New-Object System.Security.Principal.NTAccount("BUILTIN\Administrators")
$securityIdentifier = $identity.Translate([System.Security.Principal.SecurityIdentifier])
$sid = $securityIdentifier.Value

Write-Host "  Identity: $($identity)" -ForegroundColor Yellow
Write-Host "  SID: $($sid)" -ForegroundColor Green 
