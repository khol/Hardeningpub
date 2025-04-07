Get-AppxPackage -AllUsers *3dbuilder* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Wifi* | Remove-AppxPackage
Get-AppxPackage -AllUsers *windowsalarms* | Remove-AppxPackage
Get-AppxPackage -AllUsers *windowscommunicationsapps* | Remove-AppxPackage
Get-AppxPackage -AllUsers *officehub* | Remove-AppxPackage
Get-AppxPackage -AllUsers *skypeapp* | Remove-AppxPackage
Get-AppxPackage -AllUsers *getstarted* | Remove-AppxPackage
Get-AppxPackage -AllUsers *zunemusic* | Remove-AppxPackage
Get-AppxPackage -AllUsers *windowsmaps* | Remove-AppxPackage
Get-AppxPackage -AllUsers *solitairecollection* | Remove-AppxPackage
Get-AppxPackage -AllUsers *bingfinance* | Remove-AppxPackage
Get-AppxPackage -AllUsers *zunevideo* | Remove-AppxPackage
Get-AppxPackage -AllUsers *bingnews* | Remove-AppxPackage
Get-AppxPackage -AllUsers *onenote* | Remove-AppxPackage
Get-AppxPackage -AllUsers *people* | Remove-AppxPackage
Get-AppxPackage -AllUsers *windowsphone* | Remove-AppxPackage
Get-AppxPackage -AllUsers *bingsports* | Remove-AppxPackage
Get-AppxPackage -AllUsers *soundrecorder* | Remove-AppxPackage
Get-AppxPackage -AllUsers *bingweather* | Remove-AppxPackage
Get-AppxPackage -AllUsers *xboxapp* | Remove-AppxPackage
Get-AppxPackage -AllUsers *phone* | Remove-AppxPackage
Get-AppxPackage -AllUsers *sway* | Remove-AppxPackage
Get-AppxPackage -AllUsers *AdobePhotoshopExpress* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Candy* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Duolingo* | Remove-AppxPackage
Get-AppxPackage -AllUsers *EclipseManager* | Remove-AppxPackage
Get-AppxPackage -AllUsers *FarmVille* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.3DBuilder* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.BingNews* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.BingTranslator* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.BingWeather* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.FreshPaint* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.Getstarted* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.Messaging* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.MicrosoftOfficeHub* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.MicrosoftSolitaireCollection* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.NetworkSpeedTest* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.Office.OneNote* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.People* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.SkypeApp* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.WindowsAlarms* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.WindowsFeedbackHub* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.WindowsMaps* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.XboxApp* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.ZuneMusic* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.ZuneVideo* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Netflix* | Remove-AppxPackage
Get-AppxPackage -AllUsers *PandoraMediaInc* | Remove-AppxPackage
Get-AppxPackage -AllUsers *PicsArt* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Twitter* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Wunderlist* | Remove-AppxPackage
Get-AppxPackage -AllUsers *3dbuilder* | Remove-AppxPackage
Get-AppxPackage -AllUsers *windowsalarms* | Remove-AppxPackage
Get-AppxPackage -AllUsers *windowscommunicationsapps* | Remove-AppxPackage
Get-AppxPackage -AllUsers *officehub* | Remove-AppxPackage
Get-AppxPackage -AllUsers *skypeapp* | Remove-AppxPackage
Get-AppxPackage -AllUsers *getstarted* | Remove-AppxPackage
Get-AppxPackage -AllUsers *zunemusic* | Remove-AppxPackage
Get-AppxPackage -AllUsers *windowsmaps* | Remove-AppxPackage
Get-AppxPackage -AllUsers *solitairecollection* | Remove-AppxPackage
Get-AppxPackage -AllUsers *bingfinance* | Remove-AppxPackage
Get-AppxPackage -AllUsers *zunevideo* | Remove-AppxPackage
Get-AppxPackage -AllUsers *bingnews* | Remove-AppxPackage
Get-AppxPackage -AllUsers *onenote* | Remove-AppxPackage
Get-AppxPackage -AllUsers *people* | Remove-AppxPackage
Get-AppxPackage -AllUsers *windowsphone* | Remove-AppxPackage
Get-AppxPackage -AllUsers *bingsports* | Remove-AppxPackage
Get-AppxPackage -AllUsers *soundrecorder* | Remove-AppxPackage
Get-AppxPackage -AllUsers *bingweather* | Remove-AppxPackage
Get-AppxPackage -AllUsers *xboxapp* | Remove-AppxPackage
Get-AppxPackage -AllUsers *phone* | Remove-AppxPackage
Get-AppxPackage -AllUsers *sway* | Remove-AppxPackage

Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*AdobePhotoshopExpress*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Candy*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Duolingo*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*EclipseManager*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*FarmVille*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Microsoft.3DBuilder*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Microsoft.BingNews*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Microsoft.BingTranslator*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Microsoft.BingWeather*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Microsoft.FreshPaint*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Microsoft.Getstarted*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Microsoft.Messaging*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Microsoft.MicrosoftOfficeHub*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Microsoft.MicrosoftSolitaireCollection*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Microsoft.NetworkSpeedTest*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Microsoft.Office.OneNote*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Microsoft.People*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Microsoft.SkypeApp*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Microsoft.WindowsAlarms*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Microsoft.WindowsFeedbackHub*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Microsoft.WindowsMaps*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Microsoft.XboxApp*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Microsoft.ZuneMusic*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Microsoft.ZuneVideo*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Netflix*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*PandoraMediaInc*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*PicsArt*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Twitter*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Wunderlist*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Phone*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*windowscommunicationsapps*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*bingfinance*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*zunevideo*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*zunevideo*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*WindowsPhone*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Phone*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Money*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Windowsalarms*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*bingsports*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*sports*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*sway*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "*Wifi*"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}


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
$startMenuShortcuts | Remove-Item -Force -ErrorAction SilentlyContinue
$desktopShortcuts | Remove-Item -Force -ErrorAction SilentlyContinue
