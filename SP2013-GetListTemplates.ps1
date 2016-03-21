$siteUrl = "http://fuse.catdemos.com/"

Add-PSSnapin Microsoft.SharePoint.PowerShell
$site = Get-SPSite $siteUrl
$rootWeb = $site.RootWeb
$listTemplates = $rootWeb.ListTemplates
$listTemplates | select InternalName, Name, Type_Client, BaseType | sort Type_Client | Export-Csv C:\Users\Fuse.Admin\Desktop\SharePoint2013-ListTemplates.csv