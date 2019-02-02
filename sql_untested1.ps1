function ExecuteQuery([string]$CommandText){
	$errorActionPreference = "SilentlyContinue"
	$DataTable = New-Object "System.Data.DataTable"
	$Command.CommandText = $CommandText
	$Results = $Command.ExecuteReader()
	If ($? -eq $false){
		$Results = "Error: $($error[0].Exception.Message)"; 
		return $Results
	} Else{
		$DataTable.Load($Results);
		return $DataTable
	}
}

$ConnectionString = "Driver={SQL Server};Server=DatabaseServer;Database=Database;"
$Connection = New-Object System.Data.Odbc.OdbcConnection($ConnectionString)
$Connection.Open()
if ($Connection.State -eq [System.Data.ConnectionState]::Open)
{	$Command = New-Object System.Data.Odbc.OdbcCommand
	$Command.Connection = $Connection
	$Command.CommandTimeout = 300
	$Results = ExecuteQuery("Select * from RandomTable")
	$Results
}