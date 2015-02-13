<#
.SYNOPSIS
   Resets the master page for each of the app webs in a given site collection.
.DESCRIPTION
   References:  
   1)  http://mctalex.blogspot.com.au/2013/07/powershell-fix-for-app-master-problem.html
   2)  http://www.esbenwiberg.net/Blog/Post/2/Master-page-inheritance-will-break-your-apps

.PARAMETER <paramName>
   [string]$siteCollectionInput = "$(Read-Host 'Enter the root URL of a site collection: ')"
.EXAMPLE
   Set-SPAppWebMasterPages -siteCollectionUrl http://SPWebApp/sites/SPSiteCollRoot
#>
Param( 
		[string]$siteCollectionUrl = "$(Read-Host 'Enter the root URL of a site collection: ')"
	)
begin {
}
process {
	try {
	$siteCollection = Get-SPSite $siteCollectionUrl
	$allWebs = $siteCollection.AllWebs;
	$allWebs | foreach-object {
			if($_.IsAppWeb -eq $true){
				$_.CustomMasterUrl = $_.ServerRelativeUrl+"/_catalogs/masterpage/app.master" 
				$_.MasterUrl = $_.ServerRelativeUrl+"/_catalogs/masterpage/app.master" 
				$_.Update()
				write-host "App at "+$_.ServerRelativeUrl+"updated!"
			}
		}
	}
	catch
	{
	   Write-Host -ForegroundColor Red $Error[0].ToString();
	}
  }
}