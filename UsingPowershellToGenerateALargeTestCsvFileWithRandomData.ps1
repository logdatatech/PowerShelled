# ORIGIN:https://blogs.technet.microsoft.com/josebda/2017/02/13/using-powershell-to-generate-a-large-test-csv-file-with-random-data/

$Start = Get-Date
$BaseDate = (Get-Date "2018/12/31 12:59:59")
$FullYear = 366*24*60*60

$File = "C:\SACRIFICIAL\Random2MillionLine.csv" 
"Date,Customer,Type,Value" | Out-File -FilePath $File -Encoding utf8

1..2000 | ForEach-Object {
  Write-Progress -Activity "Generating File" -PercentComplete ($_/20) 
  $Lines = ""
  1..1000 | ForEach-Object {
    $Dt = $BaseDate.AddSeconds(-(Get-Random $FullYear))
    $Ct = (Get-Random 100)
    if ((Get-Random 5) -lt 4) {
      $Ty="Sale"
    } else { 
      $Ty="Return"
    }
    $Vl = (Get-Random 100000) / 100
    $Lines += [string]$Dt + "," + [string]$Ct + "," + $Ty + "," + [string]$Vl + [char]10 + [char]13
  }
  $Lines | Out-File -FilePath $File -Encoding utf8 -Append
}

$End = Get-Date
"Started at $Start and ended at $End"
$Diff = ($End-$Start).TotalSeconds
"Processing took $Diff seconds"