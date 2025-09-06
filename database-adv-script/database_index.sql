-- ============================================
-- Database: alx-airbnb-database
-- File: database_index.sql
-- Purpose: Create indexes for high-usage columns
-- NOTE: Use backticks to avoid reserved-word issues (e.g., `User`)
-- ============================================

/* =========================
   USERS
   Common usage:
   - WHERE email = ? (login lookups)
   - WHERE role = ? (admin/host filters)
   - ORDER BY created_at DESC (recent users)
   ========================= */
CREATE INDEX idx_user_email        ON `User`(email);
CREATE INDEX idx_user_role         ON `User`(role);
CREATE INDEX idx_user_created_at   ON `User`(created_at);

/* Optional (MySQL 5.6+/8.0+): full-text search on name fields/description-like fields
   Uncomment only if you actually run text search:
-- CREATE FULLTEXT INDEX ft_user_name ON `User`(first_name, last_name);
*/

/* =========================
   PROPERTIES
   Common usage:
   - JOIN Booking ON property_id
   - WHERE host_id = ? (listings by host)
   - WHERE location = ? (search by city/area)
   - ORDER BY pricepernight (sort by price)
   - Availability searches often combine property_id + date range
   ========================= */
-- PK on property_id already indexed by definition; add selective secondaries:
CREATE INDEX idx_property_host_id      ON `Property`(host_id);
CREATE INDEX idx_property_location     ON `Property`(location);
CREATE INDEX idx_property_price        ON `Property`(pricepernight);

-- Optional text search:
-- CREATE FULLTEXT INDEX ft_property_text ON `Property`(name, description);

/* =========================
   BOOKINGS
   Common usage:
   - JOIN User/Property on FKs
   - WHERE user_id = ? (a user's trips)
   - WHERE property_id = ? (property’s bookings)
   - Availability window checks by date range
   - WHERE status IN (...)
   ========================= */
CREATE INDEX idx_booking_user_id       ON `Booking`(user_id);
CREATE INDEX idx_booking_property_id   ON `Booking`(property_id);
CREATE INDEX idx_booking_status        ON `Booking`(status);

-- Composite indexes for typical predicates:
-- 1) Availability search on a property within a date range
--    Order columns by filtering selectivity, then sort/inequality
CREATE INDEX idx_booking_prop_start_end ON `Booking`(property_id, start_date, end_date);

-- 2) A user’s bookings by most recent
CREATE INDEX idx_booking_user_created ON `Booking`(user_id, created_at);

/* =========================
   PAYMENTS, REVIEWS, MESSAGES
   (not requested, but commonly needed)
   ========================= */
-- CREATE INDEX idx_payment_booking_id ON `Payment`(booking_id);
-- CREATE INDEX idx_review_property_id ON `Review`(property_id);
-- CREATE INDEX idx_review_user_id     ON `Review`(user_id);
-- CREATE INDEX idx_message_sender     ON `Message`(sender_id);
-- CREATE INDEX idx_message_recipient  ON `Message`(recipient_id);

-- =========================
-- VERIFY
-- =========================
-- SHOW INDEX FROM `User`;
-- SHOW INDEX FROM `Property`;
-- SHOW INDEX FROM `Booking`;
