[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$Repository = 'bieltrue95/cyberpunk-pwsh-terminal',
    [string[]]$Branches = @('main', 'develop'),
    [string[]]$RequiredStatusChecks = @('validate'),
    [string]$Token = $env:GITHUB_TOKEN
)

$ErrorActionPreference = 'Stop'

if (-not $Token) {
    throw 'GitHub token not found. Set GITHUB_TOKEN with repo administration permission before running this script.'
}

if ($Repository -notmatch '^[^/]+/[^/]+$') {
    throw "Repository must use owner/name format. Received: $Repository"
}

$headers = @{
    Authorization          = "Bearer $Token"
    Accept                 = 'application/vnd.github+json'
    'X-GitHub-Api-Version' = '2022-11-28'
    'User-Agent'           = 'cyberpunk-pwsh-terminal-branch-protection'
}

$body = @{
    required_status_checks        = @{
        strict   = $true
        contexts = $RequiredStatusChecks
    }
    enforce_admins                = $true
    required_pull_request_reviews = @{
        dismiss_stale_reviews           = $true
        require_code_owner_reviews      = $true
        required_approving_review_count = 1
        require_last_push_approval      = $false
    }
    restrictions                   = $null
    required_linear_history        = $false
    allow_force_pushes             = $false
    allow_deletions                = $false
    required_conversation_resolution = $true
} | ConvertTo-Json -Depth 10

foreach ($branch in $Branches) {
    $encodedBranch = [System.Uri]::EscapeDataString($branch)
    $uri = "https://api.github.com/repos/$Repository/branches/$encodedBranch/protection"

    if ($PSCmdlet.ShouldProcess("$Repository/$branch", 'Apply branch protection')) {
        Invoke-RestMethod -Method Put -Uri $uri -Headers $headers -Body $body -ContentType 'application/json' | Out-Null
        Write-Host "Protected branch: $branch" -ForegroundColor Green
    }
}

Write-Host 'Branch protection configuration finished.' -ForegroundColor Green
