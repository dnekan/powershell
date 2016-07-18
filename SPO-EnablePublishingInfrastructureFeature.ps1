Workflow SPO-EnablePublishingFeatures {
    param(
      $credO365
    )

    Connect-SPOService https://catsysdemo-admin.sharepoint.com -Credential $credO365
    $devSites = Get-SPOSite | Where-Object{$_.Url -like "*ericskaggs*"}

    ForEach -Parallel ($devSite in $devSites){
        Connect-SPOnline -Url $devSite.Url -Credentials $credO365
        Enable-SPOFeature -Scope Site -Identity "f6924d36-2fa8-4f0b-b16d-06b7250180fa"
    }

    ForEach -Parallel ($devSite in $devSites){
        Connect-SPOnline -Url $devSite.Url -Credentials $credO365
        Enable-SPOFeature -Scope Web -Identity "94c94ca6-b32f-4da9-a9e3-1f3d343d7ecb"
    }
}

$tenantName = "catsysdemo"
$adminUserName = "demo-eric.skaggs"
$creds = Get-Credential -Credential $adminUserName@$tenantName.com
SPO-EnablePublishingFeatures $creds
