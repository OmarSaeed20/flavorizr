# Phase 0 — Foundations & Architecture

> **Duration:** 2–3 weeks | **Priority:** 🔴 Critical | **Dependencies:** None  
> **Status:** ✅ Complete

---

## 📋 Overview

Phase 0 establishes the architectural skeleton of the **Fast Golden Taxi** multi-role ride-hailing app. This foundation supports three distinct user roles — Consumer, Driver, and Company — each with their own navigation shell, feature modules, and API surface.

**Figma Design References:**
- 🟢 Consumer: [Figma Page (node 0-1)](https://www.figma.com/design/YzQcnOIa7TG5auHuL04M9O/Fast-Golden-Taxi--Copy-?node-id=0-1)
- 🔵 Driver: [Figma Page (node 2-37588)](https://www.figma.com/design/YzQcnOIa7TG5auHuL04M9O/Fast-Golden-Taxi--Copy-?node-id=2-37588)
- 🟣 Company: [Figma Page (node 2-61931)](https://www.figma.com/design/YzQcnOIa7TG5auHuL04M9O/Fast-Golden-Taxi--Copy-?node-id=2-61931)

**API Base URL:** `https://fasttaxi.questifysolutions.com/api/v1`

**Key Deliverables:**
- ✅ Clean Architecture project structure (data/domain/presentation per feature)
- ✅ Multi-flavor build system (dev/staging/prod) via `flutter_flavorizr`
- ✅ Theme system with light/dark mode (`flex_color_scheme`)
- ✅ Role-based GoRouter navigation (Consumer, Driver, Company shells)
- ✅ Dio HTTP client with auth interceptor & automatic token refresh
- ✅ WebSocket infrastructure for real-time features
- ✅ Firebase integration (Core, Auth, Crashlytics, Analytics, Messaging, Remote Config)
- ✅ Riverpod state management with annotation-based code generation
- ✅ Error handling framework (typed failures, exception mapping, error boundaries)
- ✅ Responsive UI framework with breakpoints & adaptive widgets
- ✅ Localization setup (l10n with ARB files, `Accept-Language` header)
- ✅ Performance monitoring & image caching infrastructure

---

## 🎯 Goals

| Goal | Success Criteria | Status |
|------|-----------------|--------|
| Scalable Architecture | Clean Architecture with feature-based modules for 3 roles | ✅ |
| Multi-Flavor Builds | dev/staging/prod flavors with separate Firebase configs | ✅ |
| Theme System | Light/dark mode, dynamic colors, OLED black | ✅ |
| Navigation | GoRouter with auth/onboarding/role guards, 80+ routes | ✅ |
| Network Layer | Dio + 5 interceptors (auth, logging, retry, analytics, performance) | ✅ |
| Real-time Infra | WebSocket client with auto-reconnection & event handling | ✅ |
| Firebase | Core, Crashlytics, Analytics, FCM, Remote Config | ✅ |
| State Management | Riverpod with `riverpod_generator` code-gen | ✅ |
| Error Handling | Typed failures, DioException mapping, ErrorBoundary widget | ✅ |
| Responsive UI | Breakpoints, adaptive scaffold, spacing tokens | ✅ |
| Localization | ARB-based l10n with runtime locale switching | ✅ |

---

## 📁 Implemented Structure

### Project Layout
```
lib/
├── app.dart                      # MaterialApp.router (theme, localization, router)
├── bootstrap.dart                # 17-step initialization sequence
├── main.dart                     # Flavor → bootstrap()
├── observers.dart                # App lifecycle observers
├── config/
│   ├── app_config.dart           # Per-flavor configuration
│   ├── flavors.dart              # Flavor enum (dev/staging/prod)
│   └── firebase/                 # Per-flavor Firebase options
├── core/
│   ├── accessibility/            # Semantic widgets, focus helpers
│   ├── di/providers.dart         # Riverpod DI providers
│   ├── error/                    # Failures, ErrorBoundary, ErrorHandler
│   ├── localization/             # Locale controller & service
│   ├── logger/                   # Talker-based logging with UI viewer
│   ├── network/                  # Dio, WebSocket, interceptors, base classes
│   │   ├── api/                  # Endpoint constants, models, parameters, repos, services
│   │   ├── base/                 # BaseRemoteDataSource, BaseLocalDataSource, BaseRepository
│   │   ├── exception/            # NetworkException types, DioException handler
│   │   ├── interceptors/         # Auth, Logging, Retry, Analytics, Performance
│   │   ├── resluts/              # ApiResult<T> (freezed union type)
│   │   └── websocket/            # WebSocket client, manager, event handler
│   ├── performance/              # Image cache, lazy loading, profiler
│   ├── platform/                 # Adaptive widgets, platform detection
│   ├── router/                   # GoRouter config, guards, routes, transitions
│   ├── services/                 # Notification service (FCM)
│   ├── theme/                    # App theme, color schemes, typography, controller
│   └── ui/responsive/            # Breakpoints, spacing, responsive widgets
├── features/                     # Feature modules (see Phase 1+)
├── l10n/                         # ARB localization files
├── services/                     # Firebase service, analytics, crashlytics
└── shared/                       # Base UseCase, shared widgets
```

### Feature Module Template
```
feature_name/
├── data/
│   ├── datasources/       # Remote (API) + Local (storage) data sources
│   ├── endpoints/         # API endpoint path constants
│   ├── models/            # Freezed data models with JSON serialization
│   ├── parameters/        # Typed request parameter classes
│   └── repositories/      # Repository implementations
├── domain/
│   ├── entities/          # Business entities (freezed)
│   ├── repositories/      # Repository interfaces (abstract)
│   └── usecases/          # Use case classes (single responsibility)
└── presentation/
    ├── controllers/       # Riverpod controllers / state notifiers
    ├── pages/             # Screen widgets
    ├── providers/         # Riverpod providers
    └── widgets/           # Reusable feature-specific widgets
```

---

### Route Architecture (80+ Routes)

| Role | Prefix | Shell Type | Screens |
|------|--------|-----------|---------|
| **Auth** | `/auth/` | None | login, register, forgot-password, reset-password, verify-email, role-selection |
| **Consumer** | `/consumer/` | BottomNav | home, location-search, ride-options, direct-booking, tracking, trip details, payments, wallet, saved-places, profile, settings, chat, support |
| **Driver** | `/driver/` | BottomNav | home, earnings, trips, profile, documents, vehicle, reviews, schedule, settings |
| **Company** | `/company/` | BottomNav | dashboard, analytics, fleet, drivers, trips, earnings, settings, zones |
| **Shared** | `/` | None | splash, onboarding, error, 404 |

### Navigation Guard Chain
1. **AuthGuard** — Validates token in `FlutterSecureStorage`
2. **OnboardingGuard** — Checks `SharedPreferences` for completion
3. **UserRoleGuard** — Routes to Consumer/Driver/Company shell by stored role

---

### Network Layer

**API Client:** Singleton `ApiClient` wrapping Dio with base URL `https://fasttaxi.questifysolutions.com/api/v1`

**Interceptors:**
1. `AuthInterceptor` — Attaches `Bearer {token}`, auto-refreshes on 401 via `POST /driver/auth/refresh`
2. `LoggingInterceptor` — Debug-mode request/response logging
3. `RetryInterceptor` — Exponential backoff for transient failures
4. `AnalyticsInterceptor` — API call event tracking
5. `PerformanceInterceptor` — Response time measurement

**Auth Token Storage Keys:**
- `auth_access_token` — JWT access token (FlutterSecureStorage)
- `auth_refresh_token` — Refresh token (FlutterSecureStorage)
- `auth_access_token_expiry` — Token expiry timestamp (FlutterSecureStorage)
- `auth_user` — Cached user JSON (SharedPreferences)

---

## 📊 Acceptance Criteria

- [x] App builds for all 3 flavors on Android & iOS
- [x] Light/dark themes render correctly
- [x] Auth guard redirects unauthenticated users to `/auth/login`
- [x] Role guard routes to correct shell (consumer/driver/company)
- [x] API client attaches Bearer token and refreshes on 401
- [x] WebSocket client connects with auto-reconnection
- [x] Firebase services initialize (Crashlytics, Analytics, FCM)
- [x] Error boundaries catch and display widget-level errors
- [x] Localization framework supports Arabic & English
- [x] Responsive layouts adapt to phone/tablet

---

## 🔗 Phase 0 → Phase 1 Dependencies

| Phase 0 Output | Used By Phase 1 |
|----------------|-----------------|
| GoRouter + auth guards | Auth flow routing & redirects |
| Dio + AuthInterceptor | Login/Register/Verify API calls |
| BaseRemoteDataSource | Auth remote data source |
| BaseLocalDataSource | Token & user caching |
| BaseRepository | Auth repository with cache strategy |
| Riverpod providers | Auth state management |
| Theme system | Auth & onboarding screen styling |
| Error handling | Auth error display (validation, network) |
| Localization | Multi-language auth screens |
