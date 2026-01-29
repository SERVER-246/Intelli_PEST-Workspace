# 🐛 Intelli-PEST Workspace

**Unified development workspace for the Intelli-PEST sugarcane pest detection system.**

[![Python](https://img.shields.io/badge/Python-3.10+-blue.svg)](https://python.org)
[![PyTorch](https://img.shields.io/badge/PyTorch-2.0+-EE4C2C.svg)](https://pytorch.org)
[![Kotlin](https://img.shields.io/badge/Kotlin-Android-7F52FF.svg)](https://kotlinlang.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📦 Repository Structure

This workspace orchestrates **3 sub-repositories** for the complete Intelli-PEST system:

| Repository | Description | Path |
|------------|-------------|------|
| [⚙️ Intelli_PEST-Backend](https://github.com/SERVER-246/Intelli_PEST-Backend) | FastAPI inference server, Ghost Trainer, ML pipeline | `Intelli_PEST-Backend/` |
| [📱 pest-detection-app](https://github.com/SERVER-246/pest-detection-app) | Android app (Kotlin, Jetpack Compose) | `App/Intelli_PEST/` |
| [🧠 Intelli_PEST-KnowledgeDistillation](https://github.com/SERVER-246/Intelli_PEST-KnowledgeDistillation) | Knowledge distillation training pipeline | `KnowledgeDistillation/` |

---

## 🚀 Quick Start

### 1. Clone with Submodules

```bash
git clone --recurse-submodules https://github.com/SERVER-246/Intelli_PEST-Workspace.git
cd Intelli_PEST-Workspace
```

### 2. Setup Environment

```powershell
.\scripts\setup-environment.ps1
```

### 3. Open in VS Code

```bash
code intellipest.code-workspace
```

---

## 📊 Management Scripts

| Script | Description | Usage |
|--------|-------------|-------|
| `status-all.ps1` | Show status of all repos | `.\scripts\status-all.ps1` |
| `commit-all.ps1` | Commit to multiple repos | `.\scripts\commit-all.ps1 -Message "msg" -All` |
| `push-all.ps1` | Push to all remotes | `.\scripts\push-all.ps1` |
| `pull-all.ps1` | Pull from all remotes | `.\scripts\pull-all.ps1` |
| `sync-check.ps1` | Verify pipeline compatibility | `.\scripts\sync-check.ps1` |
| `setup-environment.ps1` | One-click dev setup | `.\scripts\setup-environment.ps1` |

---

## ⌨️ VS Code Tasks

Open Command Palette (`Ctrl+Shift+P`) → "Run Task":

- 📊 **Status All Repos** — Quick overview
- 💾 **Commit All Repos** — Unified commits
- 🚀 **Push All Repos** — Push to GitHub
- 📥 **Pull All Repos** — Sync with remote
- 🔍 **Check Pipeline Sync** — Verify compatibility
- ▶️ **Start Server** — Run inference server
- 🧪 **Run All Tests** — Execute test suite

---

## 🏗️ System Architecture

```
┌─────────────────┐     HTTPS      ┌─────────────────────────────┐
│  📱 Android App │ ─────────────▶ │  ⚙️ FastAPI Inference Server │
│  (Kotlin)       │                │  (PyTorch, Phase 3)          │
└─────────────────┘                └──────────────┬──────────────┘
                                                  │
                    ┌─────────────────────────────┤
                    │                             │
                    ▼                             ▼
        ┌───────────────────┐         ┌────────────────────┐
        │  🧠 Student Model  │         │  👻 Ghost Trainer   │
        │  (96.25% accuracy) │◀────────│  (Auto-retraining)  │
        └───────────────────┘         └────────────────────┘
                    ▲
                    │ Knowledge Distillation
                    │
        ┌───────────────────┐
        │  📚 11 Teachers   │
        │  (ONNX models)    │
        └───────────────────┘
```

---

## 📁 Directory Layout

```
D:\                              ← This workspace
├── intellipest.code-workspace   ← Open this in VS Code
├── scripts/                     ← Management scripts
├── .vscode/                     ← VS Code config
│
├── Intelli_PEST-Backend/        ← [Submodule] Backend server
├── App/Intelli_PEST/            ← [Submodule] Android app
├── KnowledgeDistillation/       ← [Submodule] Training pipeline
│
├── Base-dir/                    ← (Not tracked) Original training artifacts
├── IMAGE DATASET/               ← (Not tracked) 3,840 training images
└── tmp/                         ← (Not tracked) Temporary files
```

---

## 🔗 Related Documentation

- [MULTI_REPO_GIT_GUIDE.md](MULTI_REPO_GIT_GUIDE.md) — Comprehensive git workflow guide
- [PROJECT_OVERSEER_REPORT_PEST.md](PROJECT_OVERSEER_REPORT_PEST.md) — Full project documentation
- [Intelli_PEST-Backend/README.md](Intelli_PEST-Backend/README.md) — Backend documentation
- [pest-detection-app/README.md](App/Intelli_PEST/README.md) — App documentation

---

## 📈 Project Stats

| Metric | Value |
|--------|-------|
| 🎯 Accuracy | 96.25% validation |
| 🐛 Pest Classes | 11 + 1 junk filter |
| 📚 Teacher Models | 11 (7 base + 4 ensemble) |
| 📱 Android Min SDK | API 24 (Android 7.0) |
| 🧪 Tests | 97+ passing |

---

## 🤝 Contributing

1. Make changes in the appropriate sub-repo
2. Run `.\scripts\sync-check.ps1` to verify compatibility
3. Commit with `.\scripts\commit-all.ps1 -Message "description" -All`
4. Push with `.\scripts\push-all.ps1`

---

## 📄 License

MIT License — See individual repository LICENSE files.

---

**Made with ❤️ for sustainable agriculture**
