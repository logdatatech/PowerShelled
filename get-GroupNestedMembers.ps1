#
# .SYNOPSIS
#   Get members of an active directory group including members
#   of nested groups
#
# .DESCRIPTION
#   Search Active Dircetory to find a group and get members of
#   that group including members of nested groups. Return
#   an object.
#
#   Author   : Jean-Pierre.Paradis@fsa.ulaval.ca
#   Date     : May 13, mars 2010
#   Version  : 1.00
#   Language : PowerShell 2.0
#
# .PARAMETER GroupName
#   Name of the group (mandatory)
#
# .PARAMETER OU
#   Distinguished name of an Organizational Unit (OU) to search (optional)
#
# .LINK
#   Inspired by http://gallery.technet.microsoft.com/ScriptCenter/en-us/1228cdfa-9c04-4bc7-a016-11b492c704d2
#   from Trevor Hayman
#
# .EXAMPLE
#   C:\PS> .\get-GroupNestedMembers.ps1 -groupname "mygroup"
# .EXAMPLE
#   C:\PS> .\get-GroupNestedMembers.ps1 -groupname "mygroup" -ou "OU=Experimentation,DC=mydomain,DC=com"
# .EXAMPLE
#   C:\PS> .\get-GroupNestedMembers.ps1 -groupname "mygroup" -verbose
# .EXAMPLE
#   C:\PS> .\get-GroupNestedMembers.ps1 -groupname "mygroup" | Out-GridView


#REQUIRES -version 2.0

param (
    [parameter(
    Mandatory=$true,
    ValueFromPipeline=$True)]
    [String]$GroupName,

    [parameter(
    Mandatory=$false)]
    [String]$OU=""

    )

Set-StrictMode -Version 2.0

Function Add-GroupMembers {
# .SYNOPSIS
#   Add member of -GroupDistinguishedName to $Script:ColGroupMembers
    param (
        [parameter(
        Mandatory=$true)]
        [String]$GroupDistinguishedName
        )
    $objGroup = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$GroupDistinguishedName")
    $MemberList = $objGroup.member
    ForEach ($member in $MemberList) {
        $objMember = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$member")
        if ($objMember.objectCategory.Value.Contains("Group")) {
            Add-GroupMembers -GroupDistinguishedName $objMember.DistinguishedName
            }
        Else {
            $Script:ColGroupMembers.add((New-Object psobject -Property @{Name=[string]$objMember.name;DisplayName=[string]$objMember.DisplayName;DistinguishedName=[string]$objMember.DistinguishedName;ImmediateParent=[string]$objGroup.name}))
            }
        }
}

# Setup AD search root
if ($OU -ne "") {
    Write-Verbose "Searching from $OU"
    $root=[System.DirectoryServices.DirectoryEntry] "LDAP://$OU"
    }
Else {
    $root=[string]""
    }
$search = [ADSISearcher] $root

# Find the group
$search.Filter = "(&(objectCategory=Group)(cn=$GroupName))"
$result = $search.FindOne()
If ($result -eq $null) {
    Write-Error "Group '$groupname' not found !"
    exit
    }
Write-Verbose "Found group $($result.Properties.distinguishedname)"

# Create a collection to store de results
$psobjectStrongName = (New-Object psobject).psobject.GetType().AssemblyQualifiedName
$Script:ColGroupMembers = New-Object "System.Collections.ObjectModel.Collection``1[[$psobjectStrongName]]"

Add-GroupMembers -GroupDistinguishedName $result.Properties.distinguishedname
Write-verbose "Found $($ColGroupMembers.count) member(s)"
return ($ColGroupMembers|Sort-Object 'Name')