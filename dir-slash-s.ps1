# Closest I have come to dir /s *XYZ*
Get-ChildItem -recurse -path Z:\ -directory | Where-Object { $_.FullName -match 'PEN'}