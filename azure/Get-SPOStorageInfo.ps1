Workflow Get-SPOStorageInfo
{
	param( 
		[Parameter(Mandatory=$true)][string]$credO365GlobalAdminName = "Office 365 Global Admin",
		[Parameter(Mandatory=$true)][string]$tenantAdminUrl = "https://tenantName-admin.sharepoint.com",
		[Parameter(Mandatory=$true)][string]$emailSender = "someone@somewhere.com",
		[Parameter(Mandatory=$true)][string]$emailRecipients = "someone@somewhere.com",
		[Parameter(Mandatory=$true)][string]$emailSmtpServer = "smtp.office365.com",
		[Parameter(Mandatory=$true)][int]$emailPort = 587,
		[Parameter(Mandatory=$true)][string]$reportSubject = "Office 365 Report - SharePoint Online Storage"
	)
	$credO365GlobalAdmin = Get-AutomationPSCredential -Name $credO365GlobalAdminName
	Connect-SPOService -Url $tenantAdminUrl -Credential $credO365GlobalAdmin   
	$sites = Get-SPOSite -Detailed
	$html = "<div style='font-family:Calibri, Helvetica, sans-serif; font-size:18pt;'>$reportSubject</div><br/>"
	$html += "<table><tbody><tr><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'><b>URL</b></td><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'><b>Current (GB)</b></td><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'><b>Quota (GB)</b></td></tr>"    
	foreach ($s in $sites) {
		$surl = $s.Url
		$curr = [math]::Round($s.StorageUsageCurrent / 1024, 2)
		$quota = [math]::Round($s.StorageQuota / 1024, 2)
		$html += "<tr><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'><a target='_blank' href='" + $surl + "/_layouts/15/storman.aspx'>" + $surl + "</a></td><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'>" + $curr + "</td><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'>" + $quota + "</td></tr>"
	}    
	$html += "</tbody></table>"
	Send-MailMessage -From $emailSender -To $emailRecipients -Subject $reportSubject -Body $html -BodyAsHtml -SmtpServer $emailSmtpServer -Port $emailPort -Credential $credO365GlobalAdmin -UseSsl
}