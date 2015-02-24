<#
	.SYNOPSIS
		SP2013-EmptyRecycleBins.ps1
	.DESCRIPTION
		# Completely empties all recycle bins within an entire site collection (stage 1 and stage 2)
	.EXAMPLE
		NMDOH - Deploy CHILEnet Branding Solution.ps1 -siteUrl http://FullSiteUrl
	.INPUTS
		siteUrl:  full path to a site collection
	.OUTPUTS
		Console text
	.NOTES
	.LINK
		http://www.twitter.com/skaggej
		http://www.ericskaggs.net
#> 
Param(
		[string]$siteUrl = "$(Read-Host 'Enter the full URL of a site collection')"
)
# load PowerShell cmdlets for SharePoint
Add-PsSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
$site = Get-SPSite $siteUrl
$site.RecycleBin.DeleteAll()
Write-Host -ForegroundColor Green "All recycle bins emptied!"