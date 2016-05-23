Workflow Add-O365GlobalAdminAsSiteCollectionAdministrator
{
	param( 
		[Parameter(Mandatory=$true)][string]$credO365GlobalAdminName = "Office 365 Global Admin",
		[Parameter(Mandatory=$true)][string]$tenantAdminUrl = "https://tenantName-admin.sharepoint.com",
		[Parameter(Mandatory=$true)][string]$adminLoginName = "someone@somewhere.com"
	)
	$credO365GlobalAdmin = Get-AutomationPSCredential -Name $credO365GlobalAdminName
	Connect-SPOService -Url $tenantAdminUrl -Credential $credO365GlobalAdmin   
    $sites = Get-SPOSite -Limit All            
    ForEach ($url in $sites.Url)                        
    {            
        Set-SPOUser -Site $url -LoginName $adminLoginName -IsSiteCollectionAdmin $True                        
        Write-Output "Added to $url"
    }
}