<#
.SYNOPSIS
   Useful script to generate a "report" of your custom content types and fields.
.DESCRIPTION
   Running this script will prompt you for some input values, but then will list out every
   content type and the fields within that content type for the specified content type group
   and field group.  I wrote this script as part of a deliverable for a client.  They wanted
   to know what custom content types I created for them and this was an easy way to give them
   what they wanted in a repeatable way.
.PARAMETER <paramName>
   [string]$url = "$(Read-Host 'Enter the root URL of a web application')",
   [string]$outFile = "$(Read-Host 'Enter the path of the output file')",
   [string]$ctGroup = "$(Read-Host 'Enter the name of your custom content type group')",
   [string]$fieldGroup = "$(Read-Host 'Enter the name of your custom field group')"
.EXAMPLE
   Get-SPCustomContentTypesAndFields
#>
Param( 
		[string]$url = "$(Read-Host 'Enter the root URL of a web application')",
		[string]$outFile = "$(Read-Host 'Enter the path of the output file')",
		[string]$ctGroup = "$(Read-Host 'Enter the name of your custom content type group')",
		[string]$fieldGroup = "$(Read-Host 'Enter the name of your custom field group')"
	)
begin {
}
process {
	try {
# Create the output text file 
Out-File $outFile

#Get the web app
$webApplication = Get-SPWebApplication $url

#Get all site collections
$siteCollections = $webApplication | Get-SPSite

#Output the appropriate data
$siteCollections | ForEach-Object{
 $siteLabel = "$_"
 if($siteLabel.Length -gt 0)
 {
  Write-Host $siteLabel
  $siteLabel | Out-File $outFile -Append
 }
 $topLevelWeb = $_.RootWeb
 $cpdContentTypes = $topLevelWeb.ContentTypes | Where-Object{$_.Group -eq $ctGroup} | Sort Name
 $cpdContentTypes | Foreach-Object{
  $contentTypeName = $_.Name
  $contentTypeLabel = " Content Type:  $contentTypeName"
  if($contentTypeName.Length -gt 0)
  {
   Write-Host $contentTypeLabel
   $contentTypeLabel | Out-File $outFile -Append
  }
  $allFields = $_.Fields | Where-Object{$_.Group -eq $fieldGroup} | Sort Title
  $allFields | ForEach-Object{
   $fieldLabel = "  Field:  $_"
   if($_.Title.Length -gt 0)
   {
    Write-Host $fieldLabel
    $fieldLabel | Out-File $outFile -Append
   }
  }
 }
 }
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