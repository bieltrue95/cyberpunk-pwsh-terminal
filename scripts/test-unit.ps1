$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$testsPath = Join-Path $repoRoot 'tests'

if (-not (Get-Module -ListAvailable -Name Pester)) {
    throw 'Pester is required to run unit tests. Install with: Install-Module Pester -Scope CurrentUser -Force'
}

Import-Module Pester -ErrorAction Stop

if (Get-Command -Name New-PesterConfiguration -ErrorAction SilentlyContinue) {
    $config = New-PesterConfiguration
    $config.Run.Path = $testsPath
    $config.Output.Verbosity = 'Detailed'
    $config.TestResult.Enabled = $true
    $config.TestResult.OutputPath = (Join-Path $repoRoot 'TestResults.xml')
    $config.TestResult.OutputFormat = 'NUnitXml'

    $result = Invoke-Pester -Configuration $config
    if ($result.FailedCount -gt 0) {
        throw "Unit tests failed: $($result.FailedCount)"
    }

    Write-Host "UNIT_TESTS_OK ($($result.PassedCount) passed)" -ForegroundColor Green
    return
}

$result = Invoke-Pester -Script $testsPath -PassThru
if ($result.FailedCount -gt 0) {
    throw "Unit tests failed: $($result.FailedCount)"
}

Write-Host "UNIT_TESTS_OK ($($result.PassedCount) passed)" -ForegroundColor Green
