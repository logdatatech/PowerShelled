# Origin:https://blogs.technet.microsoft.com/askcore/2013/03/24/alternate-data-streams-in-ntfs/

pushd "C:\Users\d787502\OneDrive - Telstra\_Code_TeamWork\_DOCO\Tips.and.Tricks"

Get-Item -Path '.\Notepad++ Cheat Sheet.pdf' -stream *
Get-Item -Path '.\Notepad++ Cheat Sheet.pdf' -stream Zone.Identifier

Get-Content -Path '.\Notepad++ Cheat Sheet.pdf' -stream Zone.Identifier
Remove-Item -Path '.\Notepad++ Cheat Sheet.pdf' -stream Zone.Identifier