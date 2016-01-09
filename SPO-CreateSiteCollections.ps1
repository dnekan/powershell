#This section provides a script that allows you to provision multiple site collections in SharePoint Online based on a CSV file

#SharePoint Online Url Prefix
$spoUrlPrefix = "https://YourTenantName.sharepoint.com/sites/"

#Default SharePoint Site Collection Owner
$siteOwner = "username@domain.com"

#Default Storage Quota
$storageQuota = 1000

#Path for the CSV import - you'll want to update the path
$sites = import-csv -Path SPO-SiteCollections.csv

#Connects your PowerShell session to SharePoint Online.  This cmdlet prompts you for your Office 365 admin credentials.
$credO365 = Get-Credential
Connect-SPOService -Url https://YourTenantName-admin.sharepoint.com -Credential $credO365

foreach($site in $sites)
{
	#store the comma-separated values in variables
	$siteTitle = $site.Title
	$siteUrl = $site.Url
	$siteTemplate = $site.Template

	#provision the site
	write-host -foregroundcolor blue ============================================================
	write-host -foregroundcolor green Creating Site Collection at $spoUrlPrefix$siteUrl

	New-SPOSite -Url $spoUrlPrefix$siteUrl -Owner $siteOwner -StorageQuota $storageQuota -Title $siteTitle -Template $siteTemplate
	
	write-host -foregroundcolor green DONE!
}