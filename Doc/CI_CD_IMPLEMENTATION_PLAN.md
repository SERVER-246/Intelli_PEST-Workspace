# CI/CD Implementation Plan - Intelli-PEST Project

**Created:** 2026-02-02  
**Status:** Planning Phase  
**Priority:** HIGH  
**Estimated Effort:** 2-3 days

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Current State Analysis](#current-state-analysis)
3. [Proposed CI/CD Architecture](#proposed-cicd-architecture)
4. [Implementation Phases](#implementation-phases)
5. [Workflow Definitions](#workflow-definitions)
6. [Configuration Files](#configuration-files)
7. [Secrets & Environment Variables](#secrets--environment-variables)
8. [Testing Strategy](#testing-strategy)
9. [Rollout Plan](#rollout-plan)
10. [Maintenance & Monitoring](#maintenance--monitoring)

---

## Executive Summary

### Goal
Implement GitHub Actions CI/CD pipelines for all 3 Intelli-PEST repositories to automate:
- Code quality checks (linting, type checking)
- Unit and integration testing (364 tests)
- Build verification
- Model validation (optional)
- APK build for Android app (optional)

### Repositories Affected

| Repository | GitHub URL | Primary Language | Tests |
|------------|------------|------------------|-------|
| Intelli_PEST-Backend | github.com/SERVER-246/Intelli_PEST-Backend | Python | 364 |
| pest-detection-app | github.com/SERVER-246/pest-detection-app | Kotlin | TBD |
| Intelli_PEST-KnowledgeDistillation | github.com/SERVER-246/Intelli_PEST-KnowledgeDistillation | Python | TBD |

### Success Criteria
- ✅ All PRs must pass tests before merge
- ✅ Automated linting catches issues before review
- ✅ Build status badges on README
- ✅ < 5 minute CI run time for fast feedback
- ✅ No GPU required for CI (CPU-only tests)

---

## Current State Analysis

### What Exists Today

| Component | Status | Notes |
|-----------|--------|-------|
| Unit Tests | ✅ 364 tests | `tests/` and `black_ops_training/tests/` |
| Test Runner | ✅ pytest | `run_unit_tests.py` wrapper exists |
| Linting | ❌ None | No flake8/ruff/black configured |
| Type Checking | ⚠️ Partial | pyrightconfig.json exists but not enforced |
| Pre-commit Hooks | ❌ None | No `.pre-commit-config.yaml` |
| GitHub Actions | ❌ None | No `.github/workflows/` directory |
| Docker | ⚠️ Partial | `inference_server/docker/` exists (unused) |

### Test Categories (Backend)

| Category | Count | Location | GPU Required |
|----------|-------|----------|--------------|
| Inference Tests | 15 | `tests/test_inference.py` | No (mocked) |
| Training Tests | 12 | `tests/test_training.py` | No (mocked) |
| Conversion Tests | 8 | `tests/test_conversion.py` | No |
| Phase 2 Systems | 45 | `black_ops_training/tests/test_phase2_systems.py` | No |
| Phase 3 Contracts | 89 | `black_ops_training/tests/test_phase3_*.py` | No |
| Training Utils | 195 | `black_ops_training/tests/test_training_utils.py` | No |

### Current Test Commands

```bash
# Full test suite
cd D:\Intelli_PEST-Backend
python -m pytest tests/ black_ops_training/tests/ -v

# Quick smoke test
python run_unit_tests.py

# Specific test file
python -m pytest tests/test_inference.py -v
```

---

## Proposed CI/CD Architecture

### Workflow Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          GitHub Repository                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐       │
│  │  Push/PR │────▶│  Lint &  │────▶│   Test   │────▶│  Build   │       │
│  │  Trigger │     │TypeCheck │     │  Suite   │     │ Verify   │       │
│  └──────────┘     └──────────┘     └──────────┘     └──────────┘       │
│                                           │                              │
│                                           ▼                              │
│                                    ┌──────────┐                         │
│                                    │ Coverage │                         │
│                                    │  Report  │                         │
│                                    └──────────┘                         │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│                         Optional Pipelines                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌──────────┐     ┌──────────┐     ┌──────────┐                        │
│  │  Release │────▶│  Model   │────▶│  Deploy  │   (Future)             │
│  │   Tag    │     │Validation│     │ to Prod  │                        │
│  └──────────┘     └──────────┘     └──────────┘                        │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Workflow Types

| Workflow | Trigger | Duration | Purpose |
|----------|---------|----------|---------|
| **ci.yml** | push, PR | ~3-5 min | Lint, type check, test |
| **test-full.yml** | manual, nightly | ~10 min | Full test suite + coverage |
| **release.yml** | tag v*.*.* | ~5 min | Build artifacts, create release |
| **model-validation.yml** | manual | ~15 min | Validate model loads & predicts |

---

## Implementation Phases

### Phase 1: Backend CI (Priority: HIGH) — Day 1

**Objective:** Get basic CI running on Intelli_PEST-Backend

**Tasks:**
1. Create `.github/workflows/ci.yml`
2. Configure pytest with coverage
3. Add linting with ruff (fast Python linter)
4. Add type checking with pyright
5. Add build status badge to README

**Files to Create:**
```
D:\Intelli_PEST-Backend\
├── .github/
│   └── workflows/
│       └── ci.yml
├── pyproject.toml          # Unified config for ruff, pytest, coverage
└── .pre-commit-config.yaml # Optional: local pre-commit hooks
```

### Phase 2: KnowledgeDistillation CI — Day 1-2

**Objective:** Mirror Backend CI for KD repo

**Tasks:**
1. Create `.github/workflows/ci.yml` (simplified)
2. Add basic tests if missing
3. Verify training scripts import correctly

### Phase 3: App CI (Optional) — Day 2-3

**Objective:** Android build verification

**Tasks:**
1. Create `.github/workflows/android-ci.yml`
2. Configure Gradle build
3. Add APK artifact upload (optional)

### Phase 4: Integration & Polish — Day 3

**Objective:** Cross-repo coordination and monitoring

**Tasks:**
1. Add GitHub status checks as required
2. Create branch protection rules
3. Add Slack/Discord notifications (optional)
4. Document CI usage in README

---

## Workflow Definitions

### 1. Backend CI Workflow (`ci.yml`)

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  lint:
    name: Lint & Type Check
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
          cache: 'pip'
      
      - name: Install dependencies
        run: |
          pip install ruff pyright
          pip install -r inference_server/requirements.txt
      
      - name: Run ruff (linting)
        run: ruff check . --output-format=github
      
      - name: Run pyright (type check)
        run: pyright --warnings
        continue-on-error: true  # Start as warning, enforce later

  test:
    name: Test Suite
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
          cache: 'pip'
      
      - name: Install dependencies
        run: |
          pip install pytest pytest-cov pytest-timeout
          pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu
          pip install -r inference_server/requirements.txt
          pip install -r knowledge_distillation/requirements.txt
      
      - name: Run tests with coverage
        run: |
          python -m pytest tests/ black_ops_training/tests/ \
            --cov=inference_server \
            --cov=black_ops_training \
            --cov-report=xml \
            --cov-report=term-missing \
            --timeout=60 \
            -v
        env:
          CUDA_VISIBLE_DEVICES: ""  # Force CPU
      
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v4
        with:
          file: ./coverage.xml
          fail_ci_if_error: false

  build:
    name: Build Verification
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      
      - name: Verify package builds
        run: |
          pip install build
          python -m build --sdist
```

### 2. Full Test Workflow (`test-full.yml`)

```yaml
# .github/workflows/test-full.yml
name: Full Test Suite

on:
  workflow_dispatch:  # Manual trigger
  schedule:
    - cron: '0 2 * * *'  # Nightly at 2 AM UTC

jobs:
  test-matrix:
    name: Test Python ${{ matrix.python-version }}
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ['3.10', '3.11', '3.12']
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python ${{ matrix.python-version }}
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
      
      - name: Install dependencies
        run: |
          pip install pytest pytest-cov pytest-xdist
          pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu
          pip install -r inference_server/requirements.txt
          pip install -r knowledge_distillation/requirements.txt
      
      - name: Run full test suite (parallel)
        run: |
          python -m pytest tests/ black_ops_training/tests/ \
            -n auto \
            --cov=. \
            --cov-report=xml \
            -v
        env:
          CUDA_VISIBLE_DEVICES: ""
```

### 3. Model Validation Workflow (`model-validation.yml`)

```yaml
# .github/workflows/model-validation.yml
name: Model Validation

on:
  workflow_dispatch:
    inputs:
      model_path:
        description: 'Path to model file (relative to repo)'
        required: false
        default: 'N/A'

jobs:
  validate:
    name: Validate Model
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: |
          pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu
          pip install onnxruntime pillow
      
      - name: Validate model imports
        run: |
          python -c "
          import torch
          from inference_server.engine.pytorch_inference import PyTorchInference
          print('✅ PyTorch inference module loads')
          "
      
      - name: Validate ONNX runtime
        run: |
          python -c "
          import onnxruntime as ort
          print(f'✅ ONNX Runtime version: {ort.__version__}')
          "
```

---

## Configuration Files

### pyproject.toml (Unified Python Config)

```toml
# D:\Intelli_PEST-Backend\pyproject.toml

[project]
name = "intelli-pest-backend"
version = "1.0.0"
requires-python = ">=3.10"

[tool.ruff]
line-length = 120
target-version = "py311"

[tool.ruff.lint]
select = [
    "E",   # pycodestyle errors
    "W",   # pycodestyle warnings
    "F",   # pyflakes
    "I",   # isort
    "B",   # flake8-bugbear
    "C4",  # flake8-comprehensions
    "UP",  # pyupgrade
]
ignore = [
    "E501",  # line too long (handled by formatter)
    "B008",  # function call in default argument
    "B905",  # zip without explicit strict
]

[tool.ruff.lint.per-file-ignores]
"tests/*" = ["B", "C4"]
"black_ops_training/*" = ["E", "W"]  # Legacy code, relax rules

[tool.pytest.ini_options]
testpaths = ["tests", "black_ops_training/tests"]
python_files = "test_*.py"
python_functions = "test_*"
addopts = "-v --tb=short"
filterwarnings = [
    "ignore::DeprecationWarning",
    "ignore::UserWarning",
]
markers = [
    "slow: marks tests as slow (deselect with '-m \"not slow\"')",
    "gpu: marks tests requiring GPU",
]

[tool.coverage.run]
source = ["inference_server", "black_ops_training"]
omit = ["*/tests/*", "*/__pycache__/*"]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "if TYPE_CHECKING:",
    "raise NotImplementedError",
]
```

### .pre-commit-config.yaml (Optional Local Hooks)

```yaml
# D:\Intelli_PEST-Backend\.pre-commit-config.yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.3.0
    hooks:
      - id: ruff
        args: [--fix, --exit-non-zero-on-fix]
      - id: ruff-format

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
        args: ['--maxkb=10000']  # Block files > 10MB
```

---

## Secrets & Environment Variables

### Required GitHub Secrets

| Secret | Repository | Purpose | How to Get |
|--------|------------|---------|------------|
| `CODECOV_TOKEN` | Backend | Coverage upload | codecov.io dashboard |

### Environment Variables in Workflows

| Variable | Value | Purpose |
|----------|-------|---------|
| `CUDA_VISIBLE_DEVICES` | `""` | Force CPU-only for CI |
| `PYTHONUNBUFFERED` | `1` | Real-time log output |
| `CI` | `true` | Detect CI environment |

### No Secrets Required Initially

The basic CI pipeline does NOT require any secrets:
- Tests run on CPU (no GPU/cloud inference)
- No deployment step (manual for now)
- Codecov token is optional

---

## Testing Strategy

### Test Categorization for CI

```python
# Add markers to slow tests
@pytest.mark.slow
def test_full_training_loop():
    ...

@pytest.mark.gpu
def test_cuda_inference():
    ...
```

### CI Test Execution

```bash
# Default CI run (fast tests only)
pytest tests/ black_ops_training/tests/ -m "not slow and not gpu" -v

# Full suite (nightly)
pytest tests/ black_ops_training/tests/ -v

# Skip GPU tests explicitly
pytest tests/ black_ops_training/tests/ --ignore-glob="*gpu*" -v
```

### Expected CI Timing

| Stage | Duration | Notes |
|-------|----------|-------|
| Checkout | 5s | |
| Setup Python | 30s | With pip cache |
| Install deps | 60s | PyTorch CPU ~500MB |
| Ruff lint | 10s | Very fast |
| Pyright | 30s | Type checking |
| Pytest (364 tests) | 120s | ~0.33s per test |
| Coverage upload | 10s | |
| **Total** | **~4-5 min** | |

---

## Rollout Plan

### Step-by-Step Implementation

#### Day 1: Backend CI

1. **Create workflow file:**
   ```powershell
   cd D:\Intelli_PEST-Backend
   mkdir -p .github/workflows
   # Create ci.yml as defined above
   ```

2. **Create pyproject.toml:**
   ```powershell
   # Create pyproject.toml with ruff, pytest, coverage config
   ```

3. **Test locally:**
   ```powershell
   pip install ruff pytest pytest-cov
   ruff check .
   pytest tests/ -v --timeout=60
   ```

4. **Push and verify:**
   ```powershell
   git add .github/ pyproject.toml
   git commit -m "ci: Add GitHub Actions CI pipeline"
   git push
   ```

5. **Check GitHub Actions tab** for green checkmarks

#### Day 2: Branch Protection

1. **Go to GitHub repo → Settings → Branches**

2. **Add rule for `main`:**
   - ✅ Require status checks before merging
   - ✅ Require branches to be up to date
   - Select: `lint`, `test`, `build`

3. **Test with a PR**

#### Day 3: Polish & Documentation

1. **Add badge to README.md:**
   ```markdown
   ![CI](https://github.com/SERVER-246/Intelli_PEST-Backend/actions/workflows/ci.yml/badge.svg)
   ```

2. **Update PROJECT_OVERSEER_REPORT_PEST.md**

3. **Document in CONTRIBUTING.md (optional)**

---

## Maintenance & Monitoring

### Weekly Tasks

- Review failed CI runs
- Update dependencies if security alerts
- Check test coverage trends

### Monthly Tasks

- Review and remove flaky tests
- Update GitHub Actions versions
- Audit CI duration (keep under 5 min)

### Alerts to Configure (Optional)

| Alert Type | Platform | Trigger |
|------------|----------|---------|
| CI Failure | Email/Slack | Any push fails |
| Coverage Drop | Codecov | Coverage < 60% |
| Security | Dependabot | Vulnerability detected |

---

## Quick Reference

### Commands to Verify CI Locally

```powershell
# From D:\Intelli_PEST-Backend

# 1. Lint check
pip install ruff
ruff check .

# 2. Type check
pip install pyright
pyright

# 3. Run tests (fast)
pytest tests/ black_ops_training/tests/ -v --timeout=60 -x

# 4. Run tests with coverage
pytest tests/ black_ops_training/tests/ --cov=inference_server --cov-report=term-missing
```

### GitHub Actions Status

After implementation, check:
- https://github.com/SERVER-246/Intelli_PEST-Backend/actions

---

## Appendix: File Checklist

| File | Repo | Status |
|------|------|--------|
| `.github/workflows/ci.yml` | Backend | TODO |
| `.github/workflows/test-full.yml` | Backend | TODO |
| `.github/workflows/model-validation.yml` | Backend | OPTIONAL |
| `pyproject.toml` | Backend | TODO |
| `.pre-commit-config.yaml` | Backend | OPTIONAL |
| `.github/workflows/ci.yml` | KD | TODO |
| `.github/workflows/android-ci.yml` | App | OPTIONAL |

---

**Document Status:** Ready for Implementation  
**Next Action:** Create `.github/workflows/ci.yml` in Backend repo  
**Estimated Time to First Green CI:** 2-3 hours
