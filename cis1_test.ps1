# CIS Control: 1.2.4. (L1) Ensure 'Reset account lockout counter after' is set to '15 or more minute(s)'
# In simpler terms: This setting controls how long a user's account stays locked out after too many failed login attempts.
# Define the security policy setting and desired value
$desiredValue = 15
# Create hashtable for CIS 1.2.4
$cis124Settings = @{
    "HKLM\SECURITY\Policy\PolAdt" = @{
        "LockoutResetMin" = $desiredValue
    }
}


function Set-RegistryKeys {
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]$table
    )
    foreach ($key in $table.Keys) {
        try {
            # Convert HKLM to full path
            $fullPath = $key -replace '^HKLM\\', 'HKLM:\\'
            
            if (!(Test-Path $fullPath)) {
                New-Item -Path $fullPath -Force | Out-Null
            }
            $values = $table[$key]
            foreach ($valueName in $values.Keys) {
                $value = $values[$valueName]
                $type = if ($value -is [int]) { "DWord" } else { "String" }
                
                # Use New-ItemProperty instead of Set-ItemProperty
                if (Get-ItemProperty -Path $fullPath -Name $valueName -ErrorAction SilentlyContinue) {
                    Set-ItemProperty -Path $fullPath -Name $valueName -Value $value
                } else {
                    New-ItemProperty -Path $fullPath -Name $valueName -Value $value -PropertyType $type -Force | Out-Null
                }
            }
        }
        catch {
            Write-Error "Failed to process key '$fullPath': $_"
        }
    }
}



# Apply CIS 1.2.4 settings
Set-RegistryKeys -Table $cis124Settings
Write-Host "CIS 1.2.4: 'Reset account lockout counter after' set to $desiredValue minutes" -ForegroundColor Green
