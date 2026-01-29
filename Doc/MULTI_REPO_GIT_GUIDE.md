# Intelli-PEST Multi-Repository Git Guide

> **Version:** 1.0.0  
> **Last Updated:** June 2025  
> **Repository:** https://github.com/SERVER-246/Intelli_PEST-Workspace

## Overview

The Intelli-PEST project uses a **multi-repository architecture** with a parent workspace containing three git submodules:

```
D:\ (Intelli_PEST-Workspace)           <- Parent Repository
├── Intelli_PEST-Backend/              <- Submodule: Backend API
├── App/Intelli_PEST/                  <- Submodule: Flutter Mobile App  
├── KnowledgeDistillation/             <- Submodule: ML Training Pipeline
└── scripts/                           <- Orchestration Scripts
```

### Repository URLs

| Component | Repository |
|-----------|------------|
| **Parent Workspace** | https://github.com/SERVER-246/Intelli_PEST-Workspace |
| **Backend** | https://github.com/SERVER-246/Intelli_PEST-Backend |
| **Mobile App** | https://github.com/SERVER-246/pest-detection-app |
| **Knowledge Distillation** | https://github.com/SERVER-246/Intelli_PEST-KnowledgeDistillation |

---

## Quick Reference

### Daily Workflow Commands

```powershell
# Check status of all repos
.\scripts\status-all.ps1

# Commit changes (choose what to commit)
.\scripts\commit-all.ps1 -Message "Your message" -Backend      # Backend only
.\scripts\commit-all.ps1 -Message "Your message" -KD           # KD only
.\scripts\commit-all.ps1 -Message "Your message" -All          # All repos

# Push all changes to GitHub
.\scripts\push-all.ps1

# Pull latest from all repos
.\scripts\pull-all.ps1

# Verify pipeline compatibility
.\scripts\sync-check.ps1
```

### VS Code Tasks

Open the Command Palette (`Ctrl+Shift+P`) → "Tasks: Run Task":

| Task | Description |
|------|-------------|
| `📊 Status All Repos` | Show git status of all repositories |
| `📝 Commit All Repos` | Commit changes across all repos |
| `📝 Commit Backend Only` | Commit only Backend changes |
| `📝 Commit KD Only` | Commit only KnowledgeDistillation changes |
| `⬆️ Push All Repos` | Push all repos to GitHub |
| `⬇️ Pull All Repos` | Pull and update all repos |
| `🔍 Sync Check` | Verify pipeline compatibility |

---

## Understanding Submodules

### What is a Submodule?

A git submodule is a **pointer to a specific commit** in another repository. The parent repository (Intelli_PEST-Workspace) doesn't contain the actual code from submodules - it just references which commit each submodule should be at.

### Key Concepts

1. **Submodules are frozen at specific commits**  
   When you clone the parent repo, submodules are checked out at the exact commits recorded by the parent.

2. **Changes in submodules must be committed twice**  
   First in the submodule itself, then in the parent (to update the reference).

3. **Parent tracks submodule state**  
   `git status` in parent will show changes if submodule commits have changed.

---

## Common Workflows

### 1. Starting Fresh on a New Machine

```powershell
# Clone the parent repo with all submodules
git clone --recursive https://github.com/SERVER-246/Intelli_PEST-Workspace.git D:\

# If you forgot --recursive:
cd D:\
git submodule update --init --recursive

# Run environment setup
.\scripts\setup-environment.ps1
```

### 2. Making Changes to Backend

```powershell
# 1. Make your code changes in D:\Intelli_PEST-Backend\

# 2. Check status
.\scripts\status-all.ps1

# 3. Commit the Backend
cd D:\Intelli_PEST-Backend
git add -A
git commit -m "feat: Your feature description"
git push

# 4. Update parent to reference new commit
cd D:\
git add Intelli_PEST-Backend
git commit -m "chore: Update Backend submodule"
git push
```

**Or use the script:**
```powershell
.\scripts\commit-all.ps1 -Message "feat: Your feature" -Backend
# Script will ask if you want to update parent reference
```

### 3. Making Changes to KnowledgeDistillation

```powershell
# 1. Make your changes in D:\KnowledgeDistillation\

# 2. Commit using the script
.\scripts\commit-all.ps1 -Message "train: Add rotation augmentation" -KD
```

### 4. Syncing After Someone Else Pushed Changes

```powershell
# Pull everything
.\scripts\pull-all.ps1

# This will:
# 1. Pull parent repo
# 2. Update submodules to recorded commits
# 3. Pull latest from each submodule's remote
```

### 5. Working on Multiple Components

```powershell
# Make changes to both Backend and KD, then:
.\scripts\commit-all.ps1 -Message "feat: Cross-component feature" -All
```

### 6. Checking Pipeline Compatibility

After major changes, run:
```powershell
.\scripts\sync-check.ps1
```

This verifies:
- Model files exist
- Teacher models for KD are present
- Configs are in place
- All repos are synced

---

## Script Reference

### `status-all.ps1`

Shows at-a-glance status for all repositories:
- Current branch
- Latest commit hash
- Staged/unstaged changes count
- Ahead/behind remote status

### `commit-all.ps1`

**Parameters:**
- `-Message` (required): Commit message
- `-Backend`: Commit Backend repo only
- `-App`: Commit App repo only
- `-KD`: Commit KnowledgeDistillation only
- `-All`: Commit all repos

After committing, prompts to update parent submodule references.

### `push-all.ps1`

Pushes all repositories (parent + submodules) to their remotes.

### `pull-all.ps1`

1. Pulls parent repository
2. Updates submodules to recorded commits
3. Pulls latest from each submodule's remote branch

### `sync-check.ps1`

Verifies pipeline compatibility:
1. Student model existence
2. TFLite models in Backend
3. Teacher models for KD
4. Config file presence
5. Git synchronization status

### `setup-environment.ps1`

One-time setup for new developers:
1. Checks Python/Git installation
2. Initializes submodules
3. Creates virtual environments
4. Installs dependencies

---

## Troubleshooting

### "Submodule path not initialized"

```powershell
git submodule update --init --recursive
```

### "Submodule has uncommitted changes"

Commit or stash changes in the submodule first:
```powershell
cd D:\Intelli_PEST-Backend  # or the problematic submodule
git stash  # or git add -A && git commit -m "message"
```

### "Detached HEAD in submodule"

This is normal after submodule update. If you need to make changes:
```powershell
cd D:\Intelli_PEST-Backend
git checkout main
```

### "Script cannot be loaded because running scripts is disabled"

Enable PowerShell script execution:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

### "Merge conflict in .gitmodules"

```powershell
git checkout --theirs .gitmodules
git add .gitmodules
git submodule update --init --recursive
```

---

## Best Practices

### 1. Always Update Parent After Submodule Changes

When you push changes to a submodule, always update the parent's reference:
```powershell
cd D:\
git add Intelli_PEST-Backend  # or the submodule you changed
git commit -m "chore: Update submodule reference"
git push
```

### 2. Use Descriptive Commit Messages

Follow conventional commit prefixes:
- `feat:` - New feature
- `fix:` - Bug fix
- `refactor:` - Code restructure
- `train:` - Training-related changes
- `docs:` - Documentation
- `chore:` - Maintenance tasks

### 3. Run sync-check Before Major Deployments

```powershell
.\scripts\sync-check.ps1
```

### 4. Keep Model Files Out of Git

Large files (`.pt`, `.pth`, `.onnx`, `.tflite`) are gitignored. Transfer them separately or use Git LFS for version control.

### 5. Use the VS Code Workspace

Open `intellipest.code-workspace` for:
- Multi-root folder view
- Integrated tasks
- Correct Python paths
- Launch configurations

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                    Intelli_PEST-Workspace (Parent)                  │
│                   github.com/SERVER-246/Intelli_PEST-Workspace      │
├─────────────────────────────────────────────────────────────────────┤
│  .gitmodules           <- Submodule configuration                   │
│  scripts/              <- PowerShell orchestration                  │
│  intellipest.code-workspace <- VS Code multi-root config            │
│  .vscode/tasks.json    <- VS Code task automation                   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Intelli_PEST-Backend (Submodule)                           │   │
│  │  github.com/SERVER-246/Intelli_PEST-Backend                 │   │
│  │  - FastAPI inference server                                 │   │
│  │  - TFLite model serving                                     │   │
│  │  - Analytics & feedback system                              │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  App/Intelli_PEST (Submodule)                               │   │
│  │  github.com/SERVER-246/pest-detection-app                   │   │
│  │  - Flutter mobile application                               │   │
│  │  - Image capture & upload                                   │   │
│  │  - Prediction display                                       │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  KnowledgeDistillation (Submodule)                          │   │
│  │  github.com/SERVER-246/Intelli_PEST-KnowledgeDistillation   │   │
│  │  - Teacher-student training                                 │   │
│  │  - Model optimization                                       │   │
│  │  - Export scripts                                           │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | June 2025 | Initial multi-repo setup with submodules and PowerShell scripts |

---

*This guide replaces the previous MULTI_REPO_MANAGEMENT_PLAN.md*
