# 🧪 API Testing Guide - Deccan Car Rental

## 📍 Base URL
- **Local**: `http://localhost:3000/api`
- **Production**: `https://your-domain.vercel.app/api`

---

## 🔓 Public Endpoints (No Authentication Required)

### 1. Get All Cars
```bash
GET /api/cars
```

**Example:**
```bash
curl http://localhost:3000/api/cars
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "_id": "abc123",
      "name": "Toyota Camry",
      "brand": "Toyota",
      "model": "Camry",
      "price": 30000,
      "status": "available"
    }
  ]
}
```

---

### 2. Get Single Car
```bash
GET /api/cars/{carId}
```

**Example:**
```bash
curl http://localhost:3000/api/cars/abc123
```

---

### 3. Check Car Availability ⭐
```bash
GET /api/cars/availability?startDate=YYYY-MM-DD&endDate=YYYY-MM-DD
```

**Example:**
```bash
# Correct format
curl "http://localhost:3000/api/cars/availability?startDate=2026-01-06&endDate=2026-02-05"
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "_id": "abc123",
      "name": "Toyota Camry",
      "status": "available"
    }
  ]
}
```

**Error if dates missing:**
```json
{
  "success": false,
  "error": "Start date and end date are required"
}
```

---

### 4. Create Reservation (Public)
```bash
POST /api/reservations
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:3000/api/reservations \
  -H "Content-Type: application/json" \
  -d '{
    "customerName": "John Doe",
    "email": "john@example.com",
    "phone": "+1-234-567-8900",
    "carId": "abc123",
    "startDate": "2026-01-10",
    "endDate": "2026-01-15",
    "message": "Need car for business trip"
  }'
```

**Response:**
```json
{
  "success": true,
  "data": {
    "_id": "res123",
    "reservationNumber": "RES-1704556800000",
    "customerName": "John Doe",
    "status": "open",
    "totalPrice": 150.00
  }
}
```

---

### 5. Get Financial Analytics
```bash
GET /api/financial-analytics
```

**Example:**
```bash
curl http://localhost:3000/api/financial-analytics
```

---

### 6. Get Maintenance Records
```bash
GET /api/maintenance
```

---

### 7. Get Repair Orders
```bash
GET /api/repair-orders
```

---

## 🔒 Protected Endpoints (Require Authentication)

### Authentication Flow

#### 1. Login
```bash
POST /api/auth/login
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123"
  }'
```

**Response:**
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGc...",
    "username": "admin"
  }
}
```

#### 2. Use Token in Requests
Add `Authorization` header with Bearer token:

```bash
curl http://localhost:3000/api/reservations \
  -H "Authorization: Bearer eyJhbGc..."
```

---

### Protected Endpoints List

#### Get Reservations
```bash
GET /api/reservations
Authorization: Bearer {token}
```

#### Get Rentals
```bash
GET /api/rentals
Authorization: Bearer {token}
```

#### Get Payments
```bash
GET /api/payments
Authorization: Bearer {token}
```

#### Get Dashboard Stats
```bash
GET /api/dashboard/stats
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "totalCars": 10,
    "availableCars": 7,
    "rentedCars": 3,
    "pendingReservations": 5,
    "activeRentals": 3,
    "pendingPayments": 2
  }
}
```

#### Add New Car
```bash
POST /api/cars
Authorization: Bearer {token}
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:3000/api/cars \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Honda Accord",
    "brand": "Honda",
    "model": "Accord",
    "price": 28000,
    "features": ["GPS", "Bluetooth"],
    "specs": {
      "seats": 5,
      "transmission": "Automatic"
    }
  }'
```

#### Update Car
```bash
PUT /api/cars/{carId}
Authorization: Bearer {token}
```

#### Delete Car
```bash
DELETE /api/cars/{carId}
Authorization: Bearer {token}
```

---

## 🧪 Testing with Different Tools

### Using cURL (Terminal)

**Test availability endpoint:**
```bash
curl "http://localhost:3000/api/cars/availability?startDate=2026-01-06&endDate=2026-02-05"
```

**Test with JSON response formatting:**
```bash
curl "http://localhost:3000/api/cars/availability?startDate=2026-01-06&endDate=2026-02-05" | jq
```

### Using Postman

1. **Create New Request**
   - Method: `GET`
   - URL: `http://localhost:3000/api/cars/availability`
   - Params:
     - `startDate`: `2026-01-06`
     - `endDate`: `2026-02-05`

2. **For Protected Routes**
   - Add Header:
     - Key: `Authorization`
     - Value: `Bearer {your_token}`

### Using Browser

Simply paste in address bar:
```
http://localhost:3000/api/cars/availability?startDate=2026-01-06&endDate=2026-02-05
```

### Using JavaScript/Fetch

```javascript
// Public endpoint
fetch('http://localhost:3000/api/cars/availability?startDate=2026-01-06&endDate=2026-02-05')
  .then(res => res.json())
  .then(data => console.log(data));

// Protected endpoint
fetch('http://localhost:3000/api/reservations', {
  headers: {
    'Authorization': 'Bearer eyJhbGc...'
  }
})
  .then(res => res.json())
  .then(data => console.log(data));
```

---

## 📝 Complete Test Scenarios

### Scenario 1: Check Available Cars

```bash
# Step 1: Get all cars
curl http://localhost:3000/api/cars

# Step 2: Check availability for specific dates
curl "http://localhost:3000/api/cars/availability?startDate=2026-01-10&endDate=2026-01-15"

# Step 3: Create a reservation for available car
curl -X POST http://localhost:3000/api/reservations \
  -H "Content-Type: application/json" \
  -d '{
    "customerName": "Test User",
    "email": "test@example.com",
    "phone": "+1-555-0100",
    "carId": "{carId from step 1}",
    "startDate": "2026-01-10",
    "endDate": "2026-01-15"
  }'
```

### Scenario 2: Admin Workflow

```bash
# Step 1: Login as admin
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username": "admin", "password": "admin123"}'

# Save the token from response

# Step 2: Get dashboard stats
curl http://localhost:3000/api/dashboard/stats \
  -H "Authorization: Bearer {token}"

# Step 3: Get all reservations
curl http://localhost:3000/api/reservations \
  -H "Authorization: Bearer {token}"

# Step 4: Update reservation status
curl -X PUT http://localhost:3000/api/reservations/{reservationId} \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{"status": "approved"}'
```

---

## 🐛 Common Errors

### 404 Not Found
**Cause:** Incorrect endpoint path
```
GET /api/car/availability  ❌ (should be /cars)
GET /api/cars/availability ✅
```

### 400 Bad Request
**Cause:** Missing required fields
```json
{
  "success": false,
  "error": "Start date and end date are required"
}
```

### 401 Unauthorized
**Cause:** Missing or invalid auth token
```json
{
  "success": false,
  "error": "Unauthorized"
}
```

### 500 Internal Server Error
**Cause:** Database connection issue

**Fix:**
1. Check MongoDB is running: `docker ps`
2. Check `.env.local` has correct `MONGO_URL`
3. Restart server

---

## 🔍 Quick Debugging

### Check if API is responding
```bash
curl http://localhost:3000/api/health
```

### Check MongoDB connection
```bash
# Access Mongo Express
open http://localhost:8081

# Username: admin
# Password: admin123
```

### View server logs
Check terminal where `yarn dev` is running for error messages

---

## 📊 Sample Data for Testing

### Sample Car IDs
After adding cars, you'll get IDs like:
- `abc123`
- `def456`
- `ghi789`

Use these in your availability and reservation tests.

### Date Formats
Always use: `YYYY-MM-DD`
- ✅ `2026-01-06`
- ❌ `01/06/2026`
- ❌ `06-01-2026`

---

## 💡 Pro Tips

1. **Use environment variables in Postman**
   - Set `{{baseUrl}}` = `http://localhost:3000/api`
   - Set `{{token}}` = your auth token

2. **Save common requests**
   - Create a Postman collection
   - Export and share with team

3. **Test in sequence**
   - First test public endpoints
   - Then authenticate
   - Then test protected endpoints

4. **Check response structure**
   - All responses have `success` boolean
   - Data is in `data` field
   - Errors are in `error` field

---

**Happy Testing!** 🚀

If you get unexpected errors, check:
1. ✅ MongoDB is running (`docker ps`)
2. ✅ Server is running (`yarn dev`)
3. ✅ Correct endpoint path
4. ✅ Required parameters included
5. ✅ Auth token for protected routes
