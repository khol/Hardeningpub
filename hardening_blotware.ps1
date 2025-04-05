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
