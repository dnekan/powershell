$url = "http://www.sharepointnerd.com"  <# Replace this URL with your own. #>
$site = get-spsite $url
$rootWeb = $site.OpenWeb()
$myContentTypes = $rootWeb.ContentTypes | Where-Object{$_.Group -eq "SharePointNerd Content Types"} <# Replace this content type group with your own. #>
$myContentTypes | foreach-object{$_.Delete()}