#$url = "http://mirror.internode.on.net/pub/test/10meg.test"

$secpasswd = ConvertTo-SecureString "PlainTextPassword" -AsPlainText -Force
$yourcreds = New-Object System.Management.Automation.PSCredential ("d787502", $secpasswd)

#$url = "http://video.ch9.ms/ch9/3946/41603994-e2cb-4000-85f1-4e3c9cba3946/VisioFlybyPart2_mid.mp4"
$url = "http://video.ch9.ms/ch9/e38e/9fe7d529-baa0-49c6-88de-7abab59de38e/OfficeNAPA_high.mp4"
#http://video.ch9.ms/ch9/e38e/9fe7d529-baa0-49c6-88de-7abab59de38e/OfficeNAPA_high.mp4
$output = "D:\zNull\OfficeNAPA_high.mp4"

$start_time = Get-Date

Import-Module BitsTransfer

Start-BitsTransfer -DisplayName GetVideo -ProxyUsage AutoDetect -Source $url -Destination $output -Authentication Basic -Credential $yourcreds 
#-Asynchronous

#OR
#Start-BitsTransfer -Source $url -Destination $output -Asynchronous

Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"





