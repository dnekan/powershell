# Originally published at https://gist.github.com/nzthiago/5736907
# Customized by Vlad Catrinescu

[Environment]::CurrentDirectory=(Get-Location -PSProvider FileSystem).ProviderPath 
$rss = (new-object net.webclient)

# Grab the RSS feed for the MP4 downloads

# Ignite 2015 Videos and Slides
$a = ([xml]$rss.downloadstring("http://channel9.msdn.com/events/ignite/2015/rss/mp4high")) 
$b = ([xml]$rss.downloadstring("http://channel9.msdn.com/Events/ignite/2015/rss/slides")) 

#other qualities for the videos only. Choose the one you want!
# $a = ([xml]$rss.downloadstring("http://channel9.msdn.com/events/ignite/2015/rss/mp4")) 
#$a = ([xml]$rss.downloadstring("http://channel9.msdn.com/events/ignite/2015/rss/mp3")) 

#Preferably enter something not too long to not have filename problems! cut and paste them afterwards
$downloadlocation = "C:\Ignite"
if (-not (Test-Path $downloadlocation)) 
{ 
	Write-Host "Folder $fpath dosen't exist. Creating it..."  
	New-Item $downloadlocation -type directory 
}
set-location $downloadlocation

#Download all the slides	
try {
	$b.rss.channel.item | foreach {   
		$code = $_.comments.split("/") | select -last 1	   
		
		# Grab the URL for the PPTX file
		$urlpptx = New-Object System.Uri($_.enclosure.url)  
	    $filepptx = $code + "-" + $_.creator + " - " + $_.title.Replace(":", "-").Replace("?", "").Replace("/", "-").Replace("<", "").Replace("|", "").Replace('"',"").Replace("*","")
		$filepptx = $filepptx.substring(0, [System.Math]::Min(120, $filepptx.Length))
		$filepptx = $filepptx.trim()
		$filepptx = $filepptx + ".pptx" 
		if ($code -ne "")
		{
			 $folder = $code + " - " + $_.title.Replace(":", "-").Replace("?", "").Replace("/", "-").Replace("<", "").Replace("|", "").Replace('"',"").Replace("*","")
			 $folder = $folder.substring(0, [System.Math]::Min(100, $folder.Length))
			 $folder = $folder.trim()
		}
		else
		{
			$folder = "NoCodeSessions"
		}
		
		if (-not (Test-Path $folder)) 
		{ 
			Write-Host "Folder $folder dosen't exist. Creating it..."  
			New-Item $folder -type directory 
		}
		
		# Make sure the PowerPoint file doesn't already exist
		if (!(test-path "$downloadlocation\$folder\$filepptx"))     
		{ 	
			# Echo out the  file that's being downloaded
			$filepptx
			$wc = (New-Object System.Net.WebClient)  
	
			# Download the MP4 file
			$wc.DownloadFile($urlpptx, "$downloadlocation\$filepptx")
			mv $filepptx $folder
		}
	}
}
catch
{
Write-host "Slides are not yet up. Run this script every day to get the latest updates"
}

#download all the mp4

# Walk through each item in the feed 
$a.rss.channel.item | foreach {   
	$code = $_.comments.split("/") | select -last 1	   
	
	# Grab the URL for the MP4 file
	$url = New-Object System.Uri($_.enclosure.url)  
	
	# Create the local file name for the MP4 download
	$file = $code + "-" + $_.creator + "-" + $_.title.Replace(":", "-").Replace("?", "").Replace("/", "-").Replace("<", "").Replace("|", "").Replace('"',"").Replace("*","")
	$file = $file.substring(0, [System.Math]::Min(120, $file.Length))
	$file = $file.trim()
	$file = $file + ".mp4"  
	
	if ($code -ne "")
	{
		 $folder = $code + " - " + $_.title.Replace(":", "-").Replace("?", "").Replace("/", "-").Replace("<", "").Replace("|", "").Replace('"',"").Replace("*","")
		 $folder = $folder.substring(0, [System.Math]::Min(100, $folder.Length))
		 $folder = $folder.trim()
	}
	else
	{
		$folder = "NoCodeSessions"
	}
	
	if (-not (Test-Path $folder)) { 
		Write-Host "Folder $folder) dosen't exist. Creating it..."  
		New-Item $folder -type directory 
	}
	
	# Make sure the MP4 file doesn't already exist

	if (!(test-path "$folder\$file"))     
	{ 	
		# Echo out the  file that's being downloaded
		$file
		$wc = (New-Object System.Net.WebClient)  

		# Download the MP4 file
		$wc.DownloadFile($url, "$downloadlocation\$file")
		mv $file $folder
	}

	#text description from session
	$OutFile = New-Item -type file "$($downloadlocation)\$($Folder)\$($Code.trim()).txt" -Force  
    $Category = "" ; $Content = ""
    $_.category | foreach {$Category += $_ + ","}
    $Content = $_.title.trim() + "`r`n" + $_.creator + "`r`n" + $_.summary.trim() + "`r`n" + "`r`n" + $Category.Substring(0,$Category.Length -1)
  	 add-content $OutFile $Content	
}

set-location $home