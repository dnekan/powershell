<#
	.SYNOPSIS
		Get-SPSiteTemplates
	.DESCRIPTION
		Get a list of the webs and the templates from which they were built within a specified web application.
		I wrote this script to determine which sites were based on the "Fabulous 40" site templates for SharePoint 2007 after
		upgrading my client to SharePoint 2010.
	.EXAMPLE
		Get-SPSiteTemplates
	.INPUTS
	.OUTPUTS
		For each SPWeb within an SPWebApplication, lists the ParentWeb, Title, and WebTemplate properties.
	.NOTES
		This script was written by Eric Skaggs.
	.LINK
		http://www.twitter.com/skaggej
		http://www.sharepointnerd.com
#> 
Param( 
		[string]$Web = "$(Read-Host 'Enter the root URL of a web application')"
	)
begin {
}
process {
	try {
		$PSSnapinSP = Get-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
		if ($PSSnapinSP -eq $Null) {
			Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction Stop
		}
		
		$webApplication = Get-SPWebApplication $Web 
		$siteCollection = $webApplication | Get-SPSite -Limit ALL 
		$allWebs = $siteCollection | Get-SPWeb -Limit ALL
		$allWebs | Select-Object ParentWeb, Title, WebTemplate | Sort ParentWeb, Title | Format-Table
	}
	catch [Exception] {
		Write-Error $Error[0]
		$err = $_.Exception
		while ( $err.InnerException ) {
			$err = $err.InnerException
			Write-Output $err.Message
		}
	}
}