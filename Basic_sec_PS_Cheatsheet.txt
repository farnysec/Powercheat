########################################
###POWERSHELL CHEATSHEET SEC EDITION####
########################################

#PORT SCAN
================================================================================
0..65535 | Foreach-Object { Test-NetConnection -Port $_ scanme.nmap.org -WA SilentlyContinue | Format-Table -Property ComputerName,RemoteAddress,RemotePort,TcpTestSucceeded }

#ENVIRONMENT VARIABLES
================================================================================
Get-variable -Verbose


#WIN EVENTS TO MONITOR
================================================================================
$sec_events = @{} 
$sec_events.Add("4624",	"Account Logon")
$sec_events.Add("4625",	"Failed login")
$sec_events.Add("4663",	"Attempt made to access object")
$sec_events.Add("4688",	"Process creation logging")
$sec_events.Add("4720",	"A user account was created")
$sec_events.Add("4722",	"A user account was enabled")
$sec_events.Add("4740", "A user account was locked out")
$sec_events.Add("4728",	"A member was added to a security-enabled global group")
$sec_events.Add("4732",	"A member was added to a security-enabled local group")

Get-EventLog Security | Where-Object -FilterScript {$_.EventID -in $sec_events.Keys}


#FILES MODIFIED IN THE LAST 4 DAYS
================================================================================
Get-ChildItem c: -Recurse | ? {$_.LastWriteTime -gt (Get-Date).AddDays(-4)} | Sort-Object -Property LastWriteTime | Format-List LastWriteTime, FullName



#LIST ACCOUNTS ON THE SYSTEM
================================================================================
Get-LocalUser

#
================================================================================
Get-LocalUser

