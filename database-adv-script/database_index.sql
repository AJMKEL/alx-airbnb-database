-- ALX Airbnb Database - Index Creation for Performance Optimization
-- This file contains SQL commands to create indexes on high-usage columns
-- and includes EXPLAIN ANALYZE commands to measure performance improvements

-- =====================================================
-- PERFORMANCE MEASUREMENT - BEFORE INDEXING
-- =====================================================
-- Run these queries BEFORE creating indexes to establish baseline performance

-- Query 1: Find all bookings for a specific user
EXPLAIN ANALYZE
SELECT b.*, p.name, p.location
FROM Booking b
JOIN Property p ON b.property_id = p.property_id
WHERE b.user_id = 12345
ORDER BY b.start_date DESC;

-- Query 2: Search properties by location and price range
EXPLAIN ANALYZE
SELECT * FROM Property
WHERE location = 'New York'
  AND pricepernight BETWEEN 100 AND 300
ORDER BY pricepernight ASC;

-- Query 3: Find properties with average rating > 4.0
EXPLAIN ANALYZE
SELECT p.property_id, p.name, AVG(r.rating) as avg_rating
FROM Property p
JOIN Review r ON p.property_id = r.property_id
GROUP BY p.property_id, p.name
HAVING AVG(r.rating) > 4.0
ORDER BY avg_rating DESC;

-- Query 4: Check property availability for date range
EXPLAIN ANALYZE
SELECT * FROM Booking
WHERE property_id = 789
  AND status = 'confirmed'
  AND start_date <= '2024-12-31'
  AND end_date >= '2024-12-01';

-- Query 5: Find users with more than 3 bookings
EXPLAIN ANALYZE
SELECT u.user_id, u.first_name, u.last_name, COUNT(b.booking_id) as total_bookings
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name
HAVING COUNT(b.booking_id) > 3
ORDER BY total_bookings DESC;


-- =====================================================
-- INDEX STRATEGY OVERVIEW
-- =====================================================
-- Indexes are created based on:
-- 1. Columns frequently used in WHERE clauses
-- 2. Foreign key columns used in JOINs
-- 3. Columns used in ORDER BY clauses
-- 4. Columns used in GROUP BY clauses
-- 5. Columns with high cardinality (many unique values)

-- =====================================================
-- USER TABLE INDEXES
-- =====================================================

-- Index on email for login queries and user lookups
-- Email is frequently used in WHERE clauses and is unique
CREATE INDEX idx_user_email ON User(email);

-- Index on created_at for filtering users by registration date
-- Useful for cohort analysis and temporal queries
CREATE INDEX idx_user_created_at ON User(created_at);

-- Composite index on role and created_at for admin queries
-- Useful for filtering users by role and sorting by date
CREATE INDEX idx_user_role_created ON User(role, created_at);

-- Index on phone_number for contact lookups (if frequently queried)
CREATE INDEX idx_user_phone ON User(phone_number);


-- =====================================================
-- PROPERTY TABLE INDEXES
-- =====================================================

-- Index on host_id for finding all properties by a specific host
-- Critical for JOIN operations with User table
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Index on location for geographic searches
-- Essential for "properties near me" or location-based queries
CREATE INDEX idx_property_location ON Property(location);

-- Index on pricepernight for price range queries
-- Used in WHERE clauses with BETWEEN, <, > operators
CREATE INDEX idx_property_price ON Property(pricepernight);

-- Composite index on location and pricepernight
-- Optimizes queries filtering by both location and price
CREATE INDEX idx_property_location_price ON Property(location, pricepernight);

-- Index on created_at for sorting and filtering new listings
CREATE INDEX idx_property_created_at ON Property(created_at);

-- Full-text index on name and description for search functionality
-- Enables efficient text search across property listings
-- Note: MySQL full-text syntax, adjust for other databases
CREATE FULLTEXT INDEX idx_property_name_description ON Property(name, description);


-- =====================================================
-- BOOKING TABLE INDEXES
-- =====================================================

-- Index on user_id for finding all bookings by a user
-- Critical for JOIN operations and user booking history
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Index on property_id for finding all bookings for a property
-- Critical for property availability and booking history
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Index on start_date for date range queries and availability checks
CREATE INDEX idx_booking_start_date ON Booking(start_date);

-- Index on end_date for date range queries
CREATE INDEX idx_booking_end_date ON Booking(end_date);

-- Composite index on property_id and start_date
-- Optimizes availability queries for specific properties
CREATE INDEX idx_booking_property_start ON Booking(property_id, start_date);

-- Composite index on property_id, start_date, and end_date
-- Critical for checking booking conflicts and availability
CREATE INDEX idx_booking_property_dates ON Booking(property_id, start_date, end_date);

-- Index on status for filtering by booking status
-- Useful for finding confirmed, pending, or canceled bookings
CREATE INDEX idx_booking_status ON Booking(status);

-- Composite index on user_id and status
-- Optimizes queries for user's active/past bookings
CREATE INDEX idx_booking_user_status ON Booking(user_id, status);

-- Composite index on status and start_date
-- Useful for finding upcoming confirmed bookings
CREATE INDEX idx_booking_status_start ON Booking(status, start_date);

-- Index on created_at for sorting bookings by creation time
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- Index on total_price for analytics and revenue queries
CREATE INDEX idx_booking_total_price ON Booking(total_price);


-- =====================================================
-- REVIEW TABLE INDEXES
-- =====================================================

-- Index on property_id for finding all reviews for a property
-- Critical for JOIN operations and review aggregations
CREATE INDEX idx_review_property_id ON Review(property_id);

-- Index on user_id for finding all reviews by a user
CREATE INDEX idx_review_user_id ON Review(user_id);

-- Index on rating for filtering and sorting by rating
-- Useful for finding high/low rated properties
CREATE INDEX idx_review_rating ON Review(rating);

-- Composite index on property_id and rating
-- Optimizes queries for property reviews with specific ratings
CREATE INDEX idx_review_property_rating ON Review(property_id, rating);

-- Index on created_at for sorting reviews by date
CREATE INDEX idx_review_created_at ON Review(created_at);

-- Composite index on property_id and created_at
-- Optimizes queries for recent reviews of a property
CREATE INDEX idx_review_property_created ON Review(property_id, created_at);


-- =====================================================
-- PAYMENT TABLE INDEXES
-- =====================================================

-- Index on booking_id for linking payments to bookings
-- Critical for JOIN operations
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);

-- Index on payment_date for financial reporting
CREATE INDEX idx_payment_date ON Payment(payment_date);

-- Index on payment_method for payment analytics
CREATE INDEX idx_payment_method ON Payment(payment_method);

-- Composite index on payment_date and payment_method
-- Useful for payment trend analysis
CREATE INDEX idx_payment_date_method ON Payment(payment_date, payment_method);


-- =====================================================
-- MESSAGE TABLE INDEXES
-- =====================================================

-- Index on sender_id for finding messages sent by a user
CREATE INDEX idx_message_sender_id ON Message(sender_id);

-- Index on recipient_id for finding messages received by a user
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);

-- Composite index on sender_id and recipient_id
-- Optimizes conversation queries between two users
CREATE INDEX idx_message_sender_recipient ON Message(sender_id, recipient_id);

-- Index on sent_at for sorting messages chronologically
CREATE INDEX idx_message_sent_at ON Message(sent_at);


-- =====================================================
-- PERFORMANCE MEASUREMENT - AFTER INDEXING
-- =====================================================
-- Run these queries AFTER creating indexes to measure improvements
-- Compare the results with the baseline measurements above

-- Query 1: Find all bookings for a specific user (WITH INDEXES)
EXPLAIN ANALYZE
SELECT b.*, p.name, p.location
FROM Booking b
JOIN Property p ON b.property_id = p.property_id
WHERE b.user_id = 12345
ORDER BY b.start_date DESC;

-- Query 2: Search properties by location and price range (WITH INDEXES)
EXPLAIN ANALYZE
SELECT * FROM Property
WHERE location = 'New York'
  AND pricepernight BETWEEN 100 AND 300
ORDER BY pricepernight ASC;

-- Query 3: Find properties with average rating > 4.0 (WITH INDEXES)
EXPLAIN ANALYZE
SELECT p.property_id, p.name, AVG(r.rating) as avg_rating
FROM Property p
JOIN Review r ON p.property_id = r.property_id
GROUP BY p.property_id, p.name
HAVING AVG(r.rating) > 4.0
ORDER BY avg_rating DESC;

-- Query 4: Check property availability for date range (WITH INDEXES)
EXPLAIN ANALYZE
SELECT * FROM Booking
WHERE property_id = 789
  AND status = 'confirmed'
  AND start_date <= '2024-12-31'
  AND end_date >= '2024-12-01';

-- Query 5: Find users with more than 3 bookings (WITH INDEXES)
EXPLAIN ANALYZE
SELECT u.user_id, u.first_name, u.last_name, COUNT(b.booking_id) as total_bookings
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name
HAVING COUNT(b.booking_id) > 3
ORDER BY total_bookings DESC;


-- =====================================================
-- ADDITIONAL PERFORMANCE TESTING QUERIES
-- =====================================================

-- Query 6: Find top-rated properties in a location
EXPLAIN ANALYZE
SELECT p.property_id, p.name, p.location, AVG(r.rating) as avg_rating
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id
WHERE p.location = 'Los Angeles'
GROUP BY p.property_id, p.name, p.location
ORDER BY avg_rating DESC
LIMIT 10;

-- Query 7: Get user booking history with property details
EXPLAIN ANALYZE
SELECT u.user_id, u.first_name, u.last_name, 
       b.booking_id, b.start_date, b.end_date, b.total_price,
       p.name as property_name, p.location
FROM User u
JOIN Booking b ON u.user_id = b.user_id
JOIN Property p ON b.property_id = p.property_id
WHERE u.email = 'user@example.com'
ORDER BY b.start_date DESC;

-- Query 8: Find available properties for specific dates
EXPLAIN ANALYZE
SELECT p.* FROM Property p
WHERE p.location = 'Miami'
  AND p.property_id NOT IN (
    SELECT b.property_id FROM Booking b
    WHERE b.status = 'confirmed'
      AND b.start_date <= '2024-12-31'
      AND b.end_date >= '2024-12-01'
  );

-- Query 9: Revenue analysis by property
EXPLAIN ANALYZE
SELECT p.property_id, p.name, 
       COUNT(b.booking_id) as total_bookings,
       SUM(b.total_price) as total_revenue,
       AVG(b.total_price) as avg_booking_value
FROM Property p
LEFT JOIN Booking b ON p.property_id = b.property_id
WHERE b.status = 'confirmed'
GROUP BY p.property_id, p.name
ORDER BY total_revenue DESC
LIMIT 20;

-- Query 10: Recent reviews for properties
EXPLAIN ANALYZE
SELECT p.property_id, p.name, r.rating, r.comment, r.created_at
FROM Property p
JOIN Review r ON p.property_id = r.property_id
WHERE r.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
ORDER BY r.created_at DESC;


-- =====================================================
-- COMMANDS TO VIEW EXISTING INDEXES
-- =====================================================

-- View all indexes on a specific table (MySQL)
SHOW INDEX FROM User;
SHOW INDEX FROM Property;
SHOW INDEX FROM Booking;
SHOW INDEX FROM Review;

-- View index usage statistics (MySQL 8.0+)
-- SELECT * FROM sys.schema_index_statistics WHERE table_schema = 'your_database_name';

-- View unused indexes (MySQL 8.0+)
-- SELECT * FROM sys.schema_unused_indexes WHERE object_schema = 'your_database_name';


-- =====================================================
-- COMMANDS TO ANALYZE INDEX EFFECTIVENESS
-- =====================================================

-- Check if indexes are being used
EXPLAIN 
SELECT * FROM Booking WHERE user_id = 12345;

-- Analyze query with detailed execution plan
EXPLAIN ANALYZE
SELECT b.*, p.name 
FROM Booking b 
JOIN Property p ON b.property_id = p.property_id 
WHERE b.user_id = 12345;

-- Show query execution profile (MySQL)
-- SET profiling = 1;
-- [Run your query here]
-- SHOW PROFILES;
-- SHOW PROFILE FOR QUERY 1;


-- =====================================================
-- COMMANDS TO DROP INDEXES (IF NEEDED)
-- =====================================================

-- Drop index syntax (use if you need to remove an index)
-- DROP INDEX idx_user_email ON User;
-- DROP INDEX idx_booking_property_dates ON Booking;


-- =====================================================
-- MAINTENANCE COMMANDS
-- =====================================================

-- Analyze tables to update statistics after creating indexes (MySQL)
ANALYZE TABLE User;
ANALYZE TABLE Property;
ANALYZE TABLE Booking;
ANALYZE TABLE Review;

-- Optimize tables to reorganize data and indexes (MySQL)
-- OPTIMIZE TABLE User;
-- OPTIMIZE TABLE Property;
-- OPTIMIZE TABLE Booking;
-- OPTIMIZE TABLE Review;


-- =====================================================
-- MONITORING QUERIES FOR INDEX PERFORMANCE
-- =====================================================

-- Monitor table and index sizes
SELECT 
    table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "Size (MB)",
    ROUND((index_length / 1024 / 1024), 2) AS "Index Size (MB)"
FROM information_schema.TABLES
WHERE table_schema = DATABASE()
ORDER BY (data_length + index_length) DESC;

-- Check index cardinality (uniqueness)
SELECT 
    table_name,
    index_name,
    cardinality,
    seq_in_index,
    column_name
FROM information_schema.STATISTICS
WHERE table_schema = DATABASE()
ORDER BY table_name, index_name, seq_in_index;


-- =====================================================
-- NOTES AND BEST PRACTICES
-- =====================================================

/*
USING EXPLAIN ANALYZE:
- EXPLAIN shows the query execution plan (what the optimizer intends to do)
- EXPLAIN ANALYZE actually runs the query and shows real execution statistics
- Compare execution time, rows examined, and access types before/after indexing

KEY METRICS TO MONITOR:
1. Execution Time: Total time to run the query
2. Rows Examined: Number of rows scanned (lower is better)
3. Access Type: 
   - ALL = full table scan (bad, needs index)
   - index = full index scan (acceptable)
   - range = index range scan (good)
   - ref = index lookup (very good)
   - const = single row lookup (excellent)
4. Key Used: Which index was used (NULL means no index)
5. Extra: Additional information (Using filesort, Using temporary, etc.)

INDEX SELECTION CRITERIA:
1. Columns used in WHERE clauses (high priority)
2. Foreign key columns used in JOINs (critical)
3. Columns used in ORDER BY (important for sorting)
4. Columns used in GROUP BY (important for aggregations)
5. Columns with high cardinality (many unique values)

COMPOSITE INDEX GUIDELINES:
- Most selective column should be first
- Consider query patterns when ordering columns
- Left-prefix rule: queries can use left portion of composite index
- Example: Index on (location, pricepernight) can be used for:
  * WHERE location = 'X' AND pricepernight = Y (both columns)
  * WHERE location = 'X' (first column only)
  * But NOT for: WHERE pricepernight = Y (skips first column)

AVOID OVER-INDEXING:
- Each index adds overhead to INSERT, UPDATE, DELETE
- Monitor index usage and remove unused indexes
- Balance read performance vs write performance
- For heavy write workloads, fewer indexes may be better

MAINTENANCE:
- Rebuild fragmented indexes periodically
- Update statistics after bulk operations
- Monitor index size and growth
- Consider covering indexes for frequently used queries
- Use ANALYZE TABLE regularly to update statistics
*/
