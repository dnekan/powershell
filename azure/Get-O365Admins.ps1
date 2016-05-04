workflow Get-O365Admins
{
	param( 
		[Parameter(Mandatory=$true)][string]$credO365GlobalAdminName = "Office 365 Global Admin",
		[Parameter(Mandatory=$true)][string]$emailSender = "someone@somewhere.com",
		[Parameter(Mandatory=$true)][string]$emailRecipients = "someone@somewhere.com",
		[Parameter(Mandatory=$true)][string]$emailSmtpServer = "smtp.office365.com",
		[Parameter(Mandatory=$true)][int]$emailPort = 587,
		[Parameter(Mandatory=$true)][string]$reportSubject = "Office 365 Report - Admins"
	)
	$credO365GlobalAdmin = Get-AutomationPSCredential -Name $credO365GlobalAdminName
	Connect-MsolService -Credential $credO365GlobalAdmin
	$html = "<div style='font-family:Calibri, Helvetica, sans-serif; font-size:18pt;'>$reportSubject</div><br/>"
	$html += "<table><tr><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'><b>User Name</b></td><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'><b>Admin Role</b></td></tr>"
	$msolUsers = Get-MsolUser -All | select userprincipalname | sort userprincipalname
	foreach ($msolUser in  $msolUsers) { 
		$upn = $msolUser.userprincipalname
	    $admin=Get-MsolUserRole -UserPrincipalName $upn
		$adminName = $admin.name
		if ($adminName -ne $null) {
	        $html += "<tr><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'>" + $upn + "</td><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;''>" + $adminName + "</td></tr>"
	    }
	}
	$html += "</table>"
	Send-MailMessage -From $emailSender -To $emailRecipients -Subject $reportSubject -Body $html -BodyAsHtml -SmtpServer $emailSmtpServer -Port $emailPort -Credential $credO365GlobalAdmin -UseSsl
}
