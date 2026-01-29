# 💾 Intelli-PEST Commit All Repos
# Commits changes to multiple repos with the same message
# Usage: .\commit-all.ps1 -Message "Your commit message" [-Backend] [-App] [-KD] [-All]

param(
    [Parameter(Mandatory=$true)]
    [string]$Message,
    
    [switch]$Backend,
    [switch]$App,
    [switch]$KD,
    [switch]$All
)

# Validate at least one repo is selected
if (-not ($Backend -or $App -or $KD -or $All)) {
    Write-Host ""
    Write-Host "❌ Error: You must specify at least one repository to commit to." -ForegroundColor Red
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  .\commit-all.ps1 -Message 'Your message' -All           # Commit to all repos"
    Write-Host "  .\commit-all.ps1 -Message 'Your message' -Backend       # Commit to Backend only"
    Write-Host "  .\commit-all.ps1 -Message 'Your message' -Backend -App  # Commit to Backend and App"
    Write-Host "  .\commit-all.ps1 -Message 'Your message' -KD            # Commit to KnowledgeDistillation"
    Write-Host ""
    exit 1
}

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "                    INTELLI-PEST COMMIT ALL                             " -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "📝 Message: $Message" -ForegroundColor White
Write-Host "🕐 Time:    $timestamp" -ForegroundColor Gray
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

$results = @()

foreach ($repo in $repos) {
    Write-Host "$($repo.Name)" -ForegroundColor Yellow
    
    Push-Location $repo.Path
    
    $status = git status --porcelain 2>$null
    
    if ($status) {
        git add -A
        git commit -m "$Message" 2>&1 | Out-Null
        $hash = git rev-parse --short HEAD 2>$null
        Write-Host "   ✅ Committed: $hash" -ForegroundColor Green
        $results += @{ Repo = $repo.Name; Status = "Committed"; Hash = $hash }
    } else {
        Write-Host "   ⏭️ No changes to commit" -ForegroundColor Gray
        $results += @{ Repo = $repo.Name; Status = "Skipped"; Hash = "-" }
    }
    
    Pop-Location
}

# Update parent to track new submodule commits
Write-Host ""
Write-Host "🏠 Parent (Workspace)" -ForegroundColor Yellow

Push-Location "D:\"

# Stage submodule changes and any parent changes
git add -A 2>$null
$parentStatus = git status --porcelain 2>$null

if ($parentStatus) {
    git commit -m "sync: $Message" 2>&1 | Out-Null
    $parentHash = git rev-parse --short HEAD 2>$null
    Write-Host "   ✅ Synced: $parentHash (tracks submodule versions)" -ForegroundColor Green
} else {
    Write-Host "   ⏭️ No sync needed" -ForegroundColor Gray
}

Pop-Location

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ✅ Commit complete! Use .\push-all.ps1 to push changes.              " -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
