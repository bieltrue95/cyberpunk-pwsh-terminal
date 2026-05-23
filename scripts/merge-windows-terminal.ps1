[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$SettingsPath,
    [string]$SnippetPath
)

$ErrorActionPreference = 'Stop'

function Find-WindowsTerminalSettings {
    $candidates = @(
        (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'),
        (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json')
    )

    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate) { return $candidate }
    }

    return $null
}

function Ensure-JsonProperty {
    param(
        [Parameter(Mandatory)]$Object,
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)]$Value
    )

    if (-not $Object.PSObject.Properties[$Name]) {
        $Object | Add-Member -MemberType NoteProperty -Name $Name -Value $Value
    }
}

$repoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
if (-not $SnippetPath) { $SnippetPath = Join-Path $repoRoot 'terminal\windows-terminal-snippet.json' }
if (-not $SettingsPath) { $SettingsPath = Find-WindowsTerminalSettings }

if (-not $SettingsPath) { throw 'Windows Terminal settings.json was not found. Pass -SettingsPath explicitly.' }
if (-not (Test-Path -LiteralPath $SettingsPath)) { throw "Settings file not found: $SettingsPath" }
if (-not (Test-Path -LiteralPath $SnippetPath)) { throw "Snippet file not found: $SnippetPath" }

$settingsRaw = Get-Content -LiteralPath $SettingsPath -Raw
$snippetRaw = Get-Content -LiteralPath $SnippetPath -Raw
$settings = $settingsRaw | ConvertFrom-Json
$snippet = $snippetRaw | ConvertFrom-Json

$incomingProfile = @($snippet.profiles.list)[0]
$incomingScheme = @($snippet.schemes)[0]
if (-not $incomingProfile) { throw 'Snippet does not contain profiles.list[0].' }
if (-not $incomingScheme) { throw 'Snippet does not contain schemes[0].' }

Ensure-JsonProperty -Object $settings -Name 'profiles' -Value ([pscustomobject]@{})
Ensure-JsonProperty -Object $settings.profiles -Name 'list' -Value @()
Ensure-JsonProperty -Object $settings -Name 'schemes' -Value @()

$currentProfiles = @($settings.profiles.list) | Where-Object {
    $_.guid -ne $incomingProfile.guid -and $_.name -ne $incomingProfile.name
}
$settings.profiles.list = @(@($currentProfiles) + @($incomingProfile))

$currentSchemes = @($settings.schemes) | Where-Object { $_.name -ne $incomingScheme.name }
$settings.schemes = @(@($currentSchemes) + @($incomingScheme))

$updatedJson = $settings | ConvertTo-Json -Depth 100
$null = $updatedJson | ConvertFrom-Json

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backup = "$SettingsPath.bak-$stamp"
Copy-Item -LiteralPath $SettingsPath -Destination $backup -Force

if ($PSCmdlet.ShouldProcess($SettingsPath, 'Merge Cyberpunk profile and color scheme')) {
    Set-Content -LiteralPath $SettingsPath -Value $updatedJson -Encoding UTF8
}

Write-Host "Windows Terminal settings updated." -ForegroundColor Cyan
Write-Host "Backup: $backup"
Write-Host "Profile merged: $($incomingProfile.name)"
Write-Host "Scheme merged:  $($incomingScheme.name)"
