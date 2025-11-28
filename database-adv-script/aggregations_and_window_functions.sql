-- ALX Airbnb Database - Aggregations and Window Functions
-- This file demonstrates SQL aggregation functions and window functions for data analysis

-- =====================================================
-- 1. AGGREGATION: Total Number of Bookings per User
-- =====================================================
-- This query counts the total bookings made by each user
-- Uses COUNT function with GROUP BY to aggregate data

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings
FROM 
    User u
LEFT JOIN 
    Booking b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, 
    u.first_name, 
    u.last_name, 
    u.email
ORDER BY 
    total_bookings DESC, 
    u.user_id;


-- =====================================================
-- Enhanced version: Include additional booking statistics
-- =====================================================
-- This version provides more comprehensive booking analytics per user

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings,
    SUM(CASE WHEN b.status = 'confirmed' THEN 1 ELSE 0 END) AS confirmed_bookings,
    SUM(CASE WHEN b.status = 'canceled' THEN 1 ELSE 0 END) AS canceled_bookings,
    COALESCE(SUM(b.total_price), 0) AS total_spent,
    COALESCE(AVG(b.total_price), 0) AS avg_booking_value,
    MIN(b.start_date) AS first_booking_date,
    MAX(b.start_date) AS last_booking_date
FROM 
    User u
LEFT JOIN 
    Booking b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, 
    u.first_name, 
    u.last_name, 
    u.email
ORDER BY 
    total_bookings DESC, 
    total_spent DESC;


-- =====================================================
-- 2. WINDOW FUNCTION: Rank Properties by Total Bookings
-- =====================================================
-- Using ROW_NUMBER() to assign unique sequential ranks

SELECT 
    property_id,
    property_name,
    total_bookings,
    ROW_NUMBER() OVER (ORDER BY total_bookings DESC) AS row_num_rank
FROM (
    SELECT 
        p.property_id,
        p.name AS property_name,
        COUNT(b.booking_id) AS total_bookings
    FROM 
        Property p
    LEFT JOIN 
        Booking b ON p.property_id = b.property_id
    GROUP BY 
        p.property_id, 
        p.name
) AS property_booking_counts
ORDER BY 
    row_num_rank;


-- =====================================================
-- Using RANK() to assign ranks (with gaps for ties)
-- =====================================================
-- RANK() gives the same rank to properties with equal bookings
-- and skips the next rank(s) accordingly

SELECT 
    property_id,
    property_name,
    total_bookings,
    RANK() OVER (ORDER BY total_bookings DESC) AS booking_rank
FROM (
    SELECT 
        p.property_id,
        p.name AS property_name,
        COUNT(b.booking_id) AS total_bookings
    FROM 
        Property p
    LEFT JOIN 
        Booking b ON p.property_id = b.property_id
    GROUP BY 
        p.property_id, 
        p.name
) AS property_booking_counts
ORDER BY 
    booking_rank;


-- =====================================================
-- Using DENSE_RANK() to assign ranks (no gaps for ties)
-- =====================================================
-- DENSE_RANK() gives consecutive ranks even when there are ties

SELECT 
    property_id,
    property_name,
    total_bookings,
    DENSE_RANK() OVER (ORDER BY total_bookings DESC) AS dense_rank
FROM (
    SELECT 
        p.property_id,
        p.name AS property_name,
        COUNT(b.booking_id) AS total_bookings
    FROM 
        Property p
    LEFT JOIN 
        Booking b ON p.property_id = b.property_id
    GROUP BY 
        p.property_id, 
        p.name
) AS property_booking_counts
ORDER BY 
    dense_rank;


-- =====================================================
-- Comprehensive Ranking with Multiple Metrics
-- =====================================================
-- This query ranks properties by bookings and includes additional analytics

SELECT 
    property_id,
    property_name,
    location,
    total_bookings,
    total_revenue,
    avg_booking_value,
    ROW_NUMBER() OVER (ORDER BY total_bookings DESC) AS booking_rank,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
    DENSE_RANK() OVER (ORDER BY avg_booking_value DESC) AS avg_value_rank
FROM (
    SELECT 
        p.property_id,
        p.name AS property_name,
        p.location,
        COUNT(b.booking_id) AS total_bookings,
        COALESCE(SUM(b.total_price), 0) AS total_revenue,
        COALESCE(AVG(b.total_price), 0) AS avg_booking_value
    FROM 
        Property p
    LEFT JOIN 
        Booking b ON p.property_id = b.property_id
    GROUP BY 
        p.property_id, 
        p.name,
        p.location
) AS property_metrics
ORDER BY 
    booking_rank;


-- =====================================================
-- BONUS: Advanced Window Functions Examples
-- =====================================================

-- Example 1: Running total of bookings by user over time
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    b.booking_id,
    b.start_date,
    b.total_price,
    SUM(b.total_price) OVER (
        PARTITION BY u.user_id 
        ORDER BY b.start_date
    ) AS running_total_spent
FROM 
    User u
INNER JOIN 
    Booking b ON u.user_id = b.user_id
ORDER BY 
    u.user_id, 
    b.start_date;


-- Example 2: Percentile ranking of properties by booking count
SELECT 
    property_id,
    property_name,
    total_bookings,
    PERCENT_RANK() OVER (ORDER BY total_bookings) AS percentile_rank,
    NTILE(4) OVER (ORDER BY total_bookings DESC) AS quartile
FROM (
    SELECT 
        p.property_id,
        p.name AS property_name,
        COUNT(b.booking_id) AS total_bookings
    FROM 
        Property p
    LEFT JOIN 
        Booking b ON p.property_id = b.property_id
    GROUP BY 
        p.property_id, 
        p.name
) AS property_stats
ORDER BY 
    total_bookings DESC;


-- Example 3: Compare each property's bookings to location average
SELECT 
    property_id,
    property_name,
    location,
    total_bookings,
    AVG(total_bookings) OVER (PARTITION BY location) AS location_avg_bookings,
    total_bookings - AVG(total_bookings) OVER (PARTITION BY location) AS difference_from_avg
FROM (
    SELECT 
        p.property_id,
        p.name AS property_name,
        p.location,
        COUNT(b.booking_id) AS total_bookings
    FROM 
        Property p
    LEFT JOIN 
        Booking b ON p.property_id = b.property_id
    GROUP BY 
        p.property_id, 
        p.name,
        p.location
) AS property_location_stats
ORDER BY 
    location, 
    total_bookings DESC;


-- Example 4: Find top 3 properties per location
SELECT 
    property_id,
    property_name,
    location,
    total_bookings,
    location_rank
FROM (
    SELECT 
        p.property_id,
        p.name AS property_name,
        p.location,
        COUNT(b.booking_id) AS total_bookings,
        ROW_NUMBER() OVER (
            PARTITION BY p.location 
            ORDER BY COUNT(b.booking_id) DESC
        ) AS location_rank
    FROM 
        Property p
    LEFT JOIN 
        Booking b ON p.property_id = b.property_id
    GROUP BY 
        p.property_id, 
        p.name,
        p.location
) AS ranked_properties
WHERE 
    location_rank <= 3
ORDER BY 
    location, 
    location_rank;


-- Example 5: Moving average of bookings
SELECT 
    booking_month,
    monthly_bookings,
    AVG(monthly_bookings) OVER (
        ORDER BY booking_month 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS three_month_moving_avg
FROM (
    SELECT 
        DATE_FORMAT(start_date, '%Y-%m') AS booking_month,
        COUNT(*) AS monthly_bookings
    FROM 
        Booking
    GROUP BY 
        DATE_FORMAT(start_date, '%Y-%m')
) AS monthly_stats
ORDER BY 
    booking_month;


-- Example 6: Lag and Lead functions for trend analysis
SELECT 
    booking_month,
    monthly_bookings,
    LAG(monthly_bookings, 1) OVER (ORDER BY booking_month) AS previous_month,
    LEAD(monthly_bookings, 1) OVER (ORDER BY booking_month) AS next_month,
    monthly_bookings - LAG(monthly_bookings, 1) OVER (ORDER BY booking_month) AS month_over_month_change
FROM (
    SELECT 
        DATE_FORMAT(start_date, '%Y-%m') AS booking_month,
        COUNT(*) AS monthly_bookings
    FROM 
        Booking
    GROUP BY 
        DATE_FORMAT(start_date, '%Y-%m')
) AS monthly_trends
ORDER BY 
    booking_month;
