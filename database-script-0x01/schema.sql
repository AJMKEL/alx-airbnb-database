-- =====================================================
-- AirBnB Database Schema (DDL)
-- =====================================================
-- Description: Complete database schema for AirBnB clone
-- Version: 1.0
-- Date: November 26, 2025
-- Author: Johnson Aboagye
-- Repository: alx-airbnb-database
-- =====================================================

-- Drop existing tables if they exist (for clean recreation)
-- Order matters due to foreign key constraints
DROP TABLE IF EXISTS Message;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Booking;
DROP TABLE IF EXISTS Property;
DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS User;

-- =====================================================
-- TABLE: User
-- Description: Stores all system users (guests, hosts, admins)
-- =====================================================
CREATE TABLE User (
    user_id CHAR(36) PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role ENUM('guest', 'host', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Indexes for performance optimization
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: Location
-- Description: Normalized location data for properties
-- =====================================================
CREATE TABLE Location (
    location_id CHAR(36) PRIMARY KEY,
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Indexes for location-based queries
    INDEX idx_city_country (city, country),
    INDEX idx_country (country),
    INDEX idx_coordinates (latitude, longitude)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: Property
-- Description: Stores property listings
-- =====================================================
CREATE TABLE Property (
    property_id CHAR(36) PRIMARY KEY,
    host_id CHAR(36) NOT NULL,
    location_id CHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    pricepernight DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    CONSTRAINT fk_property_host 
        FOREIGN KEY (host_id) 
        REFERENCES User(user_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_property_location 
        FOREIGN KEY (location_id) 
        REFERENCES Location(location_id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    
    -- Check constraint for positive price
    CONSTRAINT chk_price_positive 
        CHECK (pricepernight > 0),
    
    -- Indexes for performance
    INDEX idx_host_id (host_id),
    INDEX idx_location_id (location_id),
    INDEX idx_price (pricepernight),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: Booking
-- Description: Stores property booking records
-- =====================================================
CREATE TABLE Booking (
    booking_id CHAR(36) PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    nightly_rate DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    CONSTRAINT fk_booking_property 
        FOREIGN KEY (property_id) 
        REFERENCES Property(property_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_booking_user 
        FOREIGN KEY (user_id) 
        REFERENCES User(user_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Check constraints for business logic
    CONSTRAINT chk_dates_valid 
        CHECK (end_date > start_date),
    
    CONSTRAINT chk_nightly_rate_positive 
        CHECK (nightly_rate > 0),
    
    CONSTRAINT chk_total_price_positive 
        CHECK (total_price > 0),
    
    -- Indexes for performance
    INDEX idx_property_id (property_id),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_dates (start_date, end_date),
    INDEX idx_property_dates (property_id, start_date, end_date),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: Payment
-- Description: Stores payment transaction records
-- =====================================================
CREATE TABLE Payment (
    payment_id CHAR(36) PRIMARY KEY,
    booking_id CHAR(36) NOT NULL UNIQUE,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,
    
    -- Foreign key constraint
    CONSTRAINT fk_payment_booking 
        FOREIGN KEY (booking_id) 
        REFERENCES Booking(booking_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Check constraint for positive amount
    CONSTRAINT chk_amount_positive 
        CHECK (amount > 0),
    
    -- Indexes for performance
    INDEX idx_booking_id (booking_id),
    INDEX idx_payment_date (payment_date),
    INDEX idx_payment_method (payment_method)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: Review
-- Description: Stores property reviews and ratings
-- =====================================================
CREATE TABLE Review (
    review_id CHAR(36) PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    rating INTEGER NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    CONSTRAINT fk_review_property 
        FOREIGN KEY (property_id) 
        REFERENCES Property(property_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_review_user 
        FOREIGN KEY (user_id) 
        REFERENCES User(user_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Check constraint for rating range (1-5)
    CONSTRAINT chk_rating_range 
        CHECK (rating >= 1 AND rating <= 5),
    
    -- Prevent duplicate reviews (one review per user per property)
    CONSTRAINT unique_user_property_review 
        UNIQUE (property_id, user_id),
    
    -- Indexes for performance
    INDEX idx_property_id (property_id),
    INDEX idx_user_id (user_id),
    INDEX idx_rating (rating),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: Message
-- Description: Stores messages between users
-- =====================================================
CREATE TABLE Message (
    message_id CHAR(36) PRIMARY KEY,
    sender_id CHAR(36) NOT NULL,
    recipient_id CHAR(36) NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    CONSTRAINT fk_message_sender 
        FOREIGN KEY (sender_id) 
        REFERENCES User(user_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_message_recipient 
        FOREIGN KEY (recipient_id) 
        REFERENCES User(user_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Check constraint to prevent self-messaging
    CONSTRAINT chk_different_users 
        CHECK (sender_id != recipient_id),
    
    -- Indexes for performance
    INDEX idx_sender_id (sender_id),
    INDEX idx_recipient_id (recipient_id),
    INDEX idx_sent_at (sent_at),
    INDEX idx_conversation (sender_id, recipient_id, sent_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- ADDITIONAL PERFORMANCE INDEXES
-- =====================================================

-- Composite index for property search by location and price
CREATE INDEX idx_property_location_price 
    ON Property(location_id, pricepernight);

-- Composite index for booking availability checks
CREATE INDEX idx_booking_availability 
    ON Booking(property_id, status, start_date, end_date);

-- Composite index for user's booking history
CREATE INDEX idx_user_bookings 
    ON Booking(user_id, created_at DESC);

-- Index for property average rating queries
CREATE INDEX idx_property_ratings 
    ON Review(property_id, rating);

-- =====================================================
-- VIEWS FOR COMMON QUERIES (Optional but useful)
-- =====================================================

-- View for property listings with location details
CREATE OR REPLACE VIEW vw_property_listings AS
SELECT 
    p.property_id,
    p.name,
    p.description,
    p.pricepernight,
    u.first_name AS host_first_name,
    u.last_name AS host_last_name,
    u.email AS host_email,
    l.street_address,
    l.city,
    l.state,
    l.country,
    l.postal_code,
    p.created_at,
    p.updated_at
FROM Property p
INNER JOIN User u ON p.host_id = u.user_id
INNER JOIN Location l ON p.location_id = l.location_id;

-- View for booking details with property and user info
CREATE OR REPLACE VIEW vw_booking_details AS
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    p.name AS property_name,
    p.pricepernight,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.email AS guest_email,
    CONCAT(host.first_name, ' ', host.last_name) AS host_name,
    host.email AS host_email,
    b.created_at
FROM Booking b
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN User host ON p.host_id = host.user_id;

-- View for property reviews with ratings
CREATE OR REPLACE VIEW vw_property_reviews AS
SELECT 
    r.review_id,
    r.rating,
    r.comment,
    r.created_at,
    p.property_id,
    p.name AS property_name,
    CONCAT(u.first_name, ' ', u.last_name) AS reviewer_name
FROM Review r
INNER JOIN Property p ON r.property_id = p.property_id
INNER JOIN User u ON r.user_id = u.user_id;

-- =====================================================
-- TRIGGERS FOR DATA INTEGRITY (Optional)
-- =====================================================

-- Trigger to update Property.updated_at on changes
DELIMITER //

CREATE TRIGGER trg_property_before_update
BEFORE UPDATE ON Property
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END//

-- Trigger to validate booking dates don't overlap
CREATE TRIGGER trg_booking_before_insert
BEFORE INSERT ON Booking
FOR EACH ROW
BEGIN
    DECLARE overlap_count INT;
    
    SELECT COUNT(*) INTO overlap_count
    FROM Booking
    WHERE property_id = NEW.property_id
      AND status != 'canceled'
      AND (
          (NEW.start_date BETWEEN start_date AND end_date)
          OR (NEW.end_date BETWEEN start_date AND end_date)
          OR (start_date BETWEEN NEW.start_date AND NEW.end_date)
      );
    
    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Booking dates overlap with existing reservation';
    END IF;
END//

DELIMITER ;

-- =====================================================
-- SAMPLE DATA INSERTION (Optional for testing)
-- =====================================================

-- Insert sample users
INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role) 
VALUES 
    (UUID(), 'John', 'Doe', 'john.doe@example.com', '$2y$10$abcdefghijklmnopqrstuv', '+1234567890', 'guest'),
    (UUID(), 'Jane', 'Smith', 'jane.smith@example.com', '$2y$10$abcdefghijklmnopqrstuv', '+1234567891', 'host'),
    (UUID(), 'Admin', 'User', 'admin@airbnb.com', '$2y$10$abcdefghijklmnopqrstuv', '+1234567892', 'admin');

-- Note: Additional sample data can be added for testing purposes

-- =====================================================
-- GRANTS AND PERMISSIONS (Adjust based on your setup)
-- =====================================================

-- Example: Grant permissions to application user
-- GRANT SELECT, INSERT, UPDATE, DELETE ON airbnb.* TO 'airbnb_app'@'localhost';
-- FLUSH PRIVILEGES;

-- =====================================================
-- END OF SCHEMA
-- =====================================================
