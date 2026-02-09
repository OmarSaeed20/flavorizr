# Phase 5 — Analytics, Stability & Performance

> **Duration:** 2–3 weeks | **Priority:** 🟡 Medium-High | **Dependencies:** Phase 4  
> **Status:** 🟡 Partially Complete (Firebase infra built, custom events pending)

---

## 📋 Overview

Phase 5 establishes comprehensive analytics tracking, crash reporting, and performance monitoring across all three user roles. The Firebase infrastructure (Analytics, Crashlytics) is initialized in Phase 0, and this phase focuses on implementing structured event tracking, route observation, error categorization, and performance profiling aligned with the actual API and Figma flows.

**Infrastructure Already Built:**
- `services/analytics/analytics_service.dart` — Analytics abstraction
- `services/analytics/crashlytics_service.dart` — Crash reporting
- `services/firebase_service.dart` — Firebase service facade
- `core/logger/advanced_app_logger.dart` — Structured logging (Talker)
- `core/performance/performance_monitor.dart` — Performance tracking
- `core/performance/performance_profiler.dart` — Method-level profiling
- `core/network/interceptors/analytics_interceptor.dart` — API call tracking
- `core/network/interceptors/performance_interceptor.dart` — Response time tracking
- `core/router/router_observer.dart` — Route change observation

---

## 🎯 Goals

| Goal | Success Criteria | Status |
|------|-----------------|--------|
| Firebase Analytics | Screen views, user properties, custom events | 🟡 Partial |
| Firebase Crashlytics | Crash reports with user context & breadcrumbs | ✅ Built |
| Sentry Integration | Error tracking with source maps | 🟡 Partial |
| API Performance | Track response times for all endpoints | ✅ Built |
| Custom Events | Track key business flows (booking, payment, chat) | ⬜ Not Started |
| User Properties | Role, platform, locale, app version | ⬜ Not Started |
| Route Analytics | Screen view tracking via GoRouter observer | ✅ Built |
| Performance Profiling | Frame rendering, startup time, memory | ✅ Built |
| Error Categorization | Typed errors with severity levels | ✅ Built |

---

## 📁 Tasks Breakdown

### Task 5.1: Custom Analytics Events ⬜
**Estimated Time:** 3–4 days

**Objectives:**
- Define structured event taxonomy for all user flows
- Implement event tracking at key touchpoints
- Set up user properties for segmentation

**Event Categories:**

#### Authentication Events
| Event | Trigger | Properties |
|-------|---------|------------|
| `auth_login_started` | Login screen opened | `role`, `method` |
| `auth_login_success` | Login API returns 200 | `role`, `method`, `duration_ms` |
| `auth_login_failed` | Login API returns error | `role`, `error_code`, `error_message` |
| `auth_register_started` | Register screen opened | `role`, `company_type` |
| `auth_register_success` | Registration complete | `role`, `company_type` |
| `auth_otp_requested` | OTP sent via `/auth/confirmation-code` | `role` |
| `auth_otp_verified` | OTP verified via `/auth/user-verify` | `role`, `duration_ms` |
| `auth_logout` | User logs out | `role` |

#### Consumer Trip Events
| Event | Trigger | Properties |
|-------|---------|------------|
| `trip_search_started` | Location search opened | — |
| `trip_price_previewed` | Price preview loaded | `vehicle_type`, `price`, `distance_km` |
| `trip_public_created` | Public trip created via `/user/trip/store-public` | `vehicle_type`, `smoker`, `pet`, `luggage` |
| `trip_private_created` | Private trip via `/user/trip/store-private` | `vehicle_type`, `appointment_type` |
| `trip_booked` | Book now via `/user/trip/book-now` | `order_id` |
| `trip_confirmed` | Trip confirmed via `/user/trip/confirm` | `order_id` |
| `trip_cancelled_consumer` | Consumer cancels via `/user/trip/cancel` | `order_id`, `reason` |
| `trip_evaluated` | Trip rated via `/user/trip/evaluation` | `order_id`, `rating`, `has_comment` |
| `trip_reported` | Trip reported via `/user/trip/report` | `order_id` |

#### Direct Booking Events
| Event | Trigger | Properties |
|-------|---------|------------|
| `direct_booking_started` | Direct booking flow opened | — |
| `direct_booking_vehicle_selected` | Vehicle type chosen | `vehicle_type_id`, `price` |
| `direct_booking_driver_found` | Driver matched | `driver_id`, `eta_minutes` |
| `direct_booking_completed` | Booking confirmed | `order_id`, `vehicle_type`, `price` |

#### Driver Events
| Event | Trigger | Properties |
|-------|---------|------------|
| `driver_trip_accepted` | Driver accepts via `/driver/trip/accept` | `trip_id` |
| `driver_trip_rejected` | Driver rejects via `/driver/trip/reject` | `trip_id` |
| `driver_trip_arrived` | Driver arrived via `/driver/trip/arrived` | `trip_id`, `wait_time_ms` |
| `driver_trip_started` | Trip started via `/driver/trip/start` | `trip_id` |
| `driver_trip_completed` | Trip completed via `/driver/trip/complete` | `trip_id`, `duration_ms` |
| `driver_trip_cancelled` | Driver cancels via `/driver/trip/cancel` | `trip_id`, `reason` |
| `driver_location_updated` | GPS location broadcast | `accuracy`, `speed` |
| `driver_online_status` | Driver goes online/offline | `status` |

#### Chat Events
| Event | Trigger | Properties |
|-------|---------|------------|
| `chat_opened` | Chat screen opened | `order_id` |
| `chat_message_sent` | Message sent via `/user/chat/save` | `order_id`, `message_length` |

#### Schedule Trip Events
| Event | Trigger | Properties |
|-------|---------|------------|
| `schedule_trip_created` | Created via `/user/schedule-trip/create` | `vehicle_type`, `date` |
| `schedule_trip_accepted` | Accepted via `/user/schedule-trip/accept-request` | `request_id` |
| `driver_schedule_created` | Created via `/driver/schedule-trip/create-request` | `vehicle_type`, `date` |

---

### Task 5.2: User Properties Setup ⬜
**Estimated Time:** 1 day

**Objectives:**
- Set Firebase user properties on login
- Update on profile changes

**User Properties:**
| Property | Source | Example |
|----------|--------|---------|
| `user_role` | `company_type` from auth | `customer`, `driver`, `company` |
| `platform` | Platform detection | `ios`, `android` |
| `locale` | App locale | `en`, `ar` |
| `app_version` | Package info | `1.2.0` |
| `build_flavor` | `F.appFlavor` | `dev`, `staging`, `prod` |
| `theme_mode` | Theme controller | `light`, `dark`, `system` |
| `country_id` | User profile | `1` (Egypt) |

---

### Task 5.3: Crashlytics Enhancement ⬜
**Estimated Time:** 1–2 days

**Objectives:**
- Add breadcrumbs for user actions before crash
- Set custom keys for debugging context
- Log non-fatal errors for API failures
- Record background handler errors

**Breadcrumb Points:**
- Screen transitions (via router observer)
- API calls (via analytics interceptor)
- User actions (button taps, form submissions)
- Socket.IO connection events

**Custom Keys:**
```dart
FirebaseCrashlytics.instance.setCustomKey('user_role', role);
FirebaseCrashlytics.instance.setCustomKey('active_trip_id', tripId);
FirebaseCrashlytics.instance.setCustomKey('last_api_endpoint', endpoint);
```

---

### Task 5.4: API Performance Monitoring ✅
**Estimated Time:** Already built

**Built Components:**
- `PerformanceInterceptor` — Tracks response time for every API call
- `AnalyticsInterceptor` — Logs API call events (endpoint, method, status)
- `LoggingInterceptor` — Debug-mode request/response logging

**Key Metrics Tracked:**
- Response time per endpoint
- Error rate per endpoint
- Request frequency patterns
- Token refresh frequency

---

### Task 5.5: Performance Profiling ✅
**Estimated Time:** Already built

**Built Components:**
- `core/performance/performance_monitor.dart` — Frame rate, memory, startup tracking
- `core/performance/performance_profiler.dart` — Method-level timing
- `core/performance/image_cache_service.dart` — Image loading optimization
- `core/performance/lazy_loading_service.dart` — Deferred loading

---

### Task 5.6: Error Dashboard & Monitoring ⬜
**Estimated Time:** 1–2 days

**Objectives:**
- Configure Firebase Crashlytics dashboard alerts
- Set up Sentry project with proper DSN
- Define error severity levels
- Create error notification rules

**Error Severity Levels:**
| Level | Examples | Action |
|-------|---------|--------|
| Critical | App crash, Firebase init failure | Immediate alert |
| High | Auth token failure, payment error | Alert within 1 hour |
| Medium | API timeout, WebSocket disconnect | Daily digest |
| Low | Image load failure, cache miss | Weekly review |

---

## 📊 Acceptance Criteria

- [x] Firebase Crashlytics captures crashes with stack traces
- [x] API performance interceptor tracks response times
- [x] Route observer logs screen views
- [x] Performance profiler measures startup & frame rate
- [ ] All trip events tracked with correct properties
- [ ] All auth events tracked across Consumer/Driver
- [ ] User properties set on login (role, platform, locale)
- [ ] Crashlytics breadcrumbs show user journey before crash
- [ ] Sentry configured with source maps for release builds
- [ ] Analytics dashboard shows key conversion funnels

---

## 🔗 Phase 5 → Phase 6 Dependencies

| Phase 5 Output | Used By Phase 6 |
|----------------|-----------------|
| Event tracking patterns | Schedule trip analytics |
| Performance monitoring | Map rendering optimization |
| Error categorization | Advanced feature error handling |
| User properties | Feature flag targeting |
