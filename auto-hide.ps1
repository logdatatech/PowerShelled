# Array of My/Trusted WiFies
$myWiFies = "Nathan iPhone SE","nato","shoc","triple"

$show_wifi_CMD = "netsh wlan show networks | findstr SSID"
#Select-String C:\Scripts\*.txt -pattern "Hey, Scripting Guy!" | Select-Object Filename

# Get Console Results 
$wifies = Invoke-Expression $show_wifi_CMD
#Write-Host $wifies.count
#Write-Host $wifies
ForEach ($entry in $wifies) {
	#$charCount = ($entry.ToCharArray() | Where-Object {$_} | Measure-Object).Count
	$count = $entry.length
	#Write-Host Line Length $count
	#$a.Substring($a.IndexOf(':')+1, 11)
	$colonPos = $entry.IndexOf(':')+2 # Index 0 Value
	Write-Host Line -$entry- Length $count, Colon Position $colonPos
	$ssid_name = $entry.Substring($colonPos,$count-$colonPos)
	# Test if ssid_name is in the Array of Known Good WiFies
	Write-Host "TESTING SSID :"$ssid_name
	if ($myWiFies -contains $ssid_name) {
		Write-Host "GOOD WiFi->"$ssid_name 
	} else {
		Write-Host "STRAY WiFi->"$ssid_name
		$netsh_CMD = "netsh wlan add filter permission=block ssid=`"$ssid_name`" networktype=infrastructure"
		#Write-Host $netsh_CMD
		Invoke-Expression $netsh_CMD
	}
}

Exit

# Block WiFi Networks from List
ForEach ($line in Get-Content .\wifi.visible.txt) {
	#echo $line
	$netsh_CMD = "netsh wlan add filter permission=block ssid=`"$line`" networktype=infrastructure"
	Write-Host $netsh_CMD
	Invoke-Expression $netsh_CMD
	}

#netsh wlan add filter permission=block ssid="mobilEDN" networktype=infrastructure