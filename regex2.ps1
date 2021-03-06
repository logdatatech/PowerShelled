$data = 
@'
Host       : 10.0.0.1
Output     : Listening on eth1
                # Host name (port/service if enabled)            last 2s   last 10s   last 40s cumulative
             --------------------------------------------------------------------------------------------
                1 MYPC.internaldomain.net                 =>     79.1Kb     79.1Kb     79.1Kb     19.8KB
                  www.awebsite.com.not.au                           <=     3.99Mb     3.99Mb     3.99Mb     1.00MB
             --------------------------------------------------------------------------------------------
             Total send rate:                                     83.3Kb     83.3Kb     83.3Kb
             Total receive rate:                                  3.99Mb     3.99Mb     3.99Mb
             Total send and receive rate:                         4.08Mb     4.08Mb     4.08Mb
             --------------------------------------------------------------------------------------------
             Peak rate (sent/received/total):                     83.3Kb     3.99Mb     4.08Mb
             Cumulative (sent/received/total):                    20.8KB     1.00MB     1.02MB
             ============================================================================================
             
             
ExitStatus : 0
'@


$regex = @'
(?ms).+?# Host name.+?
[\s-]+
[\s\d]+\s([\w\.]+)\s.+?
[\s\d]+\s([\w\.]+)\s.+?
[\s-]+
.+
'@

$data | Set-Content testfile.txt
$data = Get-Content testfile.txt 

if ( ($data | out-string)  -match $regex )
  { $matches[1,2] }


#LOCALPC.internaldomain.net
#www.awebsite.com.au