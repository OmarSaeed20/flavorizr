# Phase 6 — Advanced Features: Trips, Booking, Company & Map

> **Duration:** 3–4 weeks | **Priority:** 🟠 High | **Dependencies:** Phase 5  
> **Status:** 🟡 Partially Complete (User trips built, Company & Consumer modules pending)

---

## 📋 Overview

Phase 6 implements the advanced trip management features — public/private trips, schedule trips, direct booking, driver matching, and the complete Company role. This phase brings the full Figma designs to life for all three user roles, integrating deeply with the API's trip and booking endpoints.

**Figma Design References:**
- 🟢 Consumer Trips & Booking: [Figma (node 0-1)](https://www.figma.com/design/YzQcnOIa7TG5auHuL04M9O/Fast-Golden-Taxi--Copy-?node-id=0-1)
- 🔵 Driver Trip Management: [Figma (node 2-37588)](https://www.figma.com/design/YzQcnOIa7TG5auHuL04M9O/Fast-Golden-Taxi--Copy-?node-id=2-37588)
- 🟣 Company Dashboard & Fleet: [Figma (node 2-61931)](https://www.figma.com/design/YzQcnOIa7TG5auHuL04M9O/Fast-Golden-Taxi--Copy-?node-id=2-61931)

**API Endpoints Used:**
- Consumer Home: `GET /user/home`, `GET /user/advertisement`, `GET /user/available-trip`
- Trip Types: `GET /user/trip/types-by-location`
- Public Trips: `POST /user/trip/store-public`, `GET /user/trip/available-public`, `POST /user/trip/confirm`
- Private Trips: `POST /user/trip/store-private`, `POST /user/trip/edit-private`
- Trip Management: `POST /user/trip/book-now`, `POST /user/trip/cancel`, `GET /user/trip/history`, `GET /user/my-orders`, `GET /user/trip/detail/{id}`
- Direct Booking: `POST /user/direct-booking/create-trip`, `POST /user/direct-booking/find-driver`, `POST /user/direct-booking/vehicle-type`, `POST /user/direct-booking/price-preview`
- Schedule Trips (User): `POST /user/schedule-trip/create`, `GET /user/schedule-trip/trips`, `POST /user/schedule-trip/accept-request`
- Schedule Trips (Driver): `POST /driver/schedule-trip/create-request`, `GET /driver/schedule-trip/trips`, `POST /driver/schedule-trip/my-requests`
- Driver Home: `GET /driver/home`
- Driver Trips: `POST /driver/trip/accept`, `POST /driver/trip/reject`, `PATCH /driver/trip/start`, `PATCH /driver/trip/arrived`, `PATCH /driver/trip/complete`, `PATCH /driver/trip/cancel`

---

## 🎯 Goals

| Goal | Success Criteria | Status |
|------|-----------------|--------|
| Consumer Home | Map view, advertisements, available trips | ✅ Built |
| Public Trip Creation | Create public trip with preferences | ✅ Built |
| Private Trip Creation | Create/edit private trip (scheduled/instant) | ✅ Built |
| Direct Booking | Vehicle selection, driver matching, instant booking | ✅ Built |
| Trip History | View past trips with details | ✅ Built |
| Schedule Trips (User) | Create & manage scheduled trips | ✅ Built |
| Schedule Trips (Driver) | Create requests & manage schedule | ✅ Built |
| Driver Home | Active trip view, trip requests | ✅ Built |
| Driver Trip Flow | Accept → Arrive → Start → Complete lifecycle | ✅ Built |
| Driver Reviews | View passenger reviews | ✅ Built |
| Consumer Home UI | Figma-matching consumer home screen | ⬜ Not Started |
| Company Dashboard | Fleet overview, driver management | ⬜ Not Started |
| Company Analytics | Revenue, trip stats, driver performance | ⬜ Not Started |
| Company Fleet | Vehicle management, driver assignment | ⬜ Not Started |
| Company Driver Mgmt | Add/remove drivers, performance tracking | ⬜ Not Started |

---

## 📁 Tasks Breakdown

### Task 6.1: Consumer Home Screen ⬜
**Estimated Time:** 2–3 days

**Objectives:**
- Map-centered home with current location
- Search bar for destination entry
- Available trips carousel
- Advertisements banner
- Quick action buttons (Direct Booking, Schedule Trip)

**API Mapping:**

| Action | Endpoint | Method |
|--------|---------|--------|
| Home Data | `/user/home` | GET |
| Advertisements | `/user/advertisement` | GET |
| Available Trips | `/user/available-trip` | GET |
| Notification Count | `/user/notification-count` | GET |

**Implementation Plan:**
```
features/consumer/consumer_home/
├── data/
│   ├── datasources/consumer_home_remote_datasource.dart
│   ├── models/home_data_model.dart
│   ├── models/advertisement_model.dart
│   └── repositories/consumer_home_repository_impl.dart
├── domain/
│   ├── entities/home_data.dart
│   ├── entities/advertisement.dart
│   └── usecases/get_home_data.dart
└── presentation/
    ├── pages/consumer_home_page.dart
    ├── widgets/
    │   ├── home_map.dart
    │   ├── search_bar_widget.dart
    │   ├── advertisement_carousel.dart
    │   ├── available_trips_list.dart
    │   └── quick_actions.dart
    └── providers/consumer_home_providers.dart
```

**Route:** `/consumer/home`

---

### Task 6.2: Trip Booking Flow (Consumer) ✅
**Estimated Time:** Built under `features/user/trip/` and `features/user/direct_booking/`

**Public Trip Creation Flow (from Figma):**
1. Enter pickup & destination locations
2. Select date, pickup time, drop-off time
3. Choose vehicle type (A/B/S)
4. Set preferences (smoker, pet, luggage)
5. Submit → `POST /user/trip/store-public`

**Private Trip Creation Flow:**
1. Enter pickup & destination
2. Select appointment type: Scheduled (1) or Instant (2)
3. If scheduled: set date & times
4. Choose vehicle type & preferences
5. Submit → `POST /user/trip/store-private`

**Direct Booking Flow:**
1. Enter pickup & destination
2. Get vehicle types with prices → `POST /user/direct-booking/vehicle-type`
3. Preview price → `POST /user/direct-booking/price-preview`
4. Find driver → `POST /user/direct-booking/find-driver`
5. Confirm booking → `POST /user/direct-booking/create-trip`

**Trip Preferences (from API):**
```json
{
  "smoker": true,      // Allow smoking
  "pet": true,         // Allow pets
  "luggage": false,    // Has luggage
  "vehicle_type_id": 1 // 1=A, 2=B, 3=S
}
```

---

### Task 6.3: Trip Management (Consumer) ✅
**Estimated Time:** Built under `features/user/trip/`

**API Mapping:**

| Action | Endpoint | Method |
|--------|---------|--------|
| Book Now | `/user/trip/book-now` | POST |
| Confirm Public Trip | `/user/trip/confirm` | POST |
| Cancel Trip | `/user/trip/cancel` | POST |
| Trip History | `/user/trip/history` | GET |
| My Orders | `/user/my-orders` | GET |
| Available Public | `/user/trip/available-public` | GET |
| Trip Detail | `/user/trip/detail/{id}` | GET |
| Captain Trip Detail | `/user/captain/trip-detail/{id}` | GET |
| Trip Types by Location | `/user/trip/types-by-location` | GET |

---

### Task 6.4: Schedule Trip System ✅
**Estimated Time:** Built under `features/user/schedule_trip/`

**Consumer Schedule API:**

| Action | Endpoint | Method |
|--------|---------|--------|
| Create Schedule Trip | `/user/schedule-trip/create` | POST |
| Get Schedule Trips | `/user/schedule-trip/trips` | GET |
| Accept Request | `/user/schedule-trip/accept-request` | POST |

**Driver Schedule API:**

| Action | Endpoint | Method |
|--------|---------|--------|
| Create Request | `/driver/schedule-trip/create-request` | POST |
| Get Schedule Trips | `/driver/schedule-trip/trips` | GET |
| My Requests | `/driver/schedule-trip/my-requests` | POST |

**Schedule Trip Payload:**
```json
{
  "pick_up_longitude": "35.1552755",
  "pick_up_latitude": "30.1552755",
  "destination_longitude": "50.1552755",
  "destination_latitude": "55.1552755",
  "pickup_name": "Cairo Airport",
  "destination_name": "Downtown Cairo",
  "date": "2024-02-25",
  "pick_up_time": "12:58:44 AM",
  "drop_up_time": "01:50:44 PM",
  "vehicle_type_id": 1,
  "smoker": false,
  "pet": false,
  "luggage": false
}
```

---

### Task 6.5: Driver Home & Trip Management ✅
**Estimated Time:** Built under `features/driver/driver_home/` and `features/driver/driver_trips/`

**API Mapping:**

| Action | Endpoint | Method |
|--------|---------|--------|
| Home Data | `/driver/home` | GET |
| Accept Trip | `/driver/trip/accept` | POST |
| Reject Trip | `/driver/trip/reject` | POST |
| Mark Arrived | `/driver/trip/arrived` | PATCH |
| Start Trip | `/driver/trip/start` | PATCH |
| Complete Trip | `/driver/trip/complete` | PATCH |
| Cancel Trip | `/driver/trip/cancel` | PATCH |

**Driver Trip Flow (from Figma):**
```
New Trip Request → [Accept] → Navigating to Pickup → [Arrived] → Waiting → [Start] → In Progress → [Complete]
                 → [Reject]                                                          → [Cancel]
```

---

### Task 6.6: Driver Reviews ✅
**Estimated Time:** Built under `features/driver/driver_reviews/`

- View reviews from passengers
- Rating summary (average, count)
- Individual review cards

---

### Task 6.7: Company Dashboard ⬜
**Estimated Time:** 3–4 days

**Objectives:**
- Fleet overview (total vehicles, active drivers, trips today)
- Revenue summary (daily/weekly/monthly)
- Active trips map
- Quick stats cards

**Implementation Plan:**
```
features/company/company_home/
├── data/
│   ├── datasources/company_dashboard_remote_datasource.dart
│   ├── models/dashboard_data_model.dart
│   └── repositories/company_dashboard_repository_impl.dart
├── domain/
│   ├── entities/dashboard_data.dart
│   └── usecases/get_dashboard_data.dart
└── presentation/
    ├── pages/company_dashboard_page.dart
    ├── widgets/
    │   ├── fleet_overview_card.dart
    │   ├── revenue_summary_card.dart
    │   ├── active_trips_map.dart
    │   └── stats_grid.dart
    └── providers/company_dashboard_providers.dart
```

**Route:** `/company/dashboard`

---

### Task 6.8: Company Fleet Management ⬜
**Estimated Time:** 2–3 days

**Objectives:**
- View all company vehicles
- Add/edit vehicle details
- Vehicle status tracking (active/inactive/maintenance)
- Assign drivers to vehicles

**Routes:** `/company/fleet`, `/company/fleet/vehicle/{id}`, `/company/fleet/add`

---

### Task 6.9: Company Driver Management ⬜
**Estimated Time:** 2–3 days

**Objectives:**
- View all company drivers
- Driver performance metrics
- Add/invite new drivers
- Suspend/activate drivers
- Driver trip history

**Routes:** `/company/drivers`, `/company/drivers/{id}`, `/company/drivers/add`

---

### Task 6.10: Company Analytics ⬜
**Estimated Time:** 2–3 days

**Objectives:**
- Revenue charts (line/bar by day/week/month)
- Trip volume analytics
- Driver performance rankings
- Customer satisfaction metrics
- Zone-based analytics

**Routes:** `/company/analytics`

---

### Task 6.11: Company Trip Management ⬜
**Estimated Time:** 2 days

**Objectives:**
- View all company trips
- Filter by driver, status, date
- Trip detail with full timeline
- Dispute management

**Routes:** `/company/trips`, `/company/trips/{id}`

---

## 📊 Implementation Status Summary

| Module | Location | Status |
|--------|----------|--------|
| User Home | `features/user/home/` | ✅ Complete |
| User Trips | `features/user/trip/` | ✅ Complete |
| User Direct Booking | `features/user/direct_booking/` | ✅ Complete |
| User Schedule Trip | `features/user/schedule_trip/` | ✅ Complete |
| Driver Home | `features/driver/driver_home/` | ✅ Complete |
| Driver Trips | `features/driver/driver_trips/` | ✅ Complete |
| Driver Reviews | `features/driver/driver_reviews/` | ✅ Complete |
| Consumer Home | `features/consumer/consumer_home/` | ⬜ Empty |
| Consumer Trips | `features/consumer/consumer_trips/` | ⬜ Empty |
| Consumer Payments | `features/consumer/consumer_payments/` | ⬜ Empty |
| Company Home | `features/company/company_home/` | ⬜ Empty |
| Company Analytics | `features/company/company_analytics/` | ⬜ Empty |
| Company Drivers | `features/company/company_drivers/` | ⬜ Empty |

---

## 📊 Acceptance Criteria

- [x] Consumer can create public trip with preferences
- [x] Consumer can create private trip (scheduled/instant)
- [x] Consumer can browse and join public trips
- [x] Direct booking shows vehicle options with prices
- [x] Driver can accept/reject trip requests
- [x] Driver can execute full trip lifecycle (accept → arrive → start → complete)
- [x] Schedule trips work for both Consumer and Driver
- [ ] Consumer home screen matches Figma design with map + search
- [ ] Company dashboard shows fleet overview
- [ ] Company can manage drivers (add, suspend, track)
- [ ] Company analytics show revenue and trip charts
- [ ] All company routes render actual screens (not placeholders)

---

## 🔗 Phase 6 → Phase 7 Dependencies

| Phase 6 Output | Used By Phase 7 |
|----------------|-----------------|
| Trip creation flows | Integration tests for booking |
| Driver trip lifecycle | Unit tests for state transitions |
| Company features | Widget tests for dashboard components |
| Direct booking | End-to-end booking test flow |
