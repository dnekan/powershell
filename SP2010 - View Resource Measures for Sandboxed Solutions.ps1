$resourceMeasures = [Microsoft.SharePoint.Administration.SPUserCodeService]::Local.ResourceMeasures
$resourceMeasures | Select Name, ResourcesPerPoint
