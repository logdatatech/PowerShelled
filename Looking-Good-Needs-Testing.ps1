# ORIGIN:http://powershelleverydayfaq.blogspot.com/search/label/Scripting%20Techniques

##########################################################################

# How to test for Elevated Privilege
$currentPrincipal = New-Object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())
$administratorsRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator
if (!$currentPrincipal.IsInRole($administratorsRole)) {
    Throw "This script must be run in an elevated session."
}

##########################################################################

#.SYNOPSIS
# Emulation of PAUSE command (cmd)
#.DESCRIPTION
# Author : Jeffrey Snover [MSFT]
#.LINK
# http://blogs.msdn.com/b/powershell/archive/2007/02/25/pause.aspx
function Pause ([string]$Message="[Pause] Press Enter key to continue ...")
{
    if (((Get-Host).Name) -eq 'ConsoleHost') {
        Write-Host -NoNewLine $Message
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        Write-Host ""
    }
    Else {
    Read-Host -Prompt $message
    }
}

##########################################################################

[reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089") | out-null
#.SYNOPSIS
# Display a confrimation dialog
# Return$True if the user click 'Yes'
#.LINK
# http://bartdesmet.net/blogs/bart/archive/2006/09/16/4429.aspx
function ConfirmMessageBox {
    param(
        [parameter(
        Mandatory=$False)]
        [String]$WinTitle='PowerShell Script',
        [parameter(
        Mandatory=$False)]
        $MsgText='Do you really want to continue ?'
    )
    $result = [Windows.Forms.MessageBox]::Show($MsgText, $WinTitle, [Windows.Forms.MessageBoxButtons]::YesNo, [Windows.Forms.MessageBoxIcon]::Question)
    If ($result -eq [Windows.Forms.DialogResult]::Yes) {
        Return $true
    }
    Else {
        Return $false
    }
}

##########################################################################

Converting to the local time
To convert a date/time string from GMT (or any other time zone)

[DateTime]::Parse('2015-05-08T15:17:52Z')

##########################################################################

Don’t Count, Measure
How often do you use the  Count property of an object to get the number of items in it ?

$SomeArray.count
The problem is that if you try to get the  Count property on a null object or on a object that is not a collection or an array it will throw an exception.

The solution is to use the Measure-Object cmdlet :

($SomeArray | measure-object).count


##########################################################################

Find all files modified after a date
To find all files modified after may 1st, 2014 :

Get-ChildItem .\ -recurse | Where-Object { ($_.PsIsContainer -eq $false) -and ($_.LastWriteTime -gt (get-date '2014-05-01')) } | select fullname,lastwritetime,length | Out-GridView

##########################################################################

Top 5 tips for running external commands in Powershell
Running an external command in powershell looks pretty easy, to run notepad just do :

notepad.exe
Things get a little be more complicated when you add many arguments with spaces and quotes, something like the following just wont work :

Winrm set winrm/config/listener?Transport=HTTP+Address=* @{Enabled="false"}
Why is that ?

Powershell is a programming language, it has to evaluate (interpret) every line in a script as an expression. The preceding line is not a valid Powershell expression. Each arguments must be treated as an object (a String in this case), So a valid expression would be :

&Winrm "set" "winrm/config/listener?Transport=HTTP+Address=*" "@{Enabled=`"false`"}"

As you can see this can rapidly become a nightmare when you add variables and path to that call. Really not easy to debug. This is why I wrote my top 5 tips for running external commands in Powershell.

Tip #1 : Use the ampersand call operator (&)
Using the call operator (&) will help Powershell to evaluate the line as a command and not as an object. For example it will allow the following command to start Internet Explorer :

&"C:\Program Files\Internet Explorer\iexplore.exe"

Tip #2 : Do not put all arguments in one string
Each string will be treated one argument. Put each argument in a different string et separate them with a space or even better put them in an array like this :

$CallArgs = @("set",
        "winrm/config/listener?Transport=HTTP+Address=*",
        "@{Enabled=`"false`"}"
        )
&WinRM $CallArgs

Tip #3 : Don’t forget to escape each quote (")
If you want a quote to appear in an argument you must escape it like this : `"

Tip #4 : Use EchoArgs.exe for debugging

Debugging the call operator can be pretty hard simply because you can’t see what is really passed as arguments to the external command by Powershel. EchoArgs.exe is a great little tool that will simply display the arguments and the command line used to call the program. So the following command :

&.\echoargs.exe winrm "set" "winrm/config/listener?Transport=HTTP+Address=*" "@{Enabled=`"false`"}"
Will produce :


Arg 0 is <winrm>
Arg 1 is <set>
Arg 2 is <winrm/config/listener?Transport=HTTP+Address=*>
Arg 3 is <@{Enabled=false}>

Command line:
"I:\Mes Documents UL\PoSH\EchoArgs.exe"  winrm set winrm/config/listener?Transport=HTTP+Address=* @{Enabled="false"}
EchoArgs.exe is part of the Powershell Community Extensions (PSCX). You should download the version 2.1 (still in beta) to get the full comand line displayed. The Arguments (arg 0, arg 1, …) displayed by EchoArgs.exe seems to have been normalized (quotes have bnne strip), so the full command line is very helpfull.

Tip #5 : Use dot-sourcing
Don’t forget to use Powershell dot-source syntax (.\) when you call an external command in the current directory :

&.\echoargs.exe

##########################################################################

List users connected to shares
Get-WmiObject win32_serverconnection | select username,computername,sharenam

##########################################################################

$UserNameToFind="Bill"
$connectionstring="Server=server.domain.com;Initial Catalog=MyDB;Trusted_Connection=yes"
$SQLCommandText="SELECT Usager_ID FROM T_Usager WHERE Netware_ID='$($UserNameToFind)' OR IDUL='$($UserNameToFind)'"
$SQLConnection = new-object system.data.sqlclient.SqlConnection($connectionstring)
$SQLConnection.open()
$sqlCommand = New-Object system.Data.sqlclient.SqlCommand($SQLCommandText,$SQLConnection)
$sqlCommand.ExecuteScalar()
$SQLConnection.close()

##########################################################################

How to create a constant

new-variable DOMAIN_PASSWORD_COMPLEX 1 -option constant

##########################################################################


##########################################################################

How to trace a script execution ?

To trace execution of every line, every function call and every variable affection in a script type the following command before running your script :

set-psdebug -trace 2 -step

To set thing back to normal :
set-psdebug -off

How to use an environment variable
$env:path


How to list all environment variables
get-childitem env:

How to list all variables
Get-variable


$home.gettype()


##########################################################################


##########################################################################


##########################################################################



##########################################################################


##########################################################################


##########################################################################


##########################################################################


##########################################################################


##########################################################################