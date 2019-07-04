param(
	[string] $projectName,
	[string] $classTemplatePath = 'D:\SourceCode\Naos\Naos.Build\Conventions\VisualStudio2017ProjectTemplates\ClassLibrary\csClassLibrary.vstemplate')

# Arrange
$solution = $DTE.Solution
$solutionDirectory = Split-Path $solution.FileName
$projectDirectory = Join-Path $solutionDirectory $projectName
$organizationPrefix = $projectName.Split('.')[0]

$packageIdBaseAssemblySharing = "OBeautifulCode.Type"
$packageIdAnalyzer = "$organizationPrefix.Build.Analyzers"
$packageIdBootstrapperDomain = "$organizationPrefix.Bootstrapper.Domain"
$packageIdBootstrapperFeature = "$organizationPrefix.Bootstrapper.Feature"
$packageIdBootstrapperTest = "$organizationPrefix.Bootstrapper.Test"
$packageIdBootstrapperSqlServer = "$organizationPrefix.Bootstrapper.SqlServer"

# Act
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
Write-Host "Creating $projectDirectory for $organizationPrefix."
$project = $solution.AddFromTemplate($classTemplatePath, $projectDirectory, $projectName, $false)

if ($projectName.Contains('.Bootstrapper.'))
{
    Write-Host "Skipping bootstrappers because $projectName is a bootstrapper."

	Write-Host "Installing anaylzer package: $packageIdAnalyzer."
	Install-Package -Id $packageIdAnalyzer -ProjectName $projectName

	Write-Host "Installing base assembly shared package: $packageIdBaseAssemblySharing."
	Install-Package -Id $packageIdBaseAssemblySharing -ProjectName $projectName
}
elseif ($projectName.EndsWith('.Domain') -or $projectName.Contains('.Feature.'))
{
	Write-Host "Installing the Domain bootstrapper: $packageIdBootstrapperDomain."
	Install-Package -Id $packageIdBootstrapperDomain -ProjectName $projectName
}
elseif ($projectName.EndsWith('.Test') -or $projectName.EndsWith('.Tests'))
{
	Write-Host "Installing the Test bootstrapper: $packageIdBootstrapperTest."
	Install-Package -Id "$organizationPrefix.Bootstrapper.Test" -ProjectName $projectName
}
else
{
	Write-Host "No known bootstrappers available for: $projectName."
}
$stopwatch.Stop()
Write-Host "-----======>>>>>FINISHED - Total time: $($stopwatch.Elapsed) to add $projectName."