<#
	.SYNOPSIS
		Create-KLBaseContentType
	.DESCRIPTION
		It's meant to be used in conjunction with KnowledgeLake software.
		This script only does one thing:  creates the "KLBase" content type with its associated columns in the root site of the specified site collection.
	.EXAMPLE
		Create-KLBaseContentType
	.INPUTS
	.OUTPUTS
		None
	.NOTES
		This script was written by Eric Skaggs.
		This script could use refactoring and is not the coolest thing in the world, but it can save some time.
  		Use this script however you like.
  		Use this script at your own risk.
	.LINK
		http://www.twitter.com/skaggej
		http://www.sharepointnerd.com
#>

Param( 
		[string]$url = "$(Read-Host 'Enter the URL of the top-level site of a site collection')"
	)
begin {
}
process {
	try {
		$site = get-spsite $url 
		$web = $site.openweb() 
		$ctypeName = "KLBase"
		$ctypeGroup = "KnowledgeLake Content Types"
		$ctypeParent = $web.availablecontenttypes["Document"] 
		$ctype = new-object Microsoft.SharePoint.SPContentType($ctypeParent, $web.ContentTypes, $ctypeName)
		$ctype.Group = $ctypeGroup
		$web.contenttypes.add($ctype) 
		$web.fields.add("ScanUser", ([Type]"Microsoft.SharePoint.SPFieldType")::Text, $false) 
		$field = $web.fields.getfield("ScanUser")
		$field.Group = "KnowledgeLake Columns"
		$field.Update()
		$fieldLink = new-object Microsoft.SharePoint.SPFieldLink($field) 
		$ctype.fieldlinks.add($fieldLink) 
		$web.fields.add("ScanDate", ([Type]"Microsoft.SharePoint.SPFieldType")::DateTime, $false) 
		$field = $web.fields.getfield("ScanDate")
		$field.Group = "KnowledgeLake Columns"
		$field.Update()
		$fieldLink = new-object Microsoft.SharePoint.SPFieldLink($field) 
		$ctype.fieldlinks.add($fieldLink) 
		$web.fields.add("IndexUser", ([Type]"Microsoft.SharePoint.SPFieldType")::Text, $false)
		$field = $web.fields.getfield("IndexUser")
		$field.Group = "KnowledgeLake Columns"
		$field.Update()
		$fieldLink = new-object Microsoft.SharePoint.SPFieldLink($field) 
		$ctype.fieldlinks.add($fieldLink) 
		$web.fields.add("IndexDate", ([Type]"Microsoft.SharePoint.SPFieldType")::DateTime, $false)
		$field = $web.fields.getfield("IndexDate")
		$field.Group = "KnowledgeLake Columns"
		$field.Update()
		$fieldLink = new-object Microsoft.SharePoint.SPFieldLink($field) 
		$ctype.fieldlinks.add($fieldLink) 
		$web.fields.add("BatchName", ([Type]"Microsoft.SharePoint.SPFieldType")::Text, $false)
		$field = $web.fields.getfield("BatchName")
		$field.Group = "KnowledgeLake Columns"
		$field.Update()
		$fieldLink = new-object Microsoft.SharePoint.SPFieldLink($field) 
		$ctype.fieldlinks.add($fieldLink) 
		$web.fields.add("DocType", ([Type]"Microsoft.SharePoint.SPFieldType")::Text, $false)
		$field = $web.fields.getfield("DocType")
		$field.Group = "KnowledgeLake Columns"
		$field.Update()
		$fieldLink = new-object Microsoft.SharePoint.SPFieldLink($field) 
		$ctype.fieldlinks.add($fieldLink) 
		$web.fields.add("ScanStation", ([Type]"Microsoft.SharePoint.SPFieldType")::Text, $false)
		$field = $web.fields.getfield("ScanStation")
		$field.Group = "KnowledgeLake Columns"
		$field.Update()
		$fieldLink = new-object Microsoft.SharePoint.SPFieldLink($field) 
		$ctype.fieldlinks.add($fieldLink) 
		$web.fields.add("IndexStation", ([Type]"Microsoft.SharePoint.SPFieldType")::Text, $false)
		$field = $web.fields.getfield("IndexStation")
		$field.Group = "KnowledgeLake Columns"
		$field.Update()
		$fieldLink = new-object Microsoft.SharePoint.SPFieldLink($field) 
		$ctype.fieldlinks.add($fieldLink)
		$web.fields.add("PageCount", ([Type]"Microsoft.SharePoint.SPFieldType")::Number, $false)
		$field = $web.fields.getfield("PageCount")
		$field.Group = "KnowledgeLake Columns"
		$field.Update()
		$fieldLink = new-object Microsoft.SharePoint.SPFieldLink($field) 
		$ctype.fieldlinks.add($fieldLink)
		$ctype.Update()
		$web.Dispose() 
		$site.Dispose() 
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