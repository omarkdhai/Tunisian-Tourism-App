# Tourism-app — Complete Postman Testing Guide

This guide walks you through starting the infrastructure, configuring Keycloak authentication, and testing **every** endpoint across all 6 backend microservices using Postman.

---

## Table of Contents

1. [Architecture Overview](#1-architecture-overview)
2. [Prerequisites & Startup](#2-prerequisites--startup)
3. [Keycloak Configuration (One-Time Setup)](#3-keycloak-configuration-one-time-setup)
4. [Postman Environment Setup](#4-postman-environment-setup)
5. [Getting a JWT Token in Postman](#5-getting-a-jwt-token-in-postman)
6. [Testing Order (Dependency Flow)](#6-testing-order-dependency-flow)
7. [User Service Endpoints](#7-user-service-endpoints)
8. [Place Service Endpoints](#8-place-service-endpoints)
9. [Review Service Endpoints](#9-review-service-endpoints)
10. [Trip Planner Service Endpoints](#10-trip-planner-service-endpoints)
11. [Budget Service Endpoints](#11-budget-service-endpoints)
12. [Notification Service Endpoints](#12-notification-service-endpoints)
13. [Troubleshooting](#13-troubleshooting)

---

## 1. Architecture Overview

```
                    ┌──────────────┐
                    │   Postman    │
                    └──────┬───────┘
                           │ HTTP :8080
                    ┌──────▼───────┐
                    │  API Gateway  │  (Spring Cloud Gateway + JWT validation)
                    └──────┬───────┘
           ┌───────────────┼───────────────┐
           ▼               ▼               ▼
    ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
    │ user-service│ │place-service│ │review-service│  ... etc
    │   :8081     │ │   :8082     │ │   :8084     │
    └──────┬──────┘ └──────┬──────┘ └──────┬──────┘
           │               │               │
    ┌──────▼───────────────▼───────────────▼──────┐
    │            PostgreSQL :5432                  │
    │  user_db | place_db | trip_db | review_db   │
    │  budget_db | notification_db                │
    └─────────────────────────────────────────────┘
```

| Component         | Port  | Purpose                          |
|-------------------|-------|----------------------------------|
| API Gateway       | 8080  | Single entry point for all APIs  |
| Keycloak          | 9090  | OAuth2/JWT authentication        |
| Discovery Server  | 8761  | Eureka service registry          |
| Config Server     | 8888  | Centralized config               |
| PostgreSQL        | 5432  | Database (6 schemas)             |
| User Service      | 8081  | User profiles, preferences, swipes |
| Place Service     | 8082  | Places CRUD, search, nearby       |
| Trip Planner      | 8083  | Trip creation, itinerary          |
| Review Service    | 8084  | Reviews and ratings               |
| Budget Service    | 8085  | Trip budgets and expenses         |
| Notification Svc  | 8086  | Notifications and preferences     |
| Transportation    | 8087  | (Stub — no endpoints)             |
| Guide Service     | 8088  | (Stub — no endpoints)             |

> **All API calls go through the gateway at `http://localhost:8080`.** You never call individual service ports directly in production testing (though you can for debugging).

---

## 2. Prerequisites & Startup

### 2.1 Requirements
- Docker Desktop (running)
- Postman (desktop app)
- Git

### 2.2 Start Everything

```bash
cd d:\Tourism-app
docker-compose up --build
```

Wait for all services to start (~2-3 minutes). Verify they're healthy:

| Check                         | URL                                              |
|-------------------------------|--------------------------------------------------|
| Eureka Dashboard              | http://localhost:8761                            |
| Config Server Health          | http://localhost:8888/actuator/health            |
| API Gateway Health            | http://localhost:8080/actuator/health            |
| Keycloak Admin Console        | http://localhost:9090                            |
| User Service Health           | http://localhost:8081/actuator/health            |
| Place Service Health          | http://localhost:8082/actuator/health            |

> On the Eureka dashboard at `http://localhost:8761`, you should see all 8 application services registered plus the API Gateway.

### 2.3 Verify Databases

```bash
docker exec -it tourism-postgres psql -U postgres -l
```

You should see: `user_db`, `place_db`, `trip_db`, `review_db`, `budget_db`, `notification_db`.

---

## 3. Keycloak Configuration (One-Time Setup)

Keycloak is your authentication server. You must create a **Realm**, a **Client**, and **Users** before you can get JWT tokens.

### 3.1 Log in to Keycloak Admin Console
1. Open http://localhost:9090
2. Username: `admin`
3. Password: `admin`

### 3.2 Create the Realm
1. Click the dropdown in the top-left (says "master")
2. Click **Create Realm**
3. Realm name: `tunisia-tourism`
4. Click **Create**

### 3.3 Create a Client
1. Select the `tunisia-tourism` realm (top-left dropdown)
2. Go to **Clients** → **Create client**
3. **General Settings**:
   - Client ID: `tourism-client`
   - Client type: `OpenID Connect`
   - Click **Next**
4. **Authentication flow**:
   - ✅ Enable **Client authentication** (this makes it a confidential client)
   - ✅ Enable **Standard flow**
   - ✅ Enable **Direct access grants**
   - Click **Next**
5. **Login details**:
   - Valid redirect URIs: `http://localhost:*`
   - Web origins: `*`
   - Click **Save**

6. After saving, go to the **Credentials** tab and copy the **Client secret** — you'll need it for Postman.

### 3.4 Create the ADMIN Role
1. Go to **Realm roles** → **Create role**
2. Role name: `ADMIN`
3. Click **Create**

### 3.5 Create Two Users

#### User 1: Regular User (tourist)
1. Go to **Users** → **Add user**
2. Username: `tourist1`
3. Email: `tourist1@test.com`
4. First name: `Tourist`
5. Last name: `One`
6. Click **Create**
7. Go to the **Credentials** tab → **Set password**
   - Password: `password123`
   - Temporary: **OFF** (uncheck)
   - Click **Save**

#### User 2: Admin User
1. Go to **Users** → **Add user**
2. Username: `admin1`
3. Email: `admin1@test.com`
4. First name: `Admin`
5. Last name: `One`
6. Click **Create**
7. Go to **Credentials** tab → **Set password**
   - Password: `password123`
   - Temporary: **OFF**
8. Go to **Role mapping** tab → **Assign role** → select `ADMIN` → click **Assign**

### 3.6 Get Client UUIDs (for Registration)

After creating users, open each user and copy their **ID** (a UUID string at the top of the user details page). You'll use these as the `keycloakId` when registering users via the API.

---

## 4. Postman Environment Setup

### 4.1 Create a Postman Environment

In Postman, click the gear icon → **Add Environment** → name it `Tourism-app`.

Add these variables:

| Variable             | Initial Value                              |
|----------------------|--------------------------------------------|
| `base_url`           | `http://localhost:8080`                    |
| `keycloak_url`       | `http://localhost:9090`                    |
| `realm`              | `tunisia-tourism`                          |
| `client_id`          | `tourism-client`                           |
| `client_secret`      | *(paste from Keycloak step 3.3)*           |
| `user_token`         | *(will be filled by token script)*         |
| `admin_token`        | *(will be filled by token script)*         |
| `user_keycloak_id`   | *(paste tourist1's UUID from Keycloak)*    |
| `admin_keycloak_id`  | *(paste admin1's UUID from Keycloak)*      |
| `place_id`           | *(will be set during testing)*             |
| `review_id`          | *(will be set during testing)*             |
| `trip_id`            | *(will be set during testing)*             |
| `expense_id`         | *(will be set during testing)*             |
| `notification_id`    | *(will be set during testing)*             |

### 4.2 Set Up Auth Headers Automatically

In your Postman environment, add a **pre-request script** at the collection level (or on each protected request):

```javascript
// Auto-inject Bearer token on protected requests
// Set this in Collection > Pre-request Script
pm.request.headers.add({
    key: "Authorization",
    value: "Bearer " + pm.environment.get("user_token")
});
```

Alternatively, for each request, go to **Authorization** tab → Type: **Bearer Token** → Token: `{{user_token}}` (or `{{admin_token}}` for admin endpoints).

---

## 5. Getting a JWT Token in Postman

### 5.1 Create a "Get User Token" Request

| Field     | Value                                                                 |
|-----------|-----------------------------------------------------------------------|
| Method    | POST                                                                  |
| URL       | `{{keycloak_url}}/realms/{{realm}}/protocol/openid-connect/token`    |
| Body type | `x-www-form-urlencoded`                                              |

**Body parameters:**

| Key            | Value              |
|----------------|--------------------|
| `grant_type`   | `password`         |
| `client_id`    | `{{client_id}}`    |
| `client_secret`| `{{client_secret}}` |
| `username`     | `tourist1`         |
| `password`     | `password123`      |

### 5.2 Add a Test Script to Save the Token

Go to the **Tests** tab of that request and paste:

```javascript
let json = pm.response.json();
if (json.access_token) {
    pm.environment.set("user_token", json.access_token);
    console.log("User token saved!");
}
```

### 5.3 Send the Request

You should get a 200 response with `access_token`, `expires_in`, etc. The token is now saved in the `user_token` variable.

### 5.4 Create a "Get Admin Token" Request

Duplicate the above request. Change:
- `username` → `admin1`
- Tests script → `pm.environment.set("admin_token", json.access_token);`

---

## 6. Testing Order (Dependency Flow)

Test endpoints in this order because some depend on data created by others:

```
1. User Service     → Register user (needs keycloakId from Keycloak)
2. Place Service    → Create a place (needs ADMIN token) → get place_id
3. Review Service   → Create review (needs place_id + user token)
4. Trip Service     → Create trip (needs user token) → get trip_id
5. Budget Service   → Initialize budget (needs trip_id) → add expenses
6. Notification Svc → Send notification (needs user_id) → read/delete
```

---

## 7. User Service Endpoints

Base URL: `{{base_url}}/api/users`

### 7.1 Register a New User  *(Public — no token)*

```
POST {{base_url}}/api/users/register
Content-Type: application/json
```

**Body:**
```json
{
    "keycloakId": "{{user_keycloak_id}}",
    "email": "tourist1@test.com",
    "firstName": "Tourist",
    "lastName": "One",
    "preferredLanguage": "en",
    "preferredCurrency": "TND"
}
```

**Expected:** `201 Created` — returns user profile with `id`, `keycloakId`, `email`, etc.

> **Important:** The `keycloakId` must match the UUID of the Keycloak user you created. This is how the system links Keycloak accounts to user profiles.

### 7.2 Get Current User Profile  *(Protected)*

```
GET {{base_url}}/api/users/me
Authorization: Bearer {{user_token}}
```

**Expected:** `200 OK` — returns the profile created in 7.1.

### 7.3 Update Profile  *(Protected)*

```
PUT {{base_url}}/api/users/me
Authorization: Bearer {{user_token}}
Content-Type: application/json
```

**Body:**
```json
{
    "firstName": "TouristUpdated",
    "lastName": "OneUpdated",
    "preferredLanguage": "fr",
    "preferredCurrency": "EUR"
}
```

**Expected:** `200 OK` — returns updated profile.

### 7.4 Save Traveler Preferences  *(Protected)*

```
POST {{base_url}}/api/users/me/preferences
Authorization: Bearer {{user_token}}
Content-Type: application/json
```

**Body:**
```json
{
    "travelStyle": "ADVENTURE",
    "numberOfTravelers": 2,
    "groupMode": "COUPLE"
}
```

**Enum values for `groupMode`:** `SOLO`, `COUPLE`, `FAMILY`, `GROUP`

**Expected:** `200 OK` — returns preference object with `id`.

### 7.5 Get Traveler Preferences  *(Protected)*

```
GET {{base_url}}/api/users/me/preferences
Authorization: Bearer {{user_token}}
```

**Expected:** `200 OK` — returns the preference saved in 7.4.

### 7.6 Record Swipes  *(Protected)*

```
POST {{base_url}}/api/users/me/swipes
Authorization: Bearer {{user_token}}
Content-Type: application/json
```

**Body (array of swipes):**
```json
[
    {
        "category": "BEACH",
        "liked": true,
        "intensity": 5
    },
    {
        "category": "MONUMENT",
        "liked": false,
        "intensity": 2
    },
    {
        "category": "FOOD",
        "liked": true,
        "placeId": "00000000-0000-0000-0000-000000000001",
        "intensity": 4
    }
]
```

**Enum values for `category`:** `BEACH`, `MONUMENT`, `CULTURE`, `FOOD`, `SAHARA`, `NATURE`, `ACTIVITIES`, `SHOPPING`, `NIGHTLIFE`, `ART`, `ADVENTURE`

**Expected:** `201 Created` — returns array of SwipeResponse objects.

### 7.7 Get Swipe History  *(Protected)*

```
GET {{base_url}}/api/users/me/swipes
Authorization: Bearer {{user_token}}
```

**Expected:** `200 OK` — returns array of swipes.

### 7.8 Save a Place  *(Protected)*

> Requires a `place_id` — create a place first (see Place Service section 8.7), or use any existing UUID.

```
POST {{base_url}}/api/users/me/saved-places/{{place_id}}
Authorization: Bearer {{user_token}}
```

**Expected:** `201 Created` — empty body.

### 7.9 Get Saved Places  *(Protected)*

```
GET {{base_url}}/api/users/me/saved-places
Authorization: Bearer {{user_token}}
```

**Expected:** `200 OK` — returns array of UUIDs (place IDs).

### 7.10 Remove a Saved Place  *(Protected)*

```
DELETE {{base_url}}/api/users/me/saved-places/{{place_id}}
Authorization: Bearer {{user_token}}
```

**Expected:** `204 No Content`.

---

## 8. Place Service Endpoints

Base URL: `{{base_url}}/api/places`

### 8.1 Get All Places  *(Public)*

```
GET {{base_url}}/api/places?page=0&size=10&sort=name,asc
```

**Expected:** `200 OK` — returns a paginated response with `content[]`, `totalElements`, `totalPages`, etc.

> If the database is empty, `content` will be an empty array `[]`.

### 8.2 Get Place by ID  *(Public)*

```
GET {{base_url}}/api/places/{{place_id}}
```

**Expected:** `200 OK` — returns the place object.

### 8.3 Get Places by Category  *(Public)*

```
GET {{base_url}}/api/places/category/BEACH?page=0&size=10
```

**Categories:** `BEACH`, `MONUMENT`, `CULTURE`, `FOOD`, `SAHARA`, `NATURE`, `ACTIVITIES`, `SHOPPING`, `NIGHTLIFE`, `ART`, `ADVENTURE`

**Expected:** `200 OK` — paginated list of places in that category.

### 8.4 Search Places  *(Public)*

```
GET {{base_url}}/api/places/search?query=Tunis&page=0&size=10
```

**Expected:** `200 OK` — paginated results matching the query.

### 8.5 Get Nearby Places  *(Public)*

```
GET {{base_url}}/api/places/nearby?lat=36.8065&lon=10.1815&radiusMeters=5000
```

**Parameters:**
- `lat` — latitude (e.g., 36.8065 for Tunis)
- `lon` — longitude (e.g., 10.1815 for Tunis)
- `radiusMeters` — search radius in meters (default: 5000)

**Expected:** `200 OK` — list of nearby places.

### 8.6 Get Similar Places  *(Public)*

```
GET {{base_url}}/api/places/similar/{{place_id}}?limit=5
```

**Expected:** `200 OK` — list of similar places (max `limit`).

### 8.7 Create a Place  *(ADMIN ONLY)*

```
POST {{base_url}}/api/places
Authorization: Bearer {{admin_token}}
Content-Type: application/json
```

**Body:**
```json
{
    "name": "Carthage Ruins",
    "nameAr": "آثار قرطاج",
    "description": "Ancient Roman ruins and archaeological site",
    "descriptionAr": "موقع أثري روماني قديم",
    "category": "MONUMENT",
    "latitude": 36.8528,
    "longitude": 10.3236,
    "address": "Carthage, Tunis, Tunisia",
    "governorate": "Tunis",
    "openingHours": "08:00-18:00",
    "entrancePrice": 12.000,
    "estimatedVisitDuration": 120,
    "bestTimeToVisit": "Spring",
    "familyFriendly": true,
    "soloFriendly": true,
    "accessibilityInfo": "Wheelchair accessible paths"
}
```

**Test script** (to save the place ID for later tests):
```javascript
let json = pm.response.json();
if (json.id) {
    pm.environment.set("place_id", json.id);
    console.log("Place ID saved: " + json.id);
}
```

**Expected:** `201 Created` — returns the created place with generated `id`.

### 8.8 Update a Place  *(ADMIN ONLY)*

```
PUT {{base_url}}/api/places/{{place_id}}
Authorization: Bearer {{admin_token}}
Content-Type: application/json
```

**Body:**
```json
{
    "name": "Carthage Ruins - Updated",
    "nameAr": "آثار قرطاج",
    "description": "Updated description for the ancient Roman ruins",
    "category": "MONUMENT",
    "latitude": 36.8528,
    "longitude": 10.3236,
    "address": "Carthage, Tunis, Tunisia",
    "governorate": "Tunis",
    "openingHours": "08:00-19:00",
    "entrancePrice": 15.000,
    "estimatedVisitDuration": 150,
    "bestTimeToVisit": "Spring and Autumn",
    "familyFriendly": true,
    "soloFriendly": true,
    "accessibilityInfo": "Wheelchair accessible paths available"
}
```

**Expected:** `200 OK` — returns updated place.

### 8.9 Delete a Place  *(ADMIN ONLY)*

```
DELETE {{base_url}}/api/places/{{place_id}}
Authorization: Bearer {{admin_token}}
```

**Expected:** `204 No Content`.

> **Note:** Delete the place only after you've finished all other tests that depend on `place_id`. Or create a throwaway place specifically for deletion testing.

### 8.10 Get Swipe Deck  *(Protected)*

```
GET {{base_url}}/api/places/swipe-deck?page=0&size=10
Authorization: Bearer {{user_token}}
```

**Expected:** `200 OK` — returns personalized places for swiping (based on user preferences).

---

## 9. Review Service Endpoints

Base URL: `{{base_url}}/api/reviews`

### 9.1 Create a Review  *(Protected)*

```
POST {{base_url}}/api/reviews
Authorization: Bearer {{user_token}}
Content-Type: application/json
```

**Body:**
```json
{
    "placeId": "{{place_id}}",
    "rating": 4.5,
    "comment": "Amazing historical site! Well preserved and worth the visit.",
    "foodRating": 3.5,
    "cleanlinessRating": 4.0,
    "valueRating": 4.5,
    "experienceRating": 5.0,
    "visitDate": "2026-07-15"
}
```

> **Note:** `placeId` must be a valid UUID. If Postman sends it as a string variable, the Jackson deserializer should handle it. If you get a UUID parse error, paste the actual UUID directly.

**Test script:**
```javascript
let json = pm.response.json();
if (json.id) {
    pm.environment.set("review_id", json.id);
    console.log("Review ID saved: " + json.id);
}
```

**Expected:** `201 Created` — returns review with `id`, `userId`, `placeId`.

### 9.2 Get Reviews by Place  *(Public)*

```
GET {{base_url}}/api/reviews/place/{{place_id}}
```

**Expected:** `200 OK` — returns array of reviews for that place.

### 9.3 Get My Reviews  *(Protected)*

```
GET {{base_url}}/api/reviews/user/me
Authorization: Bearer {{user_token}}
```

**Expected:** `200 OK` — returns array of reviews created by the authenticated user.

### 9.4 Delete a Review  *(Protected)*

```
DELETE {{base_url}}/api/reviews/{{review_id}}
Authorization: Bearer {{user_token}}
```

**Expected:** `204 No Content`.

> Only the review owner can delete their review.

---

## 10. Trip Planner Service Endpoints

Base URL: `{{base_url}}/api/trips`

### 10.1 Create a Trip  *(Protected)*

```
POST {{base_url}}/api/trips
Authorization: Bearer {{user_token}}
Content-Type: application/json
```

**Body:**
```json
{
    "title": "Tunis Adventure Trip",
    "arrivalAirport": "TUN",
    "departureAirport": "TUN",
    "arrivalDate": "2026-08-15",
    "departureDate": "2026-08-20",
    "budget": 1500.00,
    "travelStyle": "ADVENTURE",
    "preferredTransportation": "CAR"
}
```

**Test script:**
```javascript
let json = pm.response.json();
if (json.id) {
    pm.environment.set("trip_id", json.id);
    console.log("Trip ID saved: " + json.id);
}
```

**Expected:** `201 Created` — returns trip with `id`, `userId`, `durationDays`, `status`.

### 10.2 Get User Trips  *(Protected)*

```
GET {{base_url}}/api/trips
Authorization: Bearer {{user_token}}
```

**Expected:** `200 OK` — returns array of trips for the authenticated user.

### 10.3 Get Trip by ID  *(Protected)*

```
GET {{base_url}}/api/trips/{{trip_id}}
Authorization: Bearer {{user_token}}
```

**Expected:** `200 OK` — returns the trip with days and activities (if generated).

### 10.4 Generate Itinerary  *(Protected)*

```
POST {{base_url}}/api/trips/{{trip_id}}/generate
Authorization: Bearer {{user_token}}
```

**Expected:** `200 OK` — returns the trip with auto-generated `days[]` and `activities[]`.

> **Note:** This endpoint calls the AI service at `http://localhost:8000`. If the AI service is not running, this may fail. Check the trip-planner-service logs for details. The trip will still exist; only the itinerary generation will fail.

### 10.5 Delete a Trip  *(Protected)*

```
DELETE {{base_url}}/api/trips/{{trip_id}}
Authorization: Bearer {{user_token}}
```

**Expected:** `204 No Content`.

---

## 11. Budget Service Endpoints

Base URL: `{{base_url}}/api/budget`

> Budget endpoints are linked to trips. Create a trip first (section 10.1) and use its `trip_id`.

### 11.1 Initialize a Budget for a Trip  *(Protected)*

```
POST {{base_url}}/api/budget/trips/{{trip_id}}?totalBudget=1500&currency=TND
Authorization: Bearer {{user_token}}
```

**Query parameters:**
- `totalBudget` — the total budget amount (e.g., `1500`)
- `currency` — currency code (default: `TND`)

**Expected:** `201 Created` — returns TripBudgetResponse with `id`, `totalBudget`, `currency`, `categories[]`, `totalSpent` = 0, `remainingBudget`.

### 11.2 Get Budget by Trip  *(Protected)*

```
GET {{base_url}}/api/budget/trips/{{trip_id}}
Authorization: Bearer {{user_token}}
```

**Expected:** `200 OK` — returns the budget for that trip.

### 11.3 Add an Expense  *(Protected)*

```
POST {{base_url}}/api/budget/trips/{{trip_id}}/expenses
Authorization: Bearer {{user_token}}
Content-Type: application/json
```

**Body:**
```json
{
    "category": "FOOD",
    "description": "Lunch at a local restaurant",
    "amount": 45.50,
    "currency": "TND",
    "date": "2026-08-15",
    "placeId": "{{place_id}}"
}
```

**Test script:**
```javascript
let json = pm.response.json();
if (json.id) {
    pm.environment.set("expense_id", json.id);
    console.log("Expense ID saved: " + json.id);
}
```

**Expected:** `201 Created` — returns ExpenseResponse with `id`, `amountInTnd` (converted), `category`.

### 11.4 Get All Expenses for a Trip  *(Protected)*

```
GET {{base_url}}/api/budget/trips/{{trip_id}}/expenses
Authorization: Bearer {{user_token}}
```

**Expected:** `200 OK` — returns array of expenses.

### 11.5 Delete an Expense  *(Protected)*

```
DELETE {{base_url}}/api/budget/expenses/{{expense_id}}
Authorization: Bearer {{user_token}}
```

**Expected:** `204 No Content`.

---

## 12. Notification Service Endpoints

Base URL: `{{base_url}}/api/notifications`

### 12.1 Send a Notification  *(Public — internal endpoint)*

> This is typically called by other microservices, but it's open for testing.

```
POST {{base_url}}/api/notifications/send
Content-Type: application/json
```

**Body:**
```json
{
    "userId": "{{user_keycloak_id}}",
    "title": "Trip Reminder",
    "message": "Your trip to Tunis starts tomorrow!",
    "type": "DEPARTURE",
    "data": "{\"tripId\": \"{{trip_id}}\"}"
}
```

**Enum values for `type`:** `ACTIVITY_REMINDER`, `DEPARTURE`, `WEATHER`, `ITINERARY_CHANGE`, `BUDGET_ALERT`, `NEARBY`

**Test script:**
```javascript
let json = pm.response.json();
if (json && json.id) {
    pm.environment.set("notification_id", json.id);
    console.log("Notification ID saved: " + json.id);
}
```

**Expected:** `201 Created` — returns NotificationResponse with `id`, `userId`, `read` = false, `createdAt`.

### 12.2 Get User Notifications  *(Protected)*

```
GET {{base_url}}/api/notifications
Authorization: Bearer {{user_token}}
```

**Expected:** `200 OK` — returns array of notifications for the authenticated user.

### 12.3 Get Unread Notifications  *(Protected)*

```
GET {{base_url}}/api/notifications/unread
Authorization: Bearer {{user_token}}
```

**Expected:** `200 OK` — returns only unread notifications.

### 12.4 Mark Notification as Read  *(Protected)*

```
PUT {{base_url}}/api/notifications/{{notification_id}}/read
Authorization: Bearer {{user_token}}
```

**Expected:** `204 No Content`.

### 12.5 Mark All as Read  *(Protected)*

```
PUT {{base_url}}/api/notifications/read-all
Authorization: Bearer {{user_token}}
```

**Expected:** `204 No Content`.

### 12.6 Get Notification Preferences  *(Protected)*

```
GET {{base_url}}/api/notifications/preferences
Authorization: Bearer {{user_token}}
```

**Expected:** `200 OK` — returns PreferenceResponse with boolean flags for each notification type.

### 12.7 Update Notification Preferences  *(Protected)*

```
PUT {{base_url}}/api/notifications/preferences
Authorization: Bearer {{user_token}}
Content-Type: application/json
```

**Body:**
```json
{
    "activityReminders": true,
    "departureReminders": true,
    "weatherAlerts": false,
    "budgetAlerts": true,
    "nearbyRecommendations": false
}
```

**Expected:** `200 OK` — returns updated PreferenceResponse.

### 12.8 Delete a Notification  *(Protected)*

```
DELETE {{base_url}}/api/notifications/{{notification_id}}
Authorization: Bearer {{user_token}}
```

**Expected:** `204 No Content`.

---

## 13. Troubleshooting

### 13.1 "401 Unauthorized" on Protected Endpoints
- **Cause:** Token expired or missing.
- **Fix:** Re-send the "Get User Token" request (section 5.1) to refresh `user_token`.
- Keycloak access tokens expire in **5 minutes** by default. Re-authenticate as needed.

### 13.2 "403 Forbidden" on Place Create/Update/Delete
- **Cause:** You're using a regular user token, not an admin token.
- **Fix:** Use the "Get Admin Token" request to get `admin_token`, then use that as the Bearer token for ADMIN endpoints.

### 13.3 "403 Forbidden" with `hasRole('ADMIN')`
- **Cause:** The user doesn't have the `ADMIN` role in Keycloak.
- **Fix:** Go to Keycloak → Users → admin1 → Role mapping → Assign `ADMIN` role. Then re-obtain the admin token.

### 13.4 "400 Bad Request" with UUID Errors
- **Cause:** Postman is sending a variable name instead of its value, or the UUID format is wrong.
- **Fix:** Make sure you've actually **run** the requests that set `place_id`, `trip_id`, etc. Check the current value in the environment variables panel.

### 13.5 "500 Internal Server Error" on Trip Generate
- **Cause:** The AI service at `http://localhost:8000` is not running.
- **Fix:** The generate itinerary endpoint requires an external AI service. Either start it or skip that test. The trip is still created successfully.

### 13.5 "503 Service Unavailable"
- **Cause:** The target service hasn't registered with Eureka yet, or it crashed.
- **Fix:**
  ```bash
  docker-compose logs -f <service-name>
  ```
  Check Eureka dashboard at http://localhost:8761 to confirm all services are UP.

### 13.6 Database Connection Errors
- **Cause:** PostgreSQL hasn't initialized the databases yet.
- **Fix:** Check `docker-compose logs postgres`. The `init-dbs.sh` script runs on first startup only. If you've changed the script, delete the volume:
  ```bash
  docker-compose down -v
  docker-compose up --build
  ```

### 13.7 Keycloak "Invalid client" Error
- **Cause:** Client secret doesn't match or client configuration is wrong.
- **Fix:** Re-check the client secret in Keycloak → Clients → tourism-client → Credentials tab. Update the `client_secret` variable in Postman.

### 13.8 Flyway Migration Errors
- **Cause:** Schema mismatch between entity and migration.
- **Fix:** Check service logs:
  ```bash
  docker-compose logs user-service
  ```
  If migrations fail, the service won't start. Review the migration SQL files in `src/main/resources/db/migration/`.

---

## Quick Reference: All Endpoints Summary

| # | Method | Endpoint | Auth | Service |
|---|--------|----------|------|---------|
| 1 | POST | `/api/users/register` | Public | User |
| 2 | GET | `/api/users/me` | User | User |
| 3 | PUT | `/api/users/me` | User | User |
| 4 | POST | `/api/users/me/preferences` | User | User |
| 5 | GET | `/api/users/me/preferences` | User | User |
| 6 | POST | `/api/users/me/swipes` | User | User |
| 7 | GET | `/api/users/me/swipes` | User | User |
| 8 | POST | `/api/users/me/saved-places/{placeId}` | User | User |
| 9 | GET | `/api/users/me/saved-places` | User | User |
| 10 | DELETE | `/api/users/me/saved-places/{placeId}` | User | User |
| 11 | GET | `/api/places` | Public | Place |
| 12 | GET | `/api/places/{id}` | Public | Place |
| 13 | GET | `/api/places/category/{category}` | Public | Place |
| 14 | GET | `/api/places/search?query=` | Public | Place |
| 15 | GET | `/api/places/nearby?lat=&lon=` | Public | Place |
| 16 | GET | `/api/places/similar/{id}` | Public | Place |
| 17 | GET | `/api/places/swipe-deck` | User | Place |
| 18 | POST | `/api/places` | Admin | Place |
| 19 | PUT | `/api/places/{id}` | Admin | Place |
| 20 | DELETE | `/api/places/{id}` | Admin | Place |
| 21 | POST | `/api/reviews` | User | Review |
| 22 | GET | `/api/reviews/place/{placeId}` | Public | Review |
| 23 | GET | `/api/reviews/user/me` | User | Review |
| 24 | DELETE | `/api/reviews/{id}` | User | Review |
| 25 | POST | `/api/trips` | User | Trip |
| 26 | GET | `/api/trips` | User | Trip |
| 27 | GET | `/api/trips/{id}` | User | Trip |
| 28 | POST | `/api/trips/{id}/generate` | User | Trip |
| 29 | DELETE | `/api/trips/{id}` | User | Trip |
| 30 | GET | `/api/budget/trips/{tripId}` | User | Budget |
| 31 | POST | `/api/budget/trips/{tripId}` | User | Budget |
| 32 | POST | `/api/budget/trips/{tripId}/expenses` | User | Budget |
| 33 | GET | `/api/budget/trips/{tripId}/expenses` | User | Budget |
| 34 | DELETE | `/api/budget/expenses/{id}` | User | Budget |
| 35 | GET | `/api/notifications` | User | Notification |
| 36 | GET | `/api/notifications/unread` | User | Notification |
| 37 | PUT | `/api/notifications/{id}/read` | User | Notification |
| 38 | PUT | `/api/notifications/read-all` | User | Notification |
| 39 | DELETE | `/api/notifications/{id}` | User | Notification |
| 40 | GET | `/api/notifications/preferences` | User | Notification |
| 41 | PUT | `/api/notifications/preferences` | User | Notification |
| 42 | POST | `/api/notifications/send` | Public | Notification |

**Total: 42 endpoints across 6 services.**

---

## Enum Reference

### PlaceCategory (used in Place & Swipe endpoints)
`BEACH`, `MONUMENT`, `CULTURE`, `FOOD`, `SAHARA`, `NATURE`, `ACTIVITIES`, `SHOPPING`, `NIGHTLIFE`, `ART`, `ADVENTURE`

### GroupMode (used in Traveler Preferences)
`SOLO`, `COUPLE`, `FAMILY`, `GROUP`

### NotificationType (used in Send Notification)
`ACTIVITY_REMINDER`, `DEPARTURE`, `WEATHER`, `ITINERARY_CHANGE`, `BUDGET_ALERT`, `NEARBY`
