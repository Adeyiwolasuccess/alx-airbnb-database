-- =========================================================
-- SEED DATA FOR ALX AIRBNB DATABASE
-- =========================================================

-- =======================
-- USERS
-- =======================
INSERT INTO User (user_id, name, email, password_hash, created_at)
VALUES
(1, 'Alice Johnson', 'alice@example.com', 'hashedpassword1', NOW()),
(2, 'Bob Smith', 'bob@example.com', 'hashedpassword2', NOW()),
(3, 'Charlie Lee', 'charlie@example.com', 'hashedpassword3', NOW()),
(4, 'Diana Prince', 'diana@example.com', 'hashedpassword4', NOW());

-- =======================
-- PROPERTIES
-- =======================
INSERT INTO Property (property_id, host_id, title, description, location, price_per_night, created_at)
VALUES
(1, 1, 'Cozy Apartment in NYC', 'A modern 2-bedroom apartment in Manhattan', 'New York, USA', 150.00, NOW()),
(2, 2, 'Beach House', 'Oceanfront house with 3 bedrooms and private pool', 'Miami, USA', 300.00, NOW()),
(3, 3, 'Mountain Cabin', 'Rustic cabin in the mountains, perfect for hiking lovers', 'Aspen, USA', 120.00, NOW());

-- =======================
-- BOOKINGS
-- =======================
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, status, created_at)
VALUES
(1, 1, 2, '2025-09-01', '2025-09-05', 'confirmed', NOW()),
(2, 2, 3, '2025-10-10', '2025-10-15', 'pending', NOW()),
(3, 3, 4, '2025-12-20', '2025-12-25', 'canceled', NOW());

-- =======================
-- PAYMENTS
-- =======================
INSERT INTO Payment (payment_id, booking_id, amount, payment_date, status)
VALUES
(1, 1, 600.00, '2025-08-01', 'completed'),
(2, 2, 1500.00, '2025-09-15', 'pending'),
(3, 3, 600.00, '2025-11-30', 'refunded');

-- =======================
-- REVIEWS
-- =======================
INSERT INTO Review (review_id, property_id, user_id, rating, comment, created_at)
VALUES
(1, 1, 2, 5, 'Amazing stay, the host was very friendly!', NOW()),
(2, 2, 3, 4, 'Beautiful house, but a bit pricey.', NOW()),
(3, 3, 4, 3, 'Nice location but not very clean.', NOW());

-- =======================
-- MESSAGES
-- =======================
INSERT INTO Message (message_id, sender_id, recipient_id, content, sent_at)
VALUES
(1, 2, 1, 'Hi Alice, is your apartment available in September?', NOW()),
(2, 1, 2, 'Yes Bob, it is available. You can book directly.', NOW()),
(3, 3, 2, 'Hi Bob, can I get a discount for the beach house?', NOW());
