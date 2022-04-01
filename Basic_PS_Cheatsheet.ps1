########################################
###POWERSHELL CHEATSHEET EXT EDITION####
########################################

#LINKS
================================================================================
https://docs.microsoft.com/en-gb/powershell/
https://www.powershellgallery.com/
https://forums.powershell.org/
https://www.reddit.com/r/PowerShell/


#SYSTEM
================================================================================
#Access the windows registry
Get-Item -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion | Select-Object -ExpandProperty Property
#Set the policy to execute scripts
Set-ExecutionPolicy AllSigned
#Check disk
Get-disk -Verbose


#LOGS
================================================================================
#Get lists of available logs
Get-EventLog *
#Get newst system logs and export to CSV - Security log requires admin privledge
Get-EventLog -log system -Newest 100 | Export-CSV AllEvents.CSV


#PROCESSES
================================================================================
Get-Process | Sort-Object Id | Format-Table -RepeatHeader -GroupBy Threads
#Check the processes using a specific dll and count them.
Get-process | Where { $_.Modules.filename -match "netapi32.dll"} | ForEach-Object {$i++} ; Write-Host $i
Stop-process -id 2322


#SERVICES
================================================================================
Get-Service | Sort-Object -Property @{Expression = "Status"; Descending = $true}, @{Expression = "DisplayName"; Descending = $false} 


#TASKS
================================================================================
Get-scheduledtask | where {$_.state -eq 'running'}
Stop-ScheduledTask -TaskName HPAudioSwitch



#NETWORK
================================================================================
Get-NetTCPConnection | ? {($_.State -eq "Listen") -and ($_.RemoteAddress -eq "0.0.0.0")} ; Get-NetAdapter
Get-NetRoute | Where-Object -FilterScript { $_.NextHop -Ne "::" } | Where-Object -FilterScript { $_.NextHop -Ne "0.0.0.0" } | 		Where-Object -FilterScript { ($_.NextHop.SubString(0,6) -Ne "fe80::") }
Test-Connection 1.1.1.1 -Count 2 -Delay 2 -Verbose -BufferSize 50 -TimeToLive 50
Test-NetConnection 1.1.1.1 -TraceRoute
Test-NetConnection 1.1.1.1 -port 53
Test-NetConnection contoso.com -InformationLevel Detailed
#Port Scanner
0..65535 | Foreach-Object { Test-NetConnection -Port $_ scanme.nmap.org -WA SilentlyContinue | Format-Table -Property ComputerName,RemoteAddress,RemotePort,TcpTestSucceeded }


#FILES N FOLDERS
================================================================================
Set-Location 'C:\Users\MBE66\OneDrive - Sky\Documents\Projects\powershell'
Get-Content ./logfile.log -Tail 5 –Wait
Get-ChildItem -Force -Recurse -File | Where Length -gt 100MB | Sort Length -Descending | Select fullname, CreationTime
Get-FileHash -Algorithm MD5 C:\Users\MBE66\Documents\desktop.ini


#CIM
================================================================================
#Display a list of CIM objects
Get-CimClass -ClassName Win32_Dis*
Get-CimClass -ClassName *
Get-CimInstance Win32_DiskDrive -Property *
# BIOS Version
(Get-CimInstance Win32_BIOS).SMBIOSBIOSVersion
# Serial Number
(Get-CimInstance Win32_BIOS).SerialNumber
# Model
(Get-CimInstance Win32_ComputerSystem).Model
# Printers
Get-CimInstance Win32_Printer | Select-Object Name, PortName, Default
# Active Directory Domain
(Get-CimInstance Win32_ComputerSystem).Domain
#Time since last reboot
(Get-CimInstance Win32_OperatingSystem).LastBootUpTime
#Get all data about system
Get-CIMInstance Win32_OperatingSystem | select *
#Get free memory
Get-CIMInstance Win32_OperatingSystem | Select FreePhysicalMemory


#DATE_N_TIME
================================================================================
#Days until the end of the year
(Get-Date -Date "$((Get-Date).Year + 1)/1/1") - (Get-Date)


#LOOPS
================================================================================
#FOR
for($i=10 ; $i -gt 0; $i--)  { if($i -eq 5) {write-host $i -foregroundcolor red} else {write-host $i -foregroundcolor cyan}} 
#DO WHILE
$mymatrix = (1,2,3,4,5) ; $i = 0 ; do {write-host $mymatrix[$i] ; $i++}  while ($mymatrix[$i] -lt 4) 
#SWITCH
$num = Read-Host "Enter a number" ; Switch ($num) { 1 {'Run Action 1'} ; 2 {'Run Action 2'} ; 3 {'Run Action 3'} }



#VARS
================================================================================
#Get-variable prints out all the environment variables.
Get-variable -Verbose -Name Err*
#Move to the directory where the variables are stored and list them.
Set-Location Variable: ; Get-ChildItem
$day = Read-Host “Enter day” ; write-host $day 
$day = $null ; Remove-Variable -Name day
[int]$Global:computers = 12
[char]$mychar = "a"



#ARRAYS
================================================================================
$myarray = @('one', 'two', 'three') ; $myarray.foreach({"[$PSItem]"})
$myarray[1]
$myarray[1] = 'one more'
$myarray.count
$myarray -join '-'
$myarray -join $null
$myarray.contains('one')
$myarray += 'four'

NESTED ARRAY
$data = @(@(1,2,3),@(4,5,6),@(7,8,9))

$data2 = @(
    @(1,2,3),
    @(4,5,6),
    @(7,8,9)
)

#Multidimensional array created as an object
Write-Host $mybigarray = New-Object 'object[,,]' 10,20,10



#HASHTABLE
================================================================================
$myhashtable = @{London = "Critical" ; Manchester = "Critical" ; Brighton = "Non-critical"} 
$myotherhashtable = @{1 = "Aaron" ; 2 = "Abraham" ; 3 = "Adam"} 
$myhashtable.keys
$myhashtable.values
$myhashtable.Count
$myhashtable.ContainsKey('London')
$myhashtable.london


#FUNCTIONS oneliner
================================================================================
#Create new functions
function global:Get-DependentSvs { $myreturn = Get-Service | Where-Object {$_.DependentServices} ; $myreturn = 2 ;return $myreturn}
function global:Getme-something ([string]$myparameter1, [bool]$myparameter2)  { Write-Host $myparameter1 ; Write-Host $myparameter2} 
#Check the code of a given function
Get-Content function:\Getme-something
#Move to the functions folder to check available functions
Set-Location function: ; Get-ChildItem




#EXCEPTIONS
================================================================================
#1st example
try
	{
		write-host "Just starting"
	}
catch
	{
		Write-Output "Something threw an exception"
		Write-Output $_
	}



#2nd example
try
	{
		Start-Something -ErrorAction Stop
	}
catch
	{
		Write-Output "Something threw an exception or used Write-Error"
		Write-Output $_
	}
finally
{
		write-host "Just finishing"
}



#PIPELINE
================================================================================
#   $_ and $PSItem are the same variable. It's the current item in the pipeline
1,2,3 | %{ write-host $_ } 
1,2,3 | %{ write-host $PSItem } 
1,2,3 | Where-Object {$_ -gt 1}
1,2,3 | Where-Object {$PSItem -gt 1}



#HELP
================================================================================
Get-help -Name Test-Connection -Full
Get-Command



#MODULES
================================================================================
#Check available modules
Get-Module -ListAvailable
#Check commands on module
Get-Command -Module WindowsSearch



#OBJECTS
================================================================================






#REST AND JSON
================================================================================
#REST API EXAMPLE
$Cred = Get-Credential
$Url = "https://server.contoso.com:8089/services/search/jobs/export"
$Body = @{
    search = "search index=_internal | reverse | table index,host,source,sourcetype,_raw"
    output_mode = "csv"
    earliest_time = "-2d@d"
    latest_time = "-1d@d"
}
Invoke-RestMethod -Method Post -Uri $url -Credential $Cred -Body $body -OutFile out.csv

#JSON EXAMPLE. Get info about Registry process, convert to json, save it to file, print it and reconvert it 
Get-Process Registry | ConvertTo-Json | Tee-Object json.txt ; Get-Content .\json.txt | ConvertFrom-Json



#WEB
================================================================================
#Get a website
$Response = Invoke-WebRequest -URI https://www.bing.com/
#Get links
(Invoke-WebRequest -Uri "https://aka.ms/pscore6-docs").Links.Href




#TEXT N REGEX
================================================================================
#Managing output
$Resultcsvpentest | Out-Host -Paging # This is only available on Powershell CLI, not on ISE
$Resultcsvpentest | findstr "_2 "
$mystring = Get-Process | Select-String "HP"
Get-Content ./logfile.log -Tail 5 –Wait
#Measure strings
"one two" | Measure-Object -word -line

#REGEX TO MATCH URLs
(http[s]?|[s]?ftp[s]?)(:\/\/)([^\s,]+)
(http[s]?)(:\/\/)([^\s,]+)(?=")
#Use the @" and "@ on different lines to escape the problem with apostrophes"''""''

[string]$myecho = @" 
Move-Item .\json2.txt .\this_is_how_you_deal_with_apostrophes.txt" -Confirm
"@




#MISC
===================================================================================================================
#Get a random number
get-random @(0..50) 
#Get history of commands which match the string "Service"
Get-History | Where-Object {$_.CommandLine -like "*Service*"}
	


================================================================================
================================================================================
================================================================================


function prompt_color {
    $color = 12
    Write-Host ("PS $env:USERDOMAIN@$env:USERNAME> ") -NoNewLine `
     -ForegroundColor $Color
    return " "
}

function My_circle ($p1, $p2) {
    $radius = 2.45
    $circumference = 2 * ([Math]::PI) * $radius

    $date = Get-Date -Date "2010-2-1 10:12:14 pm"
    $month = $date.Month

    $values = 10, 55, 93, 102
    $value = $values[2]

	return $circumference
}


function get_url_from_rms ($csvfile) {

	$Resultcsvpentest = Import-Csv .\Resultcsvpentest.csv

	Remove-Variable -Name url_to_inc
	Remove-Variable -Name counter
	
	$url_to_inc = @{}
	
	for($i=0 ; $i -le $Resultcsvpentest.count; $i++) {
		$key = $Resultcsvpentest[$i].inc_num
		$value = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $Resultcsvpentest[$i].scope).Matches.Value)
		if ($url_to_inc.ContainsKey($key) ) {
			$counter++
			$ext_key = $key + "_" + $counter
			$key = $ext_key
		}
		$url_to_inc.add( $key, $value )
	} 

}


try
	{
	Import-Csv “C:\test\test.csv” | ForEach-Object {
	$Name = $_.Name + “test.com”
	New-ADUser `
	-DisplayName $_.”Dname” `
	-Name $_.”Name” `
	-GivenName $_.”GName” `
	-Surname $_.”Sname” `
	-SamAccountName $_.”Name” `
	-UserPrincipalName $UPName `
	-Office $_.”off” `
	-EmailAddress $_.”EAddress” `
	-Description $_.”Desc” `
	-AccountPassword (ConvertTo-SecureString “vig@123” -AsPlainText -force) `
	-ChangePasswordAtLogon $true `
	-Enabled $true `
	Add-ADGroupMember “OrgUsers” $_.”Name”;
	Write-Host "User created and added in the AD group"
	}
	}
catch
	{
	$msge=$_.Exception.Message
	Write-Host "Exception is" $msge
	}


============

Find out who did what in Active Directory - Auditing must be enabled.

Simple GPO deployed over DCs OU -> Computer Configuration -> Policies -> Windows Settings -> Security Settings -> Advanced Audit Configuration


Find-Events -Report ADGroupMembershipChanges -DatesRange Last3days -Servers AD1, AD2 | Format-Table -AutoSize

ReportTypes:
Computer changes – Created / Changed – ADComputerCreatedChanged
Computer changes – Detailed – ADComputerChangesDetailed
Computer deleted – ADComputerDeleted
Group changes – ADGroupChanges
Group changes – Detailed – ADGroupChangesDetailed
Group changes – Created / Deleted – ADGroupCreateDelete
Group enumeration – ADGroupEnumeration
Group membership changes – ADGroupMembershipChanges
Group policy changes – ADGroupPolicyChanges
Logs Cleared Other – ADLogsClearedOther
Logs Cleared Security – ADLogsClearedSecurity
User changes – ADUserChanges
User changes detailed – ADUserChangesDetailed
User lockouts – ADUserLockouts
User logon – ADUserLogon
User logon Kerberos – ADUserLogonKerberos
User status changes – ADUserStatus
User unlocks – ADUserUnlocked


============