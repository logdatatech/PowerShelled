# Mastering GCI Some more advanced Examples.

# TODO: Add More @NK 

Get-ChildItem -Recurse -Name -Path \\cube\tv\C -exclude *.url,*.flag | Out-GridView
Get-ChildItem -Recurse -File -Path \\cube\tv\C -exclude *.url,*.flag | Out-GridView
Get-ChildItem -Recurse -File -Path \\cube\tv\C -exclude *.url,*.flag -Force | Out-GridView
Get-ChildItem -Recurse -File -Path \\cube\tv\C -exclude *.url,*.flag -Force | select-object Name,Length | Out-GridView
Get-ChildItem -Recurse -Path \\cube\tv\C -exclude *.url,*.flag -Force | select-object Name,Length | Out-GridView
Get-ChildItem -Recurse -Path \\cube\tv\C -exclude *.url,*.flag -Force | Out-GridView

#
Get-ChildItem -Recurse -Path \\cube\tv\C -exclude *.url,*.flag -Force | select-object Name,@{Name="MegaBytes";Expression={$_.Length / 1MB}},LastWriteTime | Out-GridView

# files larger than 500 MB on drive C:
Get-ChildItem -Path C:\ -Recurse | Where-Object {$_.length/1MB -gt 500} | Select-Object fullname,@{n="Size MB";e={$_.length/1MB}}
