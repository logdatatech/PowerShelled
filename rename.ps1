﻿$Script:unrarName =  "c:\windows\system32\unrar.exe"

# $file has to be full file path
# destination is the parent folder of the file.
function UnZip($file,$destination)
{
#$destination = 
$shell = new-object -com shell.application
$zip = $shell.NameSpace($file)
    foreach($item in $zip.items()) {
        $shell.Namespace($destination).copyhere($item)
    }
}

# Example
#unzip "myZip.zip" "C:\Users\me\Desktop" "c:\mylocation"
function unzip2($fileName, $sourcePath, $destinationPath)
{
    $shell = new-object -com shell.application
    if (!(Test-Path "$sourcePath\$fileName"))
    {
        throw "$sourcePath\$fileName does not exist" 
    }
    New-Item -ItemType Directory -Force -Path $destinationPath -WarningAction SilentlyContinue
    $shell.namespace($destinationPath).copyhere($shell.namespace("$sourcePath\$fileName").items()) 
}  

function UnRAR([string]$FilePath, [bool]$RemoveSuccessful=$false) 
{
<#
    .Synopsis
        unrars a file or set of rar files, then if "all ok"
        removes or moves the original rar files
    .Example
        Extract-RAR-File c:\temp\foo.rar
        Extracts contents of foo.rar to folder temp.
    .Parameter FilePath
        path to rar file 
    .Parameter RemoveSuccessful
        remove rar files if successful otherwise move files to folder called trash
    .Link
        http://heazlewood.blogspot.com
#>

# Verify we can access UNRAR.EXE .
if ([string]::IsNullOrEmpty($unrarName) -or (Test-Path -LiteralPath $unrarName) -ne $true){
     Write-Error "Unrar.exe path does not exist '$unrarPath'."
        return
}  
    [string]$unrarPath = $(Get-Command $unrarName).Definition
    if ( $unrarPath.Length -eq 0 )
    {
        Write-Error "Unable to access unrar.exe at location '$unrarPath'."
        return
    }

# Verify we can access to the compressed file.
if ([string]::IsNullOrEmpty($FilePath) -or (Test-Path -LiteralPath $FilePath) -ne $true)
{
    Write-Error "Compressed file does not exist '$FilePath'."
        return
    }
    [System.IO.FileInfo]$Compressedfile = get-item -LiteralPath $FilePath
    #set Destination to basepath folder
    #$fileBaseName = [System.IO.Path]::GetFileNameWithoutExtension($Compressedfile.Name)
    #$DestinationFolder = join-path -path $Compressedfile.DirectoryName -childpath $fileBaseName
    #set Destination to parent folder
    $DestinationFolder = $Compressedfile.DirectoryName 
    # If the extract directory does not exist, create it.
    CreateDirectoryIfNeeded ( $DestinationFolder ) | out-null
    Write-Output "Extracting files into $DestinationFolder"
    &$unrarPath x -y  $FilePath $DestinationFolder | tee-object -variable unrarOutput 
    #display the output of the rar process as verbose
    $unrarOutput | ForEach-Object {Write-Verbose $_ }
    if ( $LASTEXITCODE -ne 0 )
    { 
        # There was a problem extracting. 
        #Display error
        Write-Error "Error extracting the .RAR file"
    }
    else
    {
        # check $unrarOutput to remove files
        Write-Verbose "Checking output for OK tag" 
        if ($unrarOutput -match "^All OK$" -ne $null) {
            if ($RemoveSuccessful) {
                Write-Verbose "Removing files" 
                #remove rar files listed in output.
                $unrarOutput -match "(?<=Extracting\sfrom\s)(?<rarfile>.*)$" | 
                ForEach-Object {$_ -replace 'Extracting from ', ''} | 
                ForEach-Object { get-item -LiteralPath $_ } | 
                remove-item
            } else {
                Write-Verbose "Moving files to trash folder`n$trashPath" 
                [string]$trashPath = join-path -path $DestinationFolder "Trash"
                #create trash folder to move rars to
                #CreateDirectoryIfNeeded ($trashPath)
                #move rar files listed in output.
                #$unrarOutput -match "(?<=Extracting\sfrom\s)(?<rarfile>.*)$" | 
                #ForEach-Object {$_ -replace 'Extracting from ', ''} | 
                #foreach-object { get-item -LiteralPath $_ } | 
                #move-item -destination $trashPath
            }
        }
    }
}
function CreateDirectoryIfNeeded ( [string] $Directory ){
<#
    .Synopsis
        checks if a folder exists, if it does not it is created
    .Example
        CreateDirectoryIfNeeded "c:\foobar"
#>
    if ((test-path -LiteralPath $Directory) -ne $True)
    {
        New-Item $Directory-type directory | out-null
        if ((test-path -LiteralPath $Directory) -ne $True)
        {
            Write-Error ("Directory creation failed")
        }
        else
        {
            Write-Verbose ("Creation of directory succeeded")
        }
    }
    else
    {
        Write-Verbose ("Creation of directory not needed")
    }
}

#UnRAR "C:\Users\nathan\Downloads\EBOOKS.WEEK34.2016-TL\Andrea.Linett.-.The.Cool.Factor.2016.RETAiL.eBOOK-DiSTRiBUTiON\Andrea.Linett.-.The.Cool.Factor.2016.RETAiL.eBOOK-DiSTRiBUTiON.rar"

# unrar archives to parent folder
# created for http://www.experts-exchange.com/Programming/Languages/Scripting/Shell/Batch/Q_28391754.html

# Start at a Top / Parent Folder
$inputPath = "C:\tmp\EBOOKS"

# Recurse Each Sub Folder Remove All Except
# .pdf
# .nfo
# .epub

#Get-ChildItem -File -Path $inputPath -Exclude *.pdf,*.nfo,*.epub -Recurse | Sort-Object name | % {
#    $thisFile = $_.FullName
#    Write-Host "REMOVE ->  $thisFile"
#    Remove-Item $thisFile -Force
#}

Get-ChildItem -Directory -Path $inputPath -Recurse | Sort-Object name | ForEach-Object {
    $thisFolder = $_.FullName
    # First one has to be the Source Folder
    $newFolder = $thisFolder.Replace(".Retail.eBook-BitBook","")
    # Now We Just replacing on same string.
    $newFolder = $newFolder.Replace(".RETAIL.EBOOK-kE","")
    $newFolder = $newFolder.Replace(".RETAiL.eBOOK-DiSTRiBUTiON","")
    $newFolder = $newFolder.Replace(".RETAIL.EPUB.EBOOK-kE","")
    $newFolder = $newFolder.Replace(" RETAIL EPUB EBOOK-kE","")
    $newFolder = $newFolder.Replace(".RETAiL.eBOOk-rebOOk","")
    $newFolder = $newFolder.Replace(" RETAiL eBOOk-rebOOk","")
    # Now . to " "
    $newFolder = $newFolder.Replace("."," ")
    # Need a Function to Define the Multiple Text Replacement Rules.
    #Rename-item -Path $thisFolder -whatIf -NewName $newFolder -Verbose
    # if new differs from old
    if ($thisFolder -ne $newFolder) {
        Write-Host "RENAME $thisFolder -> $newFolder"
        Rename-item -Path $thisFolder -NewName $newFolder -Verbose
    }
}