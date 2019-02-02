<#
Author: nathan@logdata.tech @NK
Purpose: Download .VSIX Files for Visual Studio Code great for Air Gapped Environments
ExpectedFileName: VSCodeSideLoadExtensions.ps1
CanonicalSource: https://raw.githubusercontent.com/logdatatech/PowerShelled/master/VSCodeSideLoadExtensions.ps1
https://code.visualstudio.com/docs/editor/extension-gallery
https://stackoverflow.com/questions/37071388/how-to-install-vscode-extensions-offline
#>
$SCRIPT_VERSION = "1.0.0" # These are a little Passe it's in the Git.
$SCRIPT_NAME = "Visual Studio Code ... Install All The Things (Offline)"
Write-Host -ForegroundColor 2 -BackgroundColor 5 -Object "$SCRIPT_NAME $SCRIPT_VERSION"

# Array of Extension Names
#TODO: Reference an External Config File Single Line Per Entry.
$VsCodeExtensions = @(
    "Gruntfuggly.todo-tree",
    "ahmadawais.shades-of-purple",
    "ms-vscode.wordcount",
    "dracula-theme.theme-dracula",
    "Tyriar.sort-lines",
    "yzhang.markdown-all-in-one",
    "hnw.vscode-auto-open-markdown-preview",
    "CoenraadS.bracket-pair-colorizer",
    "oderwat.indent-rainbow",
    "mechatroner.rainbow-csv")

#$extensionToDownload = "ahmadawais.shades-of-purple"
foreach ($extensionToDownload in $VsCodeExtensions) {    
    $URL = 'https://marketplace.visualstudio.com/items?itemName='+$extensionToDownload
    $page = Invoke-WebRequest -Uri $URL #Web Scraping
    $details = ( $page.Scripts | Where-Object {$_.class -eq 'vss-extension'}).innerHTML | Convertfrom-Json
    $extensionName = $details.extensionName
    $publisher = $details.publisher.publisherName
    $version = $details.versions.version
    $extensionOfflinePath = "C:\OpenShare\VS-Code\OfflineExtensions\$publisher.$extensionName.$version.VSIX"
    Invoke-WebRequest -uri "$($details.versions.fallbackAssetUri)/Microsoft.VisualStudio.Services.VSIXPackage"-OutFile $extensionOfflinePath 
}

# Now Iterate and Install .VSIX files @NK FIXME: Merge with code in the other file.
# This Script is Not Trying to Install them but if you Uncomment next two lines it will.
#push-location "C:\OpenShare\VS-Code\OfflineExtensions"
#Get-ChildItem . -Filter *.vsix | ForEach-Object { code --install-extension $_.FullName }