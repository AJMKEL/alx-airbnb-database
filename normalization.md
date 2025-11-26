# Database Normalization - AirBnB Schema

## Overview
This document analyzes the AirBnB database schema and applies normalization principles to ensure compliance with Third Normal Form (3NF). The goal is to eliminate redundancy, maintain data integrity, and optimize the database structure.

---

## 1. Understanding Normal Forms

### First Normal Form (1NF)
**Requirements:**
- Each table cell contains atomic (indivisible) values
- Each record is unique
- No repeating groups or arrays

### Second Normal Form (2NF)
**Requirements:**
- Must be in 1NF
- All non-key attributes are fully functionally dependent on the primary key
- No partial dependencies (applies to composite keys)

### Third Normal Form (3NF)
**Requirements:**
- Must be in 2NF
- No transitive dependencies (non-key attributes should not depend on other non-key attributes)
- All attributes depend directly on the primary key only

---

## 2. Initial Schema Analysis

### 2.1 User Table
```sql
User (
    user_id,           -- PK
    first_name,
    last_name,
    email,
    password_hash,
    phone_number,
    role,
    created_at
)
```

**Analysis:**
- ✅ **1NF Compliant:** All attributes are atomic
- ✅ **2NF Compliant:** Single-column primary key; no partial dependencies
- ✅ **3NF Compliant:** No transitive dependencies detected
- **Status:** Already normalized to 3NF

**Justification:**
- Each attribute depends directly on `user_id`
- `first_name`, `last_name`, `email`, etc. are all user-specific attributes
- No derived or redundant data

---

### 2.2 Property Table
```sql
Property (
    property_id,       -- PK
    host_id,           -- FK → User
    name,
    description,
    location,
    pricepernight,
    created_at,
    updated_at
)
```

**Analysis:**
- ✅ **1NF Compliant:** All attributes are atomic
- ✅ **2NF Compliant:** Single-column primary key
- ⚠️ **Potential 3NF Issue:** The `location` field may contain redundant data

**Issues Identified:**
1. `location` is stored as a single VARCHAR, which may contain:
   - Street address
   - City
   - State/Province
   - Country
   - Postal code
   
   This creates potential redundancy (e.g., multiple properties in the same city repeat city/country data).

**Normalization Recommendation:**
Create a separate `Location` entity to eliminate redundancy.

#### Normalized Design:

**Location Table (NEW):**
```sql
Location (
    location_id,       -- PK, UUID
    street_address,    -- VARCHAR, NOT NULL
    city,              -- VARCHAR, NOT NULL
    state,             -- VARCHAR, NOT NULL
    country,           -- VARCHAR, NOT NULL
    postal_code,       -- VARCHAR, NULL
    latitude,          -- DECIMAL, NULL
    longitude,         -- DECIMAL, NULL
    created_at         -- TIMESTAMP
)
```

**Updated Property Table:**
```sql
Property (
    property_id,       -- PK
    host_id,           -- FK → User
    location_id,       -- FK → Location (NEW)
    name,
    description,
    pricepernight,
    created_at,
    updated_at
)
```

**Benefits:**
- Reduces data redundancy for properties in the same location
- Makes location-based queries more efficient
- Easier to update location data (e.g., city name changes)
- Supports geospatial queries with latitude/longitude

**Status After Normalization:** ✅ 3NF Compliant

---

### 2.3 Booking Table
```sql
Booking (
    booking_id,        -- PK
    property_id,       -- FK → Property
    user_id,           -- FK → User
    start_date,
    end_date,
    total_price,       -- ⚠️ POTENTIAL ISSUE
    status,
    created_at
)
```

**Analysis:**
- ✅ **1NF Compliant:** All attributes are atomic
- ✅ **2NF Compliant:** Single-column primary key
- ⚠️ **3NF Issue Detected:** `total_price` is a **derived attribute**

**Problem:**
`total_price` can be calculated from:
```
total_price = (end_date - start_date) × Property.pricepernight
```

This creates a **transitive dependency** and violates 3NF because:
- `total_price` depends on `property_id` (through `pricepernight`)
- `total_price` is not directly dependent on `booking_id` alone

**However, we should keep `total_price` for business reasons:**

#### Decision: Keep `total_price` (Denormalization for Valid Reasons)

**Justification:**
1. **Historical Accuracy:** Property prices change over time. Storing `total_price` preserves the exact amount charged at booking time.
2. **Performance:** Calculating totals on-the-fly for reports would be expensive.
3. **Business Logic:** Discounts, promotions, or special pricing may apply.

**Best Practice Implementation:**
```sql
Booking (
    booking_id,        -- PK
    property_id,       -- FK → Property
    user_id,           -- FK → User
    start_date,
    end_date,
    nightly_rate,      -- NEW: Store rate at time of booking
    total_price,       -- Calculated but stored
    status,
    created_at
)
```

**Why This Works:**
- We add `nightly_rate` to capture the price at booking time
- `total_price` becomes a snapshot of historical data
- This is **controlled denormalization** for valid business needs

**Status:** ✅ Acceptable denormalization with business justification

---

### 2.4 Payment Table
```sql
Payment (
    payment_id,        -- PK
    booking_id,        -- FK → Booking
    amount,            -- ⚠️ POTENTIAL REDUNDANCY
    payment_date,
    payment_method
)
```

**Analysis:**
- ✅ **1NF Compliant:** All attributes are atomic
- ✅ **2NF Compliant:** Single-column primary key
- ⚠️ **Potential Issue:** `amount` duplicates `Booking.total_price`

**Evaluation:**
The `amount` field typically matches `Booking.total_price`, but there are valid scenarios where they differ:
- Partial payments
- Refunds
- Payment processing fees
- Split payments

**Decision:** ✅ Keep both fields

**Justification:**
- `Booking.total_price` = amount owed
- `Payment.amount` = amount actually paid
- These may differ in real-world scenarios

**Status:** ✅ 3NF Compliant

---

### 2.5 Review Table
```sql
Review (
    review_id,         -- PK
    property_id,       -- FK → Property
    user_id,           -- FK → User
    rating,
    comment,
    created_at
)
```

**Analysis:**
- ✅ **1NF Compliant:** All attributes are atomic
- ✅ **2NF Compliant:** Single-column primary key
- ✅ **3NF Compliant:** No transitive dependencies
- **Status:** Already normalized to 3NF

**All attributes depend directly on `review_id`:**
- `property_id` identifies which property
- `user_id` identifies who wrote the review
- `rating` and `comment` are review-specific data

---

### 2.6 Message Table
```sql
Message (
    message_id,        -- PK
    sender_id,         -- FK → User
    recipient_id,      -- FK → User
    message_body,
    sent_at
)
```

**Analysis:**
- ✅ **1NF Compliant:** All attributes are atomic
- ✅ **2NF Compliant:** Single-column primary key
- ✅ **3NF Compliant:** No transitive dependencies
- **Status:** Already normalized to 3NF

---

## 3. Final Normalized Schema

### 3.1 Summary of Changes

| Table | Original Status | Changes Made | Final Status |
|-------|----------------|--------------|--------------|
| User | 3NF ✅ | None | 3NF ✅ |
| Property | Potential Issue ⚠️ | Extracted Location entity | 3NF ✅ |
| Booking | Controlled Denormalization | Added `nightly_rate` | 3NF ✅* |
| Payment | 3NF ✅ | None | 3NF ✅ |
| Review | 3NF ✅ | None | 3NF ✅ |
| Message | 3NF ✅ | None | 3NF ✅ |
| Location | N/A | **NEW TABLE** | 3NF ✅ |

*Controlled denormalization with valid business justification

---

### 3.2 Complete Normalized Schema

#### User Table (No Changes)
```sql
CREATE TABLE User (
    user_id UUID PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role ENUM('guest', 'host', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email)
);
```

---

#### Location Table (NEW)
```sql
CREATE TABLE Location (
    location_id UUID PRIMARY KEY,
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_city_country (city, country),
    INDEX idx_coordinates (latitude, longitude)
);
```

---

#### Property Table (Updated)
```sql
CREATE TABLE Property (
    property_id UUID PRIMARY KEY,
    host_id UUID NOT NULL,
    location_id UUID NOT NULL,  -- NEW: FK to Location
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    pricepernight DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (host_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES Location(location_id) ON DELETE RESTRICT,
    INDEX idx_host_id (host_id),
    INDEX idx_location_id (location_id)
);
```

---

#### Booking Table (Updated)
```sql
CREATE TABLE Booking (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    nightly_rate DECIMAL(10, 2) NOT NULL,  -- NEW: Historical price
    total_price DECIMAL(10, 2) NOT NULL,   -- Calculated but stored
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    INDEX idx_property_id (property_id),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_dates (start_date, end_date)
);
```

---

#### Payment Table (No Changes)
```sql
CREATE TABLE Payment (
    payment_id UUID PRIMARY KEY,
    booking_id UUID NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE CASCADE,
    INDEX idx_booking_id (booking_id)
);
```

---

#### Review Table (No Changes)
```sql
CREATE TABLE Review (
    review_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    INDEX idx_property_id (property_id),
    INDEX idx_user_id (user_id)
);
```

---

#### Message Table (No Changes)
```sql
CREATE TABLE Message (
    message_id UUID PRIMARY KEY,
    sender_id UUID NOT NULL,
    recipient_id UUID NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (recipient_id) REFERENCES User(user_id) ON DELETE CASCADE,
    INDEX idx_sender_id (sender_id),
    INDEX idx_recipient_id (recipient_id)
);
```

---

## 4. Normalization Steps Summary

### Step 1: Verify 1NF Compliance ✅
- **Action:** Reviewed all tables for atomic values and repeating groups
- **Result:** All tables already in 1NF
- No multi-valued attributes or arrays found

### Step 2: Verify 2NF Compliance ✅
- **Action:** Checked for partial dependencies in tables with composite keys
- **Result:** All tables use single-column primary keys (UUIDs)
- No partial dependencies possible

### Step 3: Achieve 3NF Compliance
- **Action:** Identified and resolved transitive dependencies

**Changes Made:**

1. **Property Table → Location Extraction**
   - **Issue:** `location` field contained composite data
   - **Solution:** Created `Location` table
   - **Benefit:** Eliminated redundancy for properties in same location

2. **Booking Table → Historical Price Preservation**
   - **Issue:** `total_price` is derived from `pricepernight`
   - **Solution:** Added `nightly_rate` to preserve historical pricing
   - **Justification:** Business requirement for accurate historical records

### Step 4: Verify Final Schema ✅
All tables now satisfy 3NF requirements:
- User: Direct dependencies only
- Property: Location extracted to separate table
- Booking: Historical data properly preserved
- Payment: Independent payment records
- Review: Direct dependencies only
- Message: Direct dependencies only
- Location: New normalized entity

---

## 5. Benefits of Normalization

### Data Integrity
- ✅ Eliminates update anomalies
- ✅ Prevents deletion anomalies
- ✅ Reduces insertion anomalies

### Storage Efficiency
- ✅ Reduced data redundancy
- ✅ Smaller storage footprint
- ✅ Faster backups

### Query Performance
- ✅ More efficient joins with proper indexing
- ✅ Better query optimization opportunities
- ✅ Improved location-based searches

### Maintainability
- ✅ Easier to update location data
- ✅ Clear data relationships
- ✅ Simplified application logic

---

## 6. Controlled Denormalization

While we achieved 3NF, we maintained some calculated fields for valid reasons:

| Field | Table | Justification |
|-------|-------|---------------|
| `total_price` | Booking | Historical accuracy, performance |
| `nightly_rate` | Booking | Price snapshot at booking time |

**Why This Is Acceptable:**
- These are **read-heavy** fields used in reports
- Recalculating from historical data is complex
- Prices change over time; we need snapshots
- Application logic ensures consistency

---

## 7. Migration Strategy

If migrating from the old schema:

```sql
-- Step 1: Create Location table
CREATE TABLE Location (...);

-- Step 2: Migrate existing location data
INSERT INTO Location (location_id, street_address, city, state, country)
SELECT 
    UUID() as location_id,
    location as street_address,
    -- Parse location string into components
    -- This requires custom parsing logic
FROM Property_OLD;

-- Step 3: Update Property table
ALTER TABLE Property 
ADD COLUMN location_id UUID,
ADD FOREIGN KEY (location_id) REFERENCES Location(location_id);

UPDATE Property p
SET location_id = (
    SELECT location_id FROM Location l 
    WHERE l.street_address = p.location
);

-- Step 4: Remove old location column
ALTER TABLE Property DROP COLUMN location;

-- Step 5: Add nightly_rate to Booking
ALTER TABLE Booking ADD COLUMN nightly_rate DECIMAL(10, 2);

UPDATE Booking b
SET nightly_rate = (
    SELECT pricepernight FROM Property p 
    WHERE p.property_id = b.property_id
);
```

---

## 8. Conclusion

The AirBnB database schema has been successfully normalized to Third Normal Form (3NF) with the following results:

✅ **7 tables** (6 original + 1 new Location table)  
✅ **Zero uncontrolled redundancy**  
✅ **All transitive dependencies eliminated**  
✅ **Business requirements preserved**  
✅ **Performance considerations addressed**  

The schema now provides a solid foundation for:
- Scalable application growth
- Efficient data management
- Reliable reporting
- Maintainable codebase

---

**Document Version:** 1.0  
**Date:** November 26, 2025  
**Author:** Johnson Aboagye  
**Repository:** `alx-airbnb-database`  
**File:** `normalization.md`
