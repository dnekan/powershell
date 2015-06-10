$wa = Get-SPWebApplication "Contoso HNSC Web App"
$user = "contoso.local\SPS_Admin"
Remove-SPSite http://siteurl
New-SPSite http://siteurl –HostHeaderWebApplication $wa –Name “SiteName” –owneralias $user –template “BLANKINTERNETCONTAINER#0” 