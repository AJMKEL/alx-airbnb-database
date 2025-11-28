-- ALX Airbnb Database - Subqueries Practice
-- This file demonstrates both correlated and non-correlated subqueries

-- =====================================================
-- 1. NON-CORRELATED SUBQUERY: Properties with Average Rating > 4.0
-- =====================================================
-- This query finds all properties where the average rating exceeds 4.0
-- The subquery is executed once and returns a list of property_ids
-- The outer query then retrieves full property details for those IDs

SELECT 
    property_id,
    name AS property_name,
    location,
    pricepernight,
    description
FROM 
    Property
WHERE 
    property_id IN (
        SELECT 
            property_id
        FROM 
            Review
        GROUP BY 
            property_id
        HAVING 
            AVG(rating) > 4.0
    )
ORDER BY 
    property_id;


-- =====================================================
-- Alternative approach: Using JOIN with subquery
-- =====================================================
-- This version also includes the actual average rating in results

SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    p.description,
    avg_ratings.avg_rating
FROM 
    Property p
INNER JOIN (
    SELECT 
        property_id,
        AVG(rating) AS avg_rating
    FROM 
        Review
    GROUP BY 
        property_id
    HAVING 
        AVG(rating) > 4.0
) AS avg_ratings ON p.property_id = avg_ratings.property_id
ORDER BY 
    avg_ratings.avg_rating DESC;


-- =====================================================
-- 2. CORRELATED SUBQUERY: Users with More Than 3 Bookings
-- =====================================================
-- This query finds users who have made more than 3 bookings
-- The subquery is executed once for each row in the outer query
-- It correlates with the outer query using the user_id

SELECT 
    user_id,
    first_name,
    last_name,
    email,
    phone_number,
    created_at
FROM 
    User u
WHERE 
    (SELECT 
        COUNT(*) 
     FROM 
        Booking b 
     WHERE 
        b.user_id = u.user_id) > 3
ORDER BY 
    user_id;


-- =====================================================
-- Enhanced version: Including booking count in results
-- =====================================================
-- This version shows how many bookings each user has made

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    (SELECT 
        COUNT(*) 
     FROM 
        Booking b 
     WHERE 
        b.user_id = u.user_id) AS total_bookings,
    u.created_at
FROM 
    User u
WHERE 
    (SELECT 
        COUNT(*) 
     FROM 
        Booking b 
     WHERE 
        b.user_id = u.user_id) > 3
ORDER BY 
    total_bookings DESC, u.user_id;


-- =====================================================
-- BONUS: Additional Subquery Examples
-- =====================================================

-- Example 3: Non-correlated subquery to find properties more expensive than average
SELECT 
    property_id,
    name AS property_name,
    location,
    pricepernight
FROM 
    Property
WHERE 
    pricepernight > (
        SELECT 
            AVG(pricepernight)
        FROM 
            Property
    )
ORDER BY 
    pricepernight DESC;


-- Example 4: Correlated subquery to find properties with above-average ratings
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    (SELECT 
        AVG(r.rating) 
     FROM 
        Review r 
     WHERE 
        r.property_id = p.property_id) AS avg_rating
FROM 
    Property p
WHERE 
    (SELECT 
        AVG(r.rating) 
     FROM 
        Review r 
     WHERE 
        r.property_id = p.property_id) > (
            SELECT 
                AVG(rating) 
            FROM 
                Review
        )
ORDER BY 
    avg_rating DESC;


-- Example 5: Find users who have never made a booking (correlated subquery with NOT EXISTS)
SELECT 
    user_id,
    first_name,
    last_name,
    email,
    created_at
FROM 
    User u
WHERE 
    NOT EXISTS (
        SELECT 
            1 
        FROM 
            Booking b 
        WHERE 
            b.user_id = u.user_id
    )
ORDER BY 
    created_at DESC;


-- Example 6: Find most recent booking for each property (correlated subquery)
SELECT 
    p.property_id,
    p.name AS property_name,
    (SELECT 
        MAX(b.end_date) 
     FROM 
        Booking b 
     WHERE 
        b.property_id = p.property_id) AS last_booking_date,
    (SELECT 
        COUNT(*) 
     FROM 
        Booking b 
     WHERE 
        b.property_id = p.property_id) AS total_bookings
FROM 
    Property p
ORDER BY 
    last_booking_date DESC;
