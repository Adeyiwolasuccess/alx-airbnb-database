-- ============================================
-- 1. Aggregation with COUNT + GROUP BY
-- Find the total number of bookings made by each user
-- ============================================
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    COUNT(b.booking_id) AS total_bookings
FROM User u
LEFT JOIN Booking b
    ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY total_bookings DESC;

-- ============================================
-- 2. Window Function (ROW_NUMBER + RANK)
-- Rank properties based on the total number of bookings
-- ============================================
SELECT 
    p.property_id,
    p.title AS property_name,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS property_rank,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_num
FROM Property p
LEFT JOIN Booking b
    ON p.property_id = b.property_id
GROUP BY p.property_id, p.title
ORDER BY total_bookings DESC;
