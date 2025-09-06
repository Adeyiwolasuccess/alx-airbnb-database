-- ============================================
-- Database: alx-airbnb-database
-- File: database_index.sql
-- Purpose: Create indexes for high-usage columns
-- and measure performance before/after
-- ============================================

/* =========================
   CREATE INDEXES
   ========================= */

-- User table indexes
CREATE INDEX idx_user_email        ON `User`(email);
CREATE INDEX idx_user_role         ON `User`(role);
CREATE INDEX idx_user_created_at   ON `User`(created_at);

-- Property table indexes
CREATE INDEX idx_property_host_id      ON `Property`(host_id);
CREATE INDEX idx_property_location     ON `Property`(location);
CREATE INDEX idx_property_price        ON `Property`(pricepernight);

-- Booking table indexes
CREATE INDEX idx_booking_user_id       ON `Booking`(user_id);
CREATE INDEX idx_booking_property_id   ON `Booking`(property_id);
CREATE INDEX idx_booking_status        ON `Booking`(status);
CREATE INDEX idx_booking_prop_start_end ON `Booking`(property_id, start_date, end_date);
CREATE INDEX idx_booking_user_created   ON `Booking`(user_id, created_at);

-- ============================================
-- PERFORMANCE MEASUREMENTS
-- Use EXPLAIN ANALYZE to check performance
-- before and after applying indexes
-- ============================================

-- 1) Login lookup by email
EXPLAIN ANALYZE
SELECT user_id, password_hash
FROM `User`
WHERE email = 'alice@example.com';

-- 2) Host’s property listings
EXPLAIN ANALYZE
SELECT property_id, name, location, pricepernight
FROM `Property`
WHERE host_id = 'HOST-UUID-123';

-- 3) Property availability check
EXPLAIN ANALYZE
SELECT booking_id
FROM `Booking`
WHERE property_id = 'PROP-UUID-123'
  AND start_date <= '2025-12-20'
  AND end_date   >= '2025-12-15';

-- 4) User’s bookings sorted by most recent
EXPLAIN ANALYZE
SELECT booking_id, property_id, created_at
FROM `Booking`
WHERE user_id = 'USER-UUID-123'
ORDER BY created_at DESC
LIMIT 20;

-- 5) Property search by location + sorted by price
EXPLAIN ANALYZE
SELECT property_id, name, pricepernight
FROM `Property`
WHERE location = 'Lagos'
ORDER BY pricepernight ASC
LIMIT 20;
