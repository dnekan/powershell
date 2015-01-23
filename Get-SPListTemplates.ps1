<#
	.SYNOPSIS
		Get-SPListTemplates
	.DESCRIPTION
		Get the list templates available within a specified web
	.EXAMPLE
		Get-SPListTemplates
	.INPUTS
	.OUTPUTS
		Names of list templates
	.NOTES
	.LINK
#> 
Param( 
		[string]$Web = "$(Read-Host 'Enter a web URL')"
	)
begin {
}
process {
	try {
		$PSSnapinSP = Get-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
		if ($PSSnapinSP -eq $Null) {
			Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction Stop
		}

		Start-SPAssignment -Global 
		$SPWeb = Get-SPWeb -Identity $Web 
		$Templates = $SPWeb.ListTemplates | Select Name | Sort Name
		Write-Host ""
		Write-Host "The following templates are available:" 
		$($Templates) 
		$SPWeb.Dispose() 
		Stop-SPAssignment -Global 
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