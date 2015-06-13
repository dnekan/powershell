# Plugin
Import-Module Microsoft.Online.SharePoint.PowerShell -ErrorAction SilentlyContinue

# Config -- get URL from "Tenant Admin" page in Office 365
$url	= "https://company-admin.sharepoint.com"
$user	= "admin@company.com"
# $smtp	= "mailrelay"

# Gather data
$sites = Get-SPOSite -Detailed
$coll = @()
foreach ($s in $sites) {
	$surl = $s.Url
	$curr = $s.StorageUsageCurrent
	$quota = $s.StorageQuota
	if($quota -eq 0)
	{
		$prct = [math]::Round($curr, 2) * 100
	}
	else
	{
		$prct = [math]::Round($curr/$quota, 2) * 100
	}
	$coll += New-Object -TypeName PSObject -Prop (@{'curr'=$curr;'quota'=$quota;'prct'=$prct;'surl'=$surl})
}
$coll = $coll | sort prct -Desc
	
# Format HTML
$html = "<table><tbody><tr><td><b>URL</b></td><td><b>Current (MB)</b></td><td><b>Quota (MB)</b></td><td><b>Percent</b></td><td></td></tr>"
foreach ($c in $coll) {
	$row = "<tr><td><a target='_blank' href='{0}/_layouts/15/storman.aspx'>{0}</a></td><td>{1}</td><td>{2}</td><td>{3} %</td><td><div style='background-color: blue'>&nbsp;</div><td></td>" -f $c.surl, $c.curr, $c.quota, $c.prct
	$html += $row
}
$html += "</tr></tbody></table>"

$html | Out-File O-365-Tenant-Storage-Report.html

# Send email
# Send-MailMessage -To $user -From $user -Subject "Office 365 Storage" -Body $html -BodyAsHtml -SmtpServer $smtp