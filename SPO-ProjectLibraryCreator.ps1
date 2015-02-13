<#
	.SYNOPSIS
		ProjectLibraryCreator-Eric.ps1
	.DESCRIPTION
		# This supports SharePoint 2013 on-premise and SharePoint Online with 2013 look and feel.
		# This script is tested on both root and sub site collections running a Team Site.
		# Each reference to a column name must reference the column's internal name and not the display name.
	.EXAMPLE
		ProjectLibraryCreator-Eric.ps1
	.INPUTS
		
	.OUTPUTS
		Console text
	.NOTES
		.LINK
		http://www.twitter.com/skaggej
		http://www.ericskaggs.net
#> 
Param( 
		[string]$spoSiteUrl = "$(Read-Host 'Enter the URL of the projects site collection')",
		[string]$requestsListTitle = "$(Read-Host 'Enter the name of the project site request list')",
		[string]$spoUserName = "$(Read-Host 'Enter the user name of the SharePoint Online Administrator')",
		[string]$spoPassword = "$(Read-Host 'Enter the password for the SharePoint Online Administrator')"
	)
begin {}
process 
{
	try 
	{
		# Necessary Imports
		Import-Module ".\spps.psm1"

		# Variables
		#$spoSiteUrl = "https://eskaggsdemo3.sharepoint.com/sites/projects"
		#$spoUserName = "admin@eskaggsdemo3.onmicrosoft.com"
		#$spoPassword = "pass@word1"
		#$requestsListTitle = "Project Site Requests"

		# SharePoint Online Connection Information
		Initialize-SPPS -siteURL $spoSiteUrl -online $true -username $spoUserName -password $spoPassword

		# Read from Project Site Requests list
		# Get all requests where status = 0 (representing a new, unprocessed request)
		$web = $clientContext.Web
		$webTitle = $web.Title
		$clientContext.Load($web)
		$clientContext.ExecuteQuery()
		Write-Host "Connected to '$webTitle' site"

		$requestsList = $web.Lists.GetByTitle($requestsListTitle)
		$clientContext.Load($requestsList)
		$clientContext.ExecuteQuery()

		$query = New-Object Microsoft.SharePoint.Client.CamlQuery
		$query.ViewXml = "<View><Query><Where><Eq><FieldRef Name='Request_x0020_Status'/><Value Type='Integer'>0</Value></Eq></Where></Query></View>"
		$requests = $requestsList.GetItems($query)
		$clientContext.Load($requests)
		$clientContext.ExecuteQuery()
		Write-Host "New requests found:  " $requests.Count

		for($i=0;$i -lt $requests.Count;$i++)
		{
			# Store request field values
			$title = $requests[$i]["Title"]
			$description = $requests[$i]["CategoryDescription"]
			$status = $requests[$i]["Request_x0020_Status"]
			$author = $requests[$i]["Author"].LookupValue
			$groupName = "$title Members"

			Write-Host "Group Name:  " $groupName

			# Set the Request Status of the current request to 1 to remove it from future updates
			$requests[$i]["Request_x0020_Status"] = 1;
			$requests[$i].Update();

			# Create the project library in this site
			# Add-DocumentLibrary -listTitle $title -listDescription $description
			
			# Create the project library as a subsite
			Add-Subsite -title $title -description $description

			# Grant the requestor ownership of the library
			Add-Group -name $groupName
			Add-PrincipalToGroup -username $author -groupname $groupName
			Set-WebPermissions -groupname $groupName -roleType "Contributor"
			# Set-ListPermissions -groupname $groupName -roleType "Contributor" -listname $title
		}
		Write-Host "End"
	}
	catch [Exception] 
	{
		Write-Error $Error[0]
		$err = $_.Exception
		while ( $err.InnerException ) 
		{
			$err = $err.InnerException
			Write-Output $err.Message
		}
	}
}