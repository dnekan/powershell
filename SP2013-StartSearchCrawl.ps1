Add-PSSnapin Microsoft.SharePoint.Powershell -ErrorAction SilentlyContinue
 
#Get the search service application
$SSA = Get-SPEnterpriseSearchServiceApplication -Identity "Search Service Application"
 
#Get the Local SharePoint sites content source
$ContentSource = $SSA | Get-SPEnterpriseSearchCrawlContentSource -Identity "Local SharePoint sites"
 
  #Check if Crawler is not already running
  if($ContentSource.CrawlState -eq "Idle")
        {
            Write-Host "Starting Full Crawl..."           
            #$ContentSource.StartIncrementalCrawl()
            $ContentSource.StartFullCrawl();
            #$ContentSource.PauseCrawl()
            #$ContentSource.StopCrawl()
       }
  else
  {
   Write-Host "Another Crawl is already running!"
   Write-Host "NAME: ", $ContentSource.Name, " - ", $ContentSource.CrawlStatus
  }

#Read more: http://www.sharepointdiary.com/2014/01/start-sharepoint-search-crawl-using-powershell.html#ixzz42uKg95pD
