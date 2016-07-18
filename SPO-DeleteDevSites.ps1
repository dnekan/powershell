$tenantName = "catsysdemo"
$devName = "ericskaggs"
$adminUserName = "demo-eric.skaggs"

Connect-SPOService https://$tenantName-admin.sharepoint.com -Credential $adminUserName@$tenantName.com

$devSites = Get-SPOSite | Where-Object{$_.Url -like "*$devName*"}

$devSites | ForEach-Object{Remove-SPOSite -Identity $_.Url -Confirm:$false}

$devSitesDeleted = Get-SPODeletedSite | Where-Object{$_.Url -like "*$devName*"}

$devSitesDeleted | ForEach-Object{Remove-SPODeletedSite -Identity $_.Url -Confirm:$false}
