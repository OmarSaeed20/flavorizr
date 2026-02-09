# Phase 8 — CI/CD & Deployment

> **Duration:** 1–2 weeks | **Priority:** 🟡 Medium | **Dependencies:** Phase 7  
> **Status:** 🟡 Partially Complete (Build tasks ready, CI/CD pipeline pending)

---

## 📋 Overview

Phase 8 establishes the continuous integration and deployment pipeline for the Fast Golden Taxi app. The project already has VS Code tasks for building all flavors and a multi-flavor build configuration — this phase automates testing, building, and deploying to Firebase App Distribution, TestFlight, and Play Store.

**Existing Build Infrastructure:**
- ✅ VS Code tasks for Clean, Get Packages, Build APK/iOS per flavor
- ✅ `flutter_flavorizr` configuration (`flavorizr.yaml`)
- ✅ `scripts/build.sh` — Build script
- ✅ `scripts/flutterfire-config.sh` — Firebase config generator
- ✅ `scripts/generate_keystore.dart` — Keystore generation
- ✅ Android flavor dimensions in `android/app/build.gradle.kts`
- ✅ iOS schemes per flavor in `ios/flavors/`

---

## 🎯 Goals

| Goal | Success Criteria | Status |
|------|-----------------|--------|
| CI Pipeline | Automated lint, test, build on PR | ⬜ |
| CD Pipeline | Auto-deploy dev builds to Firebase App Distribution | ⬜ |
| Flavor Builds | Automated APK/IPA for dev/staging/prod | ✅ Tasks Ready |
| Code Quality | Lint + analyze gate on PRs | ⬜ |
| Test Automation | Run `flutter test` in CI | ⬜ |
| Staging Deployment | Auto-deploy staging to TestFlight/Play Internal | ⬜ |
| Production Release | Manual approval + deploy to stores | ⬜ |
| Version Management | Semantic versioning with changelog | ⬜ |

---

## 📁 Tasks Breakdown

### Task 8.1: GitHub Actions CI Pipeline ⬜
**Estimated Time:** 2–3 days

**Objectives:**
- Run on every PR to `main` and `develop`
- Steps: checkout → setup Flutter → pub get → analyze → test → build

**Workflow: `.github/workflows/ci.yml`**
```yaml
name: CI
on:
  pull_request:
    branches: [main, develop]
  push:
    branches: [develop]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
      - run: flutter pub get
      - run: flutter analyze
      - run: dart format --set-exit-if-changed lib/ test/

  test:
    runs-on: ubuntu-latest
    needs: analyze
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v4
        with:
          file: coverage/lcov.info

  build-android:
    runs-on: ubuntu-latest
    needs: test
    strategy:
      matrix:
        flavor: [dev, staging]
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build apk --flavor=${{ matrix.flavor }} --dart-define=FLAVOR=${{ matrix.flavor }}
      - uses: actions/upload-artifact@v4
        with:
          name: apk-${{ matrix.flavor }}
          path: build/app/outputs/flutter-apk/

  build-ios:
    runs-on: macos-latest
    needs: test
    strategy:
      matrix:
        flavor: [dev, staging]
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build ios --flavor=${{ matrix.flavor }} --dart-define=FLAVOR=${{ matrix.flavor }} --no-codesign
```

---

### Task 8.2: Firebase App Distribution (Dev) ⬜
**Estimated Time:** 1–2 days

**Objectives:**
- Auto-deploy dev APK to Firebase App Distribution on push to `develop`
- Notify testers via Firebase

**Workflow: `.github/workflows/deploy-dev.yml`**
```yaml
name: Deploy Dev
on:
  push:
    branches: [develop]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build apk --flavor=dev --dart-define=FLAVOR=dev
      - uses: wzieba/Firebase-Distribution-Github-Action@v1
        with:
          appId: ${{ secrets.FIREBASE_APP_ID_DEV }}
          serviceCredentialsFileContent: ${{ secrets.FIREBASE_CREDENTIALS }}
          groups: internal-testers
          file: build/app/outputs/flutter-apk/app-dev-release.apk
```

---

### Task 8.3: Staging & Production Deployment ⬜
**Estimated Time:** 2–3 days

**Objectives:**
- Staging: Auto-deploy on release branch creation
- Production: Manual approval + store submission

**Staging Flow:**
1. Create branch `release/x.y.z` from `develop`
2. CI builds staging APK + IPA
3. Deploy to Play Store Internal Testing + TestFlight
4. QA team tests

**Production Flow:**
1. Merge `release/x.y.z` to `main`
2. CI builds prod APK + IPA
3. Manual approval in GitHub Actions
4. Submit to Play Store + App Store Connect

---

### Task 8.4: Version Management ⬜
**Estimated Time:** 1 day

**Objectives:**
- Semantic versioning in `pubspec.yaml`
- Auto-generate changelog from conventional commits
- Git tagging for releases

**Version Scheme:**
```
x.y.z+build
│ │ │   │
│ │ │   └── Build number (auto-increment in CI)
│ │ └────── Patch (bug fixes)
│ └──────── Minor (new features)
└────────── Major (breaking changes)
```

---

### Task 8.5: Existing VS Code Tasks ✅

**Available build tasks (already configured in `.vscode/tasks.json`):**

| Task | Command | Flavor |
|------|---------|--------|
| Flutter: Clean | `flutter clean` | — |
| Flutter: Get Packages | `flutter pub get` | — |
| Flutter: Build APK (Dev) | `flutter build apk --flavor=dev` | dev |
| Flutter: Build APK (Staging) | `flutter build apk --flavor=staging` | staging |
| Flutter: Build APK (Prod) | `flutter build apk --flavor=prod` | prod |
| Flutter: Build iOS (Dev) | `flutter build ios --flavor=dev` | dev |
| Flutter: Build iOS (Staging) | `flutter build ios --flavor=staging` | staging |
| Flutter: Build iOS (Prod) | `flutter build ios --flavor=prod` | prod |
| Flutter: Run Tests | `flutter test` | — |
| Flutter: Analyze | `flutter analyze` | — |
| Dart: Format | `dart format lib/ test/` | — |
| Flutter: Doctor | `flutter doctor -v` | — |

---

### Task 8.6: PR Template & Quality Gates ⬜
**Estimated Time:** 0.5 days

**Objectives:**
- PR template with checklist
- Required checks before merge
- Branch protection rules

**PR Template (`.github/pull_request_template.md`):**
```markdown
## Description
<!-- What does this PR do? -->

## Type
- [ ] Feature
- [ ] Bug Fix
- [ ] Refactor
- [ ] Documentation

## Checklist
- [ ] Code follows project style guide
- [ ] Tests added/updated
- [ ] No new lint warnings
- [ ] Tested on Android & iOS
- [ ] Figma design matched
- [ ] API documentation reviewed
```

---

## 📊 Acceptance Criteria

- [ ] CI pipeline runs on every PR (analyze → test → build)
- [ ] Dev builds auto-deploy to Firebase App Distribution
- [x] All 3 flavors build successfully via VS Code tasks
- [ ] Staging deploys to Play Internal + TestFlight
- [ ] Production requires manual approval before store submission
- [ ] Coverage reports generated and uploaded
- [ ] PR template enforces quality checklist
- [ ] Version bumping automated with changelog generation

---

## 🔗 Phase 8 → Phase 9 Dependencies

| Phase 8 Output | Used By Phase 9 |
|----------------|-----------------|
| CI/CD pipeline | Automated doc generation |
| Version management | API documentation versioning |
| PR template | Documentation review process |
| Build artifacts | Release notes generation |
