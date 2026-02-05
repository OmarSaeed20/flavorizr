# FAST App API Documentation

**Base URL:** `https://fasttaxi.questifysolutions.com/api/v1`

**Version:** v1

---

## Table of Contents

- [Authentication](#authentication)
  - [User Authentication](#user-authentication)
  - [Driver Authentication](#driver-authentication)
- [User Endpoints](#user-endpoints)
  - [Profile](#user-profile)
  - [Home](#user-home)
  - [Trip Management](#trip-management)
  - [Notifications](#notifications)
  - [Chatting](#chatting)
  - [Schedule Trip](#schedule-trip)
  - [Direct Booking](#direct-booking)
- [Driver Endpoints](#driver-endpoints)
  - [Settings](#driver-settings)
  - [Profile](#driver-profile)
  - [Home](#driver-home)
  - [Trip Management](#driver-trip-management)
  - [Schedule Trip](#driver-schedule-trip)
- [General Endpoints](#general-endpoints)
- [Test Endpoints](#test-endpoints)

---

## Authentication

### User Authentication

#### Login
Authenticate a user with phone number and password.

**Endpoint:** `POST /auth/login`

**Request Body:**
```json
{
  "phone": "01001107528",
  "phone_iso_code": "EG",
  "password": "12345678"
}
```

**Response:** Returns authentication token and user details.

---

#### Register
Register a new user account.

**Endpoint:** `POST /auth/register`

**Request Body:**
```json
{
  "company_type": "TEST",
  "name": "Omar Saed",
  "nickname": "Mora",
  "phone": "01067496938",
  "phone_iso2_code": "EG",
  "password": "12345678",
  "password_confirmation": "12345678",
  "country_id": 1,
  "governorate_id": 1,
  "birthdate": "1999",
  "gender": "male"
}
```

**Fields:**
- `company_type`: Type of user - 'customer', 'driver', or 'company'
- `name`: User's full name (required)
- `nickname`: User's nickname (optional)
- `phone`: Phone number (required)
- `phone_iso2_code`: ISO2 country code for phone
- `password`: Password (required, must meet security rules)
- `password_confirmation`: Password confirmation (required)
- `country_id`: Country ID
- `governorate_id`: Governorate ID
- `birthdate`: Birthdate in YYYY-MM-DD format (required)
- `gender`: 'male' or 'female' (required)

---

#### Confirmation Code
Request a verification code for phone number.

**Endpoint:** `POST /auth/confirmation-code`

**Request Body:**
```json
{
  "phone": "1234967890"
}
```

---

#### User Verify
Verify user account with verification code.

**Endpoint:** `POST /auth/user-verify`

**Request Body:**
```json
{
  "phone": "1234967890",
  "verification_code": "4746",
  "firebase_token": "123456"
}
```

---

#### Forget Password
Request password reset for a phone number.

**Endpoint:** `POST /auth/forget-password`

**Request Body:**
```json
{
  "phone": "01111111111"
}
```

---

#### Reset Password
Reset password using the reset token.

**Endpoint:** `POST /auth/reset-password`

**Request Body:**
```json
{
  "phone": "1234967890",
  "password": "123456789",
  "password_confirmation": "123456789",
  "token": "6|EYkp6fJPWLLbymZElqJFMXpqwaeUJzy1p1rWpgjIz832e9d15"
}
```

---

#### Logout
Logout the authenticated user.

**Endpoint:** `POST /auth/logout`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Refresh Token
Refresh the authentication token.

**Endpoint:** `POST /driver/auth/refresh`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

### Driver Authentication

#### Login
Authenticate a driver with phone number and password.

**Endpoint:** `POST /driver/auth/login`

**Request Body:**
```json
{
  "phone": "201063753136",
  "phone_iso_code": "EG",
  "password": "12345678"
}
```

---

#### Register
Register a new driver account.

**Endpoint:** `POST /driver/auth/register`

**Request Body:**
```json
{
  "phone": "201063753136",
  "phone_iso_code": "EG",
  "password": "12345678",
  "password_confirmation": "12345678",
  "name": "Driver Name",
  "gender": "male",
  "birth_date": "1990-01-01",
  "country_id": 1,
  "governorate_id": 1,
  "vehicle_type_id": 1,
  "vehicle_model": "Toyota Camry",
  "vehicle_year": "2020",
  "vehicle_color": "White",
  "vehicle_plate_number": "ABC1234",
  "license_front_image": "base64_image",
  "license_back_image": "base64_image",
  "vehicle_license_image": "base64_image",
  "national_id_image": "base64_image"
}
```

---

#### User Verify
Verify driver account with verification code.

**Endpoint:** `POST /driver/auth/user-verify`

**Request Body:**
```json
{
  "phone": "011111122222",
  "verification_code": "2782",
  "firebase_token": "123456"
}
```

---

#### Forget Password
Request password reset for driver.

**Endpoint:** `POST /driver/auth/forget-password`

**Request Body:**
```json
{
  "phone": "011111122222"
}
```

---

#### Reset Password
Reset driver password using verification code.

**Endpoint:** `POST /driver/auth/reset-password`

**Request Body:**
```json
{
  "code": "3658",
  "phone": "011111122222",
  "password": "123456789",
  "password_confirmation": "123456789"
}
```

---

#### Logout
Logout the authenticated driver.

**Endpoint:** `POST /driver/auth/logout`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Refresh Token
Refresh the driver authentication token.

**Endpoint:** `POST /driver/auth/refresh`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

## User Endpoints

### User Profile

#### Get Profile
Get the authenticated user's profile.

**Endpoint:** `GET /user/profile`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Get Profile Detail
Get detailed profile information.

**Endpoint:** `GET /user/profile/detail`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Update Profile Info
Update user profile information.

**Endpoint:** `POST /user/profile/update-info`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "name": "Updated Name",
  "nickname": "Updated Nickname",
  "email": "user@example.com",
  "gender": "male",
  "birth_date": "1990-01-01",
  "image": "base64_image_string"
}
```

---

#### Get Driver Reviews
Get reviews for a specific driver.

**Endpoint:** `GET /user/driver/reviews`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Query Parameters:**
- `driver_id`: Driver ID (required)

---

### User Home

#### Get Home Data
Get home page data including available trips and advertisements.

**Endpoint:** `GET /user/home`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Get Advertisements
Get list of advertisements.

**Endpoint:** `GET /user/advertisement`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Get Available Trip
Get available trips for booking.

**Endpoint:** `GET /user/available-trip`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Get Notification Count
Get count of unread notifications.

**Endpoint:** `GET /user/notification-count`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

### Trip Management

#### Get Trip Types by Location
Get available trip types based on pickup and destination locations.

**Endpoint:** `GET /user/trip/types-by-location`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Query Parameters:**
- `pick_up_latitude`: Pickup latitude
- `pick_up_longitude`: Pickup longitude
- `destination_latitude`: Destination latitude
- `destination_longitude`: Destination longitude

---

#### Get Captain Trip Detail
Get details of a trip by trip ID (for captain view).

**Endpoint:** `GET /user/captain/trip-detail/{trip_id}`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Store Public Trip
Create a new public trip that other users can join.

**Endpoint:** `POST /user/trip/store-public`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "pick_up_longitude": "35.1552755",
  "pick_up_latitude": "30.1552755",
  "destination_longitude": "50.1552755",
  "destination_latitude": "55.1552755",
  "pickup_name": "location_pickup_name_test",
  "destination_name": "location_destination_name_test",
  "date": "2024-02-25",
  "pick_up_time": "12:58:44 AM",
  "drop_up_time": "01:50:44 PM",
  "smoker": true,
  "pet": true,
  "luggage": false,
  "vehicle_type_id": 1
}
```

**Fields:**
- `pick_up_longitude`: Pickup longitude
- `pick_up_latitude`: Pickup latitude
- `destination_longitude`: Destination longitude
- `destination_latitude`: Destination latitude
- `pickup_name`: Pickup location name
- `destination_name`: Destination location name
- `date`: Trip date (YYYY-MM-DD)
- `pick_up_time`: Pickup time
- `drop_up_time`: Drop-off time
- `smoker`: Allow smoking (true/false)
- `pet`: Allow pets (true/false)
- `luggage`: Allow luggage (true/false)
- `vehicle_type_id`: Vehicle type ID (1=A, 2=B, 3=S)

---

#### Store Private Trip
Create a new private trip.

**Endpoint:** `POST /user/trip/store-private`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "pick_up_longitude": "35.1552755",
  "pick_up_latitude": "30.1552755",
  "destination_longitude": "50.1552755",
  "destination_latitude": "55.1552755",
  "pickup_name": "location_pickup_name_test",
  "destination_name": "location_destination_name_test",
  "vehicle_type_id": 1,
  "smoker": true,
  "pet": false,
  "luggage": true,
  "appointment_type": "1",
  "date": "2024-02-25",
  "pick_up_time": "12:58:44 AM",
  "drop_up_time": "01:50:44 PM"
}
```

**Fields:**
- `appointment_type`: "1" for scheduled, "2" for instant
- Other fields same as public trip
- For scheduled trips: `date`, `pick_up_time`, `drop_up_time` are required

---

#### Edit Private Trip
Edit an existing private trip.

**Endpoint:** `POST /user/trip/edit-private`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "order_id": 15,
  "pick_up_longitude": "35.1552755",
  "pick_up_latitude": "30.1552755",
  "destination_longitude": "50.1552755",
  "destination_latitude": "55.1552755",
  "date": "2024-02-25",
  "pick_up_time": "11:50:44 AM",
  "drop_up_time": "01:50:44 PM",
  "smoker": false,
  "pet": true,
  "luggage": false,
  "vehicle_type_id": 1
}
```

---

#### Book Now Order
Book a trip immediately.

**Endpoint:** `POST /user/trip/book-now`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "order_id": 13
}
```

---

#### Trip History
Get user's trip history.

**Endpoint:** `GET /user/trip/history`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Query Parameters:**
- `page`: Page number (optional)
- `limit`: Items per page (optional)
- `status`: Filter by status (optional)

---

#### My Orders
Get user's current and past orders.

**Endpoint:** `GET /user/my-orders`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Available Public Trips
Get available public trips that user can join.

**Endpoint:** `GET /user/trip/available-public`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Query Parameters:**
- `order_id`: Order ID
- `user_id`: User ID

---

#### Confirm Trip
Confirm and join a public trip.

**Endpoint:** `POST /user/trip/confirm`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "order_id": "11",
  "user_id": "63"
}
```

---

#### Cancel Trip
Cancel a trip.

**Endpoint:** `POST /user/trip/cancel`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "order_id": "10",
  "user_id": "63"
}
```

---

#### Report Trip
Report an issue with a trip.

**Endpoint:** `POST /user/trip/report`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "order_id": 8,
  "comment": "test comment",
  "another_note": "another note test"
}
```

---

#### Trip Evaluation
Rate and review a trip.

**Endpoint:** `POST /user/trip/evaluation`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "order_id": 5,
  "driver_id": 15,
  "rate": 2.20,
  "comment": "test comment",
  "another_note": "another note test"
}
```

---

#### Get Trip Detail
Get detailed information about a specific trip.

**Endpoint:** `GET /user/trip/detail/{trip_id}`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

### Notifications

#### Get Notifications
Get list of user notifications.

**Endpoint:** `GET /user/notification`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Get Notification Count
Get count of unread notifications.

**Endpoint:** `GET /user/notification-count`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

### Chatting

#### Get Chat by Order
Get chat messages for a specific order.

**Endpoint:** `GET /user/chat/{order_id}`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Save Message
Send a chat message.

**Endpoint:** `POST /user/chat/save`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "order_id": 1,
  "message": "Hello",
  "receiver_id": 2
}
```

---

### Schedule Trip

#### Create Schedule Trip
Create a scheduled trip request.

**Endpoint:** `POST /user/schedule-trip/create`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "pick_up_longitude": "35.1552755",
  "pick_up_latitude": "30.1552755",
  "destination_longitude": "50.1552755",
  "destination_latitude": "55.1552755",
  "pickup_name": "Pickup Location",
  "destination_name": "Destination Location",
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

#### Get Schedule Trips
Get user's scheduled trips.

**Endpoint:** `GET /user/schedule-trip/trips`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Accept Request
Accept a schedule trip request (for drivers).

**Endpoint:** `POST /user/schedule-trip/accept-request`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "request_id": 1
}
```

---

### Direct Booking

#### Create Trip
Create a direct booking trip.

**Endpoint:** `POST /user/direct-booking/create-trip`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "pick_up_longitude": "35.1552755",
  "pick_up_latitude": "30.1552755",
  "destination_longitude": "50.1552755",
  "destination_latitude": "55.1552755",
  "pickup_name": "Pickup Location",
  "destination_name": "Destination Location",
  "vehicle_type_id": 1
}
```

---

#### Test Total Price
Calculate total price for a trip.

**Endpoint:** `POST /user/direct-booking/test-total-price`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "pick_up_longitude": "35.1552755",
  "pick_up_latitude": "30.1552755",
  "destination_longitude": "50.1552755",
  "destination_latitude": "55.1552755",
  "vehicle_type_id": 1
}
```

---

#### Get Vehicle Types
Get available vehicle types for direct booking.

**Endpoint:** `POST /user/direct-booking/vehicle-type`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "pick_up_longitude": "35.1552755",
  "pick_up_latitude": "30.1552755",
  "destination_longitude": "50.1552755",
  "destination_latitude": "55.1552755"
}
```

---

#### Find Driver
Find available drivers for a trip.

**Endpoint:** `POST /user/direct-booking/find-driver`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "pick_up_longitude": "35.1552755",
  "pick_up_latitude": "30.1552755",
  "destination_longitude": "50.1552755",
  "destination_latitude": "55.1552755",
  "vehicle_type_id": 1,
  "pickup_name": "Pickup Location",
  "destination_name": "Destination Location"
}
```

---

#### Transfer Trip Price
Get transfer trip pricing.

**Endpoint:** `POST /user/direct-booking/transfer-trip-price`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "pick_up_longitude": "35.1552755",
  "pick_up_latitude": "30.1552755",
  "destination_longitude": "50.1552755",
  "destination_latitude": "55.1552755",
  "vehicle_type_id": 1,
  "pickup_name": "Pickup Location",
  "destination_name": "Destination Location"
}
```

---

#### Price Preview
Get price preview for a trip.

**Endpoint:** `POST /user/direct-booking/price-preview`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "pick_up_longitude": "35.1552755",
  "pick_up_latitude": "30.1552755",
  "destination_longitude": "50.1552755",
  "destination_latitude": "55.1552755",
  "vehicle_type_id": 1
}
```

---

## Driver Endpoints

### Driver Settings

#### About Us
Get about us information.

**Endpoint:** `GET /driver/setting/about-us`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Questions
Get frequently asked questions.

**Endpoint:** `GET /driver/setting/questions`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Policies
Get app policies.

**Endpoint:** `GET /driver/setting/policies`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### General Settings
Get general app settings.

**Endpoint:** `GET /driver/setting/general`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Update Vehicle Types
Update driver's available vehicle types.

**Endpoint:** `POST /driver/setting/update-vehicle-types`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "vehicle_type_ids": [1, 2, 3]
}
```

---

### Driver Profile

#### Get Profile
Get driver's profile.

**Endpoint:** `GET /driver/profile`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Get Profile Detail
Get detailed driver profile.

**Endpoint:** `GET /driver/profile/detail`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Update Profile Info
Update driver profile information.

**Endpoint:** `POST /driver/profile/update-info`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "name": "driver test",
  "gender": "male",
  "phone_number": "0222222222",
  "email": "driver_test@main.com",
  "birth_date": "2023-10-24",
  "hobbies_ids": [1, 5],
  "favorite_note": "favorite note test 2"
}
```

---

#### Get User Profile
Get profile of a specific user.

**Endpoint:** `GET /driver/profile/user/{user_id}`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

### Driver Profile User

#### Get User Trip
Get trip history of a specific user.

**Endpoint:** `GET /driver/profile-user/trip/{user_id}`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

### Driver Home

#### Get Home Data
Get driver home page data.

**Endpoint:** `GET /driver/home`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

### Driver Trip Management

#### Accept Trip
Accept a trip request.

**Endpoint:** `POST /driver/trip/accept`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "trip_id": 1
}
```

---

#### Reject Trip
Reject a trip request.

**Endpoint:** `POST /driver/trip/reject`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "trip_id": 1
}
```

---

#### Start Trip
Start a trip.

**Endpoint:** `PATCH /driver/trip/start`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "trip_id": 1
}
```

---

#### Arrived
Mark driver as arrived at pickup location.

**Endpoint:** `PATCH /driver/trip/arrived`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "trip_id": 1
}
```

---

#### Complete Trip
Complete a trip.

**Endpoint:** `PATCH /driver/trip/complete`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "trip_id": 1
}
```

---

#### Cancel Trip
Cancel a trip.

**Endpoint:** `PATCH /driver/trip/cancel`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "trip_id": 1
}
```

---

### Driver Schedule Trip

#### Get Schedule Trips
Get driver's scheduled trips.

**Endpoint:** `GET /driver/schedule-trip/trips`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Create Request
Create a schedule trip request.

**Endpoint:** `POST /driver/schedule-trip/create-request`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Request Body:**
```json
{
  "pick_up_longitude": "35.1552755",
  "pick_up_latitude": "30.1552755",
  "destination_longitude": "50.1552755",
  "destination_latitude": "55.1552755",
  "pickup_name": "Pickup Location",
  "destination_name": "Destination Location",
  "date": "2024-02-25",
  "pick_up_time": "12:58:44 AM",
  "drop_up_time": "01:50:44 PM",
  "vehicle_type_id": 1
}
```

---

#### Get My Requests
Get driver's schedule trip requests.

**Endpoint:** `POST /driver/schedule-trip/my-requests`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

## General Endpoints

### Select Options

#### Get Vehicle Types
Get list of available vehicle types.

**Endpoint:** `GET /select/vehicle-type`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Accept-Language: en
```

---

#### Get Cities
Get list of cities.

**Endpoint:** `GET /select/cities`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Accept-Language: en
```

---

#### Get Common Problems
Get list of common problems/issues.

**Endpoint:** `GET /select/common-problem`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Accept-Language: en
```

---

#### Get Countries
Get list of countries.

**Endpoint:** `GET /select/countries`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Accept-Language: en
```

---

### Settings

#### About Us
Get about us information.

**Endpoint:** `GET /setting/about_us`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Questions
Get frequently asked questions.

**Endpoint:** `GET /setting/questions`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### Policies
Get app policies.

**Endpoint:** `GET /setting/policies`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

#### General Settings
Get general app settings.

**Endpoint:** `GET /setting/general`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

## Test Endpoints

### Socket IO Channels

#### Test Channel
Test Socket.IO channel connection.

**Endpoint:** `POST /test/socket-io-channel`

---

### Send FCM
Test sending FCM push notification.

**Endpoint:** `GET /user/test/send-fcm`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

### Send SMS
Test sending SMS message.

**Endpoint:** `GET /user/test/send-sms`

**Headers:**
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

---

## Common Headers

Most endpoints require the following headers:

```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
Accept-Language: en
```

**Note:** Replace `{token}` with the actual authentication token received from login/refresh endpoints.

---

## Error Responses

The API uses standard HTTP status codes:

- `200 OK` - Request successful
- `201 Created` - Resource created successfully
- `400 Bad Request` - Invalid request parameters
- `401 Unauthorized` - Authentication required or invalid
- `403 Forbidden` - Access denied
- `404 Not Found` - Resource not found
- `422 Unprocessable Entity` - Validation error
- `500 Internal Server Error` - Server error

**Error Response Format:**
```json
{
  "message": "Error message description",
  "errors": {
    "field": ["Error details"]
  }
}
```

---

## Rate Limiting

API requests may be rate-limited. If you exceed the limit, you'll receive a `429 Too Many Requests` response.

---

## WebSocket/Socket.IO

The API supports real-time communication via Socket.IO for features like:
- Live trip tracking
- Real-time chat
- Driver location updates
- Trip status updates

Connect to the Socket.IO server using the base URL with appropriate authentication.

---

## Notes

1. All dates should be in `YYYY-MM-DD` format
2. All times should be in `HH:MM:SS AM/PM` format
3. Coordinates should be in decimal degrees format
4. Images should be sent as base64 encoded strings
5. Vehicle types: 1 = Type A, 2 = Type B, 3 = Type S
6. Appointment types: "1" = Scheduled, "2" = Instant

---

## Support

For issues or questions, please contact the development team or refer to the app's support channels.