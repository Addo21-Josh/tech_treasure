# 📋 Changelog

All notable changes to **Tech Treasure Database** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2026-11-16

### Added
- **Phase 1: Foundation**: Feature-First architecture, Material 3 Dark theme (Deep Sapphire & Amber Gold), Drift SQLite database with seeded categories, and GoRouter nested shell navigation.
- **Phase 2: Treasure Management**: Full CRUD operations, drag-and-drop step reordering, Quick Capture bottom sheet (<5s capture), star favorites, and "No App Needed" toggle.
- **Phase 3: Organization & Sub-Millisecond Search**: SQLite FTS5 full-text search virtual table (`treasures_fts`) with automated sync triggers, debounced search view, category management, and multi-criteria filters.
- **Phase 4: Research & Empirical Verification**: Multi-device test matrix, 6-step verification quality gate, citation link launcher, and cascade relational deletions.
- **Phase 5: Content Production Studio**: 8-stage interactive Kanban pipeline (*Ideas ➔ Research ➔ Testing ➔ Verified ➔ Scripted ➔ Recorded ➔ Edited ➔ Published*), Script Studio with 3-second hook formulator, full-screen OLED black Teleprompter with mirror mode & auto-scroll, Social Media clipboard export (Shorts, Reels, WhatsApp, Markdown), and post-publication metrics logging.
- **Phase 6: Backup, Portability & System Integration**: Android Share Sheet intent receiver (`receive_sharing_intent 1.8.1`), v1.0 JSON backup generator with SHA-256 cryptographic checksum, atomic transactional restore with tamper detection, and RFC 4180 CSV spreadsheet exporter.
- **Phase 7: Hardening & MVP Launch**: Friendly empty states across all screens, 1,000-record scale & sub-5ms performance benchmark test, ProGuard R8 keep rules, and successful Android debug APK compilation.

---

## [0.1.0] - 2026-11-10

### Added
- Comprehensive Product Requirements Document ([`PRD.md`](file:///c:/Users/DELL/StudioProjects/tech_treasure/PRD.md)) covering product vision, user model, and MVP scope lock.
- Technical Architecture specification ([`docs/ARCHITECTURE.md`](file:///c:/Users/DELL/StudioProjects/tech_treasure/docs/ARCHITECTURE.md)) defining Feature-First Clean Architecture, Riverpod state models, and reactive Drift data streams.
- Relational Database Schema specification ([`docs/DATABASE_SCHEMA.md`](file:///c:/Users/DELL/StudioProjects/tech_treasure/docs/DATABASE_SCHEMA.md)) with Mermaid ER diagram, Drift tables, FTS5 triggers, and indexes.
- Data Models & Backup specification ([`docs/DATA_MODELS_AND_BACKUP_SPEC.md`](file:///c:/Users/DELL/StudioProjects/tech_treasure/docs/DATA_MODELS_AND_BACKUP_SPEC.md)) detailing JSON v1.0 schema, atomic restore protocol, and CSV export.
- UI/UX Design System specification ([`docs/UI_UX_SPECIFICATION.md`](file:///c:/Users/DELL/StudioProjects/tech_treasure/docs/UI_UX_SPECIFICATION.md)) with Digital Treasure Chest color palette, typography tokens, wireframes, and empty states.
- Testing Strategy specification ([`docs/TESTING_STRATEGY.md`](file:///c:/Users/DELL/StudioProjects/tech_treasure/docs/TESTING_STRATEGY.md)) detailing in-memory SQLite DAO tests, Riverpod notifier tests, and E2E integration test scenario.
- Deployment & Release guide ([`docs/DEPLOYMENT_AND_RELEASE.md`](file:///c:/Users/DELL/StudioProjects/tech_treasure/docs/DEPLOYMENT_AND_RELEASE.md)) with Android Keystore, ProGuard rules, iOS signing, and pre-release checklist.
- Phased Product Roadmap ([`docs/ROADMAP.md`](file:///c:/Users/DELL/StudioProjects/tech_treasure/docs/ROADMAP.md)) from MVP foundation through Phase 10 AI co-pilot.
- Repository governance files: [`README.md`](file:///c:/Users/DELL/StudioProjects/tech_treasure/README.md), [`CONTRIBUTING.md`](file:///c:/Users/DELL/StudioProjects/tech_treasure/CONTRIBUTING.md), [`SECURITY.md`](file:///c:/Users/DELL/StudioProjects/tech_treasure/SECURITY.md), and [`LICENSE`](file:///c:/Users/DELL/StudioProjects/tech_treasure/LICENSE).

