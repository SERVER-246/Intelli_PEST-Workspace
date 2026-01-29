# 🔧 Intelli-PEST Environment Setup
# One-click development environment setup for new developers
# Usage: .\setup-environment.ps1

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "              INTELLI-PEST ENVIRONMENT SETUP                            " -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# =============================================================================
# Step 1: Check Git Installation
# =============================================================================
Write-Host "1️⃣ Checking Git installation..." -ForegroundColor Yellow

$gitVersion = git --version 2>$null
if ($gitVersion) {
    Write-Host "   ✅ $gitVersion" -ForegroundColor Green
} else {
    Write-Host "   ❌ Git not found. Please install Git first." -ForegroundColor Red
    exit 1
}

# =============================================================================
# Step 2: Initialize/Update Submodules
# =============================================================================
Write-Host "2️⃣ Initializing submodules..." -ForegroundColor Yellow

Push-Location "D:\"

if (Test-Path ".gitmodules") {
    git submodule update --init --recursive 2>&1 | Out-Null
    Write-Host "   ✅ Submodules initialized" -ForegroundColor Green
} else {
    Write-Host "   ⏭️ No .gitmodules file - skipping" -ForegroundColor Gray
}

Pop-Location

# =============================================================================
# Step 3: Check Python Installation
# =============================================================================
Write-Host "3️⃣ Checking Python installation..." -ForegroundColor Yellow

$pythonVersion = python --version 2>$null
if ($pythonVersion) {
    Write-Host "   ✅ $pythonVersion" -ForegroundColor Green
} else {
    Write-Host "   ❌ Python not found. Please install Python 3.10+." -ForegroundColor Red
    exit 1
}

# =============================================================================
# Step 4: Check/Create Virtual Environment
# =============================================================================
Write-Host "4️⃣ Checking virtual environment..." -ForegroundColor Yellow

$venvPath = "D:\Intelli_PEST-Backend\venv"
if (Test-Path $venvPath) {
    Write-Host "   ✅ Virtual environment exists" -ForegroundColor Green
} else {
    Write-Host "   📦 Creating virtual environment..." -ForegroundColor White
    Push-Location "D:\Intelli_PEST-Backend"
    python -m venv venv
    Pop-Location
    Write-Host "   ✅ Virtual environment created" -ForegroundColor Green
}

# =============================================================================
# Step 5: Check CUDA/GPU Availability
# =============================================================================
Write-Host "5️⃣ Checking GPU availability..." -ForegroundColor Yellow

try {
    Push-Location "D:\Intelli_PEST-Backend"
    & "$venvPath\Scripts\python.exe" -c "import torch; print(f'   ✅ PyTorch {torch.__version__}, CUDA: {torch.cuda.is_available()}, Device: {torch.cuda.get_device_name(0) if torch.cuda.is_available() else \"CPU\"}')"
    Pop-Location
} catch {
    Write-Host "   ⚠️ Could not check GPU (PyTorch may not be installed yet)" -ForegroundColor Yellow
}

# =============================================================================
# Step 6: Display Quick Start
# =============================================================================
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ✅ ENVIRONMENT SETUP COMPLETE                                         " -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Quick Start Commands:" -ForegroundColor White
Write-Host ""
Write-Host "  📊 Check status:     .\scripts\status-all.ps1" -ForegroundColor Gray
Write-Host "  🔍 Sync check:       .\scripts\sync-check.ps1" -ForegroundColor Gray
Write-Host "  💾 Commit all:       .\scripts\commit-all.ps1 -Message 'msg' -All" -ForegroundColor Gray
Write-Host "  🚀 Push all:         .\scripts\push-all.ps1" -ForegroundColor Gray
Write-Host ""
Write-Host "  ▶️ Start server:     cd Intelli_PEST-Backend; python run_server.py" -ForegroundColor Gray
Write-Host "  🧪 Run tests:        cd Intelli_PEST-Backend; python run_unit_tests.py" -ForegroundColor Gray
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
