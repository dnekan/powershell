$siteUrl = "http://fuse.catdemos.com/"

Add-PSSnapin Microsoft.SharePoint.PowerShell
$site = Get-SPSite $siteUrl
$site.GetWebTemplates(1033) | sort name