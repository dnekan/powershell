<#
	.SYNOPSIS
		Export-SPSolutionPackages
	.DESCRIPTION
		Copies all solution packages (.wsp files) from the SharePoint farm's solution store to a specified directory.
	    This is very useful when making significant changes to your SharePoint farm and can be viewed as an unofficial solution package backup.
		To this point, do NOT consider this an official and safe way to backup your solution packages.
   		I've found this useful when replicating a production farm to a dev farm:  export the solution packages from production and deploy them to dev so that dev matches production as closely as possible.
	.EXAMPLE
		Export-SPSolutionPackages
	.INPUTS
		The directory to which you wish to save a copy of each solution package.
	.OUTPUTS
		One copy of each of the available solution packages in the SharePoint farm solution store.  This includes those that are not deployed.
	.NOTES
		This script was adapted from http://sharepintblog.com/2011/06/04/exporting-solutions-packages-wsp-with-powershell/ by Eric Skaggs.
	.LINK
		http://sharepintblog.com/2011/06/04/exporting-solutions-packages-wsp-with-powershell/
		http://www.twitter.com/skaggej
		http://www.sharepointnerd.com
#> 

Param( 
		[string]$outputDirectory = "$(Read-Host 'Enter the export path')"
	)
begin {
}
process {
	try {
		$PSSnapinSP = Get-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
		if ($PSSnapinSP -eq $Null) {
			Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction Stop
		}

		Write-Host Exporting solutions to $outputDirectory 
		foreach ($solution in Get-SPSolution) 
		{ 
			$id = $Solution.SolutionID 
			$title = $Solution.Name 
			$filename = $Solution.SolutionFile.Name
		
			Write-Host "Exporting ‘$title’ to …\$filename" -nonewline 
			$solution.SolutionFile.SaveAs("$outputDirectory\$filename") 
			Write-Host " – done" -foreground green 
		} 
	}
	catch [Exception] {
		Write-Error $Error[0]
		$err = $_.Exception
		while ( $err.InnerException ) {
			$err = $err.InnerException
			Write-Output $err.Message
		}
	}
}