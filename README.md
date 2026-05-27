# PhytoGuard — Plant Species & Disease Recognition Mobile App

<p align="center">
  <strong>Flutter · Firebase · TensorFlow Lite</strong><br>
  Offline ML–powered plant health monitoring app developed as a graduation thesis project
</p>

> **Language:** This README is in English for GitHub and portfolio use. The thesis document and in-app copy are available in Turkish (TR) and English (EN).

---

## Table of Contents

1. [About the Project](#about-the-project)
2. [Key Features](#key-features)
3. [Screenshots](#screenshots)
4. [Tech Stack](#tech-stack)
5. [System Architecture](#system-architecture)
6. [Machine Learning](#machine-learning)
7. [Firebase & Data Model](#firebase--data-model)
8. [Project Structure](#project-structure)
9. [Installation](#installation)
10. [Configuration (.env)](#configuration-env)
11. [Running the App](#running-the-app)
12. [Optional Backend](#optional-backend)
13. [Deploying Firebase Rules](#deploying-firebase-rules)
14. [Localization](#localization)
15. [Known Limitations](#known-limitations)
16. [License & Thesis](#license--thesis)

---

## About the Project

**PhytoGuard** (`bitirme_mobile`) is a mobile application that lets users estimate **plant species** and **general disease class** from photos of leaves or whole plants. It was built to deploy deep learning models trained for a graduation thesis, persist results in the cloud, and track health over time.

The app is a **decision-support** tool only; it does not replace professional plant pathology or official agricultural reporting. All predictions are shown with confidence scores; low confidence or “sink” (easily misclassified) species are marked as **unrecognized**.

### What it does

| Area | Description |
|------|-------------|
| **Species recognition** | ~93-class PlantNet-based EfficientNetB3–style TFLite model |
| **Disease classification** | 5 classes: healthy, blight, mold, powdery mildew, rust |
| **Multi-region** | Multiple plants/regions in one photo; each region analyzed and saved separately |
| **History** | Scans grouped by species label; detail view, PDF, species/disease info pages |
| **Health progress** | 14/30-day disease trend chart and photo timeline per species |
| **Cloud sync** | Firebase Auth, Firestore, Storage |
| **On-device inference** | TFLite on mobile/desktop without a network connection |
| **Daily tip** | Contextual care tips from recent scans (OpenAI or local templates) |
| **Notifications** | Risk alerts for low health scores; follow-up reminders |
| **PDF report** | Shareable / downloadable report per scan |

---

## Key Features

### Authentication & onboarding

- Email/password sign-up and sign-in
- Google Sign-In
- Forgot-password flow
- First-launch language picker (Turkish / English) and onboarding slides
- Session cached locally and synced with Firebase Auth

### Home (dashboard)

- Personalized greeting
- Quick actions: scan, history, guide, settings
- Central scan call-to-action card
- **Daily tip** banner (context from last 5 days of scans)
- Recent scans horizontal strip
- Summary stats: total scans, unique species, disease count, low-score records

### Scan wizard

Full-screen step-by-step flow:

1. **Pick image** — camera or gallery (long edge capped at ~2048 px)
2. **Select regions** — normalized rectangles; drag-to-draw or default square
3. **Species analysis** — sequential model inference per region
4. **Species results** — per-region list
5. **Disease analysis** — 5-class model per region
6. **Summary** — species, disease, confidence; PDF; save

**Save rules:**

- Species confidence **below 60%** → unrecognized, not saved to history
- **78%** threshold for “sink” species
- Disease confidence **below 60%** → stored as `unknown` (“Disease unknown”)
- **Save savable regions** only writes regions with recognized species and completed disease analysis

**Multi-region save:**

- Each savable region creates a separate `scans` document
- Only that region’s **cropped JPEG** is uploaded to Storage (no mixed frames in history)
- Different species in one photo → each region is linked to the **plant record for its species label** automatically (no plant picker dialog)
- Same species → uses the plant with the most recent scan, or creates a new plant if none exists

### Scan history

- List grouped by `speciesLabel`
- Search
- Detail: large image, species/disease rows, confidence indicator
- Navigation to species and disease detail pages
- PDF share / download

### Health progress

- Dropdown of all scans with a species label in history
- 14- or 30-day window
- Disease-class time series via `fl_chart`
- Chronological photo strip with full-screen preview

### Profile & settings

- Profile photo (Firebase Storage + Firestore `photoUrl`)
- Personal info: name, phone, bio, email (read-only email for Google accounts)
- Privacy and password reset
- Theme: light / dark / system
- Language and notification toggle (`SharedPreferences`)

### Guide & about

- Tips for good photos and app usage
- Project / thesis-oriented information screens

### Bottom navigation

| Tab | Purpose |
|-----|---------|
| Home | Dashboard |
| History | Scan list |
| **FAB** | Scan wizard |
| Progress | Health progress |
| Menu | Guide, profile, settings, about |

---

## Screenshots

Add your app screenshots below. Place them all in this section, one after another. Optional captions can go directly above each image.

<br>

<!-- ═══════════════════════════════════════════════════════════════════ -->
<!--  ADD YOUR SCREENSHOTS FROM HERE                                   -->
<!--  Example: ![Caption](docs/screenshots/01-splash.png)            -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

<!-- Blank lines above leave room while editing; remove extras after adding images. -->

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter 3.8+ (Dart 3.8+) |
| UI | Material Design 3, Google Fonts, responsive_framework |
| State | Riverpod 2.x |
| Navigation | go_router 14.x |
| DI | get_it |
| i18n | flutter gen-l10n (TR / EN) |
| Auth | Firebase Auth, Google Sign-In |
| Database | Cloud Firestore |
| File storage | Firebase Storage |
| ML inference | TensorFlow Lite (`tflite_flutter`) |
| Imaging | image_picker, image (crop / JPEG) |
| Charts | fl_chart |
| PDF | pdf, printing |
| Notifications | flutter_local_notifications, timezone |
| Secrets | envied + `.env` |
| Codegen | build_runner, flutter_gen, json_serializable |

---

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation (Flutter UI)                 │
│  features/: home, scan, history, health_progress, auth, …    │
└──────────────────────────┬──────────────────────────────────┘
                           │ Riverpod Providers
┌──────────────────────────▼──────────────────────────────────┐
│              Business logic / Notifiers                        │
└──────────────────────────┬──────────────────────────────────┘
                           │ get_it (Service Locator)
┌──────────────────────────▼──────────────────────────────────┐
│  core/services/                                              │
│  · InferenceApiService (Mock / TFLite / HTTP)                │
│  · PlantScansFirestoreService, PlantsFirestoreService        │
│  · FirebaseStorageService, UserProfileFirestoreService       │
│  · ImageCropService, PdfReportService, NotificationService   │
│  · DailyTipApiService, CatalogFirestoreService               │
└───────┬──────────────────────────────┬──────────────────────┘
        │                              │
        ▼                              ▼
┌───────────────┐              ┌──────────────────┐
│ TFLite assets │              │ Firebase         │
│ (on-device)   │              │ Auth · Firestore │
│               │              │ · Storage        │
└───────────────┘              └──────────────────┘
```

**Startup order** (`AppInitializers`):

1. Initialize Firebase  
2. Local timezone (`timezone`)  
3. Register services (`service_locator.dart`)  
4. Load ML metadata (class lists, PlantNet map, sink classes)  
5. Notification channels  
6. Restore saved language and theme  

---

## Machine Learning

### Model files (`assets/ml/`)

| File | Role |
|------|------|
| `plant_species_model.tflite` | Species classifier (~93 classes) |
| `class_names.json` | Species class labels |
| `plantnet_species_id_map.json` | PlantNet ID → display name |
| `sink_classes.json` | Classes that use a stricter confidence threshold |
| `disease_5class.tflite` | 5-class disease model |
| `disease_class_names_5class.json` | Disease class keys |

### Disease classes

| Key | Meaning |
|-----|---------|
| `healthy` | Healthy |
| `blight` | Blight |
| `mold` | Mold |
| `powdery_mildew` | Powdery mildew |
| `rust` | Rust |

### Inference modes (`.env`)

| Mode | `USE_MOCK_INFERENCE` | `USE_LOCAL_TFLITE` | Description |
|------|----------------------|--------------------|-------------|
| Local TFLite | `false` | `true` | Recommended; offline |
| HTTP API | `false` | `false` | `API_BASE_URL` → `/predict/species`, `/predict/disease` |
| Mock | `true` | — | Development / testing |

**Preprocessing:** Decode image → resize to model input → softmax → top class + alternatives.

**Health score:** Integer 0–100 derived from disease key and confidence (`computeHealthScore`).

---

## Firebase & Data Model

### Firestore collections

| Collection | Description |
|------------|-------------|
| `users/{uid}` | Profile: email, displayName, photoUrl, phone, bio, authProvider |
| `plants/{id}` | User’s physical plant record (species label, last score, photo) |
| `scans/{id}` | Scan: species, disease, confidence, healthScore, imageUrl, plantId |
| `species/{id}` | Shared species catalog (auto-populated) |
| `diseases/{id}` | Shared disease catalog (`unknown` is not written) |

### Storage paths

| Path | Content |
|------|---------|
| `scans/{userId}/{scanId}.jpg` | Scan / region crop photo |
| `users/{userId}/profile.jpg` | Profile photo |

### Security rules

- `firestore.rules` — user data only when `ownerUid == auth.uid`
- `storage.rules` — per-user folder isolation

Rules must be **published** in Firebase Console:

```bash
firebase deploy --only firestore,storage
```

---

## Project Structure

```
bitirme_mobile/
├── android/                 # Android native
├── ios/                     # iOS native
├── assets/
│   ├── ml/                  # TFLite models and JSON labels
│   ├── colors/
│   └── fonts/
├── backend/                 # Optional FastAPI (daily tip)
├── lib/
│   ├── main.dart
│   ├── models/              # PlantScanModel, PlantModel, UserProfileModel, …
│   ├── core/
│   │   ├── navigation/      # app_router, app_paths
│   │   ├── services/        # Firebase, ML, PDF, notifications, …
│   │   ├── enums/
│   │   ├── widgets/
│   │   └── env/
│   ├── features/
│   │   ├── auth/
│   │   ├── home/
│   │   ├── scan/
│   │   ├── history/
│   │   ├── health_progress/
│   │   ├── profile/
│   │   ├── settings/
│   │   └── …
│   ├── l10n/                # app_tr.arb, app_en.arb
│   ├── gen/                 # flutter_gen output
│   └── service_locator/
├── firestore.rules
├── storage.rules
├── firebase.json
├── .env.example
└── pubspec.yaml
```

---

## Installation

### Requirements

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.8
- Android Studio / Xcode (target platform)
- Firebase project with Auth, Firestore, and Storage enabled
- `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) added to the project

### Steps

```bash
# Clone the repository
git clone <repo-url>
cd bitirme_mobile

# Dependencies
flutter pub get

# Environment file
cp .env.example .env
# Edit .env (see below)

# Code generation (envied, l10n, etc.)
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n

# Firebase setup (if using FlutterFire CLI)
# flutterfire configure
```

---

## Configuration (.env)

`.env` is **not** committed to git. Copy from `.env.example`:

| Variable | Description |
|----------|-------------|
| `API_BASE_URL` | HTTP inference server base (e.g. `http://127.0.0.1:8000`) |
| `USE_MOCK_INFERENCE` | `true` → random mock predictions |
| `USE_LOCAL_TFLITE` | `true` → on-device TFLite (recommended) |
| `GOOGLE_WEB_CLIENT_ID` | Google Sign-In web client ID |
| `OPENAI_API_KEY` | For daily tip (optional) |
| `OPENAI_MODEL` | e.g. `gpt-4o-mini` |
| `USE_AI_DAILY_TIP` | `true` → OpenAI-generated tip |
| `USE_MOCK_DAILY_TIP` | `true` → template tip |

After changes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Running the App

```bash
# List devices / emulators
flutter devices

# Debug run
flutter run

# Release APK (Android)
flutter build apk --release
```

**Note:** On web builds, local TFLite may be unavailable due to FFI limits; use HTTP or mock mode instead.

---

## Optional Backend

The `backend/` folder contains a lightweight FastAPI service (e.g. daily tip proxy). The mobile app can also call OpenAI directly via `.env`.

```bash
cd backend
python -m venv .venv
.venv\Scripts\activate          # Windows
pip install -r requirements.txt
cp .env.example .env            # Set OPENAI_API_KEY
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

---

## Deploying Firebase Rules

`firestore.rules` and `storage.rules` are included in the repo. Paste them in the Console or deploy via CLI:

```bash
firebase login
firebase use <project-id>
firebase deploy --only firestore,storage
```

Unpublished rules cause `permission-denied` errors (especially for `species` / `diseases` catalog writes and Storage uploads).

---

## Localization

- Source files: `lib/l10n/app_tr.arb`, `lib/l10n/app_en.arb`
- After editing ARB: `flutter gen-l10n`
- Language picker on first launch

---

## Known Limitations

- TFLite is fully supported on Android, iOS, and desktop native targets; web support is limited.
- Model outputs depend on training data and conditions; poor lighting, blur, or off-topic images often yield “unrecognized”.
- Multiple pots of the same species auto-link to the **most recently scanned** plant record (no manual picker).
- OpenAI daily tips require a valid API key; otherwise local template text is used.

---

## License & Thesis

This project was developed for academic purposes as a **graduation thesis**. Model training, datasets, and experimental results are described in the thesis document.

**Author:** İpek Özsaşılar  
**Institution / program:** (Add your thesis details here)

---

<p align="center">
  <sub>PhytoGuard — Photograph your plants, track species and health over time.</sub>
</p>
