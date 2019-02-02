$a = (netsh dhcp server 1.1.1.1 scope 1.1.1.0 show clients 1)

$lines = @()
#start by looking for lines where there is both IP and MAC present:
foreach ($i in $a){
    if ($i -match "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"){
        If ($i -match "[0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}"){    
            $lines += $i.Trim()
        }
    }
}
$csvfile = @()
#Trim the lines for uneeded stuff, leaving only IP, Subnet mask and hostname.
foreach ($l in $lines){
    $Row = "" | select Hostname,IP
    $l = $l -replace '[0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}', ''
    $l = $l -replace ' - ',','
    $l = $l -replace '\s{4,}',''
    $l = $l -replace '--','-'
    $l = $l -replace '-D-','-'
    $l = $l -replace '[-]{1}\d{2}[/]\d{2}[/]\d{4}',''
    $l = $l -replace '\d{1,2}[:]\d{2}[:]\d{2}',''
    $l = $l -replace 'AM',''
    $l = $l -replace 'PM',''
    $l = $l -replace '\s{1}',''
    $l = $l + "`n"
    $l = $l -replace '[,][-]',','
    $Row.IP = ($l.Split(","))[0]
    #Subnet mask not used, but maybe in a later version, so let's leave it in there:
    #$Row.SubNetMask = ($l.Split(","))[1]
    $Row.Hostname = ($l.Split(","))[2]
    $csvfile += $Row
}

#let create a csv file, in case we need i later..
$csvfile | sort-object Hostname | Export-Csv "Out_List.csv"

#Create the HTML formating
$a = "<style>"
$a = $a + "body {margin: 10px; width: 600px; font-family:arial; font-size: 12px;}"
$a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 1px;padding: 2px;border-style: solid;border-color: black;background-color: rgb(179,179,179);align='left';}"
$a = $a + "TD{border-width: 1px;padding: 2px;border-style: solid;border-color: black;background-color: white;}"
$a = $a + "</style>"

#And create HTML file...
Write-Host "Please contact theadmin@void.null for support" | Out-File "DHCPLeases.html"
$csvfile | sort-object Hostname | ConvertTo-HTML -head $a | Out-File -Append "DHCPLeases.html"