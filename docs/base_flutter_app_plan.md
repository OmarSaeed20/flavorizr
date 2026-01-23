# Base flutter app overview

You’re aiming huge—and I love that. A “base app” with nearly every feature means designing a foundation that stays fast, feels simple, and scales without chaos. Below is a modular PRD, a clean architecture that won’t coll---

# Additional feature considerations

## Background processing & task scheduling

- **Background fetch:** Periodic data sync when app is in background (WorkManager for Android, BGTaskScheduler for iOS).
- **Scheduled jobs:** Reminders, data cleanup, cache invalidation, token refresh.
- **Background location:** Geofencing and location tracking (if applicable) with battery optimization.
- **Upload/download queues:** Resume interrupted transfers; background media uploads.

## Media handling

- **Image optimization:** Compression before upload; WebP/AVIF support; responsive image loading.
- **Video processing:** Thumbnail generation, transcoding for web compatibility, chunked uploads.
- **Camera integration:** Permission handling, custom camera UI, QR/barcode scanning.
- **Gallery picker:** Multi-select, file type filtering, size limits, EXIF handling.
- **Audio:** Recording, playback controls, waveform visualization, voice messages.
- **Caching strategy:** LRU cache for images; preloading for anticipated content; disk quota management.

## Connectivity & network state

- **Network monitoring:** Real-time connectivity status; distinguish WiFi/cellular/offline.
- **Adaptive loading:** Low-res images on slow networks; defer non-critical requests.
- **Retry logic:** Exponential backoff with jitter; circuit breaker pattern for failing endpoints.
- **Request management:** Cancellation tokens; request deduplication; priority queues.
- **Offline queue:** Persist failed mutations; auto-retry on reconnection; conflict resolution UI.

## Device features & native integration

- **Haptic feedback:** Contextual vibrations for actions, errors, success states.
- **Device info:** Model, OS version, screen size for analytics and support.
- **Clipboard:** Copy/paste support; share to clipboard; clipboard listeners.
- **App shortcuts:** Quick actions from home screen (iOS 3D Touch, Android App Shortcuts).
- **Home screen widgets:** Glanceable content, quick actions (iOS WidgetKit, Android Widgets).
- **Local authentication:** Face ID, Touch ID, fingerprint; graceful fallback to PIN.
- **Contacts & calendar:** Integration for social features, event scheduling (with permissions).

## App lifecycle & state management

- **State restoration:** Preserve navigation stack and form data on app kill.
- **Cold start deep links:** Handle deep links when app is not running.
- **App update handling:** 
  - Force update: Block usage until updated.
  - Soft update: Prompt but allow skip.
  - In-app updates (Android Play Core).
- **Maintenance mode:** Server-driven UI to show downtime messages.
- **Session timeout:** Auto-logout after inactivity; re-auth prompts.

## Rate limiting & abuse prevention

- **Client-side throttling:** Debounce rapid user actions; rate limit API calls.
- **Spam detection:** Content hashing; duplicate submission prevention.
- **CAPTCHA integration:** reCAPTCHA, hCaptcha for suspicious activity.
- **Anomaly detection:** Flag unusual patterns (rapid follows, mass messages).
- **Block/report system:** User-initiated reports; temporary/permanent blocks.

## Data management & compliance

- **Data export:** GDPR-compliant data download (JSON/CSV format).
- **Account deletion:** Soft delete with grace period; hard delete on request.
- **Schema migration:** Versioned local DB; migration scripts; rollback support.
- **Backup & restore:** Cloud backup for user preferences; cross-device sync.
- **Data retention:** Auto-purge old data; configurable retention policies.
- **Consent management:** Granular consent tracking; re-consent on policy changes.

## Developer experience & debugging

- **Debug overlay:** FPS counter, memory usage, network inspector in dev builds.
- **Feature flag overrides:** QA tools to toggle flags without server changes.
- **Mock data mode:** Offline development with realistic fake data.
- **Network logging:** Request/response inspector; cURL export for debugging.
- **Screenshot tools:** Built-in screenshot capture for bug reports.
- **Environment switcher:** Quick toggle between dev/staging/prod in debug builds.
- **Performance profiler:** Widget rebuild tracking; expensive operation warnings.

## Onboarding & user education

- **Feature tours:** Spotlight overlays for new features; step-by-step guides.
- **Tooltips:** Contextual help on long-press or info icons.
- **Changelog display:** What's new screens on app update.
- **Permission rationale:** Pre-permission education screens explaining why access is needed.
- **Empty states:** Helpful guidance when lists are empty; action prompts.
- **Progressive disclosure:** Reveal advanced features as users become proficient.

## Error recovery & resilience

- **Graceful degradation:** Fallback UI when features fail; partial functionality.
- **Retry mechanisms:** User-initiated and automatic retries with feedback.
- **Error boundaries:** Catch and contain errors per feature; prevent full app crashes.
- **Fallback content:** Cached data display when network fails; placeholder states.
- **Recovery prompts:** Clear actions to resolve issues (retry, contact support, etc.).

## Performance optimizations

- **Lazy loading:** Load modules on demand; code splitting for web.
- **Image placeholders:** Shimmer effects, blur hash, low-quality previews.
- **List virtualization:** Only render visible items; recycler views for large datasets.
- **Memory management:** Dispose controllers; clear caches on memory pressure.
- **Startup optimization:** Defer non-critical initialization; splash screen best practices.
- **Bundle size:** Tree shaking; deferred components; asset optimization.

## Theme system (flex_color_scheme)

- **Color schemes:**
  - Pre-built brand palettes (primary, secondary, tertiary) via `flex_color_scheme: ^8.4.0`.
  - 50+ built-in FlexScheme options (Material, Indigo, Sakura, etc.).
  - Dynamic color extraction (Android 12+ wallpaper colors via `dynamic_color`).
  - User-selectable accent colors with preview.
  - High contrast mode for accessibility.
  - Semantic colors (error, success, warning, info).
- **Theme modes:**
  - Light / Dark / System-follow with smooth animated transitions.
  - Scheduled dark mode (sunset/sunrise or custom times).
  - Per-screen theme overrides (e.g., dark media viewer, immersive modes).
  - True black (OLED) option for dark mode.
- **Typography:**
  - Scalable type system aligned with Material 3 type scale.
  - Custom font families with fallbacks (`fontFamily` config).
  - Dynamic type scaling for accessibility (0.8x - 1.4x).
  - Font weight and style tokens.
- **Surface & elevation:**
  - M3 surface tones with `surfaceMode` blending.
  - Elevation overlay in dark mode.
  - Custom surface colors per component.
  - Blur/transparency effects where supported.
- **Component theming:**
  - Button variants (filled, tonal, outlined, text) with custom radii.
  - Input decorations (filled, outlined) with scheme colors.
  - Card, dialog, and bottom sheet styles.
  - App bar, navigation bar, and navigation rail indicators.
  - FAB scheme color and radius customization.
- **Settings persistence:**
  - Store theme mode, scheme, font scale, true black in local preferences.
  - Sync theme settings across devices (optional cloud backup).
  - Immediate preview on settings change.

## Modal system (modal_bottom_sheet)

- **Modal bottom sheets:**
  - Cupertino-style modal with drag-to-dismiss via `modal_bottom_sheet: ^3.0.0`.
  - Material bottom sheets with custom shapes and radii.
  - Nested scrolling support (lists, forms inside sheets).
  - Snap points (half-screen, full-screen, custom percentages).
  - Background interaction control (dismissible/non-dismissible).
  - Keyboard-aware resizing for input sheets.
- **Dialog templates:**
  - Confirmation dialogs (destructive actions, logout, delete).
  - Input dialogs (single field, multi-field forms).
  - Selection dialogs (single/multi-select lists, radio/checkbox).
  - Custom content dialogs (rich layouts, images, icons).
  - Error/success feedback dialogs with icons.
- **Sheet templates:**
  - Action sheets (iOS-style action list with cancel).
  - Picker sheets (date, time, custom item pickers).
  - Form sheets (input fields with validation and submit).
  - Scrollable content sheets (DraggableScrollableSheet).
  - Menu sheets (quick actions, settings).
- **Loading overlays:**
  - Modal loading indicator (blocks interaction).
  - Progress dialogs with percentage/message.
  - Cancellable loading with abort callback.
  - Non-blocking toast-style loading indicators.
- **Advanced behaviors:**
  - Stacked modals (sheet opens another sheet/dialog).
  - Persistent bottom sheets (non-dismissible, requires action).
  - Route-aware sheets (deep-linkable via go_router).
  - Animation customization (duration, curves).
  - Barrier customization (color, blur, dismissibility).
  - Haptic feedback on snap points.

## App store requirements & compliance

- **Privacy policy:** In-app link and acceptance flow.
- **Terms of service:** Display and acceptance tracking.
- **App tracking transparency:** iOS ATT prompt; respect user choice.
- **In-app review:** Strategic prompts after positive experiences (StoreKit, Play In-App Review).
- **Rating nudges:** Soft prompts to rate; don't annoy users.
- **Age gating:** Age verification if content requires it.
- **Export compliance:** Encryption declaration for App Store.

---

# Additional feature modules

| Module | Key features | Optional integrations | Gating |
|---|---|---|---|
| Background sync | Periodic fetch, upload queues, scheduled tasks | WorkManager, BGTaskScheduler | Always on |
| Media | Compression, camera, gallery, audio | FFmpeg, image_picker, camera | Plan: storage limits |
| Connectivity | Network state, adaptive loading, offline queue | connectivity_plus | Always on |
| Device features | Haptics, shortcuts, widgets, biometrics | local_auth, quick_actions | Platform-specific |
| App lifecycle | State restoration, updates, maintenance | in_app_update, package_info | Always on |
| Rate limiting | Throttling, CAPTCHA, abuse detection | reCAPTCHA | Flag: abuse.protection |
| Data management | Export, deletion, backup, migration | cloud_firestore, sqflite | GDPR compliance |
| Dev tools | Debug overlay, mocks, profiler | Flutter DevTools | Dev/Debug only |
| Onboarding | Tours, tooltips, changelog | tutorial_coach_mark | Flag: onboarding.enabled |
| App store | ATT, reviews, compliance | app_tracking_transparency | Always on |
| Theme | Flex schemes, dark/light modes, dynamic color, typography scaling, OLED true black | flex_color_scheme: ^8.4.0, dynamic_color | Always on |
| Modal/Dialog | Bottom sheets, dialogs, action sheets, loading overlays, snap points | modal_bottom_sheet: ^3.0.0 | Always on |

---

# Risks, constraints, and choices

- **Scope creep:** "All features" will balloon—use flags and a strict phased plan.under feature sprawl, and an advanced build plan you can actually execute.

---

# Product requirements

## Vision and goals

- **Vision:** A modular, production-grade Flutter starter that supports most modern app features out-of-the-box, ready for vertical customization.
- **Primary goals:** 
  - **Modularity:** Enable/disable features without impacting core.
  - **Scalability:** Clean Architecture + layered services for growth.
  - **Quality:** CI/CD, testing, analytics, and observability baked in.
  - **Speed:** Ship MVP quickly; add advanced features progressively.

## Target platforms and environments

- **Platforms:** iOS, Android, Web, Desktop (Windows/macOS/Linux) where feasible.
- **Environments:** Dev, Staging, Prod with separate configs, secrets, and feature flags.
- **Flavors:** Free, Pro, Enterprise with entitlements and gated features.

## Core user experiences

- **Auth & onboarding:** Email/password, OAuth (Google/Apple/Facebook), phone OTP, passwordless magic link, progressive onboarding, biometrics.
- **Profile & accounts:** Editable profile, avatars, preferences, multi-account, roles (user/mod/admin).
- **Content & feed:** Create/read/update/delete posts, comments, reactions, rich media, infinite lists, offline cache.
- **Messaging:** Real-time chat (1:1, groups), threads, read receipts, typing indicators, push notifications.
- **Search & discovery:** Full-text search, filters, sort, suggestions, saved searches.
- **Notifications:** Push/in-app, inbox and preference center, scheduled sends, batching.
- **Payments & monetization:** Subscriptions, consumables, tipping, promo codes, invoices, trial/upgrade/downgrade.
- **Social & sharing:** Deep links, share sheets, follow/friends, mentions, activity feed.
- **Admin & moderation:** Role-based tools, content flags, audits, analytics dashboards.
- **Settings:** Themes (light/dark/system), language, privacy, security, data export/delete.
- **Accessibility & intl:** WCAG AA focus, screen reader labels, scalable text, RTL, pluralization, multi-locale.
- **Observability:** Analytics events, crash reporting, performance metrics, feature flag telemetry.

## Non-functional requirements

- **Performance:** Cold start < 2s (mobile), scroll 60fps, chat latency < 300ms on good networks.
- **Security:** OWASP MAS baseline, secure storage, encrypted transport, least-privilege access.
- **Reliability:** Offline-first for critical flows; data sync resolution; retries with backoff.
- **Maintainability:** <10 core modules, strict boundaries, 80% unit coverage for domain logic.
- **Compliance:** GDPR data rights, CCPA requests, PCI for payments, audit logging.

---

# Feature modules

| Module | Key features | Optional integrations | Gating |
|---|---|---|---|
| Authentication | Email/pwd, OAuth, OTP, biometrics, sessions | Firebase Auth, Auth0, custom OAuth | Feature flag: auth.providers |
| Profile | Avatar, username, preferences, roles | Cloud Storage, Gravatar | Role/plan gates |
| Feed & content | CRUD posts, media, reactions, infinite scroll | Firestore/REST, S3/GCS | Plan: Free limits |
| Messaging | 1:1, groups, threads, presence, media | Stream, Firebase RTDB, WebSockets | Enterprise only |
| Notifications | Push, in-app inbox, prefs | FCM/APNS, OneSignal | Flag: notifications.enabled |
| Search | Full-text, filters, saved queries | Algolia/Meilisearch | Flag: search.provider |
| Payments | IAP, Stripe, promo codes | Stripe, RevenueCat | Pro/Enterprise |
| Admin | Moderation, audits, dashboards | Supabase, custom | Role-based only |
| Analytics | Events, funnels, A/B, performance | Firebase Analytics, Amplitude | Always on |
| Settings | Theme, language, privacy | System APIs | Always on |

> Sources: Integrations are illustrative; wire actual providers to your constraints.

---

# Software architecture

## High-level structure

- **Presentation layer (Flutter UI):** Widgets, pages, and components using Bloc or Riverpod for state, Navigator 2.0 (go_router) for routing.
- **Application layer:** Use-cases (interactors) orchestrate domain logic; error handling, validation, and permissions live here.
- **Domain layer:** Entities, value objects, repositories (interfaces), and pure business rules.
- **Data layer:** Data sources (REST/GraphQL, WebSocket, local DB), mappers, and repository implementations.
- **Platform services:** Notifications, deep links, app lifecycle, storage, biometrics, payments.
- **Feature flag & config:** Remote config service to toggle providers and features per environment/flavor.

## Key decisions

- **State management:** Riverpod for composability and testability; Bloc acceptable for larger teams with explicit event flows.
- **Navigation:** go_router for declarative routes, nested navigation, deep linking, guarded routes (auth, roles).
- **Networking:** Dio + Retrofit for REST; GraphQL optional; WebSocket channel for real-time.
- **Storage:** Hive or Isar for local cache; secure storage for secrets; shared prefs for simple flags.
- **Offline-first:** Repository writes queue with conflict resolution; optimistic UI for feed/chat; sync service on connectivity changes.
- **Theming:** `flex_color_scheme` for Material 3 + custom theme tokens; dynamic color on Android 12+; robust dark/light/system modes; OLED true black.
- **Modals & Dialogs:** `modal_bottom_sheet` for Cupertino-style sheets; unified dialog service with templates; loading overlays and action sheets.
- **Localization:** intl + arb; locale loader and fallback; RTL testing.
- **Plugin architecture:** Each feature is a package in a mono-repo (Melos) or modular folders with separate pubspecs when needed.
- **DI:** Riverpod providers or get_it; DI container per feature for swapping implementations.
- **Error handling:** Unified Failure types; global error boundary and toasts/snackbars; crash reporting hooks.
- **Security:** OAuth PKCE, token refresh, TLS pinning optional, secure key store, runtime checks for jailbreak/root detection.

## Directory layout

```
├── apps/
│   └── base_app/
│       ├── lib/
│       │   ├── main.dart                         # Entry point with flavor config
│       │   ├── main_dev.dart                     # Dev flavor entry
│       │   ├── main_staging.dart                 # Staging flavor entry
│       │   ├── main_prod.dart                    # Production flavor entry
│       │   ├── app.dart                          # MaterialApp/CupertinoApp setup
│       │   ├── bootstrap.dart                    # App initialization, DI setup
│       │   │
│       │   ├── config/
│       │   │   ├── app_config.dart               # Environment-specific config
│       │   │   ├── flavors.dart                  # Flavor enum and settings
│       │   │   ├── constants.dart                # App-wide constants
│       │   │   └── feature_flags.dart            # Feature flag definitions
│       │   │
│       │   ├── core/
│       │   │   ├── theme/
│       │   │   │   ├── app_theme.dart            # FlexColorScheme theme builder
│       │   │   │   ├── theme_controller.dart     # Theme state (Riverpod/Bloc)
│       │   │   │   ├── theme_settings.dart       # Theme preferences model
│       │   │   │   ├── color_schemes.dart        # Custom color palettes
│       │   │   │   ├── typography.dart           # Text styles and scales
│       │   │   │   └── theme_extensions.dart     # Custom ThemeExtension classes
│       │   │   │
│       │   │   ├── modals/
│       │   │   │   ├── modal_service.dart        # Unified modal/dialog service
│       │   │   │   ├── modal_config.dart         # Default modal configurations
│       │   │   │   ├── bottom_sheets/
│       │   │   │   │   ├── base_bottom_sheet.dart
│       │   │   │   │   ├── action_sheet.dart     # iOS-style action list
│       │   │   │   │   ├── picker_sheet.dart     # Date/time/custom pickers
│       │   │   │   │   ├── form_sheet.dart       # Input forms in sheet
│       │   │   │   │   ├── scrollable_sheet.dart # DraggableScrollableSheet
│       │   │   │   │   └── menu_sheet.dart       # Quick actions menu
│       │   │   │   ├── dialogs/
│       │   │   │   │   ├── base_dialog.dart
│       │   │   │   │   ├── confirmation_dialog.dart
│       │   │   │   │   ├── input_dialog.dart
│       │   │   │   │   ├── selection_dialog.dart
│       │   │   │   │   ├── error_dialog.dart
│       │   │   │   │   └── success_dialog.dart
│       │   │   │   └── overlays/
│       │   │   │       ├── loading_overlay.dart
│       │   │   │       ├── progress_overlay.dart
│       │   │   │       └── toast_overlay.dart
│       │   │   │
│       │   │   ├── responsive/
│       │   │   │   ├── README.md
│       │   │   │   ├── responsive.dart
│       │   │   │   └── src/
│       │   │   │       ├── breakpoints.dart
│       │   │   │       ├── device_info.dart
│       │   │   │       ├── responsive_context.dart
│       │   │   │       ├── responsive_data.dart
│       │   │   │       ├── responsive_extensions.dart
│       │   │   │       ├── responsive_value.dart
│       │   │   │       ├── spacing/
│       │   │   │       │   ├── gap_widgets.dart
│       │   │   │       │   ├── spacing.dart
│       │   │   │       │   └── spacing_constants.dart
│       │   │   │       ├── typography/
│       │   │   │       │   ├── text_scale.dart
│       │   │   │       │   ├── typography.dart
│       │   │   │       │   └── typography_tokens.dart
│       │   │   │       └── widgets/
│       │   │   │           ├── adaptive_scaffold.dart
│       │   │   │           ├── responsive_builder.dart
│       │   │   │           ├── responsive_layout.dart
│       │   │   │           ├── responsive_visibility.dart
│       │   │   │           └── widgets.dart
│       │   │   │
│       │   │   ├── router/
│       │   │   │   ├── app_router.dart           # GoRouter configuration
│       │   │   │   ├── routes.dart               # Route path constants
│       │   │   │   ├── route_guards.dart         # Auth/role guards
│       │   │   │   ├── route_transitions.dart    # Custom page transitions
│       │   │   │   └── deep_link_handler.dart    # Deep link parsing
│       │   │   │
│       │   │   ├── network/
│       │   │   │   ├── dio_client.dart           # Dio instance + interceptors
│       │   │   │   ├── api_endpoints.dart        # API URL constants
│       │   │   │   ├── interceptors/
│       │   │   │   │   ├── auth_interceptor.dart
│       │   │   │   │   ├── logging_interceptor.dart
│       │   │   │   │   ├── retry_interceptor.dart
│       │   │   │   │   └── cache_interceptor.dart
│       │   │   │   ├── network_info.dart         # Connectivity checker
│       │   │   │   └── api_exception.dart        # Custom API exceptions
│       │   │   │
│       │   │   ├── storage/
│       │   │   │   ├── local_storage.dart        # Hive/Isar wrapper
│       │   │   │   ├── secure_storage.dart       # flutter_secure_storage
│       │   │   │   ├── preferences.dart          # SharedPreferences wrapper
│       │   │   │   └── cache_manager.dart        # Cache policies & cleanup
│       │   │   │
│       │   │   ├── error/
│       │   │   │   ├── failures.dart             # Failure types (domain)
│       │   │   │   ├── exceptions.dart           # Exception types (data)
│       │   │   │   ├── error_handler.dart        # Global error handler
│       │   │   │   └── error_boundary.dart       # Widget error boundary
│       │   │   │
│       │   │   ├── di/
│       │   │   │   ├── injection.dart            # DI container setup
│       │   │   │   ├── providers.dart            # Riverpod providers
│       │   │   │   └── modules/                  # Feature-specific DI modules
│       │   │   │
│       │   │   ├── utils/
│       │   │   │   ├── extensions/
│       │   │   │   │   ├── context_extensions.dart
│       │   │   │   │   ├── string_extensions.dart
│       │   │   │   │   ├── datetime_extensions.dart
│       │   │   │   │   └── list_extensions.dart
│       │   │   │   ├── validators.dart           # Input validation
│       │   │   │   ├── formatters.dart           # Date/currency formatters
│       │   │   │   ├── debouncer.dart            # Debounce utility
│       │   │   │   └── logger.dart               # Logging utility
│       │   │   │
│       │   │   └── services/
│       │   │       ├── analytics_service.dart    # Analytics abstraction
│       │   │       ├── crash_service.dart        # Crash reporting
│       │   │       ├── notification_service.dart # Push notifications
│       │   │       ├── deep_link_service.dart    # Deep link handling
│       │   │       ├── permission_service.dart   # Permission requests
│       │   │       ├── biometric_service.dart    # Face ID/Touch ID
│       │   │       ├── share_service.dart        # Share sheet
│       │   │       └── haptic_service.dart       # Haptic feedback
│       │   │
│       │   ├── features/
│       │   │   ├── auth/
│       │   │   │   ├── data/
│       │   │   │   │   ├── datasources/
│       │   │   │   │   │   ├── auth_remote_datasource.dart
│       │   │   │   │   │   └── auth_local_datasource.dart
│       │   │   │   │   ├── models/
│       │   │   │   │   │   ├── user_model.dart
│       │   │   │   │   │   └── token_model.dart
│       │   │   │   │   └── repositories/
│       │   │   │   │       └── auth_repository_impl.dart
│       │   │   │   ├── domain/
│       │   │   │   │   ├── entities/
│       │   │   │   │   │   └── user.dart
│       │   │   │   │   ├── repositories/
│       │   │   │   │   │   └── auth_repository.dart
│       │   │   │   │   └── usecases/
│       │   │   │   │       ├── login_usecase.dart
│       │   │   │   │       ├── register_usecase.dart
│       │   │   │   │       ├── logout_usecase.dart
│       │   │   │   │       ├── refresh_token_usecase.dart
│       │   │   │   │       └── forgot_password_usecase.dart
│       │   │   │   └── presentation/
│       │   │   │       ├── controllers/
│       │   │   │       │   └── auth_controller.dart
│       │   │   │       ├── pages/
│       │   │   │       │   ├── login_page.dart
│       │   │   │       │   ├── register_page.dart
│       │   │   │       │   ├── forgot_password_page.dart
│       │   │   │       │   ├── otp_verification_page.dart
│       │   │   │       │   └── biometric_setup_page.dart
│       │   │   │       └── widgets/
│       │   │   │           ├── social_login_buttons.dart
│       │   │   │           └── auth_form_fields.dart
│       │   │   │
│       │   │   ├── profile/
│       │   │   │   ├── data/
│       │   │   │   ├── domain/
│       │   │   │   └── presentation/
│       │   │   │       ├── pages/
│       │   │   │       │   ├── profile_page.dart
│       │   │   │       │   └── edit_profile_page.dart
│       │   │   │       └── widgets/
│       │   │   │           ├── avatar_picker.dart
│       │   │   │           └── profile_header.dart
│       │   │   │
│       │   │   ├── feed/
│       │   │   │   ├── data/
│       │   │   │   │   ├── datasources/
│       │   │   │   │   ├── models/
│       │   │   │   │   └── repositories/
│       │   │   │   ├── domain/
│       │   │   │   │   ├── entities/
│       │   │   │   │   │   ├── post.dart
│       │   │   │   │   │   └── reaction.dart
│       │   │   │   │   ├── repositories/
│       │   │   │   │   └── usecases/
│       │   │   │   └── presentation/
│       │   │   │       ├── controllers/
│       │   │   │       ├── pages/
│       │   │   │       │   ├── feed_page.dart
│       │   │   │       │   ├── post_detail_page.dart
│       │   │   │       │   └── create_post_page.dart
│       │   │   │       └── widgets/
│       │   │   │           ├── post_card.dart
│       │   │   │           ├── reaction_bar.dart
│       │   │   │           └── media_carousel.dart
│       │   │   │
│       │   │   ├── chat/
│       │   │   │   ├── data/
│       │   │   │   ├── domain/
│       │   │   │   └── presentation/
│       │   │   │       ├── pages/
│       │   │   │       │   ├── conversations_page.dart
│       │   │   │       │   ├── chat_page.dart
│       │   │   │       │   └── chat_info_page.dart
│       │   │   │       └── widgets/
│       │   │   │           ├── message_bubble.dart
│       │   │   │           ├── chat_input.dart
│       │   │   │           ├── typing_indicator.dart
│       │   │   │           └── attachment_picker.dart
│       │   │   │
│       │   │   ├── notifications/
│       │   │   │   ├── data/
│       │   │   │   ├── domain/
│       │   │   │   └── presentation/
│       │   │   │       ├── pages/
│       │   │   │       │   ├── notifications_page.dart
│       │   │   │       │   └── notification_settings_page.dart
│       │   │   │       └── widgets/
│       │   │   │           └── notification_tile.dart
│       │   │   │
│       │   │   ├── search/
│       │   │   │   ├── data/
│       │   │   │   ├── domain/
│       │   │   │   └── presentation/
│       │   │   │       ├── pages/
│       │   │   │       │   ├── search_page.dart
│       │   │   │       │   └── search_results_page.dart
│       │   │   │       └── widgets/
│       │   │   │           ├── search_bar.dart
│       │   │   │           ├── filter_chips.dart
│       │   │   │           └── recent_searches.dart
│       │   │   │
│       │   │   ├── payments/
│       │   │   │   ├── data/
│       │   │   │   ├── domain/
│       │   │   │   └── presentation/
│       │   │   │       ├── pages/
│       │   │   │       │   ├── subscription_page.dart
│       │   │   │       │   ├── payment_methods_page.dart
│       │   │   │       │   └── purchase_history_page.dart
│       │   │   │       └── widgets/
│       │   │   │           ├── plan_card.dart
│       │   │   │           └── payment_form.dart
│       │   │   │
│       │   │   ├── admin/
│       │   │   │   ├── data/
│       │   │   │   ├── domain/
│       │   │   │   └── presentation/
│       │   │   │       ├── pages/
│       │   │   │       │   ├── admin_dashboard_page.dart
│       │   │   │       │   ├── moderation_page.dart
│       │   │   │       │   └── analytics_dashboard_page.dart
│       │   │   │       └── widgets/
│       │   │   │
│       │   │   ├── settings/
│       │   │   │   ├── data/
│       │   │   │   ├── domain/
│       │   │   │   └── presentation/
│       │   │   │       ├── pages/
│       │   │   │       │   ├── settings_page.dart
│       │   │   │       │   ├── theme_settings_page.dart
│       │   │   │       │   ├── language_settings_page.dart
│       │   │   │       │   ├── privacy_settings_page.dart
│       │   │   │       │   ├── security_settings_page.dart
│       │   │   │       │   └── about_page.dart
│       │   │   │       └── widgets/
│       │   │   │           ├── settings_tile.dart
│       │   │   │           ├── settings_section.dart
│       │   │   │           └── theme_preview_card.dart
│       │   │   │
│       │   │   └── onboarding/
│       │   │       ├── data/
│       │   │       ├── domain/
│       │   │       └── presentation/
│       │   │           ├── pages/
│       │   │           │   ├── onboarding_page.dart
│       │   │           │   ├── welcome_page.dart
│       │   │           │   └── permission_request_page.dart
│       │   │           └── widgets/
│       │   │               ├── onboarding_step.dart
│       │   │               └── page_indicator.dart
│       │   │
│       │   └── shared/
│       │       ├── presentation/
│       │       │   ├── widgets/
│       │       │   │   ├── buttons/
│       │       │   │   │   ├── app_button.dart
│       │       │   │   │   ├── icon_button.dart
│       │       │   │   │   └── loading_button.dart
│       │       │   │   ├── inputs/
│       │       │   │   │   ├── app_text_field.dart
│       │       │   │   │   ├── search_field.dart
│       │       │   │   │   ├── password_field.dart
│       │       │   │   │   └── otp_field.dart
│       │       │   │   ├── cards/
│       │       │   │   │   ├── app_card.dart
│       │       │   │   │   └── info_card.dart
│       │       │   │   ├── lists/
│       │       │   │   │   ├── infinite_list.dart
│       │       │   │   │   └── empty_state.dart
│       │       │   │   ├── media/
│       │       │   │   │   ├── cached_image.dart
│       │       │   │   │   ├── avatar.dart
│       │       │   │   │   └── image_gallery.dart
│       │       │   │   ├── feedback/
│       │       │   │   │   ├── shimmer_loading.dart
│       │       │   │   │   ├── skeleton_loader.dart
│       │       │   │   │   ├── error_view.dart
│       │       │   │   │   └── snackbar.dart
│       │       │   │   └── layout/
│       │       │   │       ├── app_scaffold.dart
│       │       │   │       ├── app_bar.dart
│       │       │   │       ├── bottom_nav.dart
│       │       │   │       └── sliver_app_bar.dart
│       │       │   │
│       │       │   └── pages/
│       │       │       ├── splash_page.dart
│       │       │       ├── error_page.dart
│       │       │       └── maintenance_page.dart
│       │       │
│       │       └── domain/
│       │           ├── entities/
│       │           │   └── pagination.dart
│       │           └── usecases/
│       │               └── usecase.dart          # Base usecase interface
│       │
│       ├── test/
│       │   ├── unit/
│       │   │   ├── core/
│       │   │   └── features/
│       │   │       ├── auth/
│       │   │       ├── feed/
│       │   │       └── ...
│       │   ├── widget/
│       │   │   ├── shared/
│       │   │   └── features/
│       │   ├── integration/
│       │   │   ├── auth_flow_test.dart
│       │   │   └── ...
│       │   ├── golden/
│       │   │   └── design_system/
│       │   ├── fixtures/
│       │   │   ├── mock_data.dart
│       │   │   └── json/
│       │   └── helpers/
│       │       ├── test_helpers.dart
│       │       ├── pump_app.dart
│       │       └── mocks.dart
│       │
│       ├── assets/
│       │   ├── images/
│       │   │   ├── 1.5x/
│       │   │   ├── 2.0x/
│       │   │   ├── 3.0x/
│       │   │   └── 4.0x/
│       │   ├── icons/
│       │   ├── fonts/
│       │   ├── animations/                       # Lottie/Rive files
│       │   └── translations/
│       │       ├── en.json
│       │       ├── ar.json
│       │       └── ...
│       │
│       ├── android/
│       │   ├── app/
│       │   │   ├── build.gradle.kts
│       │   │   └── src/
│       │   │       ├── main/
│       │   │       ├── dev/                      # Dev flavor resources
│       │   │       ├── staging/                  # Staging flavor resources
│       │   │       └── prod/                     # Prod flavor resources
│       │   └── ...
│       │
│       ├── ios/
│       │   ├── Runner/
│       │   ├── flavors/
│       │   │   ├── dev/
│       │   │   ├── staging/
│       │   │   └── prod/
│       │   └── ...
│       │
│       ├── web/
│       ├── macos/
│       ├── windows/
│       ├── linux/
│       │
│       ├── pubspec.yaml
│       ├── analysis_options.yaml
│       ├── l10n.yaml                             # Localization config
│       └── build.yaml                            # Build runner config
│
├── packages/
│   ├── design_system/
│   │   ├── lib/
│   │   │   ├── design_system.dart
│   │   │   ├── src/
│   │   │   │   ├── colors.dart
│   │   │   │   ├── typography.dart
│   │   │   │   ├── spacing.dart
│   │   │   │   ├── shadows.dart
│   │   │   │   └── animations.dart
│   │   │   └── widgets/
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   ├── core_network/
│   │   ├── lib/
│   │   │   ├── core_network.dart
│   │   │   └── src/
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   ├── core_storage/
│   │   ├── lib/
│   │   └── pubspec.yaml
│   │
│   ├── domain_entities/
│   │   ├── lib/
│   │   │   └── src/
│   │   │       ├── user.dart
│   │   │       ├── post.dart
│   │   │       └── ...
│   │   └── pubspec.yaml
│   │
│   └── analytics_bridge/
│       ├── lib/
│       │   └── src/
│       │       ├── analytics_event.dart
│       │       └── analytics_provider.dart
│       └── pubspec.yaml
│
├── configs/
│   ├── env/
│   │   ├── .env.dev
│   │   ├── .env.staging
│   │   └── .env.prod
│   ├── firebase/
│   │   ├── dev/
│   │   │   ├── google-services.json
│   │   │   └── GoogleService-Info.plist
│   │   ├── staging/
│   │   └── prod/
│   └── keys/
│       └── .gitkeep                              # Keystore files (gitignored)
│
├── scripts/
│   ├── build.sh                                  # Build automation
│   ├── setup.sh                                  # Project setup
│   ├── generate.sh                               # Code generation
│   └── deploy.sh                                 # Deployment scripts
│
├── docs/
│   ├── architecture.md
│   ├── api_contracts.md
│   ├── feature_flags.md
│   └── playbooks/
│
├── .github/
│   ├── workflows/
│   │   ├── ci.yml
│   │   ├── deploy_dev.yml
│   │   ├── deploy_staging.yml
│   │   └── deploy_prod.yml
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── CODEOWNERS
│
├── melos.yaml                                    # Mono-repo management
├── pubspec.yaml                                  # Root pubspec (if needed)
└── README.md
```

---

# Data models and API contracts

## Core entities

- **User**
  - id, email, phone, displayName, avatarUrl, roles[], createdAt, preferences{}
- **Post**
  - id, authorId, text, media[], tags[], reactions{}, createdAt, updatedAt, visibility
- **Message**
  - id, chatId, senderId, body, attachments[], createdAt, readBy[], status
- **Subscription**
  - id, userId, plan, status, startedAt, renewedAt, expiresAt
- **Notification**
  - id, type, title, body, read, createdAt, targetId

## Example REST contracts

```json
GET /v1/posts?limit=20&cursor=abc
{
  "items": [
    {
      "id": "p_123",
      "authorId": "u_1",
      "text": "Hello",
      "media": [{"type":"image","url":"https://..."}],
      "reactions": {"like": 10, "love": 2},
      "createdAt": "2025-09-01T12:00:00Z"
    }
  ],
  "nextCursor": "def"
}
```

```json
POST /v1/auth/login
{ "email": "a@b.com", "password": "secret", "deviceId": "xyz" }
-> 200
{ "accessToken": "jwt...", "refreshToken": "jwt...", "user": { "id": "u_1", "roles": ["user"] } }
```

```json
POST /v1/messages
{ "chatId": "c_1", "body": "hey", "attachments": [] }
-> 201
{ "id": "m_9", "status": "sent", "createdAt": "..." }
```

## Analytics event schema

- **Label:** App_open
  - name: "app_open"
  - params: platform, version, source
- **Label:** Post_created
  - name: "post_created"
  - params: length, mediaCount, tagsCount
- **Label:** Subscription_started
  - name: "subscription_started"
  - params: plan, source, promoCode

---

# DevOps and quality

## CI/CD

- **Pipeline:** Lint -> Unit tests -> Integration tests -> Build flavors -> Sign -> Beta distribute -> Release.
- **Tools:** Melos for multi-package mgmt, fastlane for iOS, Gradle tasks for Android, Flutter test driver, GitHub Actions or GitLab CI.
- **Environments:** Secrets via vault; per-env configs; feature flags controlled from Remote Config.

## Testing strategy

- **Unit tests:** Domain/use-cases, repository contracts.
- **Widget tests:** Key pages and components, golden tests for design system.
- **Integration tests:** Auth flows, messaging send/receive, payments sandbox.
- **Performance tests:** Scroll benchmarks, cold start.
- **Security tests:** OWASP MAS checklist, token flows, storage audits.

## Observability and feedback

- **Crash reporting:** Sentry or Firebase Crashlytics, release mapping, user identifiers with consent.
- **Analytics:** Funnels for onboarding, content creation, retention; A/B framework for flags.
- **Logs & metrics:** Structured logs with user/session correlation; network timing; error rate alarms.

---

# Advanced roadmap and plan

## Phase 0 — Foundations (2 weeks)

- **Architecture skeleton:** Project setup, mono-repo, design system, theming, localization.
- **Core infra:** Routing (go_router), DI, feature flags, config management, error boundary.
- **Theme system:** `flex_color_scheme` integration, light/dark/system modes, dynamic color, settings persistence.
- **Modal system:** `modal_bottom_sheet` setup, dialog/sheet templates, loading overlays.
- **CI/CD:** Build pipelines, code quality gates, environment flavors.

## Phase 1 — Essential UX (3–4 weeks)

- **Auth:** Email/password, OAuth, phone OTP; session mgmt; biometrics.
- **Profile & settings:** Editable profile, theme, language, privacy controls.
- **Feed:** Read + create posts, media upload, reactions, infinite scroll, caching.
- **Analytics:** Baseline events and screens; crash reporting.

## Phase 2 — Real-time and engagement (3–4 weeks)

- **Messaging:** 1:1 chat, threads, presence, attachments; optimistic updates.
- **Notifications:** Push and in-app inbox; preference center; deep links.
- **Search:** Full-text, filters, saved searches; server or hosted provider.

## Phase 3 — Monetization and admin (3–4 weeks)

- **Payments:** Stripe + IAP; plans, trials, upgrades; receipt verification.
- **Admin tools:** Moderation, audits, simple dashboards; role-based access.
- **Internationalization:** Full RTL pass; locale expansions; accessibility audit.

## Phase 4 — Hardening and scale (2–3 weeks)

- **Performance:** Startup, jank hunts, memory profiles.
- **Security:** TLS pinning option, storage reviews, jailbreak/root checks.
- **Testing depth:** Integration matrices, device labs, regression suites.
- **Docs:** Developer guides, module contracts, playbooks.

## Ongoing

- **A/B & experiments:** Iterate on onboarding, notification strategies.
- **Observability:** SLOs for latency and error rates; automated alerts.
- **Supportability:** Release notes, rollback playbook, feature flag kill switches.

---

# Risks, constraints, and choices

- **Scope creep:** “All features” will balloon—use flags and a strict phased plan.
- **Provider lock-in:** Abstract providers behind repositories; keep adapters thin and replaceable.
- **Performance vs. features:** Prefer progressive disclosure and lazy loading for heavy modules.
- **Security trade-offs:** Some features (e.g., magic links) require robust anti-abuse; plan for rate limits and anomaly detection.
- **Team workflow:** Enforce code owners per module, PR templates, and architecture reviews.

---

# Recommendations tailored for your base app

- **Start with a powerful core:** Auth, profiles, feed, analytics, flags, and CI/CD. Everything else as modules.
- **Pick defaults:** Riverpod + go_router + Dio + Isar + Firebase (Auth/Crash/Analytics) + Stripe/RevenueCat for monetization + `flex_color_scheme` for theming + `modal_bottom_sheet` for modals.
- **Guard complexity:** Feature flags for messaging, search provider, payments, and admin—enabled per flavor.
- **Document contracts:** Every module exposes minimal surface: routes, providers, and repository interfaces.
- **Ship early, iterate:** Get Phase 1 live, then add real-time and payments with careful observability.

If you want, I can tailor this to your exact tech stack, team size, and preferred providers—tell me your constraints and priorities.
 