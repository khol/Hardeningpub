 # Function to set user rights using NTRights.exe
function Set-UserRight {
    param (
        [string]$AccountName,
        [string]$Privilege,
        [string]$Action
    )

    $NTRightsPath = "C:\Tools\NTRights.exe"  # *** CORRECT THIS PATH! ***

    if (-not (Test-Path $NTRightsPath)) {
        Write-Error "Error: NTRights.exe not found at '$NTRightsPath'. Please verify the path."
        return  # Exit the function if NTRights.exe is missing
    }

    try {
        $arguments = "-u `"$AccountName`" -m +`"$Privilege`""
        if ($Action -eq "Revoke") {
            $arguments = "-u `"$AccountName`" -m -`"$Privilege`""
        }

        $process = Start-Process -FilePath $NTRightsPath -ArgumentList $arguments -Wait -PassThru -ErrorAction Stop
        if ($process.ExitCode -ne 0) {
            throw "NTRights.exe failed with exit code $($process.ExitCode)"
        }

        Write-Verbose "  # Successfully $Action privilege '$Privilege' for '$AccountName'"

    } catch {
        Write-Error "  # Error: Failed to $Action privilege '$Privilege' for '$AccountName': $_"
    }
}

# Functions for each CIS control
function Set-CIS2209 {
    param (
        [string]$Action  # "Grant" or "Revoke"
    )

    # ----------------------------------------------------------------------
    # CIS Control: 2.2.9
    # Ensure 'Change the system time' is set to 'Administrators, LOCAL SERVICE, Users'
    #
    # In simpler terms: This setting determines who can change the system's date and time.
    # Recommended Value: Administrators, LOCAL SERVICE, Users
    # Possible Values: Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE, Users
    # ----------------------------------------------------------------------

    $cisControlId = "2.2.9"
    $cisControlDescription = "Ensure 'Change the system time' is set to 'Administrators, LOCAL SERVICE, Users'"
    $inSimplerTerms = "This setting determines who can change the system's date and time."
    $recommendedValue = "Administrators, LOCAL SERVICE, Users"
    $possibleValues = "Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE, Users"
    $privilege = "SeSystemtimePrivilege"
    $accounts = @("Administrators", "LOCAL SERVICE", "Users")

    Write-Verbose "Processing CIS Control: $cisControlId - $cisControlDescription"

    foreach ($account in $accounts) {
        Set-UserRight -AccountName $account -Privilege $privilege -Action $Action
    }
}

function Set-CIS2236 {
    param (
        [string]$Action  # "Grant" or "Revoke"
    )

    # ----------------------------------------------------------------------
    # CIS Control: 2.2.36
    # Ensure 'Replace a process level token' is set to 'LOCAL SERVICE, NETWORK SERVICE'
    #
    # In simpler terms: This setting controls which system services are allowed to use a special way of getting access to resources.
    # Recommended Value: LOCAL SERVICE, NETWORK SERVICE
    # Possible Values: A list of user or group names
    # ----------------------------------------------------------------------

    $cisControlId = "2.2.36"
    $cisControlDescription = "Ensure 'Replace a process level token' is set to 'LOCAL SERVICE, NETWORK SERVICE'"
    $inSimplerTerms = "This setting controls which system services are allowed to use a special way of getting access to resources."
    $recommendedValue = "LOCAL SERVICE, NETWORK SERVICE"
    $possibleValues = "A list of user or group names"
    $privilege = "SeAssignPrimaryTokenPrivilege"
    $accounts = @("LOCAL SERVICE", "NETWORK SERVICE")

    foreach ($account in $accounts) {
        Set-UserRight -AccountName $account -Privilege $privilege -Action $Action
    }
}

# Array of functions to execute
$cisFunctions = @(
    { Set-CIS2209 -Action "Grant" },
    { Set-CIS2236 -Action "Grant" }
    # Add more function references here...
)

# Execute each function
foreach ($cisFunction in $cisFunctions) {
    Write-Host "######################################################################"
    & $cisFunction
    Write-Host ""
}

Write-Host "Script completed." 
