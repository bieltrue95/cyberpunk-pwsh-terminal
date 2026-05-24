$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$testsPath = Join-Path $repoRoot 'tests'

$pesterV5 = Get-Module -ListAvailable -Name Pester | Where-Object { $_.Version -ge [version]'5.0.0' } | Select-Object -First 1
if (-not $pesterV5) {
    Install-Module Pester -Scope CurrentUser -Force -SkipPublisherCheck
}

Import-Module Pester -MinimumVersion 5.0.0 -Force -ErrorAction Stop

if (Get-Command -Name New-PesterConfiguration -ErrorAction SilentlyContinue) {
    $config = New-PesterConfiguration
    $config.Run.Path = $testsPath
    $config.Run.PassThru = $true
    $config.Output.Verbosity = 'Detailed'
    $config.TestResult.Enabled = $true
    $config.TestResult.OutputPath = (Join-Path $repoRoot 'TestResults.xml')
    $config.TestResult.OutputFormat = 'NUnitXml'

    $result = Invoke-Pester -Configuration $config
    if (-not $result) {
        throw 'Unit tests failed: Invoke-Pester did not return a result object.'
    }
    if (($result.FailedCount -gt 0) -or ($result.FailedBlocksCount -gt 0)) {
        throw "Unit tests failed: failed tests=$($result.FailedCount), failed blocks=$($result.FailedBlocksCount)"
    }

    Write-Host "UNIT_TESTS_OK ($($result.PassedCount) passed)" -ForegroundColor Green
    return
}

$result = Invoke-Pester -Script $testsPath -PassThru
if ($result.FailedCount -gt 0) {
    throw "Unit tests failed: $($result.FailedCount)"
}

Write-Host "UNIT_TESTS_OK ($($result.PassedCount) passed)" -ForegroundColor Green
