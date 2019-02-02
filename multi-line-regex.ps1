@"
dskfj
sdfjklasdfjkl;asdf
sadfjsdkalfj;asdf
sdkfl;jafsd
fasjkdlfjasd;l what I want asdfjkl;jdsaf
asdjkl;fjasdk searchme dfjkal;s
asdfjkla;sdf
asfjdk;
sdjkfl;
asfjkl;asdfjkasd
asdfjkl;asdf I also want this dskfjlas;dfjkdl
dskfl;asdjf searchme afjksdlfjas;
asfjksdla;
"@ -split "`r`n" | 
Select-String -Pattern 'searchme' -AllMatches -Context 1 |
ForEach-Object -Process {
    $_.Context.PreContext
}