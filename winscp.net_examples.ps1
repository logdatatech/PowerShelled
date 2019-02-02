
# script that checks if a remote file exists before downloading it
$remotePath = "/home/user/test.txt"
$localPath = "C:\download\test.txt"
 
if ($session.FileExists($remotePath))
{
    Write-Host ("File {0} exists, downloading" -f $remotePath)
    $session.GetFiles($remotePath, $localPath).Check()
}
else
{
    Write-Host ("File {0} does not exist" -f $remotePath)
}


#https://winscp.net/eng/docs/script_local_move_after_successful_upload
param (
    $localPath = "C:\upload\*",
    $remotePath = "/home/user/",
    $backupPath = "C:\backup\"
)
 
try
{
    # Load WinSCP .NET assembly
    Add-Type -Path "WinSCPnet.dll"
 
    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp
        HostName = "example.com"
        UserName = "user"
        Password = "mypassword"
        SshHostKeyFingerprint = "ssh-rsa 2048 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
    }
 
    $session = New-Object WinSCP.Session
 
    try
    {
        # Connect
        $session.Open($sessionOptions)
 
        # Upload files, collect results
        $transferResult = $session.PutFiles($localPath, $remotePath)
 
        # Iterate over every transfer
        foreach ($transfer in $transferResult.Transfers)
        {
            # Success or error?
            if ($transfer.Error -eq $Null)
            {
                Write-Host ("Upload of {0} succeeded, moving to backup" -f
                    $transfer.FileName)
                # Upload succeeded, move source file to backup
                Move-Item $transfer.FileName $backupPath
            }
            else
            {
                Write-Host ("Upload of {0} failed: {1}" -f
                    $transfer.FileName, $transfer.Error.Message)
            }
        }
    }
    finally
    {
        # Disconnect, clean up
        $session.Dispose()
    }
 
    exit 0
}
catch [Exception]
{
    Write-Host ("Error: {0}" -f $_.Exception.Message)
    exit 1
}