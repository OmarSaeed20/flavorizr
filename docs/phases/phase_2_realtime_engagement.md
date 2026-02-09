# Phase 2 — Real-time Engagement: Chat, Notifications & Live Tracking

> **Duration:** 3–4 weeks | **Priority:** 🔴 Critical | **Dependencies:** Phase 1  
> **Status:** 🟡 Partially Complete (Chat & Notifications built, live tracking in progress)

---

## 📋 Overview

Phase 2 implements real-time communication between Consumers and Drivers, push notifications for trip events, and live location tracking during active trips. This phase leverages the WebSocket infrastructure from Phase 0 and the Socket.IO channels documented in the API.

**Figma Design References:**
- 🟢 Consumer Chat & Tracking: [Figma (node 0-1)](https://www.figma.com/design/YzQcnOIa7TG5auHuL04M9O/Fast-Golden-Taxi--Copy-?node-id=0-1)
- 🔵 Driver Trip Tracking: [Figma (node 2-37588)](https://www.figma.com/design/YzQcnOIa7TG5auHuL04M9O/Fast-Golden-Taxi--Copy-?node-id=2-37588)

**API Endpoints Used:**
- Chat: `GET /user/chat/{order_id}`, `POST /user/chat/save`
- Notifications: `GET /user/notification`, `GET /user/notification-count`
- Real-time: Socket.IO channels for trip tracking, chat, driver location
- Test: `POST /test/socket-io-channel`, `GET /user/test/send-fcm`, `GET /user/test/send-sms`

---

## 🎯 Goals

| Goal | Success Criteria | Status |
|------|-----------------|--------|
| In-Trip Chat | Consumer ↔ Driver messaging per order | ✅ Built |
| Push Notifications | FCM notifications for trip events | ✅ Built |
| Notification Center | In-app notification list & badge count | ✅ Built |
| Live Trip Tracking | Real-time driver location on map during trip | 🟡 In Progress |
| Socket.IO Integration | Real-time event channels for trips & chat | 🟡 In Progress |
| Driver Location Updates | Continuous GPS broadcast during active trip | ⬜ Not Started |
| Trip Status Events | Real-time trip state changes (accepted, started, arrived, completed) | ⬜ Not Started |

---

## 📁 Tasks Breakdown

### Task 2.1: In-Trip Chat System ✅
**Estimated Time:** 3–4 days

**Objectives:**
- Order-based chat between Consumer and Driver
- Message send/receive with real-time updates
- Chat history retrieval

**Implementation Status:** ✅ Complete (under `features/user/chat/`)

**API Mapping:**

| Action | Endpoint | Method |
|--------|---------|--------|
| Get Chat Messages | `/user/chat/{order_id}` | GET |
| Send Message | `/user/chat/save` | POST |

**Send Message Payload:**
```json
{
  "order_id": 1,
  "message": "Hello, I'm at the pickup point",
  "receiver_id": 2
}
```

**Architecture:**
```
features/user/chat/
├── data/
│   ├── datasources/chat_remote_datasource.dart
│   ├── endpoints/chat_endpoints.dart
│   ├── models/chat_message_model.dart
│   ├── parameters/chat_parameters.dart
│   └── repositories/chat_repository_impl.dart
├── domain/
│   ├── entities/chat_message.dart
│   ├── repositories/chat_repository.dart
│   └── usecases/
│       ├── get_chat_messages.dart
│       └── send_message.dart
└── presentation/
    ├── controllers/chat_controller.dart
    ├── pages/chat_page.dart
    ├── providers/chat_providers.dart
    └── widgets/
        ├── message_bubble.dart
        ├── message_input.dart
        └── chat_list.dart
```

---

### Task 2.2: Push Notification Service ✅
**Estimated Time:** 2–3 days

**Objectives:**
- Firebase Cloud Messaging (FCM) integration
- Background message handling
- Local notification display
- Token management for push delivery

**Implementation Status:** ✅ Complete

**Components:**
- `lib/core/services/notification_service.dart` — FCM setup, token management
- `lib/bootstrap.dart` — `FirebaseMessaging.onBackgroundMessage()` handler
- Firebase token sent during OTP verification (`firebase_token` field)

**FCM Events:**
- Trip request received (Driver)
- Trip accepted/rejected (Consumer)
- Driver arrived at pickup
- Trip started
- Trip completed
- New chat message
- Schedule trip updates

---

### Task 2.3: Notification Center ✅
**Estimated Time:** 2 days

**Objectives:**
- List all notifications with read/unread status
- Badge count for unread notifications
- Pull-to-refresh

**Implementation Status:** ✅ Complete (under `features/user/notification/`)

**API Mapping:**

| Action | Endpoint | Method |
|--------|---------|--------|
| Get Notifications | `/user/notification` | GET |
| Get Unread Count | `/user/notification-count` | GET |

**Routes:**
- Consumer: `/consumer/notifications`
- Consumer badge: `/consumer/home` (header badge)

---

### Task 2.4: Socket.IO Real-time Integration 🟡
**Estimated Time:** 3–4 days

**Objectives:**
- Socket.IO client connection with auth
- Channel subscription for trip events
- Real-time message delivery
- Presence status updates

**Implementation Plan:**

**WebSocket Infrastructure (already built in Phase 0):**
- `core/network/websocket/websocket_client.dart` — Connection management
- `core/network/websocket/websocket_event_handler.dart` — Event routing
- `core/network/websocket/websocket_manager.dart` — Lifecycle management

**Socket.IO Channels to Implement:**

| Channel | Purpose | Events |
|---------|---------|--------|
| `trip.{trip_id}` | Trip lifecycle | accepted, started, arrived, completed, cancelled |
| `chat.{order_id}` | In-trip messaging | new_message, typing, read_receipt |
| `driver.{driver_id}` | Driver location | location_update, status_change |
| `user.{user_id}` | User notifications | trip_request, trip_update, system_message |

**Test Endpoint:** `POST /test/socket-io-channel` — For development testing

---

### Task 2.5: Live Trip Tracking ⬜
**Estimated Time:** 3–4 days

**Objectives:**
- Display driver location on map in real-time
- ETA updates during trip
- Route visualization (pickup → destination)
- Trip status indicators

**Implementation Plan:**
- Route: `/consumer/tracking` (already defined)
- Use Google Maps Flutter plugin
- Subscribe to `driver.{driver_id}` socket channel
- Update map marker on `location_update` events
- Show trip status bar (Accepted → Arrived → Started → Completed)

**Consumer Tracking Screen (from Figma):**
- Map with driver marker & route polyline
- Bottom sheet with driver info, ETA, trip status
- Call/Chat buttons
- Cancel trip option (before pickup)

**Driver Tracking Screen (from Figma):**
- Map with passenger pickup marker
- Navigation mode with turn-by-turn
- Status buttons: "I've Arrived" → "Start Trip" → "Complete Trip"
- Passenger info panel

---

### Task 2.6: Driver Location Broadcasting ⬜
**Estimated Time:** 2 days

**Objectives:**
- Continuous GPS location updates during active trip
- Battery-optimized location service
- Background location when app is minimized

**Implementation Plan:**
- Use `geolocator` package for GPS
- Broadcast location via Socket.IO every 5 seconds
- Reduce frequency when stationary
- Handle location permission flows

---

### Task 2.7: Trip Status Events ⬜
**Estimated Time:** 2 days

**Objectives:**
- Real-time trip state machine updates
- Push notification + in-app update on state change
- Sound/vibration alerts for drivers on new trip requests

**Trip State Machine:**
```
CREATED → ACCEPTED → DRIVER_ARRIVED → STARTED → COMPLETED
                 ↘ REJECTED          ↘ CANCELLED
```

**Driver API Actions:**

| Action | Endpoint | Method |
|--------|---------|--------|
| Accept Trip | `/driver/trip/accept` | POST |
| Reject Trip | `/driver/trip/reject` | POST |
| Mark Arrived | `/driver/trip/arrived` | PATCH |
| Start Trip | `/driver/trip/start` | PATCH |
| Complete Trip | `/driver/trip/complete` | PATCH |
| Cancel Trip | `/driver/trip/cancel` | PATCH |

---

## 📊 Implementation Status Summary

| Module | Location | Status |
|--------|----------|--------|
| Chat | `features/user/chat/` | ✅ Complete |
| Notifications | `features/user/notification/` | ✅ Complete |
| FCM Service | `core/services/notification_service.dart` | ✅ Complete |
| WebSocket Client | `core/network/websocket/` | ✅ Built (needs Socket.IO adaptation) |
| Live Tracking | `features/consumer/consumer_trips/` | ⬜ Empty |
| Driver Location | `features/driver/driver_trips/` | 🟡 Partial |
| Trip Events | Socket.IO integration | ⬜ Not Started |

---

## 📊 Acceptance Criteria

- [x] Consumer can chat with Driver during active trip
- [x] Push notifications received for trip events
- [x] Notification list shows with unread badge count
- [ ] Driver location appears on Consumer's map in real-time
- [ ] Trip status changes broadcast to both parties instantly
- [ ] Driver can tap "Arrived" → "Start" → "Complete" flow
- [ ] Socket.IO channels connect with auth and handle reconnection
- [ ] Background location updates continue when app minimized

---

## 🔗 Phase 2 → Phase 3 Dependencies

| Phase 2 Output | Used By Phase 3 |
|----------------|-----------------|
| Trip completion events | Payment trigger |
| Chat system | Payment dispute communication |
| Notification service | Payment confirmation notifications |
| Socket.IO channels | Real-time payment status updates |
