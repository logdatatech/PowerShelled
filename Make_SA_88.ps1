<#
Z:\ Was Mapped to 
\\legacy\TeamWeb2010\CORP\ciog\DNOC\JP2047ce\DeployAudi\02_Site_Audit_Data
Obviously you already need access.

To make the List of Parent Folders
Get-ChildItem -path Z:\ -directory | select-object Name > H:\CR3.txt

#>
$Folders = Get-Content H:\SA_88.txt
foreach ($Folder in $Folders){
	$PartPath = $Folder.Trim() # Trim If Needed.
	$CR3_Folder = "Y:\Site Acceleration\$PartPath\00_SiteAcceptance"
	# Weird Renamed WebDav Folder ...
	#$CR3_Folder = 'Y:\Acceleration Progam\'+$PartPath+'\00_SiteAcceptance'
	echo "Create Folder ->$CR3_Folder<-"
	New-Item $CR3_Folder -type Directory -Force # Comment this Line out to Test Before Making the Folders.
}