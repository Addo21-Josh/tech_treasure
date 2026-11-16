# 🚀 Deployment & Release Guide

This document provides step-by-step instructions for signing, packaging, and deploying **Tech Treasure Database** for production on Android and iOS.

---

## 1. Release Versioning Scheme

Tech Treasure adheres to [Semantic Versioning 2.0.0](https://semver.org/):

$$\text{MAJOR}.\text{MINOR}.\text{PATCH}+\text{BUILD}$$

- **MAJOR**: Breaking schema changes requiring major data migrations.
- **MINOR**: New features, new categories, or export enhancements.
- **PATCH**: Bug fixes, performance improvements, or UI adjustments.
- **BUILD**: Monotonically increasing build integer for app stores (e.g., `1.0.0+1`, `1.0.1+2`).

Update in `pubspec.yaml`:
```yaml
version: 1.0.0+1
```

---

## 2. Android Production Build

### 2.1 Generate Release Keystore
Generate a secure Java Keystore (JKS) if you don't already have one:

```bash
keytool -genkey -v -keystore tech_treasure_release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias techtreasure
```

### 2.2 Configure `key.properties`
Create `android/key.properties` (ensure this file is listed in `.gitignore`):

```properties
storePassword=YOUR_SECURE_STORE_PASSWORD
keyPassword=YOUR_SECURE_KEY_PASSWORD
keyAlias=techtreasure
storeFile=../tech_treasure_release.jks
```

### 2.3 Gradle Signing Configuration
Configure `android/app/build.gradle.kts` (or `build.gradle`):

```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias = keystoreProperties['keyAlias']
            keyPassword = keystoreProperties['keyPassword']
            storeFile = keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword = keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.release
            minifyEnabled = true
            shrinkResources = true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 2.4 ProGuard Rules for Drift and SQLite
Add the following to `android/app/proguard-rules.pro` to prevent R8 from stripping SQLite native libraries:

```proguard
# Drift & SQLite Native Bindings
-keep class com.simonbinder.sqlite3.** { *; }
-keep class org.sqlite.** { *; }
-keepclassmembers class * extends androidx.room.RoomDatabase { *; }
-dontwarn com.simonbinder.sqlite3.**
```

### 2.5 Build Release Artifacts

```bash
# Build Android App Bundle for Google Play Store:
flutter build appbundle --release

# Build standalone APK for direct installation/sideloading:
flutter build apk --release --split-per-abi
```

The resulting bundle is located at:  
`build/app/outputs/bundle/release/app-release.aab`

---

## 3. iOS Production Build

### 3.1 App Store Setup
1. Set Bundle Identifier in Xcode: `com.techtraasure.database`.
2. Configure **Automatic Signing** with your Apple Developer Team account or download explicit Provisioning Profiles.
3. Set minimum iOS deployment target: **iOS 13.0**.

### 3.2 Build Archive & IPA

```bash
# Clean previous builds
flutter clean
flutter pub get

# Build iOS release archive
flutter build ipa --release
```

Open Xcode Organizer or use Transporter to upload the resulting `.ipa` to TestFlight.

---

## 4. Pre-Release Verification Checklist

Before publishing any release build:

- [ ] **Analyzer Clean**: `flutter analyze` reports zero warnings or errors.
- [ ] **Tests Passing**: `flutter test` passes 100% of unit, DAO, and widget tests.
- [ ] **Database Migration Verified**: Tested upgrade path from previous version with non-empty local databases.
- [ ] **Offline Sanity Check**: App launched in Airplane Mode; all CRUD, search, and backup operations work without lag.
- [ ] **Backup Integrity Tested**: Performed JSON export, deleted app data, restored from file, and verified 100% data fidelity.
- [ ] **CSV Export Tested**: Opened exported CSV in Excel/Google Sheets to verify RFC 4180 compliance.
- [ ] **Dark Mode Audit**: Checked contrast ratios on all text and lifecycle badges in both Light and Dark themes.
- [ ] **ProGuard Verification**: Release APK installed on real Android device and launched without runtime native crash.

