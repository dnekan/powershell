<#
.SYNOPSIS
   Enables the Developer Dashboard by setting its DisplayMode property to "OnDemand"
.DESCRIPTION
   Enables the Developer Dashboard by setting its DisplayMode property to "OnDemand"
.PARAMETER <paramName>
   None
.EXAMPLE
   Enable-SPDeveloperDashboard
.NOTES
	This script was written by Eric Skaggs.
.LINK
	http://www.twitter.com/skaggej
	http://www.sharepointnerd.com
#>
begin {
}
process {
	try {
		$dd = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.DeveloperDashboardSettings
		$dd.DisplayLevel = 'OnDemand'
		$dd.TraceEnabled = $true
		$dd.Update()
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