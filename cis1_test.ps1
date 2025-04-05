# CIS Control: 1.2.4. (L1) Ensure 'Reset account lockout counter after' is set to '15 or more minute(s)'
# Define the security policy setting and desired value
$desiredValue124 = 15

# Create hashtable for CIS 1.2.4
$cis124Settings = @{
    "HKLM\SECURITY\Policy\PolAdt" = @{
        "LockoutResetMin" = $desiredValue124
    }
}

# CIS Control: 1.2.3. (L1) Ensure 'Allow Administrator account lockout' is set to 'Enabled'
# In simpler terms: This setting makes sure that even the main administrator account can be locked out if someone tries to guess the password too many times.

# Define the security policy setting and desired value
$policyName123 = "Administrator account lockout duration" # This policy determines if lockout is active
$desiredValue123 = 30 # Any value other than 0 enables lockout. We'll use 30 minutes as a reasonable default.
$cis123Settings = @{
    "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" = @{
        "AdministratorAccountLockout" = $desiredValue123
    }
}

# Installera PSRegistry (om det inte redan är installerat)
try {
    Get-Module -Name PSRegistry -ListAvailable -ErrorAction Stop | Out-Null
    Write-Host "PSRegistry är redan installerat." -ForegroundColor Green
} catch {
    Write-Host "Installerar PSRegistry..." -ForegroundColor Yellow
    try {
        Install-Module PSRegistry -Scope CurrentUser -Force -ErrorAction Stop
        Write-Host "PSRegistry installerat." -ForegroundColor Green
    } catch {
        Write-Error "Misslyckades med att installera PSRegistry: $_"
        return # Avbryt skriptet om installationen misslyckas
    }
}

# Importera PSRegistry
try {
    Install-Module -Name PSRegistry
    Import-Module PSRegistry -ErrorAction Stop
    Write-Host "PSRegistry importerat." -ForegroundColor Green
} catch {
    Write-Error "Misslyckades med att importera PSRegistry: $_"
    return # Avbryt skriptet om importen misslyckas
}

# Kontrollera att modulen ar tillganglig
if (Get-Module -Name PSRegistry) {
    Write-Host "PSRegistry-modulen är tillgänglig." -ForegroundColor Green
} else {
    Write-Error "PSRegistry-modulen är inte tillgänglig efter import."
    return # Avbryt skriptet om modulen inte ar tillgänglig
}

$SetRegistryKeysRunning = $false # Global flagga för att indikera om funktionen körs

function Set-RegistryKeys {
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]$table,
        [switch]$RunAsAdmin # Flagga för att undvika oändliga loopar
    )

    if (-not $RunAsAdmin) {
        if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            # Starta en ny PowerShell-process med administratörsbehörighet
            Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`" -RunAsAdmin" -Verb RunAs -Wait
            return # Avbryt den aktuella processen
        }
    }

    # Vänta tills funktionen inte körs
    while ($SetRegistryKeysRunning) {
        Start-Sleep -Milliseconds 100
    }

    $SetRegistryKeysRunning = $true # Markera funktionen som körande

    # Resten av din kod för att ändra registervärden
    foreach ($key in $table.Keys) {
        try {
            # Konvertera HKLM till fullständig sökväg
            $fullPath = $key -replace '^HKLM\\', 'HKLM:\\'

            if (!(Test-Path $fullPath)) {
                New-Item -Path $fullPath -Force | Out-Null
            }
            $values = $table[$key]
            foreach ($valueName in $values.Keys) {
                $value = $values[$valueName]
                $type = if ($value -is [int]) { "DWord" } else { "String" }

                # Hämta befintligt värde
                $currentValue = (Get-ItemProperty -Path $fullPath -Name $valueName -ErrorAction SilentlyContinue).$valueName

                if ($currentValue -ne $null) {
                    Write-Host "Befintligt värde för '$valueName' är: $currentValue" -ForegroundColor Yellow
                    Set-ItemProperty -Path $fullPath -Name $valueName -Value $value
                    Write-Host "Set registry value '$valueName' in key '$fullPath' to '$value'." -ForegroundColor Green
                } else {
                    New-ItemProperty -Path $fullPath -Name $valueName -Value $value -PropertyType $type -Force | Out-Null
                    Write-Host "Created registry value '$valueName' in key '$fullPath' with value '$value'." -ForegroundColor Green
                }
            }
        }
        catch {
            Write-Error "Failed to process key '$fullPath': $_"
        }
    }

    $SetRegistryKeysRunning = $false # Markera funktionen som klar
}

# Apply CIS 1.2.4 settings
Set-RegistryKeys -Table $cis124Settings -RunAsAdmin
Write-Host "CIS 1.2.4: 'Reset account lockout counter after' set to $desiredValue124 minutes" -ForegroundColor Green

# Apply CIS 1.2.3. settings
Set-RegistryKeys -Table $cis123Settings -RunAsAdmin
Write-Host " CIS Control: 1.2.3. (L1) Ensure 'Allow Administrator account lockout' is set to 'Enabled'" -ForegroundColor Green
