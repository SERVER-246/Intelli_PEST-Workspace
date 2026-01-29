# Intelli-PEST Batch Commit Script
# Commits changes across selected repositories
# Usage: .\commit-all.ps1 -Message "Your commit message" [-Backend] [-App] [-KD] [-All]

param(
    [Parameter(Mandatory=$true)]
    [string]$Message,
    [switch]$Backend,
    [switch]$App,
    [switch]$KD,
    [switch]$All
)

Write-Host ""
Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host "                    INTELLI-PEST BATCH COMMIT                          " -ForegroundColor Cyan
Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host ""

$repos = @()

if ($All) {
    $repos = @(
        @{ Name = "Backend"; Path = "D:\Intelli_PEST-Backend"; Tag = "[BE]" },
        @{ Name = "App"; Path = "D:\App\Intelli_PEST"; Tag = "[APP]" },
        @{ Name = "KnowledgeDistillation"; Path = "D:\KnowledgeDistillation"; Tag = "[KD]" }
    )
} else {
    if ($Backend) { $repos += @{ Name = "Backend"; Path = "D:\Intelli_PEST-Backend"; Tag = "[BE]" } }
    if ($App) { $repos += @{ Name = "App"; Path = "D:\App\Intelli_PEST"; Tag = "[APP]" } }
    if ($KD) { $repos += @{ Name = "KnowledgeDistillation"; Path = "D:\KnowledgeDistillation"; Tag = "[KD]" } }
}

if ($repos.Count -eq 0) {
    Write-Host "[!] No repositories selected. Use -Backend, -App, -KD, or -All" -ForegroundColor Yellow
    exit 1
}

Write-Host "Commit Message: $Message" -ForegroundColor White
Write-Host "Repositories:   $($repos.Name -join ', ')" -ForegroundColor White
Write-Host ""

$committed = @()
$skipped = @()

foreach ($repo in $repos) {
    Write-Host "$($repo.Tag) $($repo.Name)" -ForegroundColor Yellow
    
    if (-not (Test-Path "$($repo.Path)\.git")) {
        Write-Host "   [X] Not a git repository - skipping" -ForegroundColor Red
        $skipped += $repo.Name
        continue
    }
    
    Push-Location $repo.Path
    
    # Check for changes
    $status = git status --porcelain 2>$null
    if (-not $status) {
        Write-Host "   [SKIP] No changes to commit" -ForegroundColor Gray
        $skipped += $repo.Name
        Pop-Location
        continue
    }
    
    # Stage all changes
    git add -A 2>$null
    
    # Commit
    $result = git commit -m $Message 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   [OK] Committed successfully" -ForegroundColor Green
        $committed += $repo.Name
    } else {
        Write-Host "   [!] Commit failed: $result" -ForegroundColor Red
        $skipped += $repo.Name
    }
    
    Pop-Location
}

Write-Host ""
Write-Host "=======================================================================" -ForegroundColor Cyan
if ($committed.Count -gt 0) {
    Write-Host "Committed: $($committed -join ', ')" -ForegroundColor Green
}
if ($skipped.Count -gt 0) {
    Write-Host "Skipped:   $($skipped -join ', ')" -ForegroundColor Yellow
}

# Ask about parent repo update
Write-Host ""
Write-Host "[?] Update parent repo submodule references? (y/n): " -NoNewline -ForegroundColor Magenta
$response = Read-Host
if ($response -eq 'y' -or $response -eq 'Y') {
    Push-Location D:\
    git add Intelli_PEST-Backend App/Intelli_PEST KnowledgeDistillation 2>$null
    git commit -m "chore: Update submodule references - $Message" 2>$null
    Write-Host "   [OK] Parent repo updated" -ForegroundColor Green
    Pop-Location
}

Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host ""
