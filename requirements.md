# AirBnB Database - Entity-Relationship Diagram Requirements

## Project Overview
This document outlines the entities, attributes, and relationships for the AirBnB database system. Use this specification to create the ER diagram using Draw.io or similar tools.

---

## 1. Entities and Attributes

### 1.1 User Entity
**Description:** Represents all users in the system (guests, hosts, and admins).

| Attribute | Type | Constraints | Description |
|-----------|------|-------------|-------------|
| user_id | UUID | PRIMARY KEY, INDEXED | Unique identifier for each user |
| first_name | VARCHAR | NOT NULL | User's first name |
| last_name | VARCHAR | NOT NULL | User's last name |
| email | VARCHAR | UNIQUE, NOT NULL, INDEXED | User's email address |
| password_hash | VARCHAR | NOT NULL | Hashed password for authentication |
| phone_number | VARCHAR | NULL | User's contact number (optional) |
| role | ENUM | NOT NULL | User role: `guest`, `host`, or `admin` |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Account creation timestamp |

---

### 1.2 Property Entity
**Description:** Represents properties listed by hosts for booking.

| Attribute | Type | Constraints | Description |
|-----------|------|-------------|-------------|
| property_id | UUID | PRIMARY KEY, INDEXED | Unique identifier for each property |
| host_id | UUID | FOREIGN KEY → User(user_id) | Reference to the property owner |
| name | VARCHAR | NOT NULL | Property name/title |
| description | TEXT | NOT NULL | Detailed property description |
| location | VARCHAR | NOT NULL | Property address/location |
| pricepernight | DECIMAL | NOT NULL | Nightly rental price |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Property listing creation date |
| updated_at | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Last modification timestamp |

---

### 1.3 Booking Entity
**Description:** Represents reservation records for properties.

| Attribute | Type | Constraints | Description |
|-----------|------|-------------|-------------|
| booking_id | UUID | PRIMARY KEY, INDEXED | Unique identifier for each booking |
| property_id | UUID | FOREIGN KEY → Property(property_id), INDEXED | Reference to booked property |
| user_id | UUID | FOREIGN KEY → User(user_id) | Reference to guest making booking |
| start_date | DATE | NOT NULL | Check-in date |
| end_date | DATE | NOT NULL | Check-out date |
| total_price | DECIMAL | NOT NULL | Total cost of booking |
| status | ENUM | NOT NULL | Booking status: `pending`, `confirmed`, `canceled` |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Booking creation timestamp |

---

### 1.4 Payment Entity
**Description:** Tracks payment transactions for bookings.

| Attribute | Type | Constraints | Description |
|-----------|------|-------------|-------------|
| payment_id | UUID | PRIMARY KEY, INDEXED | Unique identifier for each payment |
| booking_id | UUID | FOREIGN KEY → Booking(booking_id), INDEXED | Reference to associated booking |
| amount | DECIMAL | NOT NULL | Payment amount |
| payment_date | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Payment processing timestamp |
| payment_method | ENUM | NOT NULL | Payment method: `credit_card`, `paypal`, `stripe` |

---

### 1.5 Review Entity
**Description:** Stores guest reviews and ratings for properties.

| Attribute | Type | Constraints | Description |
|-----------|------|-------------|-------------|
| review_id | UUID | PRIMARY KEY, INDEXED | Unique identifier for each review |
| property_id | UUID | FOREIGN KEY → Property(property_id) | Reference to reviewed property |
| user_id | UUID | FOREIGN KEY → User(user_id) | Reference to reviewer (guest) |
| rating | INTEGER | NOT NULL, CHECK (rating >= 1 AND rating <= 5) | Rating score (1-5 stars) |
| comment | TEXT | NOT NULL | Review text/feedback |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Review submission timestamp |

---

### 1.6 Message Entity
**Description:** Facilitates communication between users.

| Attribute | Type | Constraints | Description |
|-----------|------|-------------|-------------|
| message_id | UUID | PRIMARY KEY, INDEXED | Unique identifier for each message |
| sender_id | UUID | FOREIGN KEY → User(user_id) | Reference to message sender |
| recipient_id | UUID | FOREIGN KEY → User(user_id) | Reference to message recipient |
| message_body | TEXT | NOT NULL | Message content |
| sent_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Message sending timestamp |

---

## 2. Relationships

### 2.1 User ↔ Property (One-to-Many)
- **Type:** One-to-Many
- **Description:** A User (host) can list multiple Properties, but each Property belongs to one host.
- **Cardinality:** 1:N
- **Foreign Key:** `Property.host_id` → `User.user_id`

---

### 2.2 User ↔ Booking (One-to-Many)
- **Type:** One-to-Many
- **Description:** A User (guest) can make multiple Bookings, but each Booking is made by one user.
- **Cardinality:** 1:N
- **Foreign Key:** `Booking.user_id` → `User.user_id`

---

### 2.3 Property ↔ Booking (One-to-Many)
- **Type:** One-to-Many
- **Description:** A Property can have multiple Bookings over time, but each Booking is for one property.
- **Cardinality:** 1:N
- **Foreign Key:** `Booking.property_id` → `Property.property_id`

---

### 2.4 Booking ↔ Payment (One-to-One)
- **Type:** One-to-One
- **Description:** Each Booking has exactly one Payment record, and each Payment is linked to one booking.
- **Cardinality:** 1:1
- **Foreign Key:** `Payment.booking_id` → `Booking.booking_id`

---

### 2.5 Property ↔ Review (One-to-Many)
- **Type:** One-to-Many
- **Description:** A Property can receive multiple Reviews, but each Review is for one property.
- **Cardinality:** 1:N
- **Foreign Key:** `Review.property_id` → `Property.property_id`

---

### 2.6 User ↔ Review (One-to-Many)
- **Type:** One-to-Many
- **Description:** A User (guest) can write multiple Reviews, but each Review is written by one user.
- **Cardinality:** 1:N
- **Foreign Key:** `Review.user_id` → `User.user_id`

---

### 2.7 User ↔ Message (Sender) (One-to-Many)
- **Type:** One-to-Many
- **Description:** A User can send multiple Messages, but each Message has one sender.
- **Cardinality:** 1:N
- **Foreign Key:** `Message.sender_id` → `User.user_id`

---

### 2.8 User ↔ Message (Recipient) (One-to-Many)
- **Type:** One-to-Many
- **Description:** A User can receive multiple Messages, but each Message has one recipient.
- **Cardinality:** 1:N
- **Foreign Key:** `Message.recipient_id` → `User.user_id`

---

## 3. Constraints Summary

### 3.1 Unique Constraints
- `User.email` must be unique across all users

### 3.2 Check Constraints
- `Review.rating` must be between 1 and 5 (inclusive)
- `User.role` must be one of: `guest`, `host`, `admin`
- `Booking.status` must be one of: `pending`, `confirmed`, `canceled`
- `Payment.payment_method` must be one of: `credit_card`, `paypal`, `stripe`

### 3.3 Referential Integrity
- All foreign keys must reference existing records in parent tables
- Cascade rules should be defined for deletions (consider business logic)

---

## 4. Indexes

### 4.1 Primary Key Indexes (Automatic)
- `User.user_id`
- `Property.property_id`
- `Booking.booking_id`
- `Payment.payment_id`
- `Review.review_id`
- `Message.message_id`

### 4.2 Additional Indexes (Performance Optimization)
- `User.email` - for fast login/authentication queries
- `Property.host_id` - for retrieving properties by host
- `Booking.property_id` - for property availability checks
- `Booking.user_id` - for user booking history
- `Payment.booking_id` - for payment lookup by booking
- `Review.property_id` - for fetching property reviews
- `Message.sender_id` - for outbox queries
- `Message.recipient_id` - for inbox queries

---

## 5. ER Diagram Creation Guidelines

### 5.1 Using Draw.io
1. **Entities:** Represent each entity as a rectangle with rounded corners
2. **Attributes:** List attributes inside the entity box
   - Underline primary keys
   - Mark foreign keys with (FK)
   - Indicate data types next to attribute names
3. **Relationships:** Use lines to connect entities
   - Add cardinality notation (1, N, 1..1, 0..N)
   - Label relationships with descriptive names
4. **Layout:** Arrange entities to minimize line crossings

### 5.2 Recommended Notation
- **Crow's Foot Notation** for relationship cardinality
- **Chen Notation** for attribute representation (optional)
- Use color coding for entity types if desired

### 5.3 Key Visual Elements
- **Primary Keys:** Underlined or marked with 🔑
- **Foreign Keys:** Marked with (FK) or different color
- **Mandatory Fields:** Bold text or asterisk (*)
- **Optional Fields:** Regular text

---

## 6. Validation Checklist

Before finalizing your ER diagram, verify:

- [ ] All 6 entities are represented
- [ ] All attributes are listed with correct data types
- [ ] Primary keys are clearly marked
- [ ] Foreign keys are identified and connected
- [ ] All 8 relationships are drawn with correct cardinality
- [ ] ENUM constraints are documented
- [ ] Check constraints are noted (especially Review.rating)
- [ ] Indexes are identified on the diagram or in legend
- [ ] Timestamps (created_at, updated_at) are included

---

## 7. Expected Deliverable

Your ER diagram should clearly show:
1. All entities with their complete attribute sets
2. Relationship lines with cardinality notation
3. Primary and foreign key relationships
4. Any business rule constraints (ENUM values, CHECK constraints)
5. A legend explaining symbols and notation used

**File Location:** `ERD/requirements.md` (this file)  
**Diagram File:** `ERD/airbnb_erd.drawio` or `ERD/airbnb_erd.png`

---

## 8. Additional Notes

### Business Logic Considerations
- A user can be both a guest and a host simultaneously
- Properties can only be booked if status is not `canceled`
- Reviews can only be written after a booking is `confirmed` (implement in application logic)
- Messages create a communication thread between users

### Future Enhancements (Optional)
- Add `Amenity` entity for property features
- Add `PropertyImage` entity for photo galleries
- Implement soft deletes with `deleted_at` timestamps
- Add `Availability` entity for property calendar management

---

**Document Version:** 1.0  
**Last Updated:** November 26, 2025  
**Author:** Johnson Aboagye  
**Repository:** `alx-airbnb-database`
