# https://mjolinor.wordpress.com/2014/01/31/random-password-generator/
$Length = 10

# @NK FIXME: it's just a lazy way of typing A-Z,a-z,0-9 
$PasswordCharCodes = {33..126}.invoke()

#Exclude ",',/,`,O,0 <= these are dastardly to type and read.
34,39,47,96,48,79 | ForEach-Object {[void]$PasswordCharCodes.Remove($_)}

$PasswordChars = [char[]]$PasswordCharCodes

# Write-Output $PassWordChars
foreach ($i in 1..$length) {
    $RandChar = Get-Random -InputObject $PasswordChars
    $NewPassword = $NewPassword+$RandChar 
}
Write-Output $NewPassWord
# do { 
#     $NewPassWord =  $(ForEach-Object ($i in 1..$length)) 
#     Get-Random -InputObject $PassWordChars}) -join '' 
# } until (
#     ( $NewPassword -cmatch '[A-Z]' ) -and
#     ( $NewPassWord -cmatch '[a-z]' ) -and
#     ( $NewPassWord -imatch '[0-9]' ) -and 
#     ( $NewPassWord -imatch '[^A-Z0-9]' )
# ) 
# $NewPassword