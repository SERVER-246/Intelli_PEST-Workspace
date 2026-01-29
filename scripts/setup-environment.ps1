# Intelli-PEST Development Environment Setup
# One-click setup for new developers
# Usage: .\setup-environment.ps1

Write-Host ""
Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host "               INTELLI-PEST ENVIRONMENT SETUP                          " -ForegroundColor Cyan
Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Python
Write-Host "[1/6] Checking Python installation..." -ForegroundColor Yellow
$python = Get-Command python -ErrorAction SilentlyContinue
if ($python) {
    $version = python --version 2>&1
    Write-Host "   [OK] $version" -ForegroundColor Green
} else {
    Write-Host "   [X] Python not found! Please install Python 3.9+" -ForegroundColor Red
    exit 1
}

# Step 2: Check Git
Write-Host ""
Write-Host "[2/6] Checking Git installation..." -ForegroundColor Yellow
$git = Get-Command git -ErrorAction SilentlyContinue
if ($git) {
    $version = git --version 2>&1
    Write-Host "   [OK] $version" -ForegroundColor Green
} else {
    Write-Host "   [X] Git not found! Please install Git" -ForegroundColor Red
    exit 1
}

# Step 3: Initialize submodules
Write-Host ""
Write-Host "[3/6] Initializing git submodules..." -ForegroundColor Yellow
Push-Location D:\
git submodule update --init --recursive 2>$null
Write-Host "   [OK] Submodules initialized" -ForegroundColor Green
Pop-Location

# Step 4: Create virtual environments
Write-Host ""
Write-Host "[4/6] Setting up virtual environments..." -ForegroundColor Yellow

# Backend venv
$backendVenv = "D:\Intelli_PEST-Backend\venv"
if (-not (Test-Path $backendVenv)) {
    Write-Host "   Creating Backend venv..." -ForegroundColor Gray
    Push-Location D:\Intelli_PEST-Backend
    python -m venv venv 2>$null
    Pop-Location
    Write-Host "   [OK] Backend venv created" -ForegroundColor Green
} else {
    Write-Host "   [OK] Backend venv already exists" -ForegroundColor Green
}

# KD venv  
$kdVenv = "D:\KnowledgeDistillation\venv"
if (-not (Test-Path $kdVenv)) {
    Write-Host "   Creating KnowledgeDistillation venv..." -ForegroundColor Gray
    Push-Location D:\KnowledgeDistillation
    python -m venv venv 2>$null
    Pop-Location
    Write-Host "   [OK] KnowledgeDistillation venv created" -ForegroundColor Green
} else {
    Write-Host "   [OK] KnowledgeDistillation venv already exists" -ForegroundColor Green
}

# Step 5: Install dependencies
Write-Host ""
Write-Host "[5/6] Installing Python dependencies..." -ForegroundColor Yellow

# Backend dependencies
if (Test-Path "D:\Intelli_PEST-Backend\requirements.txt") {
    Write-Host "   Installing Backend dependencies..." -ForegroundColor Gray
    & "$backendVenv\Scripts\pip.exe" install -r "D:\Intelli_PEST-Backend\requirements.txt" -q 2>$null
    Write-Host "   [OK] Backend dependencies installed" -ForegroundColor Green
}

# KD dependencies
if (Test-Path "D:\KnowledgeDistillation\requirements.txt") {
    Write-Host "   Installing KnowledgeDistillation dependencies..." -ForegroundColor Gray
    & "$kdVenv\Scripts\pip.exe" install -r "D:\KnowledgeDistillation\requirements.txt" -q 2>$null
    Write-Host "   [OK] KnowledgeDistillation dependencies installed" -ForegroundColor Green
}

# Step 6: Verify setup
Write-Host ""
Write-Host "[6/6] Verifying setup..." -ForegroundColor Yellow

$checks = @(
    @{ Name = "Backend repo"; Path = "D:\Intelli_PEST-Backend\.git" },
    @{ Name = "App repo"; Path = "D:\App\Intelli_PEST\.git" },
    @{ Name = "KD repo"; Path = "D:\KnowledgeDistillation\.git" },
    @{ Name = "Backend venv"; Path = $backendVenv },
    @{ Name = "KD venv"; Path = $kdVenv }
)

$allOk = $true
foreach ($check in $checks) {
    if (Test-Path $check.Path) {
        Write-Host "   [OK] $($check.Name)" -ForegroundColor Green
    } else {
        Write-Host "   [X] $($check.Name) not found" -ForegroundColor Red
        $allOk = $false
    }
}

Write-Host ""
Write-Host "=======================================================================" -ForegroundColor Cyan
if ($allOk) {
    Write-Host "  [OK] Environment setup complete!                                    " -ForegroundColor Green
    Write-Host ""
    Write-Host "  Next steps:" -ForegroundColor White
    Write-Host "    1. Open intellipest.code-workspace in VS Code" -ForegroundColor Gray
    Write-Host "    2. Run .\scripts\status-all.ps1 to check repo status" -ForegroundColor Gray
    Write-Host "    3. Run .\scripts\sync-check.ps1 to verify pipeline" -ForegroundColor Gray
} else {
    Write-Host "  [!] Setup completed with warnings - check errors above             " -ForegroundColor Yellow
}
Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host ""
