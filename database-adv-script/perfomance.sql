-- ============================================
-- File: database-adv-script/perfomance.sql
-- Goal: Retrieve all bookings with user, property,
--       and payment details, analyze & optimize.
-- ============================================

/* =========================================================
   SECTION A — Initial (unoptimized) query
   Notes:
   - SELECT * pulls wide text columns unnecessarily
   - No explicit ordering/pagination
   - Uses INNER JOIN to Payment (drops unpaid bookings)
   - Ambiguous column names (hard to read / maintain)
   ========================================================= */
-- INITIAL (BASELINE) QUERY
SELECT
  *
FROM Booking b
JOIN `User` u
  ON b.user_id = u.user_id
JOIN Property p
  ON b.property_id = p.property_id
JOIN Payment pay
  ON pay.booking_id = b.booking_id;


/* =========================================================
   SECTION B — EXPLAIN baseline
   (Run this in MySQL 8.0+ to get the plan & timing)
   ========================================================= */
EXPLAIN ANALYZE
SELECT
  *
FROM Booking b
JOIN `User` u
  ON b.user_id = u.user_id
JOIN Property p
  ON b.property_id = p.property_id
JOIN Payment pay
  ON pay.booking_id = b.booking_id;


/* =========================================================
   SECTION C — Refactored (optimized) query
   Improvements:
   - Project only needed columns (avoids wide rows)
   - LEFT JOIN Payment to keep unpaid bookings
   - Stable ORDER BY for deterministic results
   - Optional WHERE/LIMIT for paging (uncomment as needed)
   - Works well with indexes created in database_index.sql:
       Booking(user_id), Booking(property_id),
       Payment(booking_id), Property(host_id), etc.
   ========================================================= */
-- OPTIMIZED QUERY
SELECT
  b.booking_id,
  b.property_id,
  b.user_id,
  b.start_date,
  b.end_date,
  b.status,
  u.first_name,
  u.last_name,
  u.email,
  p.name         AS property_name,   -- use p.title if your column is 'title'
  p.location,
  p.pricepernight,
  pay.payment_id,
  pay.amount     AS payment_amount,
  pay.payment_method,
  pay.payment_date
FROM Booking AS b
JOIN `User` AS u
  ON u.user_id = b.user_id
JOIN Property AS p
  ON p.property_id = b.property_id
LEFT JOIN Payment AS pay
  ON pay.booking_id = b.booking_id
-- Optional filters to support index usage and reduce scanned rows:
-- WHERE b.created_at >= '2025-01-01'
ORDER BY b.booking_id ASC
-- LIMIT 200
;


/* =========================================================
   SECTION D — EXPLAIN optimized
   ========================================================= */
EXPLAIN ANALYZE
SELECT
  b.booking_id,
  b.property_id,
  b.user_id,
  b.start_date,
  b.end_date,
  b.status,
  u.first_name,
  u.last_name,
  u.email,
  p.name         AS property_name,   -- or p.title
  p.location,
  p.pricepernight,
  pay.payment_id,
  pay.amount     AS payment_amount,
  pay.payment_method,
  pay.payment_date
FROM Booking AS b
JOIN `User` AS u
  ON u.user_id = b.user_id
JOIN Property AS p
  ON p.property_id = b.property_id
LEFT JOIN Payment AS pay
  ON pay.booking_id = b.booking_id
ORDER BY b.booking_id ASC;
