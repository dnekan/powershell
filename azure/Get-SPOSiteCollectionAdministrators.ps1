﻿Workflow Get-SPOSiteCollectionAdministrators
{
	param( 
		[Parameter(Mandatory=$true)][string]$credO365GlobalAdminName = "Office 365 Global Admin",
		[Parameter(Mandatory=$true)][string]$tenantAdminUrl = "https://tenantName-admin.sharepoint.com",
		[Parameter(Mandatory=$true)][string]$emailSender = "someone@somewhere.com",
		[Parameter(Mandatory=$true)][string]$emailRecipients = "someone@somewhere.com",
		[Parameter(Mandatory=$true)][string]$emailSmtpServer = "smtp.office365.com",
		[Parameter(Mandatory=$true)][int]$emailPort = 587,
		[Parameter(Mandatory=$true)][string]$reportSubject = "Office 365 Report - SharePoint Online Site Collection Administrators"
	)
	$credO365GlobalAdmin = Get-AutomationPSCredential -Name $credO365GlobalAdminName
	Connect-SPOService -Url $tenantAdminUrl -Credential $credO365GlobalAdmin
	$html = "<div style='font-family:Calibri, Helvetica, sans-serif; font-size:18pt;'>$reportSubject</div><br/>"
    #Iterate through the users for each site and output the Site Collection Administrators
    $sites = Get-SPOSite -Limit All
	foreach ($site in $sites) {
	    $html += "<table><tbody><tr><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'>Site: " + $site.Url + "</b></td></tr>"    
        $siteUsers = Get-SPOUser -Limit All -Site $site.Url | sort DisplayName
		foreach ($siteUser in $siteUsers) {
            if($siteUser.IsSiteAdmin) {
		        $html += "<tr><td style='font-family:Calibri, Helvetica, sans-serif; font-size:11pt;'>--" + $siteUser.DisplayName + "</td></tr>"
            }
        }
        $html += "</tbody></table><hr/>"
    }
	Send-MailMessage -From $emailSender -To $emailRecipients -Subject $reportSubject -Body $html -BodyAsHtml -SmtpServer $emailSmtpServer -Port $emailPort -Credential $credO365GlobalAdmin -UseSsl
}
