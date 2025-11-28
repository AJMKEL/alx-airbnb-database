-- ALX Airbnb Database - Complex Queries with Joins
-- This file contains SQL queries demonstrating different types of joins

-- =====================================================
-- 1. INNER JOIN: Retrieve all bookings with respective users
-- =====================================================
-- This query returns only bookings that have associated users
-- It combines data from Booking and User tables where there's a match

SELECT 
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
ORDER BY 
    b.created_at DESC;


-- =====================================================
-- 2. LEFT JOIN: Retrieve all properties and their reviews
-- =====================================================
-- This query returns all properties, including those without reviews
-- Properties with no reviews will have NULL values in review columns

SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_date
FROM 
    Property p
LEFT JOIN 
    Review r ON p.property_id = r.property_id
ORDER BY 
    p.property_id, r.created_at DESC;


-- =====================================================
-- 3. FULL OUTER JOIN: Retrieve all users and all bookings
-- =====================================================
-- This query returns all users and all bookings
-- Users without bookings and bookings without users are included
-- Note: MySQL doesn't support FULL OUTER JOIN directly, so we use UNION

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM 
    User u
LEFT JOIN 
    Booking b ON u.user_id = b.user_id

UNION

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM 
    User u
RIGHT JOIN 
    Booking b ON u.user_id = b.user_id
ORDER BY 
    user_id, booking_id;


-- =====================================================
-- Alternative FULL OUTER JOIN (for databases that support it)
-- =====================================================
-- Use this version if your database supports FULL OUTER JOIN natively
-- (PostgreSQL, Oracle, SQL Server)

/*
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM 
    User u
FULL OUTER JOIN 
    Booking b ON u.user_id = b.user_id
ORDER BY 
    u.user_id, b.booking_id;
*/
