# Phase 8 — CI/CD & Deployment

> **Duration:** 2-3 weeks  
> **Priority:** High  
> **Dependencies:** Phases 1-7

---

## 📋 Overview

Phase 8 establishes comprehensive CI/CD pipelines and deployment infrastructure. This phase ensures reliable, automated build and release processes for all platforms.

**Key Deliverables:**
- CI pipeline for automated testing
- CD pipeline for automated deployment
- Code signing and provisioning
- Multi-environment builds
- Release management

---

## 🎯 Goals

| Goal | Success Criteria |
|------|------------------|
| CI Pipeline | All commits are tested automatically |
| CD Pipeline | Deployments are one-click |
| Multi-Environment | Dev, Staging, Prod builds work |
| Code Signing | iOS and Android signing automated |
| Release Process | Versioning and changelogs automated |

---

## 📁 Tasks Breakdown

### Task 8.1: GitHub Actions CI Pipeline

**Estimated Time:** 2-3 days

#### Objectives
- Set up automated testing on PR
- Run linting and formatting checks
- Build apps for all platforms
- Cache dependencies for speed

#### Implementation Steps

1. **Create `.github/workflows/ci.yml`**
   ```yaml
   # Continuous Integration Pipeline
   # 
   # Runs on every push and pull request to main/develop branches.
   # Performs:
   # - Code analysis and formatting checks
   # - Unit and widget tests
   # - Build verification for all platforms
   
   name: CI
   
   on:
     push:
       branches: [main, develop]
     pull_request:
       branches: [main, develop]
   
   env:
     FLUTTER_VERSION: '3.16.0'
     JAVA_VERSION: '17'
   
   jobs:
     # ============================================
     # Code Quality Checks
     # ============================================
     analyze:
       name: Analyze
       runs-on: ubuntu-latest
       
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
         
         - name: Setup Flutter
           uses: subosito/flutter-action@v2
           with:
             flutter-version: ${{ env.FLUTTER_VERSION }}
             channel: 'stable'
             cache: true
         
         - name: Install dependencies
           run: flutter pub get
         
         - name: Check formatting
           run: dart format --set-exit-if-changed .
         
         - name: Analyze code
           run: flutter analyze --fatal-infos
         
         - name: Check for unused dependencies
           run: |
             dart pub global activate dependency_validator
             dart pub global run dependency_validator
           continue-on-error: true
   
     # ============================================
     # Unit and Widget Tests
     # ============================================
     test:
       name: Test
       runs-on: ubuntu-latest
       
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
         
         - name: Setup Flutter
           uses: subosito/flutter-action@v2
           with:
             flutter-version: ${{ env.FLUTTER_VERSION }}
             channel: 'stable'
             cache: true
         
         - name: Install dependencies
           run: flutter pub get
         
         - name: Run tests with coverage
           run: flutter test --coverage --coverage-path=coverage/lcov.info
         
         - name: Upload coverage
           uses: codecov/codecov-action@v3
           with:
             files: coverage/lcov.info
             fail_ci_if_error: false
         
         - name: Check coverage threshold
           run: |
             # Fail if coverage is below 80%
             COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | awk '{print $2}' | tr -d '%')
             if (( $(echo "$COVERAGE < 80" | bc -l) )); then
               echo "Coverage is below 80%: $COVERAGE%"
               exit 1
             fi
           continue-on-error: true
   
     # ============================================
     # Build Android
     # ============================================
     build-android:
       name: Build Android
       runs-on: ubuntu-latest
       needs: [analyze, test]
       
       strategy:
         matrix:
           flavor: [dev, staging]
       
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
         
         - name: Setup Java
           uses: actions/setup-java@v4
           with:
             distribution: 'temurin'
             java-version: ${{ env.JAVA_VERSION }}
         
         - name: Setup Flutter
           uses: subosito/flutter-action@v2
           with:
             flutter-version: ${{ env.FLUTTER_VERSION }}
             channel: 'stable'
             cache: true
         
         - name: Install dependencies
           run: flutter pub get
         
         - name: Build APK
           run: |
             flutter build apk \
               --flavor ${{ matrix.flavor }} \
               --dart-define=FLAVOR=${{ matrix.flavor }}
         
         - name: Upload APK artifact
           uses: actions/upload-artifact@v4
           with:
             name: android-${{ matrix.flavor }}-apk
             path: build/app/outputs/flutter-apk/app-${{ matrix.flavor }}-release.apk
             retention-days: 7
   
     # ============================================
     # Build iOS
     # ============================================
     build-ios:
       name: Build iOS
       runs-on: macos-latest
       needs: [analyze, test]
       
       strategy:
         matrix:
           flavor: [dev, staging]
       
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
         
         - name: Setup Flutter
           uses: subosito/flutter-action@v2
           with:
             flutter-version: ${{ env.FLUTTER_VERSION }}
             channel: 'stable'
             cache: true
         
         - name: Install dependencies
           run: flutter pub get
         
         - name: Build iOS (no codesign)
           run: |
             flutter build ios \
               --flavor ${{ matrix.flavor }} \
               --dart-define=FLAVOR=${{ matrix.flavor }} \
               --no-codesign
         
         # Note: For actual distribution, you'd need provisioning profiles
         # and certificates. See the CD workflow for signed builds.
   
     # ============================================
     # Build Web
     # ============================================
     build-web:
       name: Build Web
       runs-on: ubuntu-latest
       needs: [analyze, test]
       
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
         
         - name: Setup Flutter
           uses: subosito/flutter-action@v2
           with:
             flutter-version: ${{ env.FLUTTER_VERSION }}
             channel: 'stable'
             cache: true
         
         - name: Install dependencies
           run: flutter pub get
         
         - name: Build Web
           run: flutter build web --release
         
         - name: Upload Web artifact
           uses: actions/upload-artifact@v4
           with:
             name: web-build
             path: build/web
             retention-days: 7
   ```

2. **Create `.github/workflows/pr-check.yml`**
   ```yaml
   # Pull Request Checks
   # 
   # Runs lightweight checks on PRs for fast feedback.
   
   name: PR Check
   
   on:
     pull_request:
       types: [opened, synchronize, reopened]
   
   env:
     FLUTTER_VERSION: '3.16.0'
   
   jobs:
     quick-check:
       name: Quick Check
       runs-on: ubuntu-latest
       
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
         
         - name: Setup Flutter
           uses: subosito/flutter-action@v2
           with:
             flutter-version: ${{ env.FLUTTER_VERSION }}
             channel: 'stable'
             cache: true
         
         - name: Install dependencies
           run: flutter pub get
         
         - name: Format check
           run: dart format --set-exit-if-changed .
         
         - name: Analyze
           run: flutter analyze
         
         - name: Run tests
           run: flutter test
   
     # Check PR title follows conventional commits
     pr-title:
       name: PR Title
       runs-on: ubuntu-latest
       
       steps:
         - name: Check PR title
           uses: amannn/action-semantic-pull-request@v5
           env:
             GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
           with:
             types: |
               feat
               fix
               docs
               style
               refactor
               perf
               test
               build
               ci
               chore
               revert
             requireScope: false
   ```

#### Acceptance Criteria
- [ ] CI runs on every PR and push
- [ ] All checks must pass before merge
- [ ] Build artifacts are uploaded
- [ ] Coverage is tracked
- [ ] Dependencies are cached

---

### Task 8.2: CD Pipeline & Deployment

**Estimated Time:** 3-4 days

#### Objectives
- Automate deployment to app stores
- Set up code signing
- Implement environment-specific builds
- Create release workflows

#### Implementation Steps

1. **Create `.github/workflows/cd.yml`**
   ```yaml
   # Continuous Deployment Pipeline
   # 
   # Deploys to:
   # - Firebase App Distribution (dev/staging)
   # - Google Play Store (production)
   # - Apple TestFlight (production)
   
   name: CD
   
   on:
     push:
       tags:
         - 'v*'
     workflow_dispatch:
       inputs:
         environment:
           description: 'Deployment environment'
           required: true
           default: 'staging'
           type: choice
           options:
             - dev
             - staging
             - production
   
   env:
     FLUTTER_VERSION: '3.16.0'
     JAVA_VERSION: '17'
   
   jobs:
     # ============================================
     # Determine Version and Environment
     # ============================================
     prepare:
       name: Prepare
       runs-on: ubuntu-latest
       outputs:
         version: ${{ steps.version.outputs.version }}
         build_number: ${{ steps.version.outputs.build_number }}
         environment: ${{ steps.env.outputs.environment }}
       
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
         
         - name: Determine version
           id: version
           run: |
             if [[ "${{ github.ref }}" == refs/tags/v* ]]; then
               VERSION="${{ github.ref_name }}"
               VERSION="${VERSION#v}"
             else
               VERSION="0.0.0"
             fi
             BUILD_NUMBER="${{ github.run_number }}"
             echo "version=$VERSION" >> $GITHUB_OUTPUT
             echo "build_number=$BUILD_NUMBER" >> $GITHUB_OUTPUT
         
         - name: Determine environment
           id: env
           run: |
             if [[ "${{ github.event_name }}" == "workflow_dispatch" ]]; then
               echo "environment=${{ github.event.inputs.environment }}" >> $GITHUB_OUTPUT
             elif [[ "${{ github.ref }}" == refs/tags/v*-rc* ]]; then
               echo "environment=staging" >> $GITHUB_OUTPUT
             elif [[ "${{ github.ref }}" == refs/tags/v* ]]; then
               echo "environment=production" >> $GITHUB_OUTPUT
             else
               echo "environment=dev" >> $GITHUB_OUTPUT
             fi
   
     # ============================================
     # Build and Deploy Android
     # ============================================
     android:
       name: Android
       runs-on: ubuntu-latest
       needs: prepare
       
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
         
         - name: Setup Java
           uses: actions/setup-java@v4
           with:
             distribution: 'temurin'
             java-version: ${{ env.JAVA_VERSION }}
         
         - name: Setup Flutter
           uses: subosito/flutter-action@v2
           with:
             flutter-version: ${{ env.FLUTTER_VERSION }}
             channel: 'stable'
             cache: true
         
         - name: Install dependencies
           run: flutter pub get
         
         # Decode keystore for signing
         - name: Decode keystore
           if: needs.prepare.outputs.environment != 'dev'
           run: |
             echo "${{ secrets.ANDROID_KEYSTORE_BASE64 }}" | base64 --decode > android/app/keystore.jks
         
         # Create key.properties for signing
         - name: Create key.properties
           if: needs.prepare.outputs.environment != 'dev'
           run: |
             cat > android/key.properties <<EOF
             storePassword=${{ secrets.ANDROID_KEYSTORE_PASSWORD }}
             keyPassword=${{ secrets.ANDROID_KEY_PASSWORD }}
             keyAlias=${{ secrets.ANDROID_KEY_ALIAS }}
             storeFile=keystore.jks
             EOF
         
         # Build App Bundle for production
         - name: Build App Bundle
           if: needs.prepare.outputs.environment == 'production'
           run: |
             flutter build appbundle \
               --flavor prod \
               --dart-define=FLAVOR=prod \
               --build-name=${{ needs.prepare.outputs.version }} \
               --build-number=${{ needs.prepare.outputs.build_number }}
         
         # Build APK for dev/staging
         - name: Build APK
           if: needs.prepare.outputs.environment != 'production'
           run: |
             flutter build apk \
               --flavor ${{ needs.prepare.outputs.environment }} \
               --dart-define=FLAVOR=${{ needs.prepare.outputs.environment }} \
               --build-name=${{ needs.prepare.outputs.version }} \
               --build-number=${{ needs.prepare.outputs.build_number }}
         
         # Deploy to Firebase App Distribution
         - name: Deploy to Firebase
           if: needs.prepare.outputs.environment != 'production'
           uses: wzieba/Firebase-Distribution-Github-Action@v1
           with:
             appId: ${{ secrets.FIREBASE_ANDROID_APP_ID }}
             serviceCredentialsFileContent: ${{ secrets.FIREBASE_SERVICE_ACCOUNT }}
             groups: testers
             file: build/app/outputs/flutter-apk/app-${{ needs.prepare.outputs.environment }}-release.apk
         
         # Deploy to Google Play Store
         - name: Deploy to Play Store
           if: needs.prepare.outputs.environment == 'production'
           uses: r0adkll/upload-google-play@v1
           with:
             serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
             packageName: com.example.app
             releaseFiles: build/app/outputs/bundle/prodRelease/app-prod-release.aab
             track: internal
             status: completed
   
     # ============================================
     # Build and Deploy iOS
     # ============================================
     ios:
       name: iOS
       runs-on: macos-latest
       needs: prepare
       
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
         
         - name: Setup Flutter
           uses: subosito/flutter-action@v2
           with:
             flutter-version: ${{ env.FLUTTER_VERSION }}
             channel: 'stable'
             cache: true
         
         - name: Install dependencies
           run: flutter pub get
         
         # Install Apple certificates
         - name: Install certificates
           if: needs.prepare.outputs.environment != 'dev'
           env:
             P12_PASSWORD: ${{ secrets.IOS_P12_PASSWORD }}
             KEYCHAIN_PASSWORD: ${{ secrets.KEYCHAIN_PASSWORD }}
           run: |
             # Create temporary keychain
             security create-keychain -p "$KEYCHAIN_PASSWORD" build.keychain
             security default-keychain -s build.keychain
             security unlock-keychain -p "$KEYCHAIN_PASSWORD" build.keychain
             security set-keychain-settings -t 3600 -u build.keychain
             
             # Import certificate
             echo "${{ secrets.IOS_P12_BASE64 }}" | base64 --decode > certificate.p12
             security import certificate.p12 -k build.keychain -P "$P12_PASSWORD" -T /usr/bin/codesign
             security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$KEYCHAIN_PASSWORD" build.keychain
         
         # Install provisioning profile
         - name: Install provisioning profile
           if: needs.prepare.outputs.environment != 'dev'
           run: |
             mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
             echo "${{ secrets.IOS_PROVISIONING_PROFILE_BASE64 }}" | base64 --decode > ~/Library/MobileDevice/Provisioning\ Profiles/profile.mobileprovision
         
         # Build iOS
         - name: Build iOS
           run: |
             FLAVOR=${{ needs.prepare.outputs.environment }}
             if [ "$FLAVOR" == "production" ]; then
               FLAVOR="prod"
             fi
             
             flutter build ipa \
               --flavor $FLAVOR \
               --dart-define=FLAVOR=$FLAVOR \
               --build-name=${{ needs.prepare.outputs.version }} \
               --build-number=${{ needs.prepare.outputs.build_number }} \
               --export-options-plist=ios/ExportOptions.plist
         
         # Deploy to TestFlight
         - name: Deploy to TestFlight
           if: needs.prepare.outputs.environment == 'production'
           run: |
             xcrun altool --upload-app \
               --type ios \
               --file build/ios/ipa/*.ipa \
               --username "${{ secrets.APPLE_ID }}" \
               --password "${{ secrets.APPLE_APP_SPECIFIC_PASSWORD }}"
   
     # ============================================
     # Create GitHub Release
     # ============================================
     release:
       name: Create Release
       runs-on: ubuntu-latest
       needs: [prepare, android, ios]
       if: startsWith(github.ref, 'refs/tags/v')
       
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
           with:
             fetch-depth: 0
         
         - name: Generate changelog
           id: changelog
           uses: orhun/git-cliff-action@v2
           with:
             config: cliff.toml
             args: --latest
         
         - name: Create Release
           uses: softprops/action-gh-release@v1
           with:
             body: ${{ steps.changelog.outputs.content }}
             draft: false
             prerelease: ${{ contains(github.ref, 'rc') }}
           env:
             GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
   ```

2. **Create `ios/ExportOptions.plist`**
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>method</key>
       <string>app-store</string>
       <key>teamID</key>
       <string>YOUR_TEAM_ID</string>
       <key>uploadBitcode</key>
       <false/>
       <key>uploadSymbols</key>
       <true/>
       <key>destination</key>
       <string>upload</string>
   </dict>
   </plist>
   ```

#### Acceptance Criteria
- [ ] Production builds are signed correctly
- [ ] Firebase App Distribution receives dev/staging builds
- [ ] TestFlight receives production builds
- [ ] Play Store receives production builds
- [ ] Releases are created with changelogs

---

### Task 8.3: Version Management

**Estimated Time:** 1-2 days

#### Objectives
- Automate version bumping
- Generate changelogs
- Manage release branches

#### Implementation Steps

1. **Create `.github/workflows/version-bump.yml`**
   ```yaml
   # Version Bump Workflow
   # 
   # Automatically bumps version based on conventional commits.
   
   name: Version Bump
   
   on:
     workflow_dispatch:
       inputs:
         bump_type:
           description: 'Version bump type'
           required: true
           default: 'patch'
           type: choice
           options:
             - major
             - minor
             - patch
   
   jobs:
     bump:
       name: Bump Version
       runs-on: ubuntu-latest
       
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
           with:
             fetch-depth: 0
             token: ${{ secrets.PAT_TOKEN }}
         
         - name: Setup Node.js
           uses: actions/setup-node@v4
           with:
             node-version: '20'
         
         - name: Get current version
           id: current
           run: |
             VERSION=$(grep 'version:' pubspec.yaml | head -1 | awk '{print $2}' | tr -d '\r')
             echo "version=$VERSION" >> $GITHUB_OUTPUT
         
         - name: Calculate new version
           id: new
           run: |
             CURRENT="${{ steps.current.outputs.version }}"
             IFS='.' read -r MAJOR MINOR PATCH <<< "${CURRENT%%+*}"
             BUILD=$((${CURRENT##*+} + 1))
             
             case "${{ github.event.inputs.bump_type }}" in
               major)
                 MAJOR=$((MAJOR + 1))
                 MINOR=0
                 PATCH=0
                 ;;
               minor)
                 MINOR=$((MINOR + 1))
                 PATCH=0
                 ;;
               patch)
                 PATCH=$((PATCH + 1))
                 ;;
             esac
             
             NEW_VERSION="$MAJOR.$MINOR.$PATCH+$BUILD"
             echo "version=$NEW_VERSION" >> $GITHUB_OUTPUT
         
         - name: Update pubspec.yaml
           run: |
             sed -i "s/version: .*/version: ${{ steps.new.outputs.version }}/" pubspec.yaml
         
         - name: Commit and push
           run: |
             git config user.name "GitHub Actions"
             git config user.email "actions@github.com"
             git add pubspec.yaml
             git commit -m "chore: bump version to ${{ steps.new.outputs.version }}"
             git push
         
         - name: Create tag
           run: |
             git tag "v${{ steps.new.outputs.version }}"
             git push origin "v${{ steps.new.outputs.version }}"
   ```

2. **Create `cliff.toml`**
   ```toml
   # Changelog generation configuration
   # See: https://git-cliff.org/docs/configuration
   
   [changelog]
   header = """
   # Changelog
   
   All notable changes to this project will be documented in this file.
   
   """
   body = """
   {% if version %}\
       ## [{{ version | trim_start_matches(pat="v") }}] - {{ timestamp | date(format="%Y-%m-%d") }}
   {% else %}\
       ## [Unreleased]
   {% endif %}\
   {% for group, commits in commits | group_by(attribute="group") %}
       ### {{ group | upper_first }}
       {% for commit in commits %}
           - {% if commit.scope %}**{{ commit.scope }}**: {% endif %}{{ commit.message | upper_first }}\
       {% endfor %}
   {% endfor %}\n
   """
   trim = true
   footer = ""
   
   [git]
   conventional_commits = true
   filter_unconventional = true
   split_commits = false
   commit_parsers = [
       { message = "^feat", group = "Features" },
       { message = "^fix", group = "Bug Fixes" },
       { message = "^doc", group = "Documentation" },
       { message = "^perf", group = "Performance" },
       { message = "^refactor", group = "Refactor" },
       { message = "^style", group = "Styling" },
       { message = "^test", group = "Testing" },
       { message = "^chore\\(release\\)", skip = true },
       { message = "^chore", group = "Miscellaneous" },
   ]
   filter_commits = false
   tag_pattern = "v[0-9].*"
   skip_tags = ""
   ignore_tags = ""
   topo_order = false
   sort_commits = "oldest"
   ```

#### Acceptance Criteria
- [ ] Version can be bumped with one command
- [ ] Changelog is auto-generated
- [ ] Tags follow semver
- [ ] Build numbers auto-increment

---

### Task 8.4: Environment Configuration

**Estimated Time:** 2-3 days

*(Environment-specific configuration management)*

---

### Task 8.5: Monitoring & Alerts

**Estimated Time:** 1-2 days

*(Build and deployment monitoring)*

---

## 📊 Phase 8 Checklist

| Task | Status | Notes |
|------|--------|-------|
| 8.1 CI Pipeline | ⬜ | |
| 8.2 CD Pipeline | ⬜ | |
| 8.3 Version Management | ⬜ | |
| 8.4 Environment Config | ⬜ | |
| 8.5 Monitoring & Alerts | ⬜ | |

---

## 🔗 Dependencies

This phase requires:
- GitHub repository access
- App Store Connect access
- Google Play Console access
- Firebase project setup
- Code signing certificates

---

## 📝 Notes

- Store all secrets securely in GitHub Secrets
- Test CD pipeline with a dry run first
- Document the release process
- Set up branch protection rules
- Monitor build times and optimize
