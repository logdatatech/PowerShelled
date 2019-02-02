# Closest I have come to dir /s *XYZ*
#match_pattern = '*.xlsm'
Get-ChildItem -recurse -path H:\ -file | Where-Object { $_.FullName -match '.xlsm'}
Get-ChildItem -recurse -path I:\ -file | Where-Object { $_.FullName -match '.xlsm'}
