# 📥 Intelli-PEST Pull All Repos
# Pulls latest changes from all remotes
# Usage: .\pull-all.ps1

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "                    INTELLI-PEST PULL ALL                               " -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$repos = @(
    @{ Name = "⚙️ Backend"; Path = "D:\Intelli_PEST-Backend" },
    @{ Name = "📱 App"; Path = "D:\App\Intelli_PEST" },
    @{ Name = "🧠 KnowledgeDistillation"; Path = "D:\KnowledgeDistillation" },
    @{ Name = "🏠 Parent (Workspace)"; Path = "D:\" }
)

foreach ($repo in $repos) {
    Write-Host "$($repo.Name)" -ForegroundColor Yellow
    
    if (-not (Test-Path "$($repo.Path)\.git")) {
        Write-Host "   ❌ Not a git repository" -ForegroundColor Red
        continue
    }
    
    Push-Location $repo.Path
    
    $remote = git remote 2>$null
    
    if (-not $remote) {
        Write-Host "   ⚠️ No remote configured - skipping" -ForegroundColor Yellow
        Pop-Location
        continue
    }
    
    # Check if there are commits to pull
    git fetch --quiet 2>$null
    $behind = git rev-list --count "HEAD..@{u}" 2>$null
    
    if ($behind -eq 0) {
        Write-Host "   ✅ Already up to date" -ForegroundColor Green
        Pop-Location
        continue
    }
    
    Write-Host "   📥 Pulling $behind commit(s)..." -ForegroundColor White -NoNewline
    
    $pullResult = git pull --rebase 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host " ✅" -ForegroundColor Green
    } else {
        Write-Host " ⚠️" -ForegroundColor Yellow
        Write-Host "   Warning: $pullResult" -ForegroundColor Yellow
    }
    
    Pop-Location
}

# Update submodules in parent
Write-Host ""
Write-Host "🔄 Updating submodule references..." -ForegroundColor Yellow
Push-Location "D:\"
git submodule update --remote 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ Submodules updated" -ForegroundColor Green
}
Pop-Location

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ✅ Pull complete!                                                     " -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
