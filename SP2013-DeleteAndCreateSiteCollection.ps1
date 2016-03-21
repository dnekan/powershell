$siteUrl = "http://fuse.catdemos.com/"
$siteName = "Fuse Demo"
$ownerAlias = "catdemos\fuse.admin"
$siteTemplate = "STS#0"

Add-PSSnapin Microsoft.SharePoint.PowerShell
$siteToDelete = Get-SPSite $siteUrl
$siteToDelete.Delete()

New-SPSite -Url $siteUrl -Name $siteName -OwnerAlias $ownerAlias -Template $siteTemplate