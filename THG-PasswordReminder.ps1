<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2020 v5.7.172
	 Created on:   07/13/2021 10:49 PM
	 Created by:   	Brysen Freitas
	 Organization: 	HilbGroup
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		Notify Users to reset passwords
#> 


#Import AD Module
 Import-Module ActiveDirectory
  
#Create warning dates for future password expiration
$SevenDayWarnDate = (get-date).adddays(7).ToLongDateString()
$SixDayWarnDate = (get-date).adddays(6).ToLongDateString()
$FiveDayWarnDate = (get-date).adddays(5).ToLongDateString()
$fourDayWarnDate = (get-date).adddays(4).ToLongDateString()
$ThreeDayWarnDate = (get-date).adddays(3).ToLongDateString()
$twoDayWarnDate = (get-date).adddays(2).ToLongDateString()
$OneDayWarnDate = (get-date).adddays(1).ToLongDateString()

$helpdeskemail = "Helpdesk@hilbgroup.com'
$MailSender = "PasswordReminder@hilbgroup.com"
$Subject = 'Your password will Expire soon.'
$EmailStub1 = 'This is a friendly reminder that your password'
$EmailStub2 = 'will expire in'
$EmailStub3 = 'days on'
$EmailStub4 = '. Please contact the helpdesk at $Helpdeskemail if you need assistance changing your password. DO NOT REPLY TO THIS EMAIL.'
$SMTPServer = 'smtp.office365.com'
 
#Find accounts that are enabled and have expiring passwords
$users = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and PasswordLastSet -gt 0 } `
 -Properties "Name", "EmailAddress", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Name", "EmailAddress", `
 @{Name = "PasswordExpiry"; Expression = {[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed").tolongdatestring() }}
 
#check password expiration date and send email on match
foreach ($user in $users) {
     if ($user.PasswordExpiry -eq $SevenDayWarnDate) {
         $days = 7
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $SevenDayWarnDate, $EmailStub4 -join ' '
 
         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
     }
     elseif ($user.PasswordExpiry -eq $sixDayWarnDate) {
         $days = 6
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $ThreeDayWarnDate, $EmailStub4 -join ' '
 
         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject `
         -Body $EmailBody
     }
     elseif ($user.PasswordExpiry -eq $fiveDayWarnDate) {
         $days = 5
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $OneDayWarnDate, $EmailStub4 -join ' '
 
         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
     }
     elseif ($user.PasswordExpiry -eq $fourDayWarnDate) {
         $days = 4
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $OneDayWarnDate, $EmailStub4 -join ' '
 
         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
     }
     elseif ($user.PasswordExpiry -eq $threeDayWarnDate) {
         $days = 3
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $OneDayWarnDate, $EmailStub4 -join ' '
 
         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
     }
     elseif ($user.PasswordExpiry -eq $twoDayWarnDate) {
         $days = 2
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $OneDayWarnDate, $EmailStub4 -join ' '
 
         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
     }
     elseif ($user.PasswordExpiry -eq $oneDayWarnDate) {
         $days = 1
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $OneDayWarnDate, $EmailStub4 -join ' '
 
         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
     }
    else {}
 }
