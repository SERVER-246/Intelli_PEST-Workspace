# Intelli-PEST Pull All Script
# Pulls all repositories and updates submodules
# Usage: .\pull-all.ps1

Write-Host ""
Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host "                    INTELLI-PEST PULL ALL                              " -ForegroundColor Cyan
Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host ""

# First, update parent and submodules
Write-Host "[ROOT] Parent (Workspace)" -ForegroundColor Yellow
Push-Location D:\

Write-Host "   Pulling parent repository..." -ForegroundColor Gray
git pull 2>$null

Write-Host "   Updating submodules..." -ForegroundColor Gray
git submodule update --init --recursive 2>$null

Write-Host "   [OK] Parent and submodules updated" -ForegroundColor Green
Pop-Location

Write-Host ""

# Then pull each submodule's latest from its remote
$submodules = @(
    @{ Name = "Backend"; Path = "D:\Intelli_PEST-Backend"; Tag = "[BE]" },
    @{ Name = "App"; Path = "D:\App\Intelli_PEST"; Tag = "[APP]" },
    @{ Name = "KnowledgeDistillation"; Path = "D:\KnowledgeDistillation"; Tag = "[KD]" }
)

foreach ($repo in $submodules) {
    Write-Host "$($repo.Tag) $($repo.Name)" -ForegroundColor Yellow
    
    Push-Location $repo.Path
    
    # Get current branch
    $branch = git rev-parse --abbrev-ref HEAD 2>$null
    Write-Host "   Branch: $branch" -ForegroundColor Magenta
    
    # Pull
    $result = git pull origin $branch 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   [OK] Pulled successfully" -ForegroundColor Green
    } else {
        Write-Host "   [!] Pull result: $result" -ForegroundColor Yellow
    }
    
    Pop-Location
    Write-Host ""
}

Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host "  All repositories are up to date                                      " -ForegroundColor Green
Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host ""
