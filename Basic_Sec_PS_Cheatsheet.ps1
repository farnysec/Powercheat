########################################
###POWERSHELL CHEATSHEET SEC EDITION####
########################################

#PORT SCAN
================================================================================
0..65535 | Foreach-Object { Test-NetConnection -Port $_ scanme.nmap.org -WA SilentlyContinue | Format-Table -Property ComputerName,RemoteAddress,RemotePort,TcpTestSucceeded }

#ENVIRONMENT VARIABLES
================================================================================
Get-variable -Verbose


#FILES MODIFIED IN THE LAST 4 DAYS
================================================================================
Get-ChildItem c: -Recurse | ? {$_.LastWriteTime -gt (Get-Date).AddDays(-4)} | Sort-Object -Property LastWriteTime | Format-List LastWriteTime, FullName


#PROCESS DUMP FROM MEMORY - EXAMPLE WITH LSASS
================================================================================
$Mylsass = Get-Process -Name lsass
C:\Windows\System32\rundll32.exe C:\Windows\System32\comsvcs.dll, MiniDump $Mylsass.id c:\somewhere\dumplsass.bin full


#LIST ACCOUNTS ON THE SYSTEM
================================================================================
Get-LocalUser


#LIST ACCOUNTS ON THE SYSTEM BY LAST LOGON
================================================================================
Get-WmiObject -Class Win32_NetworkLoginProfile | 
Sort-Object -Property LastLogon -Descending | Select-Object -Property * 


#SIGNED SCRIPTS
================================================================================
#Check execution policy
Get-ExecutionPolicy
#Set the policy to execute scripts
Set-ExecutionPolicy [policy]


#FIND OUT WHO DID WHAT IN ACTIVE DIRECTORY - AUDITING MUST BE ENABLED.
================================================================================
#Simple GPO deployed over DCs OU -> Computer Configuration -> Policies -> Windows Settings -> Security Settings -> Advanced Audit Configuration

Find-Events -Report ADGroupMembershipChanges -DatesRange Last3days -Servers AD1, AD2 | Format-Table -AutoSize

#ReportTypes:
#Computer changes – Created / Changed – ADComputerCreatedChanged
#Computer changes – Detailed – ADComputerChangesDetailed
#Computer deleted – ADComputerDeleted
#Group changes – ADGroupChanges
#Group changes – Detailed – ADGroupChangesDetailed
#Group changes – Created / Deleted – ADGroupCreateDelete
#Group enumeration – ADGroupEnumeration
#Group membership changes – ADGroupMembershipChanges
#Group policy changes – ADGroupPolicyChanges
#Logs Cleared Other – ADLogsClearedOther
#Logs Cleared Security – ADLogsClearedSecurity
#User changes – ADUserChanges
#User changes detailed – ADUserChangesDetailed
#User lockouts – ADUserLockouts
#User logon – ADUserLogon
#User logon Kerberos – ADUserLogonKerberos
#User status changes – ADUserStatus
#User unlocks – ADUserUnlocked



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

