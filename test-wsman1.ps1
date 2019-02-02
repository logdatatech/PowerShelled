$Credential = Get-Credential 10.90.211.15\RemoteExec
Test-WSMan -ComputerName 10.90.211.15 -Authentication Basic -Credential $Credential