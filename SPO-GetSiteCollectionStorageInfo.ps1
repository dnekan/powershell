workflow Get-SPOStorageInfo
{
	$emailRecipients ="someone@somewhere.com", "someone@somewhere.com", "someone@somewhere.com"
	$credName = "<Azure credential asset name>"
	$cred = Get-AutomationPSCredential -Name $credName
	Connect-SPOService -Url https://TenantName-admin.sharepoint.com -Credential $cred   
	$sites = Get-SPOSite -Detailed
	$html = "<div style='font-family:Calibri, Helvetica, sans-serif; font-size:18pt;'>Office 365 Report - TenantName - SharePoint Online Storage</div><br/>"
    $html += "<table><tbody><tr><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'><b>URL</b></td><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'><b>Current (GB)</b></td><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'><b>Quota (GB)</b></td></tr>"    
	foreach ($s in $sites) {
    	$surl = $s.Url
    	$curr = [math]::Round($s.StorageUsageCurrent / 1024, 2)
    	$quota = [math]::Round($s.StorageQuota / 1024, 2)
        $html += "<tr><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'><a target='_blank' href='" + $surl + "/_layouts/15/storman.aspx'>" + $surl + "</a></td><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'>" + $curr + "</td><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'>" + $quota + "</td></tr>"
    }    
    $html += "</tbody></table>"
	Send-MailMessage -From "someone@somewhere.com" -To $emailRecipients -Subject "Office 365 Report - TenantName - SharePoint Online Storage" -Body $html -BodyAsHtml -SmtpServer "smtp.office365.com" -Port 587 -Credential $cred -UseSsl
}