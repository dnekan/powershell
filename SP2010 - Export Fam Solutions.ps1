$path = "C:\downloads\Exported Solution Packages"
(Get-SPFarm).Solutions | ForEach-Object{$var = $path + "\" + $_.Name; $_.SolutionFile.SaveAs($var)}