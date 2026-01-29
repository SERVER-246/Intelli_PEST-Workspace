# Changelog

All notable changes to the Intelli-PEST project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- Multi-repo workspace management with git submodules
- PowerShell automation scripts (status-all, commit-all, push-all, pull-all, sync-check, setup-environment)
- VS Code tasks for unified development workflow
- Comprehensive workspace documentation

---

## [1.3.0] - 2026-01-29

### Added - Workspace
- **Intelli_PEST-Workspace** parent repository created
- Git submodule integration for 3 repositories
- 6 PowerShell management scripts
- VS Code multi-root workspace configuration
- Unified development workflow

### Added - Backend (Intelli_PEST-Backend)
- Phase 3 features: region-aware perception, multi-label classification
- Ghost Trainer auto-retraining system
- 12-class classification (11 pests + junk)
- 100+ concurrent connection support

### Added - App (pest-detection-app)
- Server-side PyTorch inference via VS Code Dev Tunnels
- Firebase email/password and Google Sign-In
- Continuous GPS background tracking
- Detection history with date, time, location stamps
- Statistics dashboard

### Added - Training (Intelli_PEST-KnowledgeDistillation)
- Git version control initialized
- Sequential knowledge distillation from 11 teachers
- Rotation robustness training (360° with 24-angle validation)
- 96.25% validation accuracy achieved

---

## [1.2.0] - 2026-01-16

### Changed - Backend
- Phase 3 fully operational
- Learning-based region scoring
- Multi-label classification support

---

## [1.1.0] - 2025-12-31

### Added - App
- Server-side inference migration
- Firebase authentication
- Location tracking service
- Detection history

### Changed - Backend
- Knowledge distillation pipeline complete
- Auto-retraining system operational

---

## [1.0.0] - 2025-12-11

### Added
- Initial release of Intelli_PEST-Backend
- 11 teacher models trained (7 base + 4 ensemble)
- ONNX model conversion pipeline
- FastAPI inference server
- pest-detection-app initial release

---

## Pre-Release History

### 2025-10-07
- ONNX conversion of all 11 teacher models (100% success)

### 2025-10-01
- Ensemble model training complete (4 models)
- Best ensemble: Ensemble_Attention (96.39% accuracy)

### 2025-09-29 to 2025-09-30
- Base model training complete (7 models)
- Best base model: ResNet50 (97.12% accuracy)

### 2021-01-08
- Dataset collection began
- First sugarcane pest images captured

---

[Unreleased]: https://github.com/SERVER-246/Intelli_PEST-Workspace/compare/v1.3.0...HEAD
[1.3.0]: https://github.com/SERVER-246/Intelli_PEST-Workspace/releases/tag/v1.3.0
[1.2.0]: https://github.com/SERVER-246/Intelli_PEST-Backend/releases/tag/v1.2.0
[1.1.0]: https://github.com/SERVER-246/pest-detection-app/releases/tag/v1.1.0
[1.0.0]: https://github.com/SERVER-246/Intelli_PEST-Backend/releases/tag/v1.0.0
