$has_putty = Test-Path "C:\users\$env:username\appdata\local\temp\putty.exe"
If($has_putty -eq $false) {Copy-Item -Path "Z:\Tools for DPE\Programs For IE\Putty\putty.exe" -Destination C:\users\$env:username\appdata\local\temp}
& "C:\users\$env:username\appdata\local\temp\putty.exe"