# Download 64 Bit Definitions for Windows Servers
$x64S1 = "https://go.microsoft.com/fwlink/?LinkID=121721&arch=x64"
$x64D1 = "mpam-fe.exe"
#$x64S2 = "//go.microsoft.com/fwlink/?LinkId=211054"
#$x64D2 = "mpam-d.exe"
$x64S3 = "https://go.microsoft.com/fwlink/?LinkID=187316&arch=x64&nri=true"
$x64D3 = "nis_full.exe"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($x64S1, $x64D1)
#$wc.DownloadFile($x64S2, $x64D2)
$wc.DownloadFile($x64S3, $x64D3)