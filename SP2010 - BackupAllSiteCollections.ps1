Write-Host "Starting Backup of All Site Collections"
Add-PSSnapIn Microsoft.SharePoint.PowerShell

New-EventLog -LogName "Application" -Source "SharePoint Backup Site Collection Script" -ErrorAction SilentlyContinue | Out-Null

try 
{
  $todaysDate = get-date -Format yyyy-MM-dd
  $newFolder = new-item \\UNCPATH\$todaysDate -type directory
  $webApps = Get-SPWebApplication  #Get all web applications (excluding Central Administration)
  $siteCollections = $webApps | ForEach-Object {$_.Sites}  #Get all site collections
  $siteCollections | ForEach-Object   {
  $trimmedUrl = $_.Url.SubString(7,$_.Url.Length-7)
  $fileName = $trimmedUrl.Replace('/','.')
  Backup-SPSite -Identity $_.Id -Path \\UNCPATH\$todaysDate\$fileName.bak -force
  $s = "$([DateTime]::Now.ToString('yyyy.dd.MM HH:mm:ss')) : SUCCESS : ""$($trimmedUrl)"""
  $logFile=((Split-Path ($MyInvocation.MyCommand.Path))+"\lastrunlog.txt")
  if( Test-Path $logFile -PathType Leaf )
  {
    $c = Get-Content $logFile
    $cl = $c -split '`n'
    $s = ((@($s) + $cl) | select -First 200)
  }
  Out-File -InputObject ($s -join "`r`n") -FilePath $logFile}
}
catch 
{
  Write-EventLog -Source "SharePoint Backup Site Collection Script"  -Category 0 -ComputerName "." -EntryType Error -LogName "Application" -Message "SharePoint site collection backup failed." -EventId 54321
  $s = "$([DateTime]::Now.ToString('yyyy.dd.MM HH:mm:ss')) : FAILURE : $($_.Exception.Message)"	
  $filename=((Split-Path ($MyInvocation.MyCommand.Path))+"\lastrunlog.txt")
  if( Test-Path $filename -PathType Leaf ) 
  {
    $c = Get-Content $filename
    $cl = $c -split '`n'
    $s = ((@($s) + $cl) | select -First 200)
  }
  Out-File -InputObject ($s -join "`r`n") -FilePath $filename
}