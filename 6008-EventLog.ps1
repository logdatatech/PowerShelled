$now=get-date
$startdate=$now.adddays(-7)

#Get-EventLog -LogName Security -ErrorAction SilentlyContinue | Select TimeWritten, @{name='ReplacementStrings';Expression={ $_.ReplacementStrings -join ';'}} | where {$_.ReplacementStrings -notmatch '^S-1-5'} | Export-Csv output.csv

$el = get-eventlog -ComputerName BEAR -log System -After $startdate -EntryType Error
$el | Select EntryType, TimeGenerated, Source, EventID | Export-CSV 6008-eventlog.csv -NoTypeInfo
