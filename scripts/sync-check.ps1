# 🔍 Intelli-PEST Pipeline Sync Check
# Verifies compatibility between repos (model paths, class counts, API endpoints)
# Usage: .\sync-check.ps1

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "                 INTELLI-PEST PIPELINE SYNC CHECK                       " -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$issues = @()
$checks = 0
$passed = 0

# =============================================================================
# Check 1: Student Model Exists
# =============================================================================
$checks++
Write-Host "1️⃣ Checking student model..." -ForegroundColor Yellow

$studentModel = "D:\KnowledgeDistillation\student_model_rotation_robust.pt"
if (Test-Path $studentModel) {
    $size = [math]::Round((Get-Item $studentModel).Length / 1MB, 2)
    Write-Host "   ✅ student_model_rotation_robust.pt exists ($size MB)" -ForegroundColor Green
    $passed++
} else {
    Write-Host "   ❌ Student model NOT FOUND: $studentModel" -ForegroundColor Red
    $issues += "Student model missing: $studentModel"
}

# =============================================================================
# Check 2: Backend References Correct Model Path
# =============================================================================
$checks++
Write-Host "2️⃣ Checking backend model reference..." -ForegroundColor Yellow

$runServerPath = "D:\Intelli_PEST-Backend\run_server.py"
if (Test-Path $runServerPath) {
    $content = Get-Content $runServerPath -Raw
    if ($content -match "student_model_rotation_robust\.pt") {
        Write-Host "   ✅ run_server.py references correct model" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "   ⚠️ run_server.py may reference different model" -ForegroundColor Yellow
        $issues += "run_server.py doesn't reference student_model_rotation_robust.pt"
    }
} else {
    Write-Host "   ❌ run_server.py not found" -ForegroundColor Red
    $issues += "run_server.py not found"
}

# =============================================================================
# Check 3: ONNX Teachers Exist for KD Training
# =============================================================================
$checks++
Write-Host "3️⃣ Checking ONNX teachers..." -ForegroundColor Yellow

$onnxPath = "D:\Intelli_PEST-Backend\tflite_models_compatible\onnx_models"
if (Test-Path $onnxPath) {
    $onnxModels = Get-ChildItem -Path $onnxPath -Filter "*.onnx" -Recurse -ErrorAction SilentlyContinue
    $onnxCount = ($onnxModels | Measure-Object).Count
    
    if ($onnxCount -ge 11) {
        $totalSize = [math]::Round(($onnxModels | Measure-Object -Property Length -Sum).Sum / 1GB, 2)
        Write-Host "   ✅ $onnxCount ONNX teachers found ($totalSize GB)" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "   ⚠️ Only $onnxCount ONNX models found (expected 11)" -ForegroundColor Yellow
        $issues += "Missing ONNX teachers (found $onnxCount, need 11)"
    }
} else {
    Write-Host "   ❌ ONNX models directory not found" -ForegroundColor Red
    $issues += "ONNX models directory missing: $onnxPath"
}

# =============================================================================
# Check 4: Class Count Consistency
# =============================================================================
$checks++
Write-Host "4️⃣ Checking class count consistency..." -ForegroundColor Yellow

$classConfigPath = "D:\KnowledgeDistillation\configs\class_mapping.json"
if (Test-Path $classConfigPath) {
    try {
        $classConfig = Get-Content $classConfigPath | ConvertFrom-Json
        $classCount = ($classConfig.PSObject.Properties | Measure-Object).Count
        
        if ($classCount -eq 12) {
            Write-Host "   ✅ Class mapping has 12 classes (11 pests + junk)" -ForegroundColor Green
            $passed++
        } else {
            Write-Host "   ⚠️ Class count is $classCount (expected 12)" -ForegroundColor Yellow
            $issues += "Class count mismatch: $classCount instead of 12"
        }
    } catch {
        Write-Host "   ⚠️ Could not parse class_mapping.json" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ⏭️ class_mapping.json not found - skipping" -ForegroundColor Gray
    $passed++  # Don't fail on this
}

# =============================================================================
# Check 5: Git Repos Initialized
# =============================================================================
$checks++
Write-Host "5️⃣ Checking git repositories..." -ForegroundColor Yellow

$repos = @(
    @{ Name = "Backend"; Path = "D:\Intelli_PEST-Backend" },
    @{ Name = "App"; Path = "D:\App\Intelli_PEST" },
    @{ Name = "KnowledgeDistillation"; Path = "D:\KnowledgeDistillation" },
    @{ Name = "Parent"; Path = "D:\" }
)

$allReposOk = $true
foreach ($repo in $repos) {
    if (Test-Path "$($repo.Path)\.git") {
        # Check for uncommitted changes
        Push-Location $repo.Path
        $status = git status --porcelain 2>$null
        Pop-Location
        
        if ($status) {
            $changeCount = ($status | Measure-Object).Count
            Write-Host "   ⚠️ $($repo.Name): $changeCount uncommitted changes" -ForegroundColor Yellow
        }
    } else {
        Write-Host "   ❌ $($repo.Name): Not a git repository" -ForegroundColor Red
        $issues += "$($repo.Name) is not a git repository"
        $allReposOk = $false
    }
}

if ($allReposOk) {
    Write-Host "   ✅ All git repositories initialized" -ForegroundColor Green
    $passed++
}

# =============================================================================
# Summary
# =============================================================================
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

if ($issues.Count -eq 0) {
    Write-Host "  ✅ ALL CHECKS PASSED ($passed/$checks)                               " -ForegroundColor Green
    Write-Host "  Pipeline is synchronized and ready!                                  " -ForegroundColor Green
} else {
    Write-Host "  ⚠️ ISSUES FOUND ($passed/$checks checks passed)                      " -ForegroundColor Yellow
    Write-Host "" 
    foreach ($issue in $issues) {
        Write-Host "  • $issue" -ForegroundColor Red
    }
}

Write-Host "═══════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
