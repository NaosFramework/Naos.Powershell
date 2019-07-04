param(
	[string] $projectName)

# Arrange
$solution = $DTE.Solution
$solutionDirectory = Split-Path $solution.FileName
$projectDirectory = Join-Path $solutionDirectory $projectName
$packagesConfigFile = Join-Path $projectDirectory 'packages.config'
[xml] $packagesConfigXml = Get-Content $packagesConfigFile
$packagesConfigXml.packages.package | % {
	Write-Host "<dependency id=`"$($_.Id)`" version=`"$($_.Version)`" />"
}