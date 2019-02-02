<#
Author: nathan@logdata.tech
ExpectedFileName: VSCode1Step.ps1
CanonicalSource: https://raw.githubusercontent.com/logdatatech/PowerShelled/master/VSCode1Step.ps1
Purpose: 
- To Download VS Code 
- And Related Software Then Run Completely Unattended Installers
- Install Extensions
#>
$SCRIPT_VERSION = "1.0.0" # These are a little Passe it's in the Git.
$SCRIPT_NAME = "Visual Studio Code ... Install All The Things "
#Write-Information -MessageData "$SCRIPT_NAME $SCRIPT_VERSION" -Tags "Config" -InformationAction Continue
#Write-Host -ForegroundColor 5 -BackgroundColor 3 -Object "$SCRIPT_NAME $SCRIPT_VERSION" -NoNewline
Write-Host -ForegroundColor 2 -BackgroundColor 5 -Object "$SCRIPT_NAME $SCRIPT_VERSION"

# Display Name	Registry Name	Display Version	Registry Time	Install Date	Installed For	Install Location	Install Folder Created Time	Install Folder Modified Time	Install Folder Owner	Publisher	Uninstall String	Change Install String	Quiet Uninstall String	Comments	About URL	Update Info URL	Help Link	Install Source	Installer Name	Release Type	Display Icon Path	MSI Filename	Estimated Size	Attributes	Language	Parent Key Name	Registry Key	
# Microsoft Visual Studio Code	{EA457B21-F73E-494C-ACAB-524FDE069978}_is1	1.30.2	20/01/2019 5:25:09 PM	13/01/2019	All Users (64-Bit)	C:\Program Files\Microsoft VS Code	4/03/2018 6:55:24 PM	13/01/2019 3:12:40 PM	BUILTIN\Administrators	Microsoft Corporation	"C:\Program Files\Microsoft VS Code\unins000.exe"		"C:\Program Files\Microsoft VS Code\unins000.exe" /SILENT		https://code.visualstudio.com/	https://code.visualstudio.com/	https://code.visualstudio.com/		Inno Setup		C:\Program Files\Microsoft VS Code\Code.exe		191,323 KB	No Modify, No Repair			HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall\{EA457B21-F73E-494C-ACAB-524FDE069978}_is1	
$VSCodeSystemUninstallerPath = "C:\Program Files\Microsoft VS Code\unins000.exe"
if([System.IO.File]::Exists($VSCodeSystemUninstallerPath)){
	# file with path $path exists
	$startTime = Get-Date	
	Write-Output $VSCodeSystemUninstallerPath + " /SILENT Being Invoked"
	Start-Process $VSCodeSystemUninstallerPath -arg " /SILENT" -Wait
	Write-Output "Time taken: Uninstall $((Get-Date).Subtract($startTime).Seconds) second(s)"
} # If the VS-Code Sytem Installer is Present We Yank It.

$VSCodeInstallFile = "C:\OpenShare\VSCodeUserSetup.exe"
$VSCodeInstallerArguments = " /VERYSILENT /mergetasks=!runcode"
$EXPANDED_LOCALAPPDATA = [System.Environment]::ExpandEnvironmentVariables("%LOCALAPPDATA%") 
$EXPANDED_APPDATA = [System.Environment]::ExpandEnvironmentVariables("%APPDATA%") # Users Roaming Folder = C:\Users\natha\AppData\Roaming
Write-Output '$EXPANDED_APPDATA->' + $EXPANDED_APPDATA
$USER_INSTALLED_PATH = $EXPANDED_LOCALAPPDATA+"\Programs\Microsoft VS Code\unins000.exe" # C:\Users\natha\AppData\Local
if([System.IO.File]::Exists($VSCodeInstallFile)){
    Write-Output "Testing NOT FILE EXISTS $USER_INSTALLED_PATH"
    if(![System.IO.File]::Exists($USER_INSTALLED_PATH)){    
        # Now Do the Silent Install
        $startTime = Get-Date
        Write-Output "Starting Install $VSCodeInstallFile$VSCodeInstallerArguments"    
        Start-Process $VSCodeInstallFile -arg $VSCodeInstallerArguments -Wait
        Start-Sleep -Seconds 1
        Write-Output "Time taken: To Install $((Get-Date).Subtract($startTime).Seconds) second(s)"
    } else {
        Write-Output "Already Installed for this User."
    } # If The Uninstaller Binary is Present for this User.
} else {
    Write-Output "$VSCodeInstallFile INSTALLER BINARY MISSING"
    if(![System.IO.File]::Exists($USER_INSTALLED_PATH)){
        # Now Do the Download and then the Install
        $validUrl = "https://aka.ms/win32-x64-user-stable"
        $startTime = Get-Date
		# Download Current Latest Stable User Version from Internet
		Invoke-WebRequest -Uri $validUrl -OutFile $VSCodeInstallFile
        Write-Output "Time taken: To Download $validUrl $((Get-Date).Subtract($startTime).Seconds) second(s)"
        $startTime = Get-Date
        Write-Output "Starting Install $VSCodeInstallFile$VSCodeInstallerArguments"    
        Start-Process $VSCodeInstallFile -arg $VSCodeInstallerArguments -Wait
        Start-Sleep -Seconds 1
        Write-Output "Time taken: To Install $((Get-Date).Subtract($startTime).Seconds) second(s)"
    }
} # If Installer Previously Downloaded File Already Present

# Make c an Alias As Well Path will Be User Relative
Write-Output "Make Alias C.CMD from $EXPANDED_LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd"
Copy-Item -Path "$EXPANDED_LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd" -Destination "$EXPANDED_LOCALAPPDATA\Programs\Microsoft VS Code\bin\c.cmd"


<#

Install/Update Optional But Basically Mandatory Components

code --install-extension Gruntfuggly.todo-tree --force
Extension 'gruntfuggly.todo-tree' is already installed.
C:\OpenShare>echo %ERRORLEVEL%
0

code --install-extension MADEUPSHITE --force
Extension 'madeupshite' not found.
Make sure you use the full extension ID, including the publisher, eg: ms-vscode.csharp

C:\OpenShare>echo %ERRORLEVEL%
1


#>

#TODO: Read the Already installed Extensions and Exclude those

# code --list-extensions
Start-Process -FilePath "$EXPANDED_LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd" -ArgumentList ' --list-extensions' -NoNewWindow -Wait -RedirectStandardError 'C:\OpenShare\StdErrors.log' -RedirectStandardOutput "C:\OpenShare\StdOutput.log"
$VsCodeAlreadyInstalledExtensions = Get-Content -Path "C:\OpenShare\StdOutput.log"
# foreach($item in $VsCodeAlreadyInstalledExtensions){
#     Write-Output "Installed Already $item"
# }

#TODO: Reference an External Config File Single Line Per Entry.
$VsCodeExtensions = @(
    "Gruntfuggly.todo-tree",
    "ms-vscode.wordcount",
    "dracula-theme.theme-dracula",
    "Tyriar.sort-lines",
    "yzhang.markdown-all-in-one",
    "hnw.vscode-auto-open-markdown-preview",
    "CoenraadS.bracket-pair-colorizer",
    "oderwat.indent-rainbow",
    "mechatroner.rainbow-csv")

foreach($extension in $VsCodeExtensions){
    If ($extension -in $VsCodeAlreadyInstalledExtensions) {
        Write-Output "$extension is Already Installed"
    } else {
        $argumentAssembled = " --install-extension $extension --force"
        #code --install-extension Gruntfuggly.todo-tree --force
        Write-Output "Installing VS-Code Extension $argumentAssembled"
        Start-Process "$EXPANDED_LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd" -arg $argumentAssembled
    }
}

<#
GitHub Command Line Program VS Code uses in Background.
$validUrl = "https://git-scm.com/download/win"
TODO: https://github.com/git-for-windows/git/releases <= work out how to Parse this for the Newest Relase
Display Name	Registry Name	Display Version	Registry Time	Install Date	Installed For	Install Location	Install Folder Created Time	Install Folder Modified Time	Install Folder Owner	Publisher	Uninstall String	Change Install String	Quiet Uninstall String	Comments	About URL	Update Info URL	Help Link	Install Source	Installer Name	Release Type	Display Icon Path	MSI Filename	Estimated Size	Attributes	Language	Parent Key Name	Registry Key	
Git version 2.16.2	Git_is1	2.16.2	20/01/2019 5:25:09 PM	4/03/2018	All Users (64-Bit)	C:\Program Files\Git	4/03/2018 7:02:09 PM	4/03/2018 7:02:35 PM	BUILTIN\Administrators	The Git Development Community	"C:\Program Files\Git\unins000.exe"		"C:\Program Files\Git\unins000.exe" /SILENT		https://gitforwindows.org/		https://github.com/git-for-windows/git/wiki/Contact		Inno Setup		C:\Program Files\Git\mingw64\share\git\git-for-windows.ico		227,639 KB	No Modify, No Repair			HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1	

TODO: Extra Fonts ?

#>

Exit-PSSession

# Scrape this Page
# https://gitforwindows.org/
Start-Process -FilePath "git" -ArgumentList ' --version' -NoNewWindow -Wait -RedirectStandardError 'C:\OpenShare\StdErrors.log' -RedirectStandardOutput "C:\OpenShare\StdOutput.log"
$CurrentGitVersion = Get-Content -Path "C:\OpenShare\StdOutput.log"
Write-Output $CurrentGitVersion

$GitSystemUninstallerPath = "C:\Program Files\Git\unins000.exe"
if([System.IO.File]::Exists($GitSystemUninstallerPath)){
	$startTime = Get-Date	
	Write-Output $GitSystemUninstallerPath + " /SILENT Being Invoked"
	#Start-Process $GitSystemUninstallerPath -arg " /SILENT" -Wait # TODO: Version Relevance Check needs to be Implemented.
	Write-Output "Time taken: Uninstall $((Get-Date).Subtract($startTime).Seconds) second(s)"
} # If the Git Sytem Installer is Present We Yank It.

$validUrl = "https://github.com/git-for-windows/git/releases/download/v2.20.1.windows.1/Git-2.20.1-64-bit.exe"
$GitInstallFile = "C:\OpenShare\Git-Stable-64-bit.exe"
$GitInstallerArguments = ' /VERYSILENT /LOADINF="savedresponse.inf"'
if([System.IO.File]::Exists($GitInstallFile)){
    Write-Output "Testing NOT FILE EXISTS $GitSystemUninstallerPath"
    if(![System.IO.File]::Exists($GitSystemUninstallerPath)){    
        # Now Do the Silent Install
        $startTime = Get-Date
        Write-Output "Starting Install $GitInstallFile$GitInstallerArguments"    
        Start-Process $GitInstallFile -arg $GitInstallerArguments -Wait
        Write-Output "Time taken: To Install $((Get-Date).Subtract($startTime).Seconds) second(s)"
    } else {
        Write-Output "Already Installed on This Computer."
    } # If The Uninstaller Binary is Present for this User.
} else {
    Write-Output "$GitInstallFile INSTALLER BINARY MISSING"
    if(![System.IO.File]::Exists($GitSystemUninstallerPath)){
        # Now Do the Download and then the Install
        $startTime = Get-Date
        Invoke-WebRequest -Uri $validUrl -OutFile $GitInstallFile
        Write-Output "Time taken: To Download $validUrl $((Get-Date).Subtract($startTime).Seconds) second(s)"
        $startTime = Get-Date
        Write-Output "Starting Install $GitInstallFile$GitInstallerArguments"    
        Start-Process $GitInstallFile -arg $GitInstallerArguments -Wait
        Write-Output "Time taken: To Install $((Get-Date).Subtract($startTime).Seconds) second(s)"
    }
} # If Installer Previously Downloaded File Already Present

#Start-Process $outputFile -arg " /LOADINF="SAVEDRESPONSE.INF" -Wait
#"C:\OpenShare\Git-Stable-64-bit.exe"  # Load A Previously Saved Response
#Import-Module BitsTransfer
#Start-BitsTransfer -Source $validUrl -Destination $outputFile
#OR
#Start-BitsTransfer -Source $url -Destination $output -Asynchronous
# Auto Download Page in a Browser
# Make Default Edits to the Key Config Files.
#code --install # Install Top 10 Extensions
#$url = "http://mirror.internode.on.net/pub/test/10meg.test"
#$output = "$PSScriptRoot\10meg.test"
#$start_time = Get-Date