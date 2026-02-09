# Phase 1 — Essential UX: Authentication, Onboarding & Profiles

> **Duration:** 3–4 weeks | **Priority:** 🔴 Critical | **Dependencies:** Phase 0  
> **Status:** 🟡 Partially Complete (User/Driver auth built, Consumer/Company auth pending)

---

## 📋 Overview

Phase 1 implements the complete authentication, onboarding, and profile management flows for all three user roles. The API uses **phone-based authentication** with OTP verification, and supports separate auth flows for Consumers/Users and Drivers.

**Figma Design References:**
- 🟢 Consumer Auth/Onboarding: [Figma (node 0-1)](https://www.figma.com/design/YzQcnOIa7TG5auHuL04M9O/Fast-Golden-Taxi--Copy-?node-id=0-1)
- 🔵 Driver Auth/Registration: [Figma (node 2-37588)](https://www.figma.com/design/YzQcnOIa7TG5auHuL04M9O/Fast-Golden-Taxi--Copy-?node-id=2-37588)
- 🟣 Company Auth: [Figma (node 2-61931)](https://www.figma.com/design/YzQcnOIa7TG5auHuL04M9O/Fast-Golden-Taxi--Copy-?node-id=2-61931)

**API Endpoints Used:**
- User Auth: `POST /auth/login`, `/auth/register`, `/auth/confirmation-code`, `/auth/user-verify`, `/auth/forget-password`, `/auth/reset-password`, `/auth/logout`
- Driver Auth: `POST /driver/auth/login`, `/driver/auth/register`, `/driver/auth/user-verify`, `/driver/auth/forget-password`, `/driver/auth/reset-password`, `/driver/auth/logout`, `/driver/auth/refresh`
- User Profile: `GET /user/profile`, `GET /user/profile/detail`, `POST /user/profile/update-info`
- Driver Profile: `GET /driver/profile`, `GET /driver/profile/detail`, `POST /driver/profile/update-info`
- General: `GET /select/countries`, `GET /select/cities`, `GET /select/vehicle-type`

---

## 🎯 Goals

| Goal | Success Criteria | Status |
|------|-----------------|--------|
| User/Consumer Auth | Login, register, OTP verify, password reset | ✅ Built |
| Driver Auth | Login, register with docs, OTP verify, password reset | ✅ Built |
| Company Auth | Login, register, manage company profile | ⬜ Not Started |
| Onboarding Flow | Welcome screens, complete/skip tracking | ✅ Built |
| Splash Screen | Token check, auto-login, role redirect | ✅ Built |
| Role Selection | Choose Consumer/Driver/Company on register | ⬜ Not Started |
| User Profile | View/edit profile, avatar upload | ✅ Built |
| Driver Profile | View/edit profile, hobbies, favorite note | ✅ Built |
| Company Profile | Company details, fleet info | ⬜ Not Started |
| Biometric Login | Fingerprint/Face ID for saved credentials | ✅ Built |
| Token Management | Secure storage, refresh, expiry tracking | ✅ Built |

---

## 📁 Tasks Breakdown

### Task 1.1: Splash Screen & Initial Routing ✅
**Estimated Time:** 1 day

**Objectives:**
- Check auth token validity on app launch
- Route to onboarding (first launch), login (no token), or home (valid token)
- Role-based redirect to Consumer/Driver/Company home

**Implementation Status:** ✅ Complete
- `SplashLocalDataSource` — checks token, onboarding, first launch
- `SplashRepository` — business logic for splash routing
- Route: `/` (splash) → `/onboarding` | `/auth/login` | `/consumer/home` | `/driver/home` | `/company/dashboard`

**API Integration:**
- Token validation: Read `auth_access_token` from `FlutterSecureStorage`
- Expiry check: Compare stored `auth_access_token_expiry` with current time
- Role detection: Parse `auth_user` JSON → extract `company_type` field

---

### Task 1.2: Onboarding Flow ✅
**Estimated Time:** 1 day

**Objectives:**
- 4-page onboarding (Welcome, Features, Security, Ready)
- Track completion in `SharedPreferences`
- Skip/complete functionality

**Implementation Status:** ✅ Complete
- `OnboardingLocalDataSource` — pages data, completion tracking
- Key: `onboarding_completed` in SharedPreferences
- Route: `/onboarding` → `/auth/login` on completion

---

### Task 1.3: Consumer/User Authentication ✅
**Estimated Time:** 3–4 days

**Objectives:**
- Phone + password login
- Registration with profile fields
- OTP phone verification
- Forgot/reset password flow
- Logout with token cleanup

**Implementation Status:** ✅ Complete (under `features/user/auth/`)

**API Mapping:**

| Screen | API Endpoint | Method |
|--------|-------------|--------|
| Login | `/auth/login` | POST |
| Register | `/auth/register` | POST |
| Request OTP | `/auth/confirmation-code` | POST |
| Verify OTP | `/auth/user-verify` | POST |
| Forgot Password | `/auth/forget-password` | POST |
| Reset Password | `/auth/reset-password` | POST |
| Logout | `/auth/logout` | POST |

**Registration Fields (from API):**
```
company_type: "customer" | "driver" | "company"
name: String (required)
nickname: String (optional)
phone: String (required)
phone_iso2_code: String (e.g., "EG")
password: String (required)
password_confirmation: String (required)
country_id: int
governorate_id: int
birthdate: String (YYYY-MM-DD)
gender: "male" | "female"
```

**Data Layer:**
- `AuthRemoteDataSource` — API calls via Dio
- `AuthLocalDataSource` — Token storage (FlutterSecureStorage), user cache (SharedPreferences)
- `AuthRepository` — Combines remote + local with error handling

**Token Entity (`AuthTokens`):**
- `accessToken`, `refreshToken`, `accessTokenExpiresAt`, `refreshTokenExpiresAt`, `tokenType`
- Helper getters: `isAccessTokenExpired`, `shouldRefresh`, `authorizationHeader`

---

### Task 1.4: Driver Authentication ✅
**Estimated Time:** 3–4 days

**Objectives:**
- Driver-specific login/register with vehicle documents
- Document upload (license, vehicle license, national ID)
- OTP verification
- Password reset

**Implementation Status:** ✅ Complete (under `features/driver/driver_auth/`)

**API Mapping:**

| Screen | API Endpoint | Method |
|--------|-------------|--------|
| Driver Login | `/driver/auth/login` | POST |
| Driver Register | `/driver/auth/register` | POST |
| Driver Verify | `/driver/auth/user-verify` | POST |
| Forgot Password | `/driver/auth/forget-password` | POST |
| Reset Password | `/driver/auth/reset-password` | POST |
| Logout | `/driver/auth/logout` | POST |
| Refresh Token | `/driver/auth/refresh` | POST |

**Driver Registration Extra Fields:**
```
vehicle_type_id: int
vehicle_model: String
vehicle_year: String
vehicle_color: String
vehicle_plate_number: String
license_front_image: base64 String
license_back_image: base64 String
vehicle_license_image: base64 String
national_id_image: base64 String
```

---

### Task 1.5: Company Authentication ⬜
**Estimated Time:** 2–3 days

**Objectives:**
- Company registration with business details
- Company admin login
- Fleet management setup on registration
- Company profile creation

**Implementation Plan:**
- Create `features/company/company_auth/` module following Clean Architecture
- Reuse auth patterns from User/Driver auth
- API: Use `/auth/register` with `company_type: "company"`
- Routes: `/company/auth/login`, `/company/auth/register`
- Figma: Company auth screens from [node 2-61931](https://www.figma.com/design/YzQcnOIa7TG5auHuL04M9O/Fast-Golden-Taxi--Copy-?node-id=2-61931)

---

### Task 1.6: Role Selection Screen ⬜
**Estimated Time:** 1 day

**Objectives:**
- After registration, allow user to select role
- Visual cards for Consumer, Driver, Company
- Route to appropriate registration flow

**Implementation Plan:**
- Route: `/auth/role-selection` (already defined in routes.dart)
- Show 3 role cards matching Figma design
- Navigate to role-specific registration on selection

---

### Task 1.7: User Profile Management ✅
**Estimated Time:** 2 days

**Objectives:**
- View profile details
- Edit name, nickname, email, gender, birthdate
- Avatar/image upload (base64)

**Implementation Status:** ✅ Complete (under `features/user/profile/`)

**API Mapping:**

| Action | Endpoint | Method |
|--------|---------|--------|
| Get Profile | `/user/profile` | GET |
| Get Profile Detail | `/user/profile/detail` | GET |
| Update Profile | `/user/profile/update-info` | POST |
| Get Driver Reviews | `/user/driver/reviews?driver_id={id}` | GET |

---

### Task 1.8: Driver Profile Management ✅
**Estimated Time:** 2 days

**Objectives:**
- View/edit driver profile
- Update hobbies, favorite note
- View user profiles (passengers)

**Implementation Status:** ✅ Complete (under `features/driver/driver_profile/`)

**API Mapping:**

| Action | Endpoint | Method |
|--------|---------|--------|
| Get Profile | `/driver/profile` | GET |
| Get Profile Detail | `/driver/profile/detail` | GET |
| Update Profile | `/driver/profile/update-info` | POST |
| View User Profile | `/driver/profile/user/{user_id}` | GET |
| User Trip History | `/driver/profile-user/trip/{user_id}` | GET |

**Update Fields:**
```
name, gender, phone_number, email, birth_date, hobbies_ids: [int], favorite_note
```

---

### Task 1.9: Company Profile Management ⬜
**Estimated Time:** 2 days

**Objectives:**
- Company profile with business details
- Fleet overview
- Admin management

**Implementation Plan:**
- Create `features/company/company_profile/` module
- Routes: `/company/profile`, `/company/settings/*`
- Figma: Company profile screens from [node 2-61931](https://www.figma.com/design/YzQcnOIa7TG5auHuL04M9O/Fast-Golden-Taxi--Copy-?node-id=2-61931)

---

### Task 1.10: General Select Data ✅
**Estimated Time:** 1 day

**Objectives:**
- Load dropdown data for registration forms
- Cache locally for offline use

**Implementation Status:** ✅ Complete (under `features/general_select/`)

**API Mapping:**

| Data | Endpoint | Method |
|------|---------|--------|
| Vehicle Types | `/select/vehicle-type` | GET |
| Cities | `/select/cities` | GET |
| Countries | `/select/countries` | GET |
| Common Problems | `/select/common-problem` | GET |

---

### Task 1.11: Settings Screens ✅
**Estimated Time:** 2 days

**Objectives:**
- User & Driver settings pages
- About Us, FAQ, Policies
- General settings

**Implementation Status:** ✅ Complete

**API Mapping:**

| Setting | User Endpoint | Driver Endpoint |
|---------|--------------|----------------|
| About Us | `GET /setting/about_us` | `GET /driver/setting/about-us` |
| FAQ | `GET /setting/questions` | `GET /driver/setting/questions` |
| Policies | `GET /setting/policies` | `GET /driver/setting/policies` |
| General | `GET /setting/general` | `GET /driver/setting/general` |
| Update Vehicle Types | — | `POST /driver/setting/update-vehicle-types` |

---

## 📊 Implementation Status Summary

| Module | Location | Status |
|--------|----------|--------|
| Splash | `features/splash/` | ✅ Complete |
| Onboarding | `features/onboarding/` | ✅ Complete |
| User Auth | `features/user/auth/` | ✅ Complete |
| Driver Auth | `features/driver/driver_auth/` | ✅ Complete |
| Consumer Auth | `features/consumer/consumer_auth/` | 🟡 Partial |
| Company Auth | `features/company/company_auth/` | ⬜ Empty |
| User Profile | `features/user/profile/` | ✅ Complete |
| Driver Profile | `features/driver/driver_profile/` | ✅ Complete |
| Company Profile | `features/company/company_profile/` | ⬜ Empty |
| General Select | `features/general_select/` | ✅ Complete |
| User Settings | `features/user/settings/` | ✅ Complete |
| Driver Settings | `features/driver/driver_settings/` | ✅ Complete |
| Company Settings | `features/company/company_settings/` | ⬜ Empty |

---

## 📊 Acceptance Criteria

- [x] User can register with phone, verify OTP, and login
- [x] Driver can register with vehicle docs and verify
- [ ] Company can register and login
- [x] Onboarding shows on first launch, skippable
- [x] Splash checks token and routes to correct role home
- [ ] Role selection screen shows Consumer/Driver/Company options
- [x] User can view and edit profile
- [x] Driver can view and edit profile with hobbies
- [ ] Company can view and edit company profile
- [x] Biometric login saves and retrieves credentials
- [x] Token refresh works automatically on 401
- [x] Settings screens load About Us, FAQ, Policies from API

---

## 🔗 Phase 1 → Phase 2 Dependencies

| Phase 1 Output | Used By Phase 2 |
|----------------|-----------------|
| Auth tokens & user session | Chat authentication |
| User/Driver profiles | Chat user identity |
| AuthInterceptor token management | WebSocket auth |
| Role-based routing | Role-specific notification channels |
| Driver Reviews feature | Real-time review updates |
