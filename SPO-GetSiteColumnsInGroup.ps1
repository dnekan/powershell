<#
.SYNOPSIS
   Useful script to obtain a CSV file that lists the site columns within a particular group.
.DESCRIPTION
   Running this script will output a CSV file that lists every site column within a specified site column group.
.PARAMETER <paramName>
    [string]$siteUrl = "$(Read-Host 'Enter the URL of a site collection')",
	[string]$fieldGroup = "$(Read-Host 'Enter the name of your custom field group')",
	[string]$outputFile = "$(Read-Host 'Enter the full path of the output CSV file')"
.EXAMPLE
   SPO-GetSiteColumnsInGroups.ps1 -siteUrl http://siteUrl -fieldGroup "My Site Columns" -outputFile $home\desktop\fields.csv
#>
Param(
    [string]$siteUrl = "$(Read-Host 'Enter the URL of a site collection')",
	[string]$fieldGroup = "$(Read-Host 'Enter the name of your custom field group')",
	[string]$outputFile = "$(Read-Host 'Enter the full path of the output CSV file')"
)

Connect-SPOnline $siteUrl # will prompt for authentication
$groupFields = $fields | Where-Object{$_.Group -eq $fieldGroup}
$groupFields | select * | Sort InternalName | Export-Csv $outputFile