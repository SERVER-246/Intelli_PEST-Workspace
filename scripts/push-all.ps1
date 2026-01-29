# 🚀 Intelli-PEST Push All Repos
# Pushes changes to GitHub for all or selected repos
# Usage: .\push-all.ps1 [-Backend] [-App] [-KD] [-Parent] [-All]

param(
    [switch]$Backend,
    [switch]$App,
    [switch]$KD,
    [switch]$Parent,
    [switch]$All
)

# Default to All if nothing specified
if (-not ($Backend -or $App -or $KD -or $Parent -or $All)) {
    $All = $true
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "                    INTELLI-PEST PUSH ALL                               " -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$repos = @()

if ($All -or $Backend) {
    $repos += @{ Name = "⚙️ Backend"; Path = "D:\Intelli_PEST-Backend" }
}
if ($All -or $App) {
    $repos += @{ Name = "📱 App"; Path = "D:\App\Intelli_PEST" }
}
if ($All -or $KD) {
    $repos += @{ Name = "🧠 KnowledgeDistillation"; Path = "D:\KnowledgeDistillation" }
}
if ($All -or $Parent) {
    $repos += @{ Name = "🏠 Parent (Workspace)"; Path = "D:\" }
}

foreach ($repo in $repos) {
    Write-Host "$($repo.Name)" -ForegroundColor Yellow
    
    Push-Location $repo.Path
    
    $remote = git remote 2>$null
    
    if (-not $remote) {
        Write-Host "   ⚠️ No remote configured - skipping" -ForegroundColor Yellow
        Pop-Location
        continue
    }
    
    # Check if there are commits to push
    $ahead = git rev-list --count "@{u}..HEAD" 2>$null
    
    if ($ahead -eq 0) {
        Write-Host "   ⏭️ Already up to date" -ForegroundColor Gray
        Pop-Location
        continue
    }
    
    Write-Host "   🚀 Pushing $ahead commit(s)..." -ForegroundColor White -NoNewline
    
    $pushResult = git push 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host " ✅" -ForegroundColor Green
    } else {
        Write-Host " ❌" -ForegroundColor Red
        Write-Host "   Error: $pushResult" -ForegroundColor Red
    }
    
    Pop-Location
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ✅ Push complete!                                                     " -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
