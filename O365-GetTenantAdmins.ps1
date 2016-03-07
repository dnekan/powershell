workflow Get-O365Admins
{
	$emailRecipients = "someone@somewhere.com", "someone@somewhere.com", "someone@somewhere.com"
	$credName = "<Azure credential asset name>"
	$cred = Get-AutomationPSCredential -Name $credName
	Connect-MsolService -Credential $cred
	$html = "<div style='font-family:Calibri, Helvetica, sans-serif; font-size:18pt;'>Office 365 Report - TenantName - Admins</div><br/>"
	$html += "<table><tr><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'><b>User Name</b></td><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'><b>Admin Role</b></td></tr>"
	$msolUsers = Get-MsolUser | select userprincipalname | sort userprincipalname
	foreach ($msolUser in  $msolUsers) { 
		$upn = $msolUser.userprincipalname
	    $admin=Get-MsolUserRole -UserPrincipalName $upn
		$adminName = $admin.name
		if ($adminName -ne $null -and $adminName -ne "Directory Synchronization Accounts") {
	        $html += "<tr><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'>" + $upn + "</td><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;''>" + $adminName + "</td></tr>"
	    }
	}
	$html += "</table>"
	Send-MailMessage -From "someone@somewhere.com" -To $emailRecipients -Subject "Office 365 Report - TenantName - Admins" -Body $html -BodyAsHtml -SmtpServer "smtp.office365.com" -Port 587 -Credential $cred -UseSsl
}