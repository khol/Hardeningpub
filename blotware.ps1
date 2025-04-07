$AppsToRemove = @(
    "*Cortana*",
    "*CompanyPortal*",
    "*ScreenSketch*",
    "*Paint3D*",
    "*WindowsStore*",
    "*Windows.Photos*",
    "*CanonicalGroupLimited*",
    "*HEIFImageExtension*",
    "*StorePurchaseApp*",
    "*VP9VideoExtensions*",
    "*WebMediaExtensions*",
    "*WebpImageExtension*",
    "*DesktopAppInstaller*",
    "*WindSynthBerry*",
    "*MIDIBerry*",
    "*SecHealthUI*",
    "*MaxxAudioProforDell2019*",
    "*MSTeams*",
    "*ActiproSoftwareLLC*",
    "*BubbleWitch3Saga*",
    "*CandyCrush*",
    "*DevHome*",
    "*Disney*",
    "*Dolby*",
    "*Duolingo-LearnLanguagesforFree*",
    "*EclipseManager*",
    "*Facebook*",
    "*Flipboard*",
    "*gaming*",
    "*Minecraft*",
    "*PandoraMediaInc*",
    "*Royal Revolt*",
    "*Speed Test*",
    "*Spotify*",
    "*Sway*",
    "*Twitter*",
    "*Wunderlist*",
    "*HPPrinterControl*",
    "*AppUp.IntelGraphicsExperience*",
    "*DropboxOEM*",
    "*Disney*",
    "*DolbyLaboratories.DolbyAccess*",
    "*DolbyLaboratories.DolbyAudio*",
    "*E0469640.SmartAppearance*",
    "*Microsoft.549981C3F5F10*",
    "*Microsoft.AV1VideoExtension*",
    "*Microsoft.BingNews*",
    "*Microsoft.BingSearch*",
    "*Microsoft.BingWeather*",
    "*Microsoft.GetHelp*",
    "*Microsoft.Getstarted*",
    "*Microsoft.GamingApp*",
    "*Microsoft.Messaging*",
    "*Microsoft.Microsoft3DViewer*",
    "*Microsoft.MicrosoftJournal*",
    "*Microsoft.MicrosoftOfficeHub*",
    "*Microsoft.MicrosoftSolitaireCollection*",
    "*Microsoft.MixedReality.Portal*",
    "*Microsoft.MPEG2VideoExtension*",
    "*Microsoft.News*",
    "*Microsoft.Office.Lens*",
    "*Microsoft.Office.Sway*",
    "*Microsoft.OneConnect*",
    "*Microsoft.OneDriveSync*",
    "*Microsoft.People*",
    "*Microsoft.PowerAutomateDesktop*",
    "*Microsoft.PowerAutomateDesktopCopilotPlugin*",
    "*Microsoft.Print3D*",
    "*Microsoft.SkypeApp*",
    "*Microsoft.StorePurchaseApp*",
    "*Microsoft.SysinternalsSuite*",
    "*Microsoft.Teams*",
    "*Microsoft.Todos*",
    "*Microsoft.Whiteboard*",
    "*Microsoft.Windows.DevHome*",
    "*Microsoft.WindowsAlarms*",
    "*Microsoft.windowscommunicationsapps*",
    "*Microsoft.WindowsFeedbackHub*",
    "*Microsoft.WindowsMaps*",
    "*Microsoft.WindowsSoundRecorder*",
    "*Microsoft.Xbox.TCUI*",
    "*Microsoft.XboxApp*",
    "*Microsoft.Xbox*",
    "*Microsoft.YourPhone*",
    "*Microsoft.ZuneMusic*",
    "*Microsoft.ZuneVideo*",
    "*MicrosoftCorporationII.MicrosoftFamily*",
    "*MicrosoftCorporationII.QuickAssist*",
    "*MicrosoftWindows.Client.WebExperience*",
    "*MicrosoftWindows.CrossDevice*",
    "*MirametrixInc.GlancebyMirametrix*",
    "*MSTeams*",
    "*RealtimeboardInc.RealtimeBoard*",
    "*3dbuilder*",
    "*Wifi*",
    "*windowsalarms*",
    "*windowscommunicationsapps*",
    "*officehub*",
    "*skypeapp*",
    "*getstarted*",
    "*zunemusic*",
    "*windowsmaps*",
    "*solitairecollection*",
    "*bingfinance*",
    "*bing*",
    "*zunevideo*",
    "*bingnews*",
    "*onenote*",
    "*people*",
    "*windowsphone*",
    "*bingsports*",
    "*soundrecorder*",
    "*bingweather*",
    "*xboxapp*",
    "*phone*",
    "*sway*",
    "*AdobePhotoshopExpress*",
    "*Candy*",
    "*Duolingo*",
    "*EclipseManager*",
    "*FarmVille*",
    "*Microsoft.3DBuilder*",
    "*Microsoft.BingNews*",
    "*Microsoft.BingTranslator*",
    "*Microsoft.BingWeather*",
    "*Microsoft.FreshPaint*",
    "*Microsoft.Getstarted*",
    "*Microsoft.Messaging*",
    "*Microsoft.MicrosoftOfficeHub*",
    "*Microsoft.MicrosoftSolitaireCollection*",
    "*Microsoft.NetworkSpeedTest*",
    "*Microsoft.Office.OneNote*",
    "*Microsoft.People*",
    "*Microsoft.SkypeApp*",
    "*Microsoft.WindowsAlarms*",
    "*Microsoft.WindowsFeedbackHub*",
    "*Microsoft.WindowsMaps*",
    "*Microsoft.XboxApp*",
    "*Microsoft.ZuneMusic*",
    "*Microsoft.ZuneVideo*",
    "*Netflix*",
    "*PandoraMediaInc*",
    "*PicsArt*",
    "*Twitter*",
    "*Wunderlist*",
    "*Money*",
    "*sports*"
)

foreach ($App in $AppsToRemove) {
    if ($App -like "*`**") { # Check for wildcard
        $AppxPackages = Get-AppxPackage -AllUsers | Where-Object {$_.Name -Like $App}
        $ProvisionedPackages = Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like $App}

        if ($AppxPackages) {
            foreach ($Package in $AppxPackages) {
                try {
                    # Stop related processes
                    Get-Process | Where-Object {$_.Name -like "*$($Package.Name)*"} | Stop-Process -Force -ErrorAction SilentlyContinue

                    Remove-AppxPackage -Package $Package.PackageFullName -AllUsers
                    Write-Host "Removed AppxPackage: $($Package.Name)" -ForegroundColor Green

                    # Remove registry entries (example)
                    Remove-Item -Path "HKCU:\Software\$($Package.Name)" -Recurse -Force -ErrorAction SilentlyContinue
                    Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$($Package.Name)" -Recurse -Force -ErrorAction SilentlyContinue

                } catch {
                    Write-Host "Failed to remove AppxPackage $($Package.Name): $_" -ForegroundColor Red
                }
            }
        }
        if ($ProvisionedPackages) {
            foreach ($Package in $ProvisionedPackages) {
                try {
                    Remove-AppxProvisionedPackage -Online -PackageName $Package.PackageName
                    Write-Host "Removed ProvisionedPackage: $($Package.PackageName)" -ForegroundColor Green

                    # Remove registry entries (example)
                    Remove-Item -Path "HKCU:\Software\$($Package.PackageName)" -Recurse -Force -ErrorAction SilentlyContinue
                    Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$($Package.PackageName)" -Recurse -Force -ErrorAction SilentlyContinue
                } catch {
                    Write-Host "Failed to remove ProvisionedPackage $($Package.PackageName): $_" -ForegroundColor Red
                }
            }
        }
        if (-not $AppxPackages -and -not $ProvisionedPackages) {
            Write-Host "No apps found matching: $App" -ForegroundColor Yellow
        }
    } else { # Exact match
        $AppxPackage = Get-AppxPackage -AllUsers -Name $App
        if ($AppxPackage) {
            try {
                # Stop related processes
                Get-Process | Where-Object {$_.Name -like "*$($AppxPackage.Name)*"} | Stop-Process -Force -ErrorAction SilentlyContinue

                Remove-AppxPackage -Package $AppxPackage.PackageFullName -AllUsers
                Write-Host "Removed AppxPackage: $($AppxPackage.Name)" -ForegroundColor Green

                # Remove registry entries (example)
                Remove-Item -Path "HKCU:\Software\$($AppxPackage.Name)" -Recurse -Force -ErrorAction SilentlyContinue
                Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$($AppxPackage.Name)" -Recurse -Force -ErrorAction SilentlyContinue

            } catch {
                Write-Host "Failed to remove AppxPackage $($AppxPackage.Name): $_" -ForegroundColor Red
            }
        } else {
            Write-Host "App not found: $App" -ForegroundColor Yellow
        }
    }
}
#Remove Shortcuts and icons.
foreach ($appToRemove in $AppsToRemove) {
    $appNameWithoutWildcard = $appToRemove -replace "\*", "" # Remove wildcard for shortcut search
    $startMenuShortcuts = Get-ChildItem -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs" -Recurse | Where-Object {$_.Name -like "*$appNameWithoutWildcard*"}
    $desktopShortcuts = Get-ChildItem -Path "$env:Public\Desktop" , "$env:userprofile\Desktop" | Where-Object {$_.Name -like "*$appNameWithoutWildcard*"}

    $startMenuShortcuts | Remove-Item -Force -ErrorAction SilentlyContinue
    $desktopShortcuts | Remove-Item -Force -ErrorAction SilentlyContinue
}
