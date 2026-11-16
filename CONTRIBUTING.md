# 🤝 Contributing to Tech Treasure

Thank you for your interest in contributing to **Tech Treasure Database**! We are building the highest quality personal offline-first technology knowledge base and content production studio for creators.

---

## 1. Code of Conduct

We are committed to providing a welcoming, inclusive, and harassment-free environment for everyone. Please be respectful, constructive, and collaborative in all discussions and pull requests.

---

## 2. Development Workflow

### 2.1 Branch Naming Convention
Create a feature branch branching off `main`:
- `feat/feature-name` (New features or UI screens)
- `fix/bug-description` (Bug fixes and patch corrections)
- `docs/topic-name` (Documentation updates or architectural specs)
- `refactor/subsystem` (Code refactoring without behavioral change)
- `test/test-scenario` (New unit, widget, or integration tests)

### 2.2 Conventional Commits
We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat(treasures): add reorderable steps widget to treasure detail`
- `fix(search): prevent crash when FTS query contains unescaped quotes`
- `docs(schema): document content_metrics snapshot table`
- `test(dao): add cascading delete verification test for sources`
- `refactor(pipeline): extract Kanban column widget into reusable component`

---

## 3. Architecture & Coding Standards

1. **Clean Architecture Discipline**:
   - The `domain/` layer must contain pure Dart only. Never import `flutter/material.dart`, `package:drift/...`, or third-party storage packages in `domain/`.
   - Data layer classes must map raw database rows into domain entities before returning them to callers.
2. **Explicit Error Handling**:
   - Use the `Result<T, Failure>` return type for all asynchronous repository operations. Avoid unhandled `throw Exception()`.
3. **Drift & SQLite Best Practices**:
   - Always specify explicit foreign keys with `ON DELETE CASCADE` where child records (sources, tests, metrics) belong strictly to a parent.
   - Use compiled Drift queries for performance.
4. **Code Generation**:
   - After modifying Drift tables, Freezed models, or Riverpod providers, regenerate source files:
     ```bash
     dart run build_runner build --delete-conflicting-outputs
     ```
5. **Static Analysis & Formatting**:
   - Code must pass with zero analyzer warnings:
     ```bash
     flutter analyze
     dart format --set-exit-if-changed .
     ```

---

## 4. Submitting a Pull Request

1. Ensure all existing tests pass:
   ```bash
   flutter test
   ```
2. Include comprehensive unit/widget tests for any newly added feature.
3. Update relevant documentation in [`docs/`](file:///c:/Users/DELL/StudioProjects/tech_treasure/docs) if you altered schemas or contracts.
4. Open a Pull Request against `main` with a clear description, screenshots of UI changes (both Light and Dark modes), and test verification notes.

