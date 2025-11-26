# AirBnB Database - Sample Seed Data

## Overview
This directory contains SQL scripts to populate the AirBnB database with realistic sample data for development, testing, and demonstration purposes.

---

## 📁 Directory Structure

```
database-script-0x02/
├── seed.sql          # Complete seed data with INSERT statements
└── README.md         # This file - documentation and usage guide
```

---

## 📊 Sample Data Summary

The seed script populates the database with the following realistic test data:

| Table | Record Count | Description |
|-------|--------------|-------------|
| **User** | 15 | 2 admins, 5 hosts, 8 guests |
| **Location** | 10 | Global locations (NYC, Miami, London, Paris, Tokyo, etc.) |
| **Property** | 12 | Diverse property types and price ranges |
| **Booking** | 20 | Mix of confirmed (8), pending (5), canceled (3) bookings |
| **Payment** | 11 | Payments for confirmed bookings only |
| **Review** | 12 | Reviews with ratings 3-5 stars |
| **Message** | 20 | Realistic conversation threads between users |

---

## 🚀 Quick Start

### Prerequisites

- MySQL 8.0+ or MariaDB 10.5+
- Database schema already created (run `schema.sql` first)
- Proper user permissions

### Installation Steps

1. **Ensure schema is created:**
```bash
# If not already done, run schema first
mysql -u root -p airbnb < ../database-script-0x01/schema.sql
```

2. **Execute seed script:**
```bash
mysql -u root -p airbnb < seed.sql
```

Or from MySQL prompt:
```sql
USE airbnb;
SOURCE /path/to/seed.sql;
```

3. **Verify data insertion:**
```sql
SELECT COUNT(*) FROM User;
SELECT COUNT(*) FROM Property;
SELECT COUNT(*) FROM Booking;
```

---

## 📋 Detailed Data Breakdown

### 1. Users (15 Total)

#### Admins (2)
- Sarah Johnson - `admin@airbnb.com`
- Michael Chen - `mchen@airbnb.com`

#### Hosts (5)
- Emily Rodriguez - 3 properties (Manhattan, Miami)
- James Williams - 2 properties (San Francisco)
- Sophia Martinez - 2 properties (London, Paris)
- David Brown - 2 properties (Rome, Tokyo)
- Olivia Taylor - 4 properties (Sydney, Toronto, Cape Town, NYC)

#### Guests (8)
- Daniel Anderson, Isabella Thomas, Matthew Jackson
- Emma White, Christopher Harris, Ava Martin
- Ryan Garcia, Mia Lee

**Password Hash:** All users share the same demo hash for testing  
**Phone Format:** US format (+1-555-XXXX)

---

### 2. Locations (10 Global Cities)

| City | State/Region | Country | Coordinates |
|------|--------------|---------|-------------|
| New York | New York | United States | 40.7505, -73.9934 |
| Miami | Florida | United States | 25.7617, -80.1918 |
| San Francisco | California | United States | 37.7749, -122.4194 |
| London | England | United Kingdom | 51.5074, -0.1278 |
| Paris | Île-de-France | France | 48.8566, 2.3522 |
| Rome | Lazio | Italy | 41.9028, 12.4964 |
| Tokyo | Tokyo | Japan | 35.6762, 139.6503 |
| Sydney | New South Wales | Australia | -33.8688, 151.2093 |
| Toronto | Ontario | Canada | 43.6532, -79.3832 |
| Cape Town | Western Cape | South Africa | -33.9249, 18.4241 |

**Features:**
- GPS coordinates for geospatial queries
- Diverse international locations
- Full address components

---

### 3. Properties (12 Listings)

#### Price Range Distribution:
- **Budget ($79-$129):** 2 properties
- **Mid-Range ($189-$279):** 5 properties
- **Luxury ($299-$449):** 4 properties
- **Ultra-Luxury ($599):** 1 property

#### Property Types:
- Studio apartments (2)
- 1-bedroom units (2)
- 2-bedroom units (4)
- 3-bedroom units (2)
- 4+ bedroom houses (2)

**Sample Properties:**
1. **Luxury Manhattan Loft** - $299.99/night - 2BR, skyline views
2. **Miami Beach Penthouse** - $449.99/night - 3BR, private pool
3. **Downtown Studio** - $129.99/night - Cozy, workspace
4. **Cape Town Seaside Retreat** - $599.99/night - 5BR, infinity pool

---

### 4. Bookings (20 Reservations)

#### Status Distribution:
- **Confirmed:** 11 bookings (55%)
- **Pending:** 5 bookings (25%)
- **Canceled:** 4 bookings (20%)

#### Date Range:
- Past bookings: June 2024 - January 2025
- Future bookings: February 2025 - October 2025

#### Booking Statistics:
- **Average Stay:** 5.5 nights
- **Shortest Stay:** 3 nights
- **Longest Stay:** 10 nights
- **Total Revenue (Confirmed):** $19,468.86

**Realistic Features:**
- Historical pricing preserved with `nightly_rate`
- Calculated `total_price` matches (nights × rate)
- No overlapping bookings for same property
- Mix of weekend and week-long stays

---

### 5. Payments (11 Transactions)

#### Payment Method Distribution:
- **Credit Card:** 4 payments (36%)
- **PayPal:** 4 payments (36%)
- **Stripe:** 3 payments (28%)

#### Payment Timeline:
- Payments match confirmed booking dates
- Processed immediately upon booking confirmation
- No payments for pending or canceled bookings

**Total Processed:** $19,468.86

---

### 6. Reviews (12 Reviews)

#### Rating Distribution:
- **5 Stars:** 9 reviews (75%)
- **4 Stars:** 3 reviews (25%)
- **3 Stars:** 1 review (8%)
- **Average Rating:** 4.67/5.00

**Review Characteristics:**
- Only guests who completed stays can review
- Detailed, realistic feedback
- Mix of positive experiences and constructive criticism
- Reviews posted after checkout dates

**Sample Review:**
> "Absolutely stunning loft! The views were incredible and Emily was a wonderful host..."

---

### 7. Messages (20 Messages)

#### Message Types:
- **Pre-Booking Inquiries:** 8 messages
- **Booking Confirmations:** 4 messages
- **During-Stay Support:** 3 messages
- **Post-Stay Feedback:** 3 messages
- **General Questions:** 2 messages

**Conversation Threads:**
- Guest → Host inquiry about availability
- Host → Guest confirmation and details
- Guest → Host questions about amenities
- Host → Guest providing recommendations
- Guest → Host reporting issues
- Host → Guest resolving problems

**Realistic Elements:**
- Natural conversation flow
- Questions and answers
- Problem resolution
- Appreciation messages

---

## 🔍 Sample Queries

### User Analysis
```sql
-- Count users by role
SELECT role, COUNT(*) as count 
FROM User 
GROUP BY role;

-- Find hosts with most properties
SELECT 
    u.first_name, 
    u.last_name, 
    COUNT(p.property_id) as property_count
FROM User u
JOIN Property p ON u.user_id = p.host_id
GROUP BY u.user_id
ORDER BY property_count DESC;
```

### Booking Analytics
```sql
-- Booking status distribution
SELECT status, COUNT(*) as count, SUM(total_price) as revenue
FROM Booking
GROUP BY status;

-- Average booking duration
SELECT AVG(DATEDIFF(end_date, start_date)) as avg_nights
FROM Booking
WHERE status = 'confirmed';

-- Top earning properties
SELECT 
    p.name,
    SUM(b.total_price) as total_revenue,
    COUNT(b.booking_id) as booking_count
FROM Property p
JOIN Booking b ON p.property_id = b.property_id
WHERE b.status = 'confirmed'
GROUP BY p.property_id
ORDER BY total_revenue DESC
LIMIT 5;
```

### Review Insights
```sql
-- Average rating per property
SELECT 
    p.name,
    AVG(r.rating) as avg_rating,
    COUNT(r.review_id) as review_count
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id
GROUP BY p.property_id
ORDER BY avg_rating DESC;

-- Properties without reviews
SELECT p.name, p.pricepernight
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id
WHERE r.review_id IS NULL;
```

### Revenue Analysis
```sql
-- Monthly revenue
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') as month,
    SUM(amount) as total_revenue,
    COUNT(*) as transaction_count
FROM Payment
GROUP BY month
ORDER BY month;

-- Payment method preferences
SELECT 
    payment_method,
    COUNT(*) as usage_count,
    SUM(amount) as total_amount,
    AVG(amount) as avg_transaction
FROM Payment
GROUP BY payment_method;
```

### Location Popularity
```sql
-- Most popular cities
SELECT 
    l.city,
    l.country,
    COUNT(DISTINCT p.property_id) as property_count,
    COUNT(b.booking_id) as booking_count
FROM Location l
JOIN Property p ON l.location_id = p.location_id
LEFT JOIN Booking b ON p.property_id = b.property_id
GROUP BY l.location_id
ORDER BY booking_count DESC;
```

---

## 🧪 Testing Scenarios

### 1. User Authentication Test
```sql
-- Verify user can login
SELECT user_id, email, role 
FROM User 
WHERE email = 'emily.rodriguez@email.com';
```

### 2. Property Search Test
```sql
-- Find properties in price range
SELECT name, pricepernight, city, country
FROM vw_property_listings
WHERE pricepernight BETWEEN 100 AND 300
ORDER BY pricepernight;
```

### 3. Booking Availability Test
```sql
-- Check if property is available for dates
SELECT b.booking_id, b.start_date, b.end_date, b.status
FROM Booking b
WHERE b.property_id = '750e8400-e29b-41d4-a716-446655440001'
  AND b.status != 'canceled'
  AND (
    ('2025-06-15' BETWEEN b.start_date AND b.end_date)
    OR ('2025-06-20' BETWEEN b.start_date AND b.end_date)
  );
```

### 4. Payment Verification Test
```sql
-- Verify payment matches booking
SELECT 
    b.booking_id,
    b.total_price as booking_amount,
    p.amount as payment_amount,
    (b.total_price = p.amount) as amounts_match
FROM Booking b
JOIN Payment p ON b.booking_id = p.booking_id;
```

### 5. Review Integrity Test
```sql
-- Ensure reviews are from actual guests
SELECT 
    r.review_id,
    r.user_id,
    r.property_id,
    COUNT(b.booking_id) as bookings_at_property
FROM Review r
LEFT JOIN Booking b ON r.user_id = b.user_id 
    AND r.property_id = b.property_id
    AND b.status = 'confirmed'
GROUP BY r.review_id;
```

---

## 🔒 Data Integrity Features

### Foreign Key Relationships
All seed data respects foreign key constraints:
- ✅ All properties reference valid hosts
- ✅ All bookings reference valid properties and users
- ✅ All payments reference valid bookings
- ✅ All reviews reference valid properties and users
- ✅ All messages reference valid sender and recipient users

### Business Logic Compliance
- ✅ No self-messaging (sender ≠ recipient)
- ✅ End dates after start dates
- ✅ Ratings between 1-5
- ✅ Positive prices and amounts
- ✅ One review per user per property
- ✅ One payment per booking

### Realistic Patterns
- ✅ Confirmed bookings have payments
- ✅ Canceled bookings have no payments
- ✅ Reviews only from completed stays
- ✅ Message conversations flow naturally
- ✅ Booking dates in logical timeline

---

## 🛠️ Customization

### Adding More Data

To add additional sample data:

```sql
-- Add a new user
INSERT INTO User (user_id, first_name, last_name, email, password_hash, role)
VALUES (UUID(), 'John', 'Doe', 'john.doe@email.com', '$2y$10$...', 'guest');

-- Add a new property
INSERT INTO Property (property_id, host_id, location_id, name, description, pricepernight)
VALUES (
    UUID(), 
    (SELECT user_id FROM User WHERE email = 'host@email.com' LIMIT 1),
    (SELECT location_id FROM Location WHERE city = 'New York' LIMIT 1),
    'New Property',
    'Description here',
    150.00
);
```

### Clearing Seed Data

To remove all seed data while keeping schema:

```sql
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM Message;
DELETE FROM Review;
DELETE FROM Payment;
DELETE FROM Booking;
DELETE FROM Property;
DELETE FROM Location;
DELETE FROM User;
SET FOREIGN_KEY_CHECKS = 1;
```

---

## 📈 Data Statistics

### User Engagement
- **Active Hosts:** 5 (33% of users)
- **Active Guests:** 8 (53% of users)
- **Users with Bookings:** 13 (87%)
- **Users with Reviews:** 8 (53%)

### Property Performance
- **Average Price:** $277.49/night
- **Properties with Bookings:** 11 (92%)
- **Properties with Reviews:** 9 (75%)
- **Average Reviews per Property:** 1.0

### Booking Metrics
- **Confirmation Rate:** 55%
- **Cancellation Rate:** 20%
- **Pending Rate:** 25%
- **Average Booking Value:** $1,770.81

### Financial Summary
- **Total Revenue:** $19,468.86
- **Average Transaction:** $1,769.90
- **Largest Transaction:** $4,049.91
- **Smallest Transaction:** $389.97

---

## 🔄 Reset and Reload

### Complete Reset
```bash
# Drop and recreate everything
mysql -u root -p airbnb < ../database-script-0x01/schema.sql
mysql -u root -p airbnb < seed.sql
```

### Verify Counts
```bash
mysql -u root -p airbnb -e "
SELECT 
    'Users' as Entity, COUNT(*) as Count FROM User
UNION ALL SELECT 'Locations', COUNT(*) FROM Location
UNION ALL SELECT 'Properties', COUNT(*) FROM Property
UNION ALL SELECT 'Bookings', COUNT(*) FROM Booking
UNION ALL SELECT 'Payments', COUNT(*) FROM Payment
UNION ALL SELECT 'Reviews', COUNT(*) FROM Review
UNION ALL SELECT 'Messages', COUNT(*) FROM Message;
"
```

---

## 📚 Related Documentation

- [Database Schema](../database-script-0x01/schema.sql)
- [ERD Requirements](../ERD/requirements.md)
- [Normalization Analysis](../normalization.md)

---

## ⚠️ Important Notes

### Development Use Only
- This seed data is for **development and testing** purposes
- **DO NOT** use in production environments
- All passwords are placeholder hashes
- Email addresses are fictional

### Data Privacy
- No real personal information used
- All data is synthetic and generated
- UUIDs are predefined for consistency

### Performance Considerations
- Seed script disables foreign key checks temporarily
- Uses transactions for atomicity
- Can be run multiple times safely (with proper cleanup)

---

## 🐛 Troubleshooting

### Issue: Duplicate Key Errors
**Solution:** Clear existing data before re-seeding
```sql
-- Uncomment DELETE statements in seed.sql
```

### Issue: Foreign Key Constraint Fails
**Solution:** Ensure schema is created first
```bash
mysql -u root -p airbnb < ../database-script-0x01/schema.sql
```

### Issue: Data Not Appearing
**Solution:** Verify foreign key checks are enabled after seeding
```sql
SHOW VARIABLES LIKE 'foreign_key_checks';
```

---

## 👨‍💻 Author

**Johnson Aboagye**  
ALX Backend Program Learner  
Repository: `alx-airbnb-database`

---

## 📝 Change Log

### Version 1.0 (November 26, 2025)
- Initial seed data creation
- 15 users across 3 roles
- 10 global locations
- 12 diverse properties
- 20 bookings with realistic patterns
- 11 payment transactions
- 12 property reviews
- 20 message conversations

---

**Last Updated:** November 26, 2025  
**Data Version:** 1.0
