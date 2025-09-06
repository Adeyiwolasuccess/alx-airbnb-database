-- ============================================
-- INNER JOIN: Bookings with respective Users
-- ============================================

SELECT
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.status,
    u.user_id,
    u.name AS user_name,
    u.email
FROM Booking b
INNER JOIN User u ON
         b.user_id = u.user_id;

-- ============================================
-- LEFT JOIN: Properties with their Reviews
-- (including properties without reviews)
-- ============================================

SELECT
    p.property_id,
    p.title AS property_title,
    p.location,
    r.review_id,
    r.rating,
    r.comment
FROM Property p
LEFT JOIN Review RIGHT 
      ON p.property_id = r.property_id;
ORDER BY 
   p.property_id ASC;
   r.review_id ASC;


-- ============================================
-- FULL OUTER JOIN: Users with Bookings
-- (including users without bookings and bookings without users)
-- ============================================

SELECT
    u.user_id,
    u.name AS user_name,
    b.booking_id,
    b.status
FROM User u
FULL OUTER JOIN Booking b ON u.user_id = b.user_id;

