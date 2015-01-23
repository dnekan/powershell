<#
	.SYNOPSIS
		Set-SPGlobalSiteCollectionAdminisrators
	.DESCRIPTION
		Allows you to assign users to the role of Site Collection Administrator for all site collections within a specified web application.
	.EXAMPLE
		Set-SPGlobalSiteCollectionAdminisrators
	.INPUTS
		Web application url
		Domain
		Comma-separated list of user names
	.OUTPUTS
		Console text
	.NOTES
		This script was written by Eric Skaggs.  This script assumes the following:
		1.  The domain is the same for all users.  If you want to run this for users on different domains, you'll need to run this script once per domain.
		2.  The domain extension is ".com" so you'll need to update this script to compensate for that.
		3.  User email addresses are in the format username@domain.com.  If your user names and email addresses do not match, you'll want to update this to compensate for that.
	.LINK
		http://www.twitter.com/skaggej
		http://www.sharepointnerd.com
#> 
Param( 
		[string]$WebAppUrl = "$(Read-Host 'Enter the root URL of a web application')",
		[string]$domain = "$(Read-Host 'Enter the one domain that applies to all users')",
		[string]$userNameList = "$(Read-Host 'Enter a comma-separated list of user names.  Example:  user1, user2, user3')"
	)
begin {
}
process {
	try {
		$PSSnapinSP = Get-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
		if ($PSSnapinSP -eq $Null) {
			Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction Stop
		}
		#Reference all site collections for the specified web application.
		$webApplication = Get-SPWebApplication $Web 
		$siteCollections = $webApplication | Get-SPSite -Limit ALL
		#Isolate each user name unto itself
		$userNames = $userNameList.Split(",");
		#Loop through each site collection to assign privileges.
		for($i=0;$i -lt $siteCollections.Count; $i++) {
			#Reference the RootWeb
			$rootWeb = $siteCollections[$i].RootWeb;
			foreach($userName in $userNames) {
				#Trim the user name to remove leading/trailing white space
				$userName = $userName.Trim();
				Write-Host "Adding $domain\$userName to the AllUsers list" -ForegroundColor Yellow
				#Add the user to the AllUsers list
				$rootWeb.AllUsers.Add("$domain\$userName","$userName@$domain.com","","");
				#Promote the user to the role of Site Collection Administrator
				$rootWeb.AllUsers | where { "$domain\$userName" -contains $_.UserLogin } | foreach { 
				$_.IsSiteAdmin = "True"; 
				$_.Update();
				Write-Host "$userName is now a Site Collection Administrator for $rootWeb"
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