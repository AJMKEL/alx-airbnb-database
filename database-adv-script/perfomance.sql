-- ALX Airbnb Database - Query Optimization
-- This file contains initial and optimized queries for performance comparison

-- =====================================================
-- INITIAL QUERY (UNOPTIMIZED)
-- =====================================================
-- Query to retrieve all bookings with user, property, and payment details
-- This is the baseline query before optimization

EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price AS booking_price,
    b.status AS booking_status,
    b.created_at AS booking_created_at,
    
    -- User details
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at AS user_created_at,
    
    -- Property details
    p.property_id,
    p.name AS property_name,
    p.description AS property_description,
    p.location AS property_location,
    p.pricepernight,
    p.created_at AS property_created_at,
    p.updated_at AS property_updated_at,
    
    -- Host details (from User table)
    h.user_id AS host_id,
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    h.email AS host_email,
    h.phone_number AS host_phone,
    
    -- Payment details
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_date,
    pay.payment_method
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
INNER JOIN 
    User h ON p.host_id = h.user_id
LEFT JOIN 
    Payment pay ON b.booking_id = pay.booking_id
ORDER BY 
    b.created_at DESC;


-- =====================================================
-- PERFORMANCE ANALYSIS OF INITIAL QUERY
-- =====================================================
-- Issues identified:
-- 1. Retrieving ALL columns from ALL tables (SELECT *)
-- 2. Multiple JOINs without proper filtering
-- 3. Unnecessary columns that may not be needed
-- 4. No LIMIT clause - retrieves all bookings
-- 5. Sorting entire result set without pagination
-- 6. Redundant User table join for host details


-- =====================================================
-- OPTIMIZED QUERY VERSION 1
-- =====================================================
-- Improvements:
-- - Select only necessary columns
-- - Add WHERE clause to filter relevant data
-- - Add LIMIT for pagination
-- - Ensure indexes are used effectively

EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    -- Essential user details only
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    
    -- Essential property details only
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    
    -- Essential host details only
    h.user_id AS host_id,
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    
    -- Payment details
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_method
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
INNER JOIN 
    User h ON p.host_id = h.user_id
LEFT JOIN 
    Payment pay ON b.booking_id = pay.booking_id
WHERE 
    b.status = 'confirmed'
    AND b.start_date >= CURRENT_DATE
ORDER BY 
    b.start_date ASC
LIMIT 100;


-- =====================================================
-- OPTIMIZED QUERY VERSION 2
-- =====================================================
-- Further improvements:
-- - Use covering indexes where possible
-- - Reduce columns to absolute minimum
-- - Add more specific filtering
-- - Consider using subquery for payment (if optional)

EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    -- User info
    CONCAT(u.first_name, ' ', u.last_name) AS user_name,
    u.email AS user_email,
    
    -- Property info
    p.name AS property_name,
    p.location AS property_location,
    
    -- Host info
    CONCAT(h.first_name, ' ', h.last_name) AS host_name,
    
    -- Payment info (only if exists)
    pay.amount AS payment_amount,
    pay.payment_method
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
INNER JOIN 
    User h ON p.host_id = h.user_id
LEFT JOIN 
    Payment pay ON b.booking_id = pay.booking_id
WHERE 
    b.status IN ('confirmed', 'pending')
    AND b.start_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)
ORDER BY 
    b.start_date ASC
LIMIT 50;


-- =====================================================
-- OPTIMIZED QUERY VERSION 3 - Using Subquery for Payments
-- =====================================================
-- Alternative approach: Use correlated subquery for payment
-- This can be more efficient if payments are sparse

EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    u.first_name AS user_first_name,
    u.last_name AS user_last_name,
    u.email AS user_email,
    
    p.name AS property_name,
    p.location AS property_location,
    
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    
    -- Get payment details via subquery
    (SELECT pay.amount 
     FROM Payment pay 
     WHERE pay.booking_id = b.booking_id 
     LIMIT 1) AS payment_amount,
    
    (SELECT pay.payment_method 
     FROM Payment pay 
     WHERE pay.booking_id = b.booking_id 
     LIMIT 1) AS payment_method
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
INNER JOIN 
    User h ON p.host_id = h.user_id
WHERE 
    b.status = 'confirmed'
    AND b.start_date >= CURRENT_DATE
ORDER BY 
    b.start_date ASC
LIMIT 50;


-- =====================================================
-- OPTIMIZED QUERY VERSION 4 - Indexed Columns Only
-- =====================================================
-- Most efficient: Only use indexed columns in WHERE and JOIN
-- Minimize data retrieval

EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.total_price,
    b.status,
    u.email,
    p.name,
    p.location
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
WHERE 
    b.status = 'confirmed'
    AND b.start_date >= '2024-12-01'
    AND b.start_date <= '2024-12-31'
ORDER BY 
    b.start_date ASC
LIMIT 100;


-- =====================================================
-- QUERY WITH PAGINATION (Best Practice)
-- =====================================================
-- Efficient pagination using OFFSET and LIMIT
-- This is the recommended approach for production

EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    u.user_id,
    u.first_name AS user_first_name,
    u.last_name AS user_last_name,
    u.email AS user_email,
    
    p.property_id,
    p.name AS property_name,
    p.location AS property_location,
    p.pricepernight,
    
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    
    pay.amount AS payment_amount,
    pay.payment_method
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
INNER JOIN 
    User h ON p.host_id = h.user_id
LEFT JOIN 
    Payment pay ON b.booking_id = pay.booking_id
WHERE 
    b.status = 'confirmed'
ORDER BY 
    b.booking_id DESC
LIMIT 20 OFFSET 0;  -- Change OFFSET for different pages


-- =====================================================
-- QUERY WITH SPECIFIC FILTERS (Production Use Case)
-- =====================================================
-- Real-world scenario: Get bookings for a specific user

EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    p.name AS property_name,
    p.location AS property_location,
    
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    h.email AS host_email,
    
    pay.amount AS payment_amount,
    pay.payment_method,
    pay.payment_date
FROM 
    Booking b
INNER JOIN 
    Property p ON b.property_id = p.property_id
INNER JOIN 
    User h ON p.host_id = h.user_id
LEFT JOIN 
    Payment pay ON b.booking_id = pay.booking_id
WHERE 
    b.user_id = 12345  -- Specific user
    AND b.status IN ('confirmed', 'completed')
ORDER BY 
    b.start_date DESC
LIMIT 50;


-- =====================================================
-- AGGREGATE QUERY - Booking Summary
-- =====================================================
-- Efficient aggregation with proper grouping

EXPLAIN ANALYZE
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_revenue,
    AVG(b.total_price) AS avg_booking_price,
    COUNT(DISTINCT b.user_id) AS unique_customers
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id 
    AND b.status = 'confirmed'
GROUP BY 
    p.property_id,
    p.name,
    p.location
HAVING 
    COUNT(b.booking_id) > 0
ORDER BY 
    total_revenue DESC
LIMIT 20;


-- =====================================================
-- COMPARISON: Simple vs Complex Query
-- =====================================================

-- Simple query (fast)
EXPLAIN ANALYZE
SELECT booking_id, user_id, property_id, start_date, status
FROM Booking
WHERE status = 'confirmed'
  AND start_date >= CURRENT_DATE
LIMIT 100;

-- Complex query (slower but more informative)
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    u.email,
    p.name,
    b.start_date,
    b.status
FROM Booking b
JOIN User u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
WHERE b.status = 'confirmed'
  AND b.start_date >= CURRENT_DATE
LIMIT 100;


-- =====================================================
-- INDEXES TO SUPPORT OPTIMIZED QUERIES
-- =====================================================
-- Ensure these indexes exist for optimal performance

-- Already created in database_index.sql, but listed here for reference:
-- CREATE INDEX idx_booking_user_id ON Booking(user_id);
-- CREATE INDEX idx_booking_property_id ON Booking(property_id);
-- CREATE INDEX idx_booking_status ON Booking(status);
-- CREATE INDEX idx_booking_start_date ON Booking(start_date);
-- CREATE INDEX idx_booking_status_start ON Booking(status, start_date);
-- CREATE INDEX idx_property_host_id ON Property(host_id);
-- CREATE INDEX idx_payment_booking_id ON Payment(booking_id);


-- =====================================================
-- PERFORMANCE TESTING SCRIPT
-- =====================================================
-- Run this to compare execution times

-- Enable timing
SET profiling = 1;

-- Run initial query
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.first_name,
    u.last_name,
    u.email,
    p.name AS property_name,
    p.location,
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    pay.amount AS payment_amount,
    pay.payment_method
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
ORDER BY b.created_at DESC;

-- Run optimized query
SELECT 
    b.booking_id,
    b.start_date,
    b.total_price,
    b.status,
    u.email,
    p.name,
    p.location
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
WHERE b.status = 'confirmed'
  AND b.start_date >= CURRENT_DATE
LIMIT 100;

-- View profiling results
SHOW PROFILES;

-- Get detailed profile for a specific query
-- SHOW PROFILE FOR QUERY 1;
-- SHOW PROFILE FOR QUERY 2;


-- =====================================================
-- NOTES ON OPTIMIZATION TECHNIQUES
-- =====================================================

/*
KEY OPTIMIZATION STRATEGIES APPLIED:

1. REDUCE COLUMNS SELECTED
   - Only select columns actually needed
   - Avoid SELECT *
   - Reduce data transfer overhead

2. ADD PROPER FILTERING
   - Use WHERE clauses to filter early
   - Filter on indexed columns
   - Reduce rows processed

3. USE APPROPRIATE JOINS
   - INNER JOIN when relationship is required
   - LEFT JOIN when relationship is optional
   - Avoid unnecessary joins

4. IMPLEMENT PAGINATION
   - Use LIMIT to restrict result set
   - Use OFFSET for pagination
   - Don't retrieve all rows at once

5. LEVERAGE INDEXES
   - Ensure foreign keys are indexed
   - Index columns used in WHERE
   - Index columns used in ORDER BY
   - Use composite indexes for multi-column filters

6. OPTIMIZE JOIN ORDER
   - Join smallest tables first
   - Let optimizer choose best order
   - Use STRAIGHT_JOIN only when necessary

7. AVOID SUBQUERIES IN SELECT
   - Use JOINs instead when possible
   - Consider derived tables
   - Use EXISTS instead of IN for large datasets

8. USE QUERY CACHE (if enabled)
   - Identical queries return cached results
   - Useful for frequently run queries
   - Clear cache after data updates

9. ANALYZE EXECUTION PLAN
   - Use EXPLAIN ANALYZE
   - Check for full table scans
   - Verify index usage
   - Look for filesort and temporary tables

10. MONITOR AND ITERATE
    - Measure actual performance
    - Test with production data volumes
    - Adjust based on real usage patterns
*/
