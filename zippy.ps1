# $file has to be full file path
$ destination is the parent folder of the file.
function UnZip($file)
{
$destination = 
$shell = new-object -com shell.application
$zip = $shell.NameSpace($file)
  foreach($item in $zip.items()) {
    $shell.Namespace($destination).copyhere($item)
  }
}


# Start in a Parent Folder

# Recurse Each Folder

# If .ZIP Files found UnZip them

UnZip "C:\Users\nathan\Downloads\EBOOKS.WEEK34.2016-TL\Apress.-.Crafting.Wearables.2016.Retail.eBook-BitBook\bb-i31na.zip"

C:\Users\nathan\Downloads\EBOOKS.WEEK34.2016-TL\Apress.-.Crafting.Wearables.2016.Retail.eBook-BitBook\bb-i31na.zip
#Then we can simply use the function like this:
#Expand-ZIPFile –File “C:\howtogeeksite.zip” –Destination “C:\temp\howtogeek”


# Example
#unzip "myZip.zip" "C:\Users\me\Desktop" "c:\mylocation"
function unzip($fileName, $sourcePath, $destinationPath)
{
    $shell = new-object -com shell.application
    if (!(Test-Path "$sourcePath\$fileName"))
    {
        throw "$sourcePath\$fileName does not exist" 
    }
    New-Item -ItemType Directory -Force -Path $destinationPath -WarningAction SilentlyContinue
    $shell.namespace($destinationPath).copyhere($shell.namespace("$sourcePath\$fileName").items()) 
}