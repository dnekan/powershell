<#
.SYNOPSIS
   Disables the Developer Dashboard by setting its DisplayMode property to "Off"
.DESCRIPTION
   Disables the Developer Dashboard by setting its DisplayMode property to "Off"
.PARAMETER <paramName>
   None
.EXAMPLE
   Disable-SPDeveloperDashboard
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
		$dd.DisplayLevel = 'Off'
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