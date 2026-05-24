$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$profilePath = Join-Path $repoRoot 'profile\Microsoft.PowerShell_profile.ps1'

Describe 'Cyberpunk rule engine' {
    BeforeAll {
        . $profilePath

        $script:originalRules = $global:CyberItemRules
        $script:testRoot = Join-Path ([System.IO.Path]::GetTempPath()) "CyberpunkPwshRules-$([guid]::NewGuid().ToString('N'))"
        New-Item -Path $script:testRoot -ItemType Directory -Force | Out-Null
    }

    AfterAll {
        $global:CyberItemRules = $script:originalRules
        if (Test-Path -LiteralPath $script:testRoot) {
            Remove-Item -LiteralPath $script:testRoot -Recurse -Force
        }
    }

    Context 'Find-CyberExtensionValue' {
        It 'matches extensions case-insensitively' {
            $map = @{
                '.ps1' = 'ICON_PS1'
            }

            Find-CyberExtensionValue -Map $map -Extension '.PS1' | Should Be 'ICON_PS1'
        }
    }

    Context 'Get-CyberItemIcon precedence' {
        BeforeEach {
            $global:CyberItemRules = @{
                Defaults = @{
                    LinkIcon      = 'ICON_LINK'
                    DirectoryIcon = 'ICON_DIR_DEFAULT'
                    FileIcon      = 'ICON_FILE_DEFAULT'
                }
                DirectoryIconRules = @(
                    @{ Pattern = '^src$'; Icon = 'ICON_DIR_RULE' }
                )
                FileIconRules = @(
                    @{ Pattern = '^README'; Icon = 'ICON_FILE_RULE' }
                )
                ExtensionIcons = @{
                    '.md' = 'ICON_MD'
                    '.ps1' = 'ICON_PS1'
                }
                DirectoryColorRules = @()
                FileColorRules = @()
                ExtensionColors = @{}
            }
        }

        It 'uses directory regex before directory default' {
            $item = New-Item -Path (Join-Path $script:testRoot 'src') -ItemType Directory -Force
            Get-CyberItemIcon -Item $item | Should Be 'ICON_DIR_RULE'
        }

        It 'uses file regex before extension mapping' {
            $item = New-Item -Path (Join-Path $script:testRoot 'README.md') -ItemType File -Force
            Get-CyberItemIcon -Item $item | Should Be 'ICON_FILE_RULE'
        }

        It 'uses extension mapping before file default' {
            $item = New-Item -Path (Join-Path $script:testRoot 'script.ps1') -ItemType File -Force
            Get-CyberItemIcon -Item $item | Should Be 'ICON_PS1'
        }

        It 'falls back to file default when no rule matches' {
            $item = New-Item -Path (Join-Path $script:testRoot 'random.unknown') -ItemType File -Force
            Get-CyberItemIcon -Item $item | Should Be 'ICON_FILE_DEFAULT'
        }

        It 'uses link icon before any other icon rule' {
            $target = New-Item -Path (Join-Path $script:testRoot 'target.ps1') -ItemType File -Force
            $linkPath = Join-Path $script:testRoot 'target-link.ps1'
            try {
                New-Item -Path $linkPath -ItemType SymbolicLink -Value $target.FullName -Force | Out-Null
            } catch {
                Write-Warning 'Skipping link precedence test: symbolic links are not permitted in this environment.'
                return
            }
            $item = Get-Item -LiteralPath $linkPath
            Get-CyberItemIcon -Item $item | Should Be 'ICON_LINK'
        }
    }

    Context 'Get-CyberItemColor precedence' {
        BeforeEach {
            $global:CyberItemRules = @{
                Defaults = @{
                    DirectoryColor = '#111111'
                    FileColor      = '#222222'
                }
                DirectoryIconRules = @()
                FileIconRules = @()
                ExtensionIcons = @{}
                DirectoryColorRules = @(
                    @{ Pattern = '^bin$'; Color = '#123456' }
                )
                FileColorRules = @(
                    @{ Pattern = '^Dockerfile$'; Color = '#654321' }
                )
                ExtensionColors = @{
                    '.json' = '#abcdef'
                }
            }
        }

        It 'uses directory color regex before directory default' {
            $item = New-Item -Path (Join-Path $script:testRoot 'bin') -ItemType Directory -Force
            Get-CyberItemColor -Item $item | Should Be '#123456'
        }

        It 'uses file color regex before extension mapping' {
            $item = New-Item -Path (Join-Path $script:testRoot 'Dockerfile') -ItemType File -Force
            Get-CyberItemColor -Item $item | Should Be '#654321'
        }

        It 'uses extension color before file default' {
            $item = New-Item -Path (Join-Path $script:testRoot 'data.json') -ItemType File -Force
            Get-CyberItemColor -Item $item | Should Be '#abcdef'
        }

        It 'falls back to file default when no color rule matches' {
            $item = New-Item -Path (Join-Path $script:testRoot 'notes.txt') -ItemType File -Force
            Get-CyberItemColor -Item $item | Should Be '#222222'
        }
    }

    Context 'Fallback safety for missing or partial data' {
        It 'returns fallback defaults when Defaults map is missing keys' {
            $global:CyberItemRules = @{
                Defaults = @{}
                DirectoryIconRules = @()
                FileIconRules = @()
                ExtensionIcons = @{}
                DirectoryColorRules = @()
                FileColorRules = @()
                ExtensionColors = @{}
            }

            $file = New-Item -Path (Join-Path $script:testRoot 'fallback.bin') -ItemType File -Force
            $dir = New-Item -Path (Join-Path $script:testRoot 'fallback-dir') -ItemType Directory -Force

            Get-CyberItemIcon -Item $file | Should Be ''
            Get-CyberItemIcon -Item $dir | Should Be ''
            Get-CyberItemColor -Item $file | Should Be '#E6ECFF'
            Get-CyberItemColor -Item $dir | Should Be '#00E5FF'
        }

        It 'find helpers do not throw on null maps or rules' {
            { Find-CyberExtensionValue -Map $null -Extension '.ps1' } | Should Not Throw
            { Find-CyberRuleValue -Rules $null -ItemName 'README.md' -ValueKey 'Icon' } | Should Not Throw

            (Find-CyberExtensionValue -Map $null -Extension '.ps1') | Should Be $null
            (Find-CyberRuleValue -Rules $null -ItemName 'README.md' -ValueKey 'Icon') | Should Be $null
        }
    }
}
