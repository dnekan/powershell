<# 
.SYNOPSIS  
    Connect to SharePoint Online (SPO) Admin Site and display storage quota and usage information of all provisioned site collections.
    
.DESCRIPTION 
    This runbook displays quota information of all the provisioned SPO site collections for a particular Office 365 tenant.
Prereq:    
    1. Automation Module Asset containing SPO integration module.
    2. Automation Credential Asset containing the admin user id and the password for SPO tenant. 
    3. The SendMailUsingOffice365 runbook needs to be imported and published within the Azure Automation Account.

.PARAMETER  SPOAdminSiteUrl 
    String Url to the SPO Admin Site. 
    Example: https//:TenantName-admin.sharepoint.com 
 
.PARAMETER  PSCredName
    String name of PSCredential Asset. 
    Example: SPOAdminCred. The asset with name 'SPOAdminCred'' must be present as a Credential asset of type PSCredential. 

.EXAMPLE 
   Get-SPOStorageInfo -SPOAdminSiteUrl "https://{tenant}-admin.sharepoint.com" -PSCredName "SPOAdminCred"

.NOTES 
    Author: Jeff Jones, modified by Eric Skaggs 
    Originally written by Jeff Jones (@spjeff) and posted here:  http://www.spjeff.com/2015/05/18/office-365-monitor-site-collection-storage-ps1-daily-email/.
    Updated by Eric Skaggs
    -Minor update to avoid divideByZero error
    -Minor update to add parameters
    -Minor update to display values in GB instead of MB.
    Last Updated: 06/18/2015   
#> 
workflow Get-SPOStorageInfo
{
   <# 
	param( 
	    [OutputType([string[]])]
	  
	    [Parameter(Mandatory=$true)]
	    [string] 
	    $SPOAdminSiteUrl,
	    
	    [Parameter(Mandatory=$true)]   
	    [string] 
	    $PSCredName
	)
    #>
	$PSCred = Get-AutomationPSCredential -Name $PSCredName
	Write-Output "Connecting to SPO Admin Site: $SPOAdminSiteUrl using account:" $PSCred.UserName
	Connect-SPOService -Url $SPOAdminSiteUrl -Credential $PSCred   
    
	$sites = Get-SPOSite -Detailed
    $html = "<table><tbody><tr><td><b>URL</b></td><td><b>Current (GB)</b></td><td><b>Quota (GB)</b></td><td><b>Percent</b></td><td></td></tr>"
    
	foreach ($s in $sites) {
    	$surl = $s.Url
    	$curr = [math]::Round($s.StorageUsageCurrent / 1024, 2)
    	$quota = [math]::Round($s.StorageQuota / 1024, 2)
    	if($quota -eq 0)
    	{
    		$prct = [math]::Round($curr, 2) * 100
    	}
    	else
    	{
    		$prct = [math]::Round($curr/$quota, 2) * 100
    	}
        $html += "<tr><td><a target='_blank' href='" + $surl + "/_layouts/15/storman.aspx'>" + $surl + "</a></td><td>" + $curr + "</td><td>" + $quota + "</td><td>" + $prct + " %</td><td><div style='background-color: blue'>&nbsp;</div><td></td>"
    }    
    $html += "</tr></tbody></table>"
            
    Write-Output "Starting send email runbook..."
    SendMailUsingOffice365 -AzureOrgIdCredential $PSCredName -Body $html -to "Someone@Somewhere.com" -from "Someone@Somewhere.com" 
    Write-Output "Done!"
}