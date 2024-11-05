
$appList = @(
    "Microsoft.WebMediaExtensions",
    "Microsoft.MSPaint",
    "Microsoft.VP9VideoExtensions",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.HEIFImageExtension",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.WindowsCommunicationsApps",
    "Microsoft.Xbox",
    "Microsoft.GetHelp",
    "Microsoft.GamingApp",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Clipchamp.Clipchamp",
    "Microsoft.YourPhone",
    "Microsoft.SkypeApp",
    "Microsoft.FeedbackHub",
    "Microsoft.WindowsMaps",
    "Microsoft.People",
    "Microsoft.Teams",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.BingWeather",
    "Microsoft.BingNews",
    "Microsoft.BingSports",
    "Microsoft.OutlookForWindows",
    "Microsoft.MicrosoftToDo",
    "Microsoft.BingFinance",
    "Microsoft.Todos"
)


ForEach ($app in $appList) {
    Write-Output "Attempting to uninstall $app..."
    Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -match $app} | Remove-AppxProvisionedPackage -AllUsers -ErrorAction SilentlyContinue
    Get-AppxPackage -Name $app | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
}


$printersToRemove = @("Fax", "Microsoft XPS Document Writer", "OneNote (Desktop)", "OneNote for Windows 10")
ForEach ($printer in $printersToRemove) {
    Write-Output "Removing printer: $printer"
    Remove-Printer -Name $printer -ErrorAction SilentlyContinue
}

Write-Output "Uninstallation complete. System may require a restart for all changes to take effect."
