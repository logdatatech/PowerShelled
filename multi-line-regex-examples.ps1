# https://stackoverflow.com/questions/12572164/multiline-regex-to-match-config-block

#$fileContent = [io.file]::ReadAllText("C:\file.txt") # Uses .NET

$fileContent = Get-Content c:\file.txt -Raw # PS 3.0+ required.

<#

00-01-23-45-67-89
 use profile PROFILE
 use rf-domain DOMAIN
 hostname ACCESSPOINT
 area inside
!

Then you need to specify a regex option to match across line terminators i.e.

SingleLine mode (. matches any char including line feed), as well as
Multiline mode (^ and $ match embedded line terminators), e.g.
(?smi) - note the "i" is to ignore case
e.g.:

#>

$fileContent | Select-String '(?smi)([0-9a-f]{2}(-|\s*$)){6}.*?!' -AllMatches | ForEach-Object {$_.Matches} | ForEach-Object {$_.Value}


$fileContent = [io.file]::ReadAllText("c:\file.txt")


$fileContent |
    Select-String '(?smi)ap71xx[^!]+!' -AllMatches |
    ForEach-Object { $_.Matches } |
    ForEach-Object { $_.Value }


$fileContent |
    Select-String '(?smi)ap71xx([^!]+!)' -AllMatches |
    ForEach-Object { $_.Matches } |
    ForEach-Object { $_.Groups[1] } |
    ForEach-Object { $_.Value }