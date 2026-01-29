# 📊 Intelli-PEST Workspace Status
# Shows git status of all repositories at a glance
# Usage: .\status-all.ps1

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "                    INTELLI-PEST WORKSPACE STATUS                       " -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$repos = @(
    @{ Name = "🏠 Parent (Workspace)"; Path = "D:\"; Emoji = "🏠" },
    @{ Name = "⚙️ Backend"; Path = "D:\Intelli_PEST-Backend"; Emoji = "⚙️" },
    @{ Name = "📱 App"; Path = "D:\App\Intelli_PEST"; Emoji = "📱" },
    @{ Name = "🧠 KnowledgeDistillation"; Path = "D:\KnowledgeDistillation"; Emoji = "🧠" }
)

foreach ($repo in $repos) {
    Write-Host "$($repo.Emoji) $($repo.Name)" -ForegroundColor Yellow
    
    if (-not (Test-Path "$($repo.Path)\.git")) {
        Write-Host "   ❌ Not a git repository" -ForegroundColor Red
        Write-Host ""
        continue
    }
    
    Push-Location $repo.Path
    
    # Get branch
    $branch = git rev-parse --abbrev-ref HEAD 2>$null
    Write-Host "   Branch: " -NoNewline -ForegroundColor White
    Write-Host "$branch" -ForegroundColor Magenta
    
    # Get current commit
    $hash = git rev-parse --short HEAD 2>$null
    Write-Host "   Commit: " -NoNewline -ForegroundColor White
    Write-Host "$hash" -ForegroundColor Gray
    
    # Check for changes
    $status = git status --porcelain 2>$null
    if ($status) {
        $staged = ($status | Where-Object { $_ -match "^[MADRC]" }).Count
        $unstaged = ($status | Where-Object { $_ -match "^.[MADRC\?]" }).Count
        Write-Host "   Changes: " -NoNewline -ForegroundColor White
        if ($staged -gt 0) {
            Write-Host "$staged staged " -NoNewline -ForegroundColor Green
        }
        if ($unstaged -gt 0) {
            Write-Host "$unstaged unstaged" -ForegroundColor Red -NoNewline
        }
        Write-Host ""
    } else {
        Write-Host "   Changes: " -NoNewline -ForegroundColor White
        Write-Host "Clean ✅" -ForegroundColor Green
    }
    
    # Check remote status
    $remote = git remote 2>$null
    if ($remote) {
        git fetch --quiet 2>$null
        $ahead = git rev-list --count "@{u}..HEAD" 2>$null
        $behind = git rev-list --count "HEAD..@{u}" 2>$null
        
        if ($ahead -gt 0) {
            Write-Host "   Ahead:  " -NoNewline -ForegroundColor White
            Write-Host "$ahead commits to push ⬆️" -ForegroundColor Magenta
        }
        if ($behind -gt 0) {
            Write-Host "   Behind: " -NoNewline -ForegroundColor White
            Write-Host "$behind commits to pull ⬇️" -ForegroundColor Yellow
        }
    } else {
        Write-Host "   Remote: " -NoNewline -ForegroundColor White
        Write-Host "No remote configured ⚠️" -ForegroundColor Yellow
    }
    
    Pop-Location
    Write-Host ""
}

Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Tip: Use .\commit-all.ps1 -Message 'msg' -All to commit all repos    " -ForegroundColor Gray
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
