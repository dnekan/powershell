$solutions = Get-ChildItem -Path "C:\downloads\Exported Solution Packages"
$solutions | ForEach-Object {add-spsolution -literalpath "C:\Exported Solution Packages\$_"}