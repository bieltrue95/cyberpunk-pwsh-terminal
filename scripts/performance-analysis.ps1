<#
    Performance analysis for Cyberpunk Terminal scripts.

    Measures execution time and memory usage of key scripts to identify
    bottlenecks and optimization opportunities.

    Usage:
        .\scripts\performance-analysis.ps1
#>

$ErrorActionPreference = 'Stop'

function Measure-Script {
    param(
        [string]$ScriptPath,
        [string]$Description,
        [hashtable]$Arguments = @{}
    )

    if (-not (Test-Path -LiteralPath $ScriptPath)) {
        Write-Host "⚠️  Script not found: $ScriptPath" -ForegroundColor Yellow
        return $null
    }

    Write-Host ""
    Write-Host "Testing: $Description" -ForegroundColor Cyan
    Write-Host "Path: $ScriptPath" -ForegroundColor Gray

    $measurements = @()

    # Run 3 times for average
    for ($i = 1; $i -le 3; $i++) {
        $watch = [System.Diagnostics.Stopwatch]::StartNew()
        $memBefore = [GC]::GetTotalMemory($true) / 1MB

        try {
            & pwsh -NoLogo -NoProfile -File $ScriptPath @Arguments -ErrorAction SilentlyContinue | Out-Null
            $exitCode = $LASTEXITCODE
        } catch {
            $exitCode = 1
        }

        $watch.Stop()
        $memAfter = [GC]::GetTotalMemory($true) / 1MB
        $memUsed = [Math]::Max(0, $memAfter - $memBefore)

        $measurements += @{
            Run = $i
            Time = $watch.ElapsedMilliseconds
            Memory = $memUsed
            ExitCode = $exitCode
        }

        Write-Host "  Run $i : ${$watch.ElapsedMilliseconds}ms | Memory: +${[Math]::Round($memUsed, 2)}MB" -ForegroundColor Gray
    }

    $avgTime = ($measurements | Measure-Object -Property Time -Average).Average
    $avgMem = ($measurements | Measure-Object -Property Memory -Average).Average

    Write-Host "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
    Write-Host "  Average: ${[Math]::Round($avgTime, 0)}ms | Memory: +${[Math]::Round($avgMem, 2)}MB" -ForegroundColor Green

    return @{
        Script = $Description
        Path = $ScriptPath
        AvgTime = $avgTime
        AvgMemory = $avgMem
        Measurements = $measurements
    }
}

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║   Cyberpunk Terminal - Performance Analysis       ║" -ForegroundColor Magenta
Write-Host "╚═══════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

$repoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$results = @()

# Test check-update.ps1
$results += Measure-Script -ScriptPath (Join-Path $repoRoot 'scripts\check-update.ps1') `
    -Description "check-update.ps1 (Silent mode)" `
    -Arguments @{Silent = $true}

# Test uninstall-checklist.ps1 display (no actual uninstall)
# Skip this as it requires interaction

# Test profile loading
Write-Host ""
Write-Host "Testing: Profile loading" -ForegroundColor Cyan
$profilePath = Join-Path $repoRoot 'profile\Microsoft.PowerShell_profile.ps1'
Write-Host "Path: $profilePath" -ForegroundColor Gray

$profileMeasurements = @()
for ($i = 1; $i -le 3; $i++) {
    $watch = [System.Diagnostics.Stopwatch]::StartNew()
    $memBefore = [GC]::GetTotalMemory($true) / 1MB

    & pwsh -NoLogo -NoProfile -File $profilePath 2>&1 | Out-Null
    $exitCode = $LASTEXITCODE

    $watch.Stop()
    $memAfter = [GC]::GetTotalMemory($true) / 1MB
    $memUsed = [Math]::Max(0, $memAfter - $memBefore)

    $profileMeasurements += @{
        Run = $i
        Time = $watch.ElapsedMilliseconds
        Memory = $memUsed
    }

    Write-Host "  Run $i : ${$watch.ElapsedMilliseconds}ms | Memory: +${[Math]::Round($memUsed, 2)}MB" -ForegroundColor Gray
}

$avgProfileTime = ($profileMeasurements | Measure-Object -Property Time -Average).Average
$avgProfileMem = ($profileMeasurements | Measure-Object -Property Memory -Average).Average

Write-Host "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "  Average: ${[Math]::Round($avgProfileTime, 0)}ms | Memory: +${[Math]::Round($avgProfileMem, 2)}MB" -ForegroundColor Green

$results += @{
    Script = "Profile loading"
    AvgTime = $avgProfileTime
    AvgMemory = $avgProfileMem
}

# Summary
Write-Host ""
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Magenta
Write-Host ""
Write-Host "📊 Performance Summary:" -ForegroundColor Yellow
Write-Host ""

$results | ForEach-Object {
    $time = [Math]::Round($_.AvgTime, 0)
    $mem = [Math]::Round($_.AvgMemory, 2)
    Write-Host "  • $($_.Script): ${time}ms | +${mem}MB" -ForegroundColor Cyan
}

Write-Host ""

# Baseline comparison
$checkUpdateTime = ($results | Where-Object { $_.Script -eq 'check-update.ps1 (Silent mode)' }).AvgTime
$profileTime = ($results | Where-Object { $_.Script -eq 'Profile loading' }).AvgTime

if ($checkUpdateTime -and $checkUpdateTime -gt 5000) {
    Write-Host "⚠️  check-update.ps1 is slow (${[Math]::Round($checkUpdateTime, 0)}ms)." -ForegroundColor Yellow
    Write-Host "   Recommendation: Consider caching results or async execution." -ForegroundColor Gray
}

if ($profileTime -and $profileTime -gt 2000) {
    Write-Host "⚠️  Profile loading is slow (${[Math]::Round($profileTime, 0)}ms)." -ForegroundColor Yellow
    Write-Host "   Recommendation: Profile should load in <1000ms for optimal UX." -ForegroundColor Gray
}

Write-Host ""
Write-Host "✅ Analysis complete." -ForegroundColor Green
Write-Host ""
