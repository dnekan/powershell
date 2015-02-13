#CODE STARTS HERE

#$siteurl = 'https://app-b9ece6611a5524.ContosoApps.com/'
$siteurl = 'http://appt-96b35eb8acb9a4.sharepointtest.apps.doh.nmdoh.nmsg/'

try
{

   $site = Get-SPSite $siteurl
   $web = $site.OpenWeb('JaRoAppNews');
   $web.CustomMasterUrl = "/JaRoAppNews/_catalogs/masterpage/app.master" 
   $web.MasterUrl = "/JaRoAppNews/_catalogs/masterpage/app.master" 

   $web.Update()   
}
catch
{
   Write-Host -ForegroundColor Red 'Error encountered when trying to fix app master url on ' $siteurl, ':' $Error[0].ToString();
}
 
#CODE ENDS HERE