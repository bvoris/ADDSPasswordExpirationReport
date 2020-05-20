
$Date= Get-date     
Import-Module activedirectory 
 
$HTMLHead=@" 
<title>Password Expiration in 10 Days Report</title> 
 <Head>
 <STYLE>
 BODY{background-color :#FFFFF} 
TABLE{Border-width:thin;border-style: solid;border-color:Black;border-collapse: collapse;} 
TH{border-width: 1px;padding: 1px;border-style: solid;border-color: black;background-color: ThreeDShadow} 
TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color: Transparent} 
</STYLE>
</HEAD>

"@ 
 

#get max password age policy
$maxPwdAge=(Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days

#expiring in 7 days
$10days=(get-date).AddDays(10-$maxPwdAge).ToShortDateString()

$PassEx = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and PasswordLastSet -gt 0} –Properties * | where {($_.PasswordLastSet).ToShortDateString() -eq $10days} | select DisplayName, PasswordLastSet| ConvertTo-HTML


#HTML Body Content
$HTMLBody = @"
<CENTER>

<Font size=4><B>Passwords Expire in 10 Days Report</B></font></BR>

<I>Script last run:$date</I><BR />
Objective: Show users whose password expires in 10 days.</BR>

<B>Password Expiration in 10 Days</B><BR />
<TABLE>
<TR>
<TD>$PassEx</TD>
</TR>
</TABLE>
</BR>
</CENTER>
"@
  
#Export to HTML
$StatusUpdate | ConvertTo-HTML -head $HTMLHead -body $HTMLBody | out-file "C:\temp\pereport.html" -Append 







