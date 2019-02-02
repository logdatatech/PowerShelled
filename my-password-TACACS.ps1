# Note Secure String is Tied to User Account+Machine Account.
# http://www.adminarsenal.com/admin-arsenal-blog/secure-password-with-powershell-encrypting-credentials-part-1
# When you are not using the -Key or -SecureKey parameters, PowerShell uses the Windows Data Protection API (DPAPI) 
# to encrypt/decrypt your strings. This effectively means that only the same user account on the same computer will be able to use this 
# encrypted string. That is something to keep in mind as you attempt to automate any scripts. If you’re using a service account, 
# you’ll need to use the -Key or -SecureKey parameters.
$thiscomputer = $env:computerName
$folder = "H:\Scripts\Credentials"
$file = "H:\Scripts\Credentials\TACACS_$thiscomputer.txt"

if (test-path $folder) { 
	# Folder Already Exists.
} else {
	New-Item $folder -type directory
} 

if (test-path $file) { 
	# File Already Exists.
	Write-Host "You have previously cached a password on this machine."
	$passwordFileString = Get-Content $file
	$passwordFileString | ConvertTo-SecureString
	Write-Host $passwordFileString
	[System.Security.SecureString]$passwordSecureString = $passwordFileString | ConvertTo-SecureString
	[String]$passwordPlainTextString = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordSecureString));
	Write-Host $passwordPlainTextString    
} else {
	Write-Host "You Do Not have a Cached Credential File $file"
	Write-Host "Run .\cache-password-TACACS.ps1"
}