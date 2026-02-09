# Phase 3 — Monetization: Payments, Pricing & Wallet

> **Duration:** 2–3 weeks | **Priority:** 🟠 High | **Dependencies:** Phase 2  
> **Status:** ⬜ Not Started

---

## 📋 Overview

Phase 3 implements the financial layer of the Fast Golden Taxi app — trip pricing calculation, payment processing, wallet system, and earnings management for Drivers. The API provides endpoints for price calculation, vehicle-type-based pricing, and direct booking payment flows.

**Figma Design References:**
- 🟢 Consumer Payments/Wallet: [Figma (node 0-1)](https://www.figma.com/design/YzQcnOIa7TG5auHuL04M9O/Fast-Golden-Taxi--Copy-?node-id=0-1)
- 🔵 Driver Earnings: [Figma (node 2-37588)](https://www.figma.com/design/YzQcnOIa7TG5auHuL04M9O/Fast-Golden-Taxi--Copy-?node-id=2-37588)
- 🟣 Company Revenue: [Figma (node 2-61931)](https://www.figma.com/design/YzQcnOIa7TG5auHuL04M9O/Fast-Golden-Taxi--Copy-?node-id=2-61931)

**API Endpoints Used:**
- Pricing: `POST /user/direct-booking/test-total-price`, `POST /user/direct-booking/price-preview`, `POST /user/direct-booking/transfer-trip-price`
- Vehicle Types: `POST /user/direct-booking/vehicle-type`, `GET /select/vehicle-type`
- Trip Evaluation: `POST /user/trip/evaluation`

---

## 🎯 Goals

| Goal | Success Criteria | Status |
|------|-----------------|--------|
| Trip Pricing | Calculate price based on distance, vehicle type | ⬜ |
| Price Preview | Show fare estimate before booking | ⬜ |
| Vehicle Type Pricing | Different rates for Type A, B, S vehicles | ⬜ |
| Consumer Wallet | View balance, transaction history | ⬜ |
| Payment Methods | Cash, wallet, card payment options | ⬜ |
| Driver Earnings | Daily/weekly/monthly earnings dashboard | ⬜ |
| Company Revenue | Fleet-wide revenue analytics | ⬜ |
| Trip Evaluation | Rate & review trips with payment feedback | ⬜ |

---

## 📁 Tasks Breakdown

### Task 3.1: Trip Pricing Engine ⬜
**Estimated Time:** 2–3 days

**Objectives:**
- Calculate trip price based on pickup/destination coordinates
- Support different vehicle types (A=1, B=2, S=3)
- Show price preview before confirming booking

**API Mapping:**

| Action | Endpoint | Method |
|--------|---------|--------|
| Test Total Price | `/user/direct-booking/test-total-price` | POST |
| Price Preview | `/user/direct-booking/price-preview` | POST |
| Transfer Trip Price | `/user/direct-booking/transfer-trip-price` | POST |
| Get Vehicle Types | `/user/direct-booking/vehicle-type` | POST |

**Price Calculation Request:**
```json
{
  "pick_up_longitude": "35.1552755",
  "pick_up_latitude": "30.1552755",
  "destination_longitude": "50.1552755",
  "destination_latitude": "55.1552755",
  "vehicle_type_id": 1
}
```

**Vehicle Types (from API):**
- `1` = Type A (Economy)
- `2` = Type B (Comfort)
- `3` = Type S (Premium/Special)

**Implementation Plan:**
```
features/consumer/consumer_payments/
├── data/
│   ├── datasources/payment_remote_datasource.dart
│   ├── models/price_estimate_model.dart
│   ├── models/vehicle_type_model.dart
│   └── repositories/payment_repository_impl.dart
├── domain/
│   ├── entities/price_estimate.dart
│   ├── entities/vehicle_type.dart
│   └── usecases/calculate_price.dart
└── presentation/
    ├── pages/price_preview_page.dart
    ├── widgets/vehicle_type_selector.dart
    └── widgets/price_breakdown_card.dart
```

---

### Task 3.2: Consumer Wallet System ⬜
**Estimated Time:** 3–4 days

**Objectives:**
- Wallet balance display
- Transaction history (trips, top-ups, refunds)
- Top-up wallet functionality
- Payment method selection (cash/wallet/card)

**Implementation Plan:**
- Routes: `/consumer/wallet`, `/consumer/wallet/top-up`, `/consumer/wallet/transactions`
- Show wallet balance on home screen
- Transaction list with filters (date, type)
- Figma: Wallet screens from Consumer page

---

### Task 3.3: Payment Flow ⬜
**Estimated Time:** 3–4 days

**Objectives:**
- Select payment method before trip confirmation
- Process payment on trip completion
- Handle payment failures & retries
- Payment confirmation notification

**Payment Methods:**
- Cash (default) — Mark paid on driver confirmation
- Wallet — Deduct from balance automatically
- Card — Integrate payment gateway (future)

**Flow:**
1. Consumer selects vehicle type → Price preview
2. Consumer selects payment method
3. Trip completes → Payment processed
4. Both parties notified of payment status

---

### Task 3.4: Driver Earnings Dashboard ⬜
**Estimated Time:** 2–3 days

**Objectives:**
- Daily/weekly/monthly earnings summary
- Trip-by-trip earnings breakdown
- Earnings history & charts
- Payout tracking

**Implementation Plan:**
- Route: `/driver/earnings` (already defined in routes)
- Dashboard with earnings cards (today, this week, this month)
- Trip list with individual earnings
- Earnings chart (line/bar)

---

### Task 3.5: Trip Evaluation & Rating ⬜
**Estimated Time:** 1–2 days

**Objectives:**
- Rate driver after trip (1–5 stars)
- Leave comment/review
- Report trip issues

**API Mapping:**

| Action | Endpoint | Method |
|--------|---------|--------|
| Rate Trip | `/user/trip/evaluation` | POST |
| Report Trip | `/user/trip/report` | POST |

**Evaluation Payload:**
```json
{
  "order_id": 5,
  "driver_id": 15,
  "rate": 4.5,
  "comment": "Great driver, smooth ride",
  "another_note": "Arrived on time"
}
```

**Report Payload:**
```json
{
  "order_id": 8,
  "comment": "Driver took wrong route",
  "another_note": "Extra charges applied"
}
```

---

### Task 3.6: Company Revenue Dashboard ⬜
**Estimated Time:** 2–3 days

**Objectives:**
- Fleet-wide revenue overview
- Per-driver earnings breakdown
- Revenue trends & analytics
- Commission tracking

**Implementation Plan:**
- Route: `/company/earnings` (defined in routes)
- Aggregate revenue from all company drivers
- Charts for daily/weekly/monthly trends
- Figma: Company analytics screens

---

## 📊 Acceptance Criteria

- [ ] Price preview shows correct fare for selected vehicle type
- [ ] Consumer can select payment method before booking
- [ ] Payment processes automatically on trip completion
- [ ] Driver earnings dashboard shows accurate daily/weekly/monthly totals
- [ ] Trip rating/review submits successfully
- [ ] Trip report creates support ticket
- [ ] Company revenue dashboard aggregates fleet earnings
- [ ] Wallet balance updates in real-time after transactions

---

## 🔗 Phase 3 → Phase 4 Dependencies

| Phase 3 Output | Used By Phase 4 |
|----------------|-----------------|
| Payment UI components | Accessibility compliance |
| Price display widgets | RTL/LTR layout support |
| Earnings charts | Adaptive widget rendering |
| Rating UI | Platform-specific rating dialog |
