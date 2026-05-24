[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

function Write-Pass {
    param([string]$Message)
    Write-Host "[PASS] $Message" -ForegroundColor Green
}

function Write-Fail {
    param([string]$Message)
    Write-Host "[FAIL] $Message" -ForegroundColor Red
}

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$failed = $false

# Secret scanning with high-signal patterns only.
$secretPatterns = @(
    '(?i)-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----',
    '(?i)\bapi[_-]?key\b\s*[:=]\s*[''"][^''"]{8,}[''"]',
    '(?i)\btoken\b\s*[:=]\s*[''"][^''"]{8,}[''"]',
    '(?i)\bsecret\b\s*[:=]\s*[''"][^''"]{8,}[''"]',
    '\bghp_[A-Za-z0-9]{36}\b',
    '\bAIza[0-9A-Za-z\-_]{35}\b'
)

foreach ($pattern in $secretPatterns) {
    $args = @('--line-number', '--hidden', '--glob', '!.git/*', '--glob', '!*.svg', '--regexp', $pattern, '.')
    $result = & rg @args 2>$null
    if ($LASTEXITCODE -eq 0 -and $result) {
        Write-Fail "Potential secret pattern matched: $pattern"
        $result | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }
        $failed = $true
    }
}

if (-not $failed) {
    Write-Pass 'No high-signal secret patterns found.'
}

# Validate that binary assets are registered in ASSET_ATTRIBUTION.md.
$binaryExtensions = @(
    '.png', '.jpg', '.jpeg', '.gif', '.webp', '.bmp', '.ico',
    '.mp3', '.wav', '.flac', '.mp4', '.mkv', '.mov', '.ttf', '.otf', '.woff', '.woff2', '.zip', '.7z'
)

$trackedBinaryFiles = git ls-files | Where-Object {
    $ext = [System.IO.Path]::GetExtension($_).ToLowerInvariant()
    $binaryExtensions -contains $ext
}

$assetAttributionPath = Join-Path $repoRoot 'ASSET_ATTRIBUTION.md'
$assetAttribution = Get-Content -Raw $assetAttributionPath

foreach ($binaryFile in $trackedBinaryFiles) {
    if ($assetAttribution -notmatch [regex]::Escape($binaryFile)) {
        Write-Fail "Binary file missing in ASSET_ATTRIBUTION.md: $binaryFile"
        $failed = $true
    }
}

if ($trackedBinaryFiles.Count -eq 0) {
    Write-Pass 'No tracked binary media/font/archive files detected.'
} elseif (-not $failed) {
    Write-Pass 'All tracked binary assets are documented in ASSET_ATTRIBUTION.md.'
}

# Validate that SVG assets under screenshots are registered in ASSET_ATTRIBUTION.md.
$svgFiles = git ls-files screenshots/*.svg
foreach ($svgFile in $svgFiles) {
    if ($assetAttribution -notmatch [regex]::Escape($svgFile)) {
        Write-Fail "Screenshot SVG missing in ASSET_ATTRIBUTION.md: $svgFile"
        $failed = $true
    }
}

if (-not $failed) {
    Write-Pass 'Legal/compliance checks passed.'
} else {
    throw 'Legal/compliance checks failed.'
}
