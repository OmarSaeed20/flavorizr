# Phase 7 — Testing & Quality Assurance

> **Duration:** 2–3 weeks | **Priority:** 🟡 Medium | **Dependencies:** Phase 6  
> **Status:** ⬜ Not Started

---

## 📋 Overview

Phase 7 establishes a comprehensive testing strategy covering unit tests, widget tests, and integration tests for all three user roles. The test suite ensures correctness of business logic, UI rendering, and end-to-end user flows aligned with the API documentation and Figma designs.

**Test Frameworks:**
- `flutter_test` — Unit & widget tests
- `mocktail` — Mock generation
- `integration_test` — End-to-end device testing
- `very_good_analysis` — Lint rules (already configured)

---

## 🎯 Goals

| Goal | Success Criteria | Status |
|------|-----------------|--------|
| Unit Tests | 80%+ coverage on domain & data layers | ⬜ |
| Widget Tests | Key screens render correctly with mock data | ⬜ |
| Integration Tests | Critical user flows pass on real device | ⬜ |
| Test Infrastructure | Mock factories, test helpers, fixtures | ⬜ |
| CI Test Runner | Tests run on every PR via GitHub Actions | ⬜ |
| Accessibility Tests | WCAG compliance checks in widget tests | ⬜ |

---

## 📁 Tasks Breakdown

### Task 7.1: Test Infrastructure Setup ⬜
**Estimated Time:** 2–3 days

**Objectives:**
- Create test helper utilities
- Build mock factories for repositories & data sources
- Create test fixtures for API responses
- Set up widget test harness with Riverpod, GoRouter, localization

**Test Directory Structure:**
```
test/
├── fixtures/                    # JSON fixtures matching API responses
│   ├── auth/
│   │   ├── login_response.json
│   │   ├── register_response.json
│   │   └── user_profile.json
│   ├── trip/
│   │   ├── trip_detail.json
│   │   ├── trip_history.json
│   │   └── public_trips.json
│   ├── direct_booking/
│   │   ├── vehicle_types.json
│   │   ├── price_preview.json
│   │   └── find_driver.json
│   └── driver/
│       ├── driver_home.json
│       ├── driver_profile.json
│       └── schedule_trips.json
│
├── helpers/
│   ├── test_app.dart            # ProviderScope + MaterialApp wrapper
│   ├── mock_factories.dart      # Mocktail mock classes
│   ├── fixture_reader.dart      # JSON fixture loader
│   ├── pump_helpers.dart        # Widget test helpers
│   └── fake_providers.dart      # Riverpod test overrides
│
├── unit/
│   ├── core/
│   │   ├── network/
│   │   ├── error/
│   │   └── router/
│   ├── features/
│   │   ├── auth/
│   │   ├── trip/
│   │   ├── direct_booking/
│   │   ├── chat/
│   │   ├── schedule_trip/
│   │   └── driver/
│   └── services/
│
├── widget/
│   ├── auth/
│   ├── consumer/
│   ├── driver/
│   ├── company/
│   └── shared/
│
└── integration/
    ├── auth_flow_test.dart
    ├── consumer_booking_test.dart
    ├── driver_trip_test.dart
    └── test_helpers.dart
```

---

### Task 7.2: Unit Tests — Domain Layer ⬜
**Estimated Time:** 3–4 days

**Objectives:**
- Test all use cases (auth, trips, booking, chat, profile)
- Test entity logic (AuthTokens expiry, trip state transitions)
- Test repository contracts

**Priority Test Cases:**

#### AuthTokens Entity
```dart
// Test cases:
// - isAccessTokenExpired returns true when expired
// - shouldRefresh returns true within 5 minutes of expiry
// - fromApiResponse correctly calculates expiry from expires_in
// - fromMap/toMap round-trip serialization
// - authorizationHeader returns "Bearer {token}"
```

#### Auth Use Cases
```dart
// Test cases:
// - LoginUseCase calls repository.login with correct params
// - RegisterUseCase validates password confirmation
// - VerifyOtpUseCase sends phone + code + firebase_token
// - ForgotPasswordUseCase sends phone number
// - ResetPasswordUseCase sends code + new password
// - LogoutUseCase clears tokens and user data
```

#### Trip Use Cases
```dart
// Test cases:
// - CreatePublicTripUseCase sends all trip preferences
// - CreatePrivateTripUseCase handles scheduled vs instant
// - BookNowUseCase sends order_id
// - CancelTripUseCase sends order_id + user_id
// - GetTripHistoryUseCase returns paginated results
// - EvaluateTripUseCase sends rating (0-5) with comment
```

#### Direct Booking Use Cases
```dart
// Test cases:
// - GetVehicleTypesUseCase sends coordinates, returns types with prices
// - PricePreviewUseCase calculates fare for vehicle type
// - FindDriverUseCase matches available driver
// - CreateDirectTripUseCase confirms booking
```

---

### Task 7.3: Unit Tests — Data Layer ⬜
**Estimated Time:** 3–4 days

**Objectives:**
- Test remote data sources (mock Dio responses)
- Test local data sources (mock secure storage & shared prefs)
- Test repository implementations (network + cache logic)
- Test model serialization/deserialization

**Priority Test Cases:**

#### Auth Remote DataSource
```dart
// Test: POST /auth/login returns tokens
// Test: POST /auth/register returns user + tokens
// Test: POST /auth/user-verify with OTP code
// Test: POST /auth/forget-password sends SMS
// Test: 401 response triggers token refresh
// Test: Network error returns NetworkException
```

#### Auth Local DataSource
```dart
// Test: saveTokens stores in FlutterSecureStorage
// Test: getTokens retrieves and deserializes
// Test: deleteTokens clears secure storage
// Test: isLoggedIn checks token existence
// Test: saveBiometricCredentials encrypts email/password
// Test: clearAll removes all auth data
```

#### Trip Remote DataSource
```dart
// Test: POST /user/trip/store-public with all fields
// Test: POST /user/trip/store-private with appointment_type
// Test: GET /user/trip/history returns list
// Test: POST /user/trip/evaluation sends rating
// Test: GET /user/trip/types-by-location returns vehicle types
```

---

### Task 7.4: Widget Tests ⬜
**Estimated Time:** 3–4 days

**Objectives:**
- Test key screens render with mock data
- Test form validation (login, register)
- Test navigation (GoRouter test helpers)
- Test error states and loading states

**Priority Widget Tests:**

| Screen | Test Cases |
|--------|-----------|
| LoginPage | Renders form, validates phone/password, shows error snackbar |
| RegisterPage | All fields render, company_type dropdown, password match validation |
| OTPVerifyPage | Code input, countdown timer, resend button |
| Consumer Home | Map renders, search bar present, available trips list |
| Trip Detail | Trip info displayed, cancel button conditionally shown |
| Driver Home | Trip request card, accept/reject buttons |
| Driver Trip | Status buttons (Arrived/Start/Complete) appear correctly |
| Chat Page | Message list renders, input field, send button |
| Profile Page | User info displayed, edit button navigates to edit form |
| Settings Page | About Us, FAQ, Policies links render |

---

### Task 7.5: Integration Tests ⬜
**Estimated Time:** 2–3 days

**Objectives:**
- End-to-end critical user flows on real device
- Test with mocked API (using test server or interceptors)

**Critical Flows:**

| Flow | Steps |
|------|-------|
| Consumer Registration | Open app → Onboarding → Register → OTP → Home |
| Consumer Booking | Login → Search destination → Select vehicle → Price preview → Book |
| Driver Trip | Login → Wait for request → Accept → Navigate → Arrive → Start → Complete |
| Chat | Start trip → Open chat → Send message → Receive response |
| Schedule Trip | Login → Create schedule → View schedule list → Accept request |

---

### Task 7.6: Accessibility Tests ⬜
**Estimated Time:** 1–2 days

**Objectives:**
- Verify semantic labels on interactive elements
- Check contrast ratios in widget tests
- Verify focus traversal order
- Test with `AccessibilityGuideline` matchers

---

## 📊 Acceptance Criteria

- [ ] 80%+ code coverage on domain layer (entities + use cases)
- [ ] 70%+ code coverage on data layer (data sources + repositories)
- [ ] Key screens pass widget tests with mock data
- [ ] Critical user flows pass integration tests
- [ ] All tests pass in CI pipeline
- [ ] Test fixtures match actual API response format
- [ ] Accessibility widget tests verify WCAG compliance

---

## 🔗 Phase 7 → Phase 8 Dependencies

| Phase 7 Output | Used By Phase 8 |
|----------------|-----------------|
| Test suite | CI pipeline test stage |
| Integration tests | Pre-deployment validation |
| Coverage reports | PR quality gate |
| Test helpers | Regression testing |
