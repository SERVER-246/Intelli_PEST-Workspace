# Intelli-PEST Push All Script
# Pushes all repositories to their remotes
# Usage: .\push-all.ps1

Write-Host ""
Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host "                    INTELLI-PEST PUSH ALL                              " -ForegroundColor Cyan
Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host ""

$repos = @(
    @{ Name = "Parent (Workspace)"; Path = "D:\"; Tag = "[ROOT]" },
    @{ Name = "Backend"; Path = "D:\Intelli_PEST-Backend"; Tag = "[BE]" },
    @{ Name = "App"; Path = "D:\App\Intelli_PEST"; Tag = "[APP]" },
    @{ Name = "KnowledgeDistillation"; Path = "D:\KnowledgeDistillation"; Tag = "[KD]" }
)

$pushed = @()
$failed = @()

foreach ($repo in $repos) {
    Write-Host "$($repo.Tag) $($repo.Name)" -ForegroundColor Yellow
    
    if (-not (Test-Path "$($repo.Path)\.git")) {
        Write-Host "   [X] Not a git repository" -ForegroundColor Red
        $failed += $repo.Name
        continue
    }
    
    Push-Location $repo.Path
    
    # Check if remote exists
    $remote = git remote 2>$null
    if (-not $remote) {
        Write-Host "   [!] No remote configured - skipping" -ForegroundColor Yellow
        $failed += $repo.Name
        Pop-Location
        continue
    }
    
    # Push
    Write-Host "   Pushing to origin..." -ForegroundColor Gray
    $result = git push 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   [OK] Pushed successfully" -ForegroundColor Green
        $pushed += $repo.Name
    } else {
        Write-Host "   [!] Push failed: $result" -ForegroundColor Red
        $failed += $repo.Name
    }
    
    Pop-Location
    Write-Host ""
}

Write-Host "=======================================================================" -ForegroundColor Cyan
if ($pushed.Count -gt 0) {
    Write-Host "Pushed:  $($pushed -join ', ')" -ForegroundColor Green
}
if ($failed.Count -gt 0) {
    Write-Host "Failed:  $($failed -join ', ')" -ForegroundColor Yellow
}
Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host ""
