# Optimization Report – Complex Booking Query

## 🎯 Objective
Refactor a complex query that retrieves **bookings + user + property + payment** details, analyze performance with `EXPLAIN`/`EXPLAIN ANALYZE`, and reduce execution time.

---

## 1) Initial (Baseline) Query

```sql
SELECT
  *
FROM Booking b
JOIN `User` u
  ON b.user_id = u.user_id
JOIN Property p
  ON b.property_id = p.property_id
JOIN Payment pay
  ON pay.booking_id = b.booking_id;
Issues Identified
SELECT * pulls unnecessary large columns (e.g., long description text), increasing I/O and network cost.

INNER JOIN to Payment excludes unpaid bookings (unintended data loss).

No ORDER/LIMIT – results are large and non-deterministic; can trigger filesort on big outputs.

Reads can’t fully leverage covering indexes.

2) Baseline Plan (EXPLAIN)
Run:

sql
Copy code
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
What to Look For
type: ALL or rows very high → full scans.

key: NULL → no index chosen.

filesort / Using temporary → expensive sort/spill.

High time in nested loop steps.

If you see full scans on Booking, User, Property, or Payment, ensure the indexes from database_index.sql exist and are used:

Booking(user_id), Booking(property_id), Booking(booking_id) (PK)

Payment(booking_id)

Property(property_id) (PK)

User(user_id) (PK)

3) Refactored (Optimized) Query
sql
Copy code
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
  p.name         AS property_name,   -- use p.title if your schema uses 'title'
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
Why This Is Faster
Column projection (no SELECT *): returns only needed fields, reduces row size and transfer time.

LEFT JOIN Payment: keeps unpaid bookings while not forcing an unnecessary match.

ORDER BY b.booking_id: aligns with PK order for stable, predictable output and efficient ordering.

Index synergy: joins map cleanly to PK/FK indexes:

b.user_id → User(user_id) (PK)

b.property_id → Property(property_id) (PK)

pay.booking_id → Payment(booking_id) (FK index)

If you frequently filter/paginate, add WHERE b.created_at >= ? + LIMIT ? and ensure Booking(created_at) or a composite (e.g., (user_id, created_at)) exists.

4) Expected EXPLAIN Improvements
type should be ref/eq_ref on joins (not ALL).

key shows the correct FK/PK or secondary index for each table.

Lower rows estimates.

EXPLAIN ANALYZE total time reduced vs. baseline.

Example (illustrative, replace with your actual output):

Step	Before (ms)	After (ms)	Notes
Read Booking	85	8	Using PK order & fewer columns
Join User	60	5	eq_ref on PK
Join Property	70	6	eq_ref on PK
Join Payment	50	4	ref on booking_id
Total	265	23	~91% faster (sample numbers)

5) Index Checklist (from database_index.sql)
Make sure these exist (or create them):

sql
Copy code
-- Booking
CREATE INDEX idx_booking_user_id        ON `Booking`(user_id);
CREATE INDEX idx_booking_property_id    ON `Booking`(property_id);
CREATE INDEX idx_booking_user_created   ON `Booking`(user_id, created_at);

-- Payment
CREATE INDEX idx_payment_booking_id     ON `Payment`(booking_id);

-- Property
CREATE INDEX idx_property_host_id       ON `Property`(host_id);
CREATE INDEX idx_property_location      ON `Property`(location);
CREATE INDEX idx_property_price         ON `Property`(pricepernight);

-- User
CREATE INDEX idx_user_email             ON `User`(email);
CREATE INDEX idx_user_role              ON `User`(role);
CREATE INDEX idx_user_created_at        ON `User`(created_at);
6) How to Reproduce
Run baseline in perfomance.sql (Section A) with EXPLAIN ANALYZE.

Apply/verify indexes (SHOW INDEX FROM …).

Run optimized query with EXPLAIN ANALYZE.

Record timings and plans; paste them back into the table above.

7) Conclusion
By narrowing projected columns, choosing correct join types, ordering by PK, and ensuring the right indexes, the complex bookings query becomes much faster and more reliable under load. Keep monitoring with EXPLAIN ANALYZE as data grows and query patterns evolve.