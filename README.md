# 💎 Tech Treasure Database

> **A personal, offline-first technology knowledge and content-production database for creators and researchers.**

[![Flutter](https://img.shields.io/badge/Flutter-3.11+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Feature--First_Clean-green)](#architecture--tech-stack)
[![State Management](https://img.shields.io/badge/State_Management-Riverpod-blue)](https://riverpod.dev)
[![Database](https://img.shields.io/badge/Database-Drift_%2B_SQLite-orange)](https://drift.simonbinder.eu)
[![Offline First](https://img.shields.io/badge/Offline-100%25_Local-brightgreen)](#offline-first-guarantee)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](file:///c:/Users/DELL/StudioProjects/tech_treasure/LICENSE)

---

## 📖 Overview

When researching technology tips, tricks, and tutorials, discoveries are easily scattered across WhatsApp chats, bookmarks, screenshots, camera rolls, paper notes, and cloud docs.

**Tech Treasure** solves this by providing a unified, completely offline-first Flutter application where technology content creators capture ideas, rigorously verify and test them across platforms, craft scripts, track content production, and learn from past performance.

### The Core Creator Loop

```text
Capture  ──►  Research  ──►  Verify  ──►  Test  ──►  Script  ──►  Publish  ──►  Learn
  💡             🔍             ✅          🧪         🎬           🚀          📈
```

---

## ✨ Key Features

- **⚡ Quick Capture (<5s)**: Instantly save discoveries with a minimal title and category without breaking your research flow.
- **🛡️ Rigorous Verification Protocol**: Ensure tips are genuine with an empirical verification checklist (source checks, step validation, limitations, and security checks).
- **🧪 Multi-Device Testing Matrix**: Record device, OS version, test environment, and empirical results (Works, Partially Works, Does Not Work).
- **🎬 Integrated Content Studio**: Convert verified discoveries into production scripts with hooks, problem statements, screen demonstrations, CTAs, and platform targets (TikTok, Shorts, Reels, YouTube).
- **📋 Visual Content Pipeline**: Kanban-style workflow board moving cards through `Ideas` ➔ `Research` ➔ `Testing` ➔ `Verified` ➔ `Scripted` ➔ `Recorded` ➔ `Edited` ➔ `Published`.
- **🔍 Sub-millisecond Offline Search**: Fast SQLite FTS5 (Full-Text Search) across titles, problems, solutions, tags, notes, and scripts.
- **🏷️ Smart Categorization & Tags**: Custom categories and multi-tag filtering (e.g., `#android`, `#whatsapp`, `#windows`, `#noapp`, `#security`).
- **🌟 "No App Needed" & High Potential Flags**: Dedicated flags to surface native OS tricks and top-tier content recommendations.
- **📦 Reliable Local Backup & Restore**: Full JSON backup with schema versioning and SHA-256 integrity verification, plus CSV export for spreadsheet analysis.
- **🎨 Digital Treasure Chest Theme**: Clean Material 3 design with deep sapphire/slate backgrounds and warm amber/gold accents, supporting light and dark modes.

---

## 🏗️ Architecture & Tech Stack

Tech Treasure strictly follows a **Feature-First Clean Architecture** with unidirectional data flow and clear separation of concerns.

```text
lib/
├── core/                        # Global shared infrastructure
│   ├── constants/               # Global constants, keys, enums
│   ├── database/                # Drift database definition, DAOs, tables & migrations
│   ├── errors/                  # Failure and Exception hierarchies
│   ├── router/                  # go_router declarative routing configuration
│   ├── theme/                   # Material 3 colors, typography, and styling
│   ├── utils/                   # DateTime, formatters, and helper extensions
│   └── widgets/                 # Reusable atomic UI components (cards, pills, dialogs)
│
├── features/                    # Feature-first modular packaging
│   ├── dashboard/               # Metrics, quick stats, "Treasure of the Day"
│   ├── treasures/               # Treasure CRUD, detail views, steps, tags, search & filtering
│   ├── research/                # Citations, sources, and research log tracking
│   ├── testing/                 # Test records, compatibility checks, and verification checklist
│   ├── pipeline/                # Kanban board content production workflow
│   ├── content/                 # Script editor, hooks, CTAs, platform targeting
│   ├── analytics/               # Manual performance snapshots (views, likes, saves)
│   └── settings/                # JSON backup/restore, CSV export, preferences
│
└── main.dart                    # Application bootstrap & ProviderScope initialization
```

### Layer Responsibilities per Feature

Each feature directory (e.g. [`lib/features/treasures`](file:///c:/Users/DELL/StudioProjects/tech_treasure/lib)) is divided into three distinct layers:

1. **`domain/`**: Pure Dart layer containing Entities, Value Objects, Failure types, and abstract Repository contracts. No Flutter or database dependencies.
2. **`data/`**: Implements repository contracts. Contains Drift DAOs, Data Sources, Data Transfer Objects (DTOs), and mapping functions (`toEntity()` / `toCompanion()`).
3. **`presentation/`**: Flutter UI layer containing Screens, Widgets, Riverpod `AsyncNotifier` state controllers, and UI state models.

### Recommended Production Stack

| Component | Technology | Rationale |
|---|---|---|
| **Framework** | Flutter 3.11+ / Dart 3.x | High-performance compiled mobile UI across Android & iOS |
| **State Management** | [Flutter Riverpod 2.x](https://riverpod.dev) | Compile-safe dependency injection, testable `AsyncNotifier`s |
| **Local Database** | [Drift (SQLite)](https://drift.simonbinder.eu) | Reactive relational database with type-safe queries & migrations |
| **Full-Text Search** | SQLite FTS5 | Sub-millisecond keyword lookup across all fields offline |
| **Routing** | [go_router](https://pub.dev/packages/go_router) | Declarative nested navigation with shell bottom tabs |
| **Model Generation** | Freezed + json_serializable | Immutable domain entities and robust JSON backup serialization |
| **Export Formats** | JSON v1.0 & CSV | Human-readable backups and spreadsheet compatibility |

---

## 📚 Technical Documentation

Comprehensive architectural and implementation guides are available in the [`docs/`](file:///c:/Users/DELL/StudioProjects/tech_treasure/docs) folder:

| Document | Purpose |
|---|---|
| [**`PRD.md`**](file:///c:/Users/DELL/StudioProjects/tech_treasure/PRD.md) | Official Product Requirements Document |
| [**`docs/ARCHITECTURE.md`**](file:///c:/Users/DELL/StudioProjects/tech_treasure/docs/ARCHITECTURE.md) | Detailed Clean Architecture, Riverpod state models, and design patterns |
| [**`docs/DATABASE_SCHEMA.md`**](file:///c:/Users/DELL/StudioProjects/tech_treasure/docs/DATABASE_SCHEMA.md) | Complete Drift SQLite tables, ER diagrams, indexes, and migrations |
| [**`docs/DATA_MODELS_AND_BACKUP_SPEC.md`**](file:///c:/Users/DELL/StudioProjects/tech_treasure/docs/DATA_MODELS_AND_BACKUP_SPEC.md) | JSON v1.0 Backup/Restore schema, checksums, and CSV export spec |
| [**`docs/UI_UX_SPECIFICATION.md`**](file:///c:/Users/DELL/StudioProjects/tech_treasure/docs/UI_UX_SPECIFICATION.md) | Color palette, typography, screen wireframes, and accessibility specs |
| [**`docs/TESTING_STRATEGY.md`**](file:///c:/Users/DELL/StudioProjects/tech_treasure/docs/TESTING_STRATEGY.md) | Unit, DAO in-memory, widget, and integration testing strategy |
| [**`docs/DEPLOYMENT_AND_RELEASE.md`**](file:///c:/Users/DELL/StudioProjects/tech_treasure/docs/DEPLOYMENT_AND_RELEASE.md) | Production build guide, Android Keystore, ProGuard, and release checklist |
| [**`docs/ROADMAP.md`**](file:///c:/Users/DELL/StudioProjects/tech_treasure/docs/ROADMAP.md) | Phased roadmap from MVP (Phases 1–7) through Phase 4 Assistant |

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.11.5`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.0.0`)
- Android Studio / VS Code with Flutter and Dart extensions
- Android device or emulator (API level 24+) or iOS device/simulator (iOS 13+)

### Installation & Local Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/tech_treasure.git
   cd tech_treasure
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run code generation (Drift, Freezed, Riverpod):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
   *(For continuous development, run `dart run build_runner watch --delete-conflicting-outputs`)*

4. **Verify analyzer and lints:**
   ```bash
   flutter analyze
   ```

5. **Run all tests:**
   ```bash
   flutter test
   ```

6. **Launch the application:**
   ```bash
   flutter run
   ```

---

## 🧪 Verification & Testing Commands

To run tests with code coverage analysis:

```bash
# Run all unit and widget tests
flutter test

# Run tests with coverage output
flutter test --coverage

# Format Dart source files
dart format lib test docs
```

---

## 🔒 Offline-First Guarantee & Privacy

Tech Treasure is built on strict data privacy principles:
- **Zero Cloud Leakage**: No network calls, telemetry, or external APIs are invoked for core usage.
- **Data Sovereignty**: All discoveries, test records, scripts, and metrics live strictly inside the SQLite database on your device.
- **Portability**: Backups can be exported to your device storage as a standard JSON file or exported as CSV at any time.

Read more in [`SECURITY.md`](file:///c:/Users/DELL/StudioProjects/tech_treasure/SECURITY.md).

---

## 🤝 Contributing

We welcome contributions, bug reports, and enhancements! Please read [`CONTRIBUTING.md`](file:///c:/Users/DELL/StudioProjects/tech_treasure/CONTRIBUTING.md) for details on our coding standards, branch conventions, and pull request workflow.

---

## 📄 License

This project is licensed under the MIT License - see the [`LICENSE`](file:///c:/Users/DELL/StudioProjects/tech_treasure/LICENSE) file for details.
