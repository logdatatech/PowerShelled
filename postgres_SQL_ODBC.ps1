# ODBC Data #
function Get-ODBC-Data
{
   param([string]$serverName=$(throw 'serverName is required.'),
	 [string]$databaseName=$(throw 'databaseName is required.'),
	   [string]$query=$(throw 'query is required.'))

  $conn=New-Object System.Data.Odbc.OdbcConnection
  $connStr = "Driver={PostgreSQL UNICODE};Server=$serverName;Port=5432;Database=$databaseName;Uid=postgres;Pwd=postgres;"
  $conn.ConnectionString= $connStr

  # display :
  " "
  "Connection :"
  $connStr
  " "
  "SQL :"
  $query
  " "

  [void]$conn.open
  $cmd=new-object System.Data.Odbc.OdbcCommand($query,$conn)
  $cmd.CommandTimeout=15
  $ds=New-Object system.Data.DataSet
  $da=New-Object system.Data.odbc.odbcDataAdapter($cmd)
  [void]$da.fill($ds)
  $ds.Tables[0] | out-gridview
  [void]$conn.close()
}

# main:
$cSQL = "select * from test"
Get-ODBC-Data -server localhost -database testdb -query $cSQL