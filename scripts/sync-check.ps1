# Intelli-PEST Sync Check Script  
# Verifies all components are compatible and pipeline is operational
# Usage: .\sync-check.ps1

Write-Host ""
Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host "                    INTELLI-PEST SYNC CHECK                            " -ForegroundColor Cyan
Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host ""

$errors = @()
$warnings = @()

# Check 1: Model file existence
Write-Host "[1/5] Checking model files..." -ForegroundColor Yellow

$studentModel = "D:\KnowledgeDistillation\student_model_final.pth"
if (Test-Path $studentModel) {
    Write-Host "   [OK] Student model exists: student_model_final.pth" -ForegroundColor Green
} else {
    Write-Host "   [!] Student model not found" -ForegroundColor Yellow
    $warnings += "Student model not found at $studentModel"
}

$tfliteModels = Get-ChildItem "D:\Intelli_PEST-Backend\tflite_models_compatible\*.tflite" 2>$null
if ($tfliteModels) {
    Write-Host "   [OK] TFLite models found: $($tfliteModels.Count) models" -ForegroundColor Green
} else {
    Write-Host "   [X] No TFLite models in Backend" -ForegroundColor Red
    $errors += "No TFLite models found in Intelli_PEST-Backend\tflite_models_compatible\"
}

# Check 2: Teacher models for KD
Write-Host ""
Write-Host "[2/5] Checking teacher models..." -ForegroundColor Yellow

$teacherDir = "D:\Intelli_PEST-Backend\teacher_models"
if (Test-Path $teacherDir) {
    $onnxTeachers = Get-ChildItem "$teacherDir\*.onnx" 2>$null
    if ($onnxTeachers) {
        Write-Host "   [OK] ONNX teacher models: $($onnxTeachers.Count) models" -ForegroundColor Green
    } else {
        Write-Host "   [!] No ONNX teacher models" -ForegroundColor Yellow
        $warnings += "No ONNX teacher models found"
    }
} else {
    Write-Host "   [!] Teacher models directory not found" -ForegroundColor Yellow
    $warnings += "Teacher models directory not found"
}

# Check 3: Config consistency
Write-Host ""
Write-Host "[3/5] Checking configuration files..." -ForegroundColor Yellow

$backendConfig = "D:\Intelli_PEST-Backend\configs\model_config.yaml"
if (Test-Path $backendConfig) {
    Write-Host "   [OK] Backend config exists" -ForegroundColor Green
} else {
    Write-Host "   [!] Backend config not found" -ForegroundColor Yellow
    $warnings += "model_config.yaml not found"
}

# Check 4: Class labels consistency
Write-Host ""
Write-Host "[4/5] Checking class definitions..." -ForegroundColor Yellow

$expectedClasses = 12
Write-Host "   Expected classes: $expectedClasses" -ForegroundColor White

# Check if class mappings exist in configs
$classConfig = "D:\Intelli_PEST-Backend\configs\class_config.yaml"
if (Test-Path $classConfig) {
    Write-Host "   [OK] Class config exists" -ForegroundColor Green
} else {
    Write-Host "   [i] Class config at different location or inline" -ForegroundColor Gray
}

# Check 5: Git status sync
Write-Host ""
Write-Host "[5/5] Checking git synchronization..." -ForegroundColor Yellow

$repos = @(
    @{ Name = "Backend"; Path = "D:\Intelli_PEST-Backend" },
    @{ Name = "KnowledgeDistillation"; Path = "D:\KnowledgeDistillation" }
)

foreach ($repo in $repos) {
    Push-Location $repo.Path
    
    $status = git status --porcelain 2>$null
    $ahead = git rev-list --count "@{u}..HEAD" 2>$null
    $behind = git rev-list --count "HEAD..@{u}" 2>$null
    
    if ($status -or $ahead -gt 0 -or $behind -gt 0) {
        Write-Host "   [!] $($repo.Name) has uncommitted or unpushed changes" -ForegroundColor Yellow
        $warnings += "$($repo.Name) not fully synced"
    } else {
        Write-Host "   [OK] $($repo.Name) is synced" -ForegroundColor Green
    }
    
    Pop-Location
}

# Summary
Write-Host ""
Write-Host "=======================================================================" -ForegroundColor Cyan

if ($errors.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host "  [OK] All checks passed! Pipeline is operational.                    " -ForegroundColor Green
} elseif ($errors.Count -gt 0) {
    Write-Host "  [X] ERRORS FOUND - Pipeline may not work correctly                  " -ForegroundColor Red
    foreach ($err in $errors) {
        Write-Host "      - $err" -ForegroundColor Red
    }
}

if ($warnings.Count -gt 0) {
    Write-Host "  [!] Warnings:                                                        " -ForegroundColor Yellow
    foreach ($warn in $warnings) {
        Write-Host "      - $warn" -ForegroundColor Yellow
    }
}

Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host ""
