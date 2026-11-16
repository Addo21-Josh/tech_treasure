# 🛡️ Security & Privacy Policy

Tech Treasure is engineered from the ground up as an offline-first, local-storage personal application.

---

## 1. Core Privacy Guarantees

- **100% Offline by Design**: Tech Treasure makes zero outbound HTTP/HTTPS requests during normal operations. There is no background telemetry, tracking, or crash analytics sent to remote servers.
- **Data Sovereignty**: Your discoveries, video scripts, research citations, and performance metrics reside strictly on your device inside the local SQLite database.
- **Zero Third-Party SDK Trackers**: No advertising, behavioral analytics, or third-party marketing SDKs are included in the codebase.

---

## 2. Local Storage Security

- **Database File**: The SQLite database file resides inside the protected internal app sandbox directory:
  - **Android**: `/data/data/com.techtraasure.database/databases/tech_treasure.sqlite`
  - **iOS**: `~/Library/Application Support/tech_treasure.sqlite`
- Other non-root applications on uncompromised devices cannot read this file.
- **Backups**: When exporting backups to JSON or CSV, files are saved to user-designated storage locations (Downloads, Documents, or Shared Drive). Users are responsible for safeguarding exported backup files.

---

## 3. Future Security Roadmap (Phase 2)

1. **Biometric Authentication**: Face ID / Fingerprint lock using `local_auth` to gate access to the app.
2. **Encrypted SQLite Database**: Integration with SQLCipher (`sqflite_sqlcipher`) to provide AES-256 database-at-rest encryption.
3. **Encrypted Backup Archives**: Password-protected AES-GCM encrypted ZIP backups for external storage.

---

## 4. Reporting a Security Vulnerability

If you discover a potential security vulnerability or unintentional data exposure within this repository, please do **not** open a public issue. Instead, report your findings via email to:

`security@techtraasure.app` (or contact the project maintainer directly)

Please provide:
- A description of the issue.
- Steps to reproduce.
- Potential impact.

We will acknowledge receipt within 48 hours and work on a resolution promptly.

