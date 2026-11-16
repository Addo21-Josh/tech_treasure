# Product Requirements Document (PRD)

# Tech Treasure Database

**Product Name:** Tech Treasure Database  
**Working Name:** Tech Treasure  
**Platform:** Flutter Mobile Application (Android / iOS / Desktop ready)  
**Architecture:** Offline-first Clean Architecture  
**Primary Storage:** Local SQLite database via Drift  
**Backend:** None for MVP (Standalone offline-first)  
**Internet:** Optional / Not required  
**Target User:** Technology content creator / researcher  
**MVP Timeline:** 2–4 weeks  
**Document Version:** 1.0  
**Status:** MVP Product Specification  

---

## 1. Product Vision

Tech Treasure is a personal offline-first Flutter application that helps technology content creators collect, organize, research, verify, test, script, and track useful technology discoveries.

Instead of keeping technology ideas scattered across WhatsApp, notes, screenshots, browser bookmarks, Google Docs, saved videos, and paper, the user has one searchable personal technology knowledge base.

### Core Philosophy

> Capture → Research → Verify → Test → Create → Publish → Learn

---

## 2. The Problem

When researching technology content, ideas appear everywhere.

For example:

> “Your phone can control your computer.”

A creator might discover the idea on YouTube, search Google for more information, test it, discover that it only works on certain Android or Windows versions, and later forget the source, exact steps, requirements, limitations, or whether it was personally tested.

Tech Treasure solves this by giving every discovery a structured record.

---

## 3. Target User

### Primary User

A technology content creator who creates educational content around:

- Smartphones
- Computers
- WhatsApp
- Internet
- Productivity
- Digital safety
- Device tricks
- Phone/computer integration

### MVP User Model

The application is initially single-user and personal.

There is:

- No account
- No login
- No cloud backend
- No subscription
- No social network

---

## 4. Product Goals

### Primary Goals

1. Capture technology ideas quickly.
2. Organize ideas into useful categories.
3. Track research and verification.
4. Record exact steps and requirements.
5. Track content production.
6. Search accumulated knowledge quickly.
7. Work completely offline.
8. Maintain reliable personal backups.

---

## 5. Non-Goals for MVP

Do not build the following during the first version:

- User accounts
- Cloud synchronization
- Social features
- AI generation
- Automatic web scraping
- YouTube API integration
- Analytics API integrations
- Collaborative editing
- Subscriptions
- Advertisements
- Complex media management
- Desktop/web application (build mobile-first, though Flutter supports multi-platform)

These may be considered in future phases.

---

## 6. Core Concept: Treasure

Every piece of knowledge is a “Treasure.”

A Treasure represents one useful technology discovery.

### Example

**Title:**  
Turn Your Android Phone Into a PC Mouse

**Category:**  
Phone + PC

**Problem:**  
User does not have a mouse.

**Solution:**  
Use a phone as a wireless mouse.

**Device:**  
Android

**Platform:**  
Windows

**Requirements:**

- Android phone
- Windows PC
- Compatible connection/application

**Status:**  
Verified

**Content Status:**  
Published

---

## 7. Treasure Lifecycle

Every Treasure can move through a content/research pipeline:

```text
IDEA
 ↓
RESEARCHING
 ↓
TESTING
 ↓
VERIFIED
 ↓
READY TO CREATE
 ↓
SCRIPTED
 ↓
RECORDED
 ↓
EDITED
 ↓
PUBLISHED
```

The user should not be forced to complete every stage. For example, a Treasure may move directly from IDEA to VERIFIED after testing.

---

## 8. Main Features

### 8.1 Dashboard

The home screen provides a quick overview of the knowledge base and content pipeline.

#### Dashboard Metrics

- Total Treasures
- Ideas
- Researching
- Testing
- Verified
- Ready to Create
- Published

#### Quick Actions

- Add Treasure
- Search
- Pipeline
- Favorites

---

## 9. Add Treasure

Adding a Treasure should be fast.

### Required Fields

- **Title**: e.g., "Turn Phone Into PC Mouse"
- **Category**: Phone Tricks, WhatsApp, Windows, Phone + PC, Internet, Security, Productivity, Ghana/Africa Tech, Other
- **Short Description**: e.g., "Use an Android phone as a wireless mouse."
- **Status**: Default is `Idea`

### Optional Fields

- Problem
- Solution
- Device
- Operating System
- Requirements
- Source
- Tags
- Notes
- Content Potential (1–5 Stars)
- No App Needed (Boolean)

---

## 10. Quick Capture

The user should be able to capture an idea without completing the entire form.
A floating bottom sheet / quick dialog with only Title, Category, and quick notes allows capturing in under 5 seconds.

---

## 11. Treasure Detail

The Treasure Detail screen is the heart of the application:

- **Header**: Title, Status badge, Favorite toggle, Edit button, Share/Copy actions
- **Overview**: Problem, Solution, Why useful
- **Compatibility**: Device, Platform, Operating system, OS version, Supported versions
- **Requirements**: Hardware, software, connectivity prerequisites
- **Steps**: Reorderable step-by-step instructions
- **Limitations**: Known constraints or edge cases
- **Security Notes**: Privacy or safety implications
- **Research**: Citation sources, URLs, research notes, dates
- **Testing**: Test device, OS version, result (Works, Partially Works, Does Not Work), date, testing notes
- **Content**: Hook, Script, CTA, Content format, Content status

---

## 12. Research Management

- **Research States**: Not Researched, Researching, Research Complete
- **Sources**: Multiple sources per Treasure with Source Name, Source Type (Official Documentation, YouTube, Reddit, Blog, Forum, Personal Discovery, Other), Source URL, Research Notes

---

## 13. Verification

Verification is a core differentiator:

- **Verification Status**: Unverified, Researching, Verified, Failed
- **Verification Checklist**:
  - [ ] Source checked
  - [ ] Steps confirmed
  - [ ] Personally tested
  - [ ] Compatibility checked
  - [ ] Limitations documented
  - [ ] Security checked

---

## 14. Testing

Multi-device empirical test logs:
- Tested: Yes / No
- Test Device (e.g., Samsung Galaxy S24)
- OS Version (e.g., Android 16)
- Test Environment (e.g., Windows 11)
- Result: Works / Partially Works / Does Not Work
- Notes
- Test Date

---

## 15. Content Creation

Once verified, transform knowledge into production scripts:
- **Content Type**: TikTok, Instagram Reel, YouTube Short, YouTube Video, Facebook Reel, Blog, Other
- **Hook**: e.g., "Did you know your phone can replace your computer mouse?"
- **Problem**: Opening hook & problem formulation
- **Demonstration**: Step-by-step screen / camera plan
- **CTA**: Call to action (e.g., "Follow for more useful technology tricks.")
- **Script**: Full Markdown text editor

---

## 16. Content Pipeline (Kanban Board)

Interactive pipeline view:
`IDEAS` → `RESEARCH` → `TESTING` → `VERIFIED` → `SCRIPTED` → `RECORDED` → `EDITED` → `PUBLISHED`

Supports card dragging or quick tap-to-move sheet.

---

## 17. Search & Filtering

- **Offline Full-Text Search (FTS5)** across titles, descriptions, problems, solutions, notes, tags, devices, scripts, research.
- **Filters**: Category, Status, Device/Platform, Content Type, Verification status, No App Needed flag, Content Potential rating.

---

## 18. Backup & Export

- **JSON Backup**: Complete relational database export with metadata, schema versioning, and checksum validation.
- **JSON Restore**: Safe dry-run validation, diff confirmation, atomic transactional restore.
- **CSV Export**: Flattened export suitable for Excel or Google Sheets analysis.

---

## 19. Architecture & Tech Stack

- **Framework**: Flutter (Dart 3.x)
- **Architecture**: Feature-first Clean Architecture
- **State Management**: Riverpod (AsyncNotifier / code generation)
- **Database**: SQLite via Drift + FTS5
- **Navigation**: go_router
- **Theme**: Material 3 with Deep Slate & Amber/Gold accents

