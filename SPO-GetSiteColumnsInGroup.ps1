<#
.SYNOPSIS
   Useful script to obtain a CSV file that lists the site columns within a particular group.
.DESCRIPTION
   Running this script will output a CSV file that lists every site column within a specified site column group.
.PARAMETER <paramName>
    [string]$siteUrl = "$(Read-Host 'Enter the URL of a site collection')",
	[string]$fieldGroup = "$(Read-Host 'Enter the name of your custom field group (without quotes)')",
	[string]$outputFile = "$(Read-Host 'Enter the full path of the output CSV file')"
.EXAMPLE
   SPO-GetSiteColumnsInGroups.ps1 -siteUrl http://siteUrl -fieldGroup "My Site Columns" -outputFile $home\desktop\fields.csv
#>
Param(
    [string]$siteUrl = "$(Read-Host 'Enter the URL of a site collection')",
	[string]$fieldGroup = "$(Read-Host 'Enter the name of your custom field group (without quotes)')",
	[string]$outputFile = "$(Read-Host 'Enter the full path of the output CSV file')"
)

$credentials = Get-Credential
$spcreds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($credentials.UserName, $credentials.Password)
Connect-SPOnline –Url $siteUrl –Credentials $credentials
$clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
$clientContext.Credentials = $spcreds
$rootWeb = $clientContext.Site.RootWeb
$clientContext.Load($rootWeb.Fields)
$clientContext.ExecuteQuery()
$fields = $rootWeb.Fields
$groupFields = $fields | Where-Object{$_.Group -eq $fieldGroup}
$groupFields | select * | Sort InternalName | Export-Csv $outputFile
