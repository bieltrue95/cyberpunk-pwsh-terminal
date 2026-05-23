$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$profilePath = Join-Path $repoRoot 'profile\Microsoft.PowerShell_profile.ps1'

if (-not (Test-Path -LiteralPath $profilePath)) {
    throw "Profile not found: $profilePath"
}

. $profilePath

$rulesPath = Join-Path $repoRoot 'data\cyber-item-rules.psd1'
if (-not (Test-Path -LiteralPath $rulesPath)) {
    throw "Rule data not found: $rulesPath"
}

if (-not $global:CyberItemRules -or $global:CyberItemRules.ExtensionIcons.Count -lt 50) {
    throw 'Cyber item rules did not load correctly.'
}

$required = 'ls','dir','l','ll','hist','hfind','ccurl'
foreach ($name in $required) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
        throw "Command was not registered: $name"
    }
}

$tempBase = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
$tempRoot = [System.IO.Path]::GetFullPath((Join-Path $tempBase 'CyberpunkPwshTerminalTest'))
if (-not $tempRoot.StartsWith($tempBase, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Unsafe temp path: $tempRoot"
}

if (Test-Path -LiteralPath $tempRoot) {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null

$dirs = '.git','.github','.vscode','.aws','.azure','.docker','.kube','.terraform','node_modules','.venv','src','dist','Windows','Program Files','Documents','Downloads'
foreach ($dir in $dirs) {
    New-Item -ItemType Directory -Path (Join-Path $tempRoot $dir) -Force | Out-Null
}

$files = 'README.md','.env.local','Dockerfile','docker-compose.yml','package.json','app.tsx','server.py','Program.cs','terraform.tf','main.bicep','report.docx','sheet.xlsx','slides.pptx','manual.pdf','photo.webp','video.mkv','certificate.pem','archive.7z'
foreach ($file in $files) {
    New-Item -ItemType File -Path (Join-Path $tempRoot $file) -Force | Out-Null
}

Show-CyberChildItem $tempRoot
Remove-Item -LiteralPath $tempRoot -Recurse -Force
Write-Host 'PROFILE_TEST_OK' -ForegroundColor Green
