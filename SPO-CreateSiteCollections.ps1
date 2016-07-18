workflow SPO-CreateSiteCollections
{
    param(
      $credO365
    )
    #This section provides a script that allows you to provision multiple site collections in SharePoint Online based on a CSV file

    #SharePoint Online Url Prefix
    $spoUrlPrefix = "https://catsysdemo.sharepoint.com/sites/"

    #Default SharePoint Site Collection Owner
    $siteOwner = "demo-eric.skaggs@catsysdemo.com"

    #Default Storage Quota
    $storageQuota = 1000

    #Path for the CSV import - you'll want to update the path
    $sites = import-csv -Path SPO-SiteCollections.csv
    
    ForEach -Parallel ($site in $sites)
    {
        #Connects your PowerShell session to SharePoint Online.  This cmdlet prompts you for your Office 365 admin credentials.
        Connect-SPOService -Url https://catsysdemo-admin.sharepoint.com -Credential $credO365

	    #store the comma-separated values in variables
	    $siteTitle = $site.Title
	    $siteUrl = $site.Url
	    $siteTemplate = $site.Template

	    #provision the site
	    Write-Output ============================================================
	    Write-Output Creating Site Collection at $spoUrlPrefix$siteUrl

	    New-SPOSite -Url $spoUrlPrefix$siteUrl -Owner $siteOwner -StorageQuota $storageQuota -Title $siteTitle -Template $siteTemplate
	
	    Write-Output DONE!
    }
}

$tenantName = "catsysdemo"
$adminUserName = "demo-eric.skaggs"
$creds = Get-Credential -Credential $adminUserName@$tenantName.com
SPO-CreateSiteCollections $creds
