# AirBnB Database Schema (DDL)

## Overview
This directory contains the complete SQL Data Definition Language (DDL) scripts for the AirBnB clone database. The schema implements a normalized relational database design that supports core platform functionality including user management, property listings, bookings, payments, reviews, and messaging.

---

## 📁 Directory Structure

```
database-script-0x01/
├── schema.sql          # Complete DDL script with all table definitions
└── README.md           # This file - documentation and usage guide
```

---

## 🗄️ Database Schema Overview

### Entity Relationship Summary

The database consists of **7 core tables**:

1. **User** - System users (guests, hosts, admins)
2. **Location** - Normalized geographic data for properties
3. **Property** - Property listings with details
4. **Booking** - Reservation records
5. **Payment** - Payment transaction records
6. **Review** - Property reviews and ratings
7. **Message** - Inter-user messaging

### Relationships

```
User (1) ──────────< (N) Property [host]
User (1) ──────────< (N) Booking [guest]
User (1) ──────────< (N) Review [reviewer]
User (1) ──────────< (N) Message [sender]
User (1) ──────────< (N) Message [recipient]

Location (1) ──────< (N) Property

Property (1) ───────< (N) Booking
Property (1) ───────< (N) Review

Booking (1) ────────── (1) Payment
```

---

## 🚀 Quick Start

### Prerequisites

- MySQL 8.0+ or MariaDB 10.5+
- Database user with CREATE, ALTER, and INDEX privileges
- UTF-8 character set support

### Installation Steps

1. **Create Database:**
```bash
mysql -u root -p
```

```sql
CREATE DATABASE airbnb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE airbnb;
```

2. **Execute Schema Script:**
```bash
mysql -u root -p airbnb < schema.sql
```

Or from MySQL prompt:
```sql
SOURCE /path/to/schema.sql;
```

3. **Verify Installation:**
```sql
SHOW TABLES;
DESCRIBE User;
SHOW CREATE TABLE Property;
```

---

## 📊 Table Specifications

### 1. User Table

**Purpose:** Stores all system users with role-based access control.

**Columns:**
- `user_id` (CHAR(36), PK) - Unique identifier (UUID)
- `first_name` (VARCHAR(255)) - User's first name
- `last_name` (VARCHAR(255)) - User's last name
- `email` (VARCHAR(255), UNIQUE) - Email address for authentication
- `password_hash` (VARCHAR(255)) - Hashed password
- `phone_number` (VARCHAR(20), NULL) - Contact number
- `role` (ENUM) - User role: `guest`, `host`, `admin`
- `created_at` (TIMESTAMP) - Account creation date

**Indexes:**
- PRIMARY KEY on `user_id`
- UNIQUE INDEX on `email`
- INDEX on `role`
- INDEX on `created_at`

**Key Constraints:**
- Email must be unique
- Role is required and restricted to defined values

---

### 2. Location Table

**Purpose:** Normalized storage of property locations to eliminate redundancy.

**Columns:**
- `location_id` (CHAR(36), PK) - Unique identifier (UUID)
- `street_address` (VARCHAR(255)) - Street address
- `city` (VARCHAR(100)) - City name
- `state` (VARCHAR(100)) - State/Province
- `country` (VARCHAR(100)) - Country name
- `postal_code` (VARCHAR(20), NULL) - Postal/ZIP code
- `latitude` (DECIMAL(10,8), NULL) - GPS latitude
- `longitude` (DECIMAL(11,8), NULL) - GPS longitude
- `created_at` (TIMESTAMP) - Record creation date

**Indexes:**
- PRIMARY KEY on `location_id`
- COMPOSITE INDEX on `(city, country)`
- INDEX on `country`
- SPATIAL INDEX on `(latitude, longitude)`

**Benefits:**
- Reduces data duplication for properties in same location
- Enables efficient location-based searches
- Supports geospatial queries

---

### 3. Property Table

**Purpose:** Stores property listings with references to hosts and locations.

**Columns:**
- `property_id` (CHAR(36), PK) - Unique identifier (UUID)
- `host_id` (CHAR(36), FK → User) - Property owner reference
- `location_id` (CHAR(36), FK → Location) - Location reference
- `name` (VARCHAR(255)) - Property title
- `description` (TEXT) - Detailed description
- `pricepernight` (DECIMAL(10,2)) - Nightly rental rate
- `created_at` (TIMESTAMP) - Listing creation date
- `updated_at` (TIMESTAMP) - Last modification date

**Indexes:**
- PRIMARY KEY on `property_id`
- INDEX on `host_id`
- INDEX on `location_id`
- INDEX on `pricepernight`
- COMPOSITE INDEX on `(location_id, pricepernight)`

**Constraints:**
- `pricepernight` must be positive
- CASCADE delete when host is deleted
- RESTRICT delete when location is referenced

---

### 4. Booking Table

**Purpose:** Manages property reservations with status tracking.

**Columns:**
- `booking_id` (CHAR(36), PK) - Unique identifier (UUID)
- `property_id` (CHAR(36), FK → Property) - Booked property
- `user_id` (CHAR(36), FK → User) - Guest making booking
- `start_date` (DATE) - Check-in date
- `end_date` (DATE) - Check-out date
- `nightly_rate` (DECIMAL(10,2)) - Rate at time of booking
- `total_price` (DECIMAL(10,2)) - Total booking cost
- `status` (ENUM) - Status: `pending`, `confirmed`, `canceled`
- `created_at` (TIMESTAMP) - Booking creation date

**Indexes:**
- PRIMARY KEY on `booking_id`
- INDEX on `property_id`
- INDEX on `user_id`
- INDEX on `status`
- COMPOSITE INDEX on `(start_date, end_date)`
- COMPOSITE INDEX on `(property_id, start_date, end_date)`

**Constraints:**
- `end_date` must be after `start_date`
- `nightly_rate` and `total_price` must be positive
- Trigger prevents overlapping bookings

**Business Logic:**
- `nightly_rate` stores historical price (snapshot)
- `total_price` preserves exact amount charged
- Overlapping bookings prevented by trigger

---

### 5. Payment Table

**Purpose:** Records payment transactions for bookings.

**Columns:**
- `payment_id` (CHAR(36), PK) - Unique identifier (UUID)
- `booking_id` (CHAR(36), FK → Booking, UNIQUE) - Associated booking
- `amount` (DECIMAL(10,2)) - Payment amount
- `payment_date` (TIMESTAMP) - Transaction timestamp
- `payment_method` (ENUM) - Method: `credit_card`, `paypal`, `stripe`

**Indexes:**
- PRIMARY KEY on `payment_id`
- UNIQUE INDEX on `booking_id` (one payment per booking)
- INDEX on `payment_date`
- INDEX on `payment_method`

**Constraints:**
- `amount` must be positive
- One-to-one relationship with Booking

---

### 6. Review Table

**Purpose:** Stores guest reviews and ratings for properties.

**Columns:**
- `review_id` (CHAR(36), PK) - Unique identifier (UUID)
- `property_id` (CHAR(36), FK → Property) - Reviewed property
- `user_id` (CHAR(36), FK → User) - Reviewer (guest)
- `rating` (INTEGER) - Rating score (1-5)
- `comment` (TEXT) - Review text
- `created_at` (TIMESTAMP) - Review submission date

**Indexes:**
- PRIMARY KEY on `review_id`
- INDEX on `property_id`
- INDEX on `user_id`
- INDEX on `rating`
- COMPOSITE UNIQUE INDEX on `(property_id, user_id)`

**Constraints:**
- `rating` must be between 1 and 5
- One review per user per property
- Prevents duplicate reviews

---

### 7. Message Table

**Purpose:** Facilitates communication between users.

**Columns:**
- `message_id` (CHAR(36), PK) - Unique identifier (UUID)
- `sender_id` (CHAR(36), FK → User) - Message sender
- `recipient_id` (CHAR(36), FK → User) - Message recipient
- `message_body` (TEXT) - Message content
- `sent_at` (TIMESTAMP) - Sending timestamp

**Indexes:**
- PRIMARY KEY on `message_id`
- INDEX on `sender_id`
- INDEX on `recipient_id`
- INDEX on `sent_at`
- COMPOSITE INDEX on `(sender_id, recipient_id, sent_at)`

**Constraints:**
- `sender_id` and `recipient_id` must be different
- Prevents self-messaging

---

## 🔍 Views

The schema includes three useful views for common queries:

### 1. vw_property_listings
Combines property, host, and location data for easy retrieval.

```sql
SELECT * FROM vw_property_listings WHERE city = 'New York';
```

### 2. vw_booking_details
Provides complete booking information including guest and host details.

```sql
SELECT * FROM vw_booking_details WHERE status = 'confirmed';
```

### 3. vw_property_reviews
Shows reviews with property and reviewer information.

```sql
SELECT * FROM vw_property_reviews WHERE property_id = 'xxx-xxx-xxx';
```

---

## ⚡ Performance Optimizations

### Indexing Strategy

1. **Primary Keys:** Auto-indexed on all UUID fields
2. **Foreign Keys:** Indexed for JOIN performance
3. **Search Columns:** Email, status, dates indexed
4. **Composite Indexes:** Multi-column queries optimized
5. **Date Ranges:** Start/end date combinations indexed

### Query Optimization Tips

**✅ DO:**
- Use indexed columns in WHERE clauses
- Leverage composite indexes for multi-column searches
- Use views for complex frequent queries

**❌ AVOID:**
- SELECT * (specify needed columns)
- Functions on indexed columns in WHERE
- OR conditions that prevent index usage

---

## 🔒 Data Integrity Features

### Foreign Key Constraints

All relationships enforce referential integrity:
- **CASCADE:** Child records deleted when parent deleted
- **RESTRICT:** Prevents deletion if referenced elsewhere

### Check Constraints

Business rules enforced at database level:
- Positive prices and amounts
- Valid date ranges
- Rating within 1-5 range
- Self-messaging prevention

### Triggers

1. **trg_property_before_update:** Auto-updates `updated_at`
2. **trg_booking_before_insert:** Prevents overlapping bookings

---

## 🧪 Testing the Schema

### Verification Queries

```sql
-- Check all tables created
SHOW TABLES;

-- Verify foreign keys
SELECT 
    TABLE_NAME, 
    CONSTRAINT_NAME, 
    REFERENCED_TABLE_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'airbnb' 
  AND REFERENCED_TABLE_NAME IS NOT NULL;

-- Check indexes
SHOW INDEX FROM Booking;

-- Verify constraints
SHOW CREATE TABLE Review;
```

### Sample Data Insertion

The schema includes sample user data. Test with:

```sql
-- View sample users
SELECT * FROM User;

-- Test foreign key constraint
INSERT INTO Property (property_id, host_id, location_id, name, description, pricepernight)
VALUES (UUID(), (SELECT user_id FROM User WHERE role='host' LIMIT 1), UUID(), 'Test Property', 'Test', 100.00);
```

---

## 🔧 Maintenance

### Regular Tasks

1. **Monitor Index Usage:**
```sql
SHOW INDEX FROM Property WHERE Cardinality IS NULL;
```

2. **Optimize Tables:**
```sql
OPTIMIZE TABLE Booking, Property, Review;
```

3. **Analyze Performance:**
```sql
EXPLAIN SELECT * FROM Booking WHERE property_id = 'xxx';
```

### Backup Strategy

```bash
# Full backup
mysqldump -u root -p airbnb > airbnb_backup_$(date +%Y%m%d).sql

# Schema only
mysqldump -u root -p --no-data airbnb > airbnb_schema.sql
```

---

## 📚 Additional Resources

### Related Documentation
- [ERD Requirements](../ERD/requirements.md)
- [Normalization Analysis](../normalization.md)

### MySQL References
- [MySQL Data Types](https://dev.mysql.com/doc/refman/8.0/en/data-types.html)
- [Foreign Keys](https://dev.mysql.com/doc/refman/8.0/en/create-table-foreign-keys.html)
- [Indexes](https://dev.mysql.com/doc/refman/8.0/en/optimization-indexes.html)

---

## 🐛 Troubleshooting

### Common Issues

**Issue:** Foreign key constraint fails
```
Solution: Ensure parent record exists before inserting child
```

**Issue:** UUID format errors
```
Solution: Use UUID() function or proper UUID format (36 chars)
```

**Issue:** Trigger fails on booking overlap
```
Solution: Check for existing confirmed bookings in date range
```

### Getting Help

If you encounter issues:
1. Check error messages carefully
2. Verify data types match schema
3. Ensure foreign key references exist
4. Review constraint definitions

---

## 📝 Change Log

### Version 1.0 (November 26, 2025)
- Initial schema creation
- Added Location table for normalization
- Implemented comprehensive indexing
- Added data integrity triggers
- Created utility views

---

## 👨‍💻 Author

**Johnson Aboagye**  
ALX Backend Program Learner  
Repository: `alx-airbnb-database`

---

## 📄 License

This project is part of the ALX Backend Program curriculum.

---

**Last Updated:** November 26, 2025  
**Schema Version:** 1.0
