Workflow Get-O365LicensedUserCount
{
	param( 
		[Parameter(Mandatory=$true)][string]$credO365GlobalAdminName = "Office 365 Global Admin",
		[Parameter(Mandatory=$true)][string]$emailSender = "someone@somewhere.com",
		[Parameter(Mandatory=$true)][string]$emailRecipients = "someone@somewhere.com",
		[Parameter(Mandatory=$true)][string]$emailSmtpServer = "smtp.office365.com",
		[Parameter(Mandatory=$true)][int]$emailPort = 587,
		[Parameter(Mandatory=$true)][string]$reportSubject = "Office 365 Report - Licensed User Count"
	)
	$credO365GlobalAdmin = Get-AutomationPSCredential -Name $credO365GlobalAdminName
	Connect-MsolService -Credential $credO365GlobalAdmin
    $allUsers = Get-MsolUser -All
    $unlicensedUsers = Get-MsolUser -All -UnlicensedUsersOnly
    $licensedUserCount = $allUsers.Count - $unlicensedUsers.Count
	$html = "<div style='font-family:Calibri, Helvetica, sans-serif; font-size:18pt;'>$reportSubject</div><br/>"
	$html += "<table><tbody><tr><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'><b>Licensed User Count</b></td></tr>"    
    $html += "<tr><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'>" + $licensedUserCount + "</td></tr></tbody></table>"
	Send-MailMessage -From $emailSender -To $emailRecipients -Subject $reportSubject -Body $html -BodyAsHtml -SmtpServer $emailSmtpServer -Port $emailPort -Credential $credO365GlobalAdmin -UseSsl
}