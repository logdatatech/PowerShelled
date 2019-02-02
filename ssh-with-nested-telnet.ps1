[void][reflection.assembly]::LoadFrom((Resolve-Path ".\Renci.SshNet.dll"))

$thiscomputer = $env:computerName
$file = "H:\Scripts\Credentials\LDAP_$thiscomputer.txt"

# Acceptable Security Method.
if (test-path $file) { 
	# File Already Exists.
	Write-Host "You have previously cached a password on this machine."
	$passwordFileString = Get-Content $file
	$passwordFileString | ConvertTo-SecureString
	#Write-Host $passwordFileString
	[System.Security.SecureString]$passwordSecureString = $passwordFileString | ConvertTo-SecureString
	[String]$passwordPlainTextString = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordSecureString));
	#Write-Host $passwordPlainTextString    
} else {
	Write-Host "You Do Not have a Cached Credential File $file"
	Write-Host "Run .\cache-password-LDAP.ps1"
} 

$SshClient = New-Object Renci.SshNet.SshClient("nmsweb", 22, "nkeogh", $passwordPlainTextString)
$SshClient.Connect()
$SshCommand = $SshClient.RunCommand("telnet C2JO1")
$sshCommand

$SshCommand = $SshClient.RunCommand("")
$sshCommand

## Note this Nesting Did not work!
# $SshCommand = $SshClient.RunCommand("ssh drnnms01")
# $sshCommand
# $SshCommand = $SshClient.RunCommand("cd /opt/diems/lumen/unidect/var/backups/")
# $sshCommand 
# $SshCommand = $SshClient.RunCommand("ls --format single-column *vbs*.cfg")
# $sshCommand