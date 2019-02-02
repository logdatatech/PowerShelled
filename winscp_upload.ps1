param (
    $localPath = "C:\upload\*",
    $remotePath = "/home/user/",
    $backupPath = "C:\backup\",
    $freshFile = "D:\GroupData\Artefacts\DRN_SM9_Exports\CAM\ENV-DEVICE.CSV",
    $remoteFolder = "/data/rxfer/DRN_SM9_Exports/CAM/"
)

# NOTE THIS IS NOT EXPECTED TO BE EXECUTED LOCALLY

# Launch Excel Headless Excel File with VBA
# It will check the TABLE winrm_remotejobs


try
{
    # Load WinSCP .NET assembly
    Add-Type -Path "C:\Program Files\WinSCP\WinSCPnet.dll"

    # Set up session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Scp
        HostName = "dknrsu10"
        UserName = "rxfer"
        SshHostKeyFingerprint = "ssh-rsa 2048 7b:27:32:d4:a4:ae:22:a4:a0:a9:07:db:d0:a4:f4:1e"
        SshPrivateKeyPath = "D:\Code\_winrm_VBA\dknrsn10.ppk"
    }

    $sessionOptions.AddRawSettings("TryAgent", "0")
    $sessionOptions.AddRawSettings("AuthKI", "0")

    $session = New-Object WinSCP.Session

    try
    {
        # Connect
        $session.Open($sessionOptions)
 
        # Upload files, collect results
        $transferResult = $session.PutFiles($freshFile, $remoteFolder)
 
        # Iterate over every transfer
        foreach ($transfer in $transferResult.Transfers)
        {
            # Success or error?
            if ($transfer.Error -eq $Null)
            {
                Write-Host ("Upload of {0} succeeded" -f $transfer.FileName)
                # Upload succeeded, move source file to backup
                #Move-Item $transfer.FileName $backupPath
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