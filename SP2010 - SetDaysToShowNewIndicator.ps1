$webApp = Get-SPWebApplication http://sharepoint2010
$webApp.DaysToShowNewIndicator = "0"
$webApp.Update()