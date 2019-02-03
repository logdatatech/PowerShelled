<#
PS C:\Program Files\PowerShell\6> $psversiontable

Name                           Value
----                           -----
PSVersion                      6.1.2
PSEdition                      Core
GitCommitId                    6.1.2
OS                             Microsoft Windows 10.0.17134
Platform                       Win32NT
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1
WSManStackVersion              3.0
#>
<#
PS C:\WINDOWS\system32> $psversiontable

Name                           Value
----                           -----
PSVersion                      5.1.17134.407
PSEdition                      Desktop
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}
BuildVersion                   10.0.17134.407
CLRVersion                     4.0.30319.42000
WSManStackVersion              3.0
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1
#>
if ($PSVersionTable.PSEdition -eq "Desktop") {
    Write-Output "Full Fat Old School PowerShell"
}
if ($PSVersionTable.PSEdition -eq "Core") {
    Write-Output "Git that Fresh New PowerShell"
}