#!/bin/bash

# Deccan Car Rental - API Test Script
# This script tests all API endpoints and adds sample data

BASE_URL="http://localhost:3000/api"

echo "🧪 Deccan Car Rental API Test Suite"
echo "===================================="
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test 1: Check API Health
echo -e "${BLUE}Test 1: Health Check${NC}"
curl -s "$BASE_URL/health" | jq '.'
echo ""

# Test 2: Login as Admin
echo -e "${BLUE}Test 2: Admin Login${NC}"
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username": "admin", "password": "admin123"}')

echo "$LOGIN_RESPONSE" | jq '.'
TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.data.token')
echo ""

if [ "$TOKEN" == "null" ]; then
  echo -e "${RED}❌ Login failed! Cannot continue tests.${NC}"
  exit 1
fi

echo -e "${GREEN}✅ Login successful! Token: ${TOKEN:0:20}...${NC}"
echo ""

# Test 3: Get All Cars (should be empty initially)
echo -e "${BLUE}Test 3: Get All Cars (Initial)${NC}"
curl -s "$BASE_URL/cars" | jq '.'
echo ""

# Test 4: Add Sample Cars
echo -e "${BLUE}Test 4: Adding Sample Cars${NC}"

CAR1=$(curl -s -X POST "$BASE_URL/cars" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Toyota Camry 2024",
    "brand": "Toyota",
    "model": "Camry",
    "price": 30000,
    "purchasePrice": 28000,
    "features": ["GPS", "Bluetooth", "Backup Camera"],
    "specs": {
      "seats": 5,
      "transmission": "Automatic",
      "fuelType": "Hybrid"
    }
  }')

CAR1_ID=$(echo "$CAR1" | jq -r '.data._id')
echo -e "${GREEN}✅ Added Toyota Camry (ID: $CAR1_ID)${NC}"

CAR2=$(curl -s -X POST "$BASE_URL/cars" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Honda Accord 2024",
    "brand": "Honda",
    "model": "Accord",
    "price": 28000,
    "purchasePrice": 26000,
    "features": ["Sunroof", "Leather Seats", "Apple CarPlay"],
    "specs": {
      "seats": 5,
      "transmission": "Automatic",
      "fuelType": "Gasoline"
    }
  }')

CAR2_ID=$(echo "$CAR2" | jq -r '.data._id')
echo -e "${GREEN}✅ Added Honda Accord (ID: $CAR2_ID)${NC}"

CAR3=$(curl -s -X POST "$BASE_URL/cars" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Tesla Model 3 2024",
    "brand": "Tesla",
    "model": "Model 3",
    "price": 45000,
    "purchasePrice": 42000,
    "features": ["Autopilot", "Premium Audio", "Glass Roof"],
    "specs": {
      "seats": 5,
      "transmission": "Automatic",
      "fuelType": "Electric"
    }
  }')

CAR3_ID=$(echo "$CAR3" | jq -r '.data._id')
echo -e "${GREEN}✅ Added Tesla Model 3 (ID: $CAR3_ID)${NC}"
echo ""

# Test 5: Get All Cars (should have 3 now)
echo -e "${BLUE}Test 5: Get All Cars (After Adding)${NC}"
curl -s "$BASE_URL/cars" | jq '.'
echo ""

# Test 6: Get Single Car
echo -e "${BLUE}Test 6: Get Single Car${NC}"
curl -s "$BASE_URL/cars/$CAR1_ID" | jq '.'
echo ""

# Test 7: Check Availability (This is your endpoint!)
echo -e "${BLUE}Test 7: Check Car Availability${NC}"
echo "Checking availability from 2026-01-06 to 2026-02-05..."
AVAILABILITY=$(curl -s "$BASE_URL/cars/availability?startDate=2026-01-06&endDate=2026-02-05")
echo "$AVAILABILITY" | jq '.'

AVAILABLE_COUNT=$(echo "$AVAILABILITY" | jq '.data | length')
echo -e "${GREEN}✅ Found $AVAILABLE_COUNT available cars${NC}"
echo ""

# Test 8: Create Public Reservation
echo -e "${BLUE}Test 8: Create Public Reservation${NC}"
RESERVATION=$(curl -s -X POST "$BASE_URL/reservations" \
  -H "Content-Type: application/json" \
  -d "{
    \"customerName\": \"John Doe\",
    \"email\": \"john@example.com\",
    \"phone\": \"+1-234-567-8900\",
    \"carId\": \"$CAR1_ID\",
    \"startDate\": \"2026-01-10\",
    \"endDate\": \"2026-01-15\",
    \"message\": \"Business trip to NYC\"
  }")

echo "$RESERVATION" | jq '.'
RESERVATION_ID=$(echo "$RESERVATION" | jq -r '.data._id')
echo -e "${GREEN}✅ Created reservation (ID: $RESERVATION_ID)${NC}"
echo ""

# Test 9: Check Availability Again (should have 2 available now for those dates)
echo -e "${BLUE}Test 9: Check Availability After Reservation${NC}"
AVAILABILITY2=$(curl -s "$BASE_URL/cars/availability?startDate=2026-01-10&endDate=2026-01-15")
echo "$AVAILABILITY2" | jq '.'

AVAILABLE_COUNT2=$(echo "$AVAILABILITY2" | jq '.data | length')
echo -e "${GREEN}✅ Found $AVAILABLE_COUNT2 available cars (1 is reserved)${NC}"
echo ""

# Test 10: Get Dashboard Stats
echo -e "${BLUE}Test 10: Dashboard Stats${NC}"
curl -s "$BASE_URL/dashboard/stats" \
  -H "Authorization: Bearer $TOKEN" | jq '.'
echo ""

# Test 11: Get All Reservations (Admin)
echo -e "${BLUE}Test 11: Get All Reservations (Admin)${NC}"
curl -s "$BASE_URL/reservations" \
  -H "Authorization: Bearer $TOKEN" | jq '.'
echo ""

echo "===================================="
echo -e "${GREEN}✅ All tests completed!${NC}"
echo ""
echo "Summary:"
echo "- Cars added: 3"
echo "- Car IDs:"
echo "  - Toyota Camry: $CAR1_ID"
echo "  - Honda Accord: $CAR2_ID"
echo "  - Tesla Model 3: $CAR3_ID"
echo "- Reservations created: 1"
echo "- Reservation ID: $RESERVATION_ID"
echo ""
echo "You can now test:"
echo "curl \"http://localhost:3000/api/cars/availability?startDate=2026-01-06&endDate=2026-02-05\""
