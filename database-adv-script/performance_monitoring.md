# Monitor and Refine Database Performance – Airbnb Database

## 🎯 Objective
Continuously monitor and refine database performance by analyzing query execution plans and applying schema adjustments such as indexes and query refactoring.

---

## 🔎 Monitored Queries
We chose five representative, high-frequency queries for profiling:

1. **Login lookup (User by email)**  
   ```sql
   SELECT user_id, password_hash
   FROM `User`
   WHERE email = 'alice@example.com';
User’s bookings (recent first)

sql
Copy code
SELECT booking_id, property_id, start_date, end_date, status, created_at
FROM Booking
WHERE user_id = 'USER-UUID-123'
ORDER BY created_at DESC
LIMIT 20;
Property availability check

sql
Copy code
SELECT booking_id
FROM Booking
WHERE property_id = 'PROP-UUID-123'
  AND start_date <= '2025-12-20'
  AND end_date   >= '2025-12-15';
Complex join: bookings + user + property + payment

sql
Copy code
SELECT b.booking_id, u.first_name, u.last_name, u.email,
       p.name AS property_name, p.location,
       pay.amount, pay.payment_method, pay.payment_date
FROM Booking b
JOIN `User` u      ON u.user_id     = b.user_id
JOIN Property p    ON p.property_id = b.property_id
LEFT JOIN Payment pay ON pay.booking_id = b.booking_id
ORDER BY b.booking_id ASC
LIMIT 200;
Ranking properties by bookings (window function)

sql
Copy code
SELECT p.property_id, p.name AS property_name,
       COUNT(b.booking_id) AS total_bookings,
       RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS property_rank
FROM Property p
LEFT JOIN Booking b ON b.property_id = p.property_id
GROUP BY p.property_id, p.name
ORDER BY total_bookings DESC
LIMIT 50;
🧪 Methodology
Used EXPLAIN and EXPLAIN ANALYZE to observe execution plans and timing.

Compared performance before and after applying optimizations.

Key checks included:

type column (ALL → bad; ref/eq_ref → good)

rows estimated vs actual

key chosen (shows which index is used)

Presence of Using filesort or Using temporary (performance red flags)

🛠 Refinements Applied
Added indexes to common filter/sort columns:

User(email), User(role), User(created_at)

Booking(user_id, created_at), Booking(property_id, start_date, end_date)

Property(location), Property(pricepernight)

Payment(booking_id)

Refactored complex join to select only necessary columns instead of SELECT *.

Ordered queries on indexed columns (e.g., ORDER BY booking_id).

Partitioning on Booking(start_date) (from Task 5) further helped range queries.

📈 Results (Sample)
Query	Before (ms)	After (ms)	Improvement
Login lookup	120	3	~97% faster
User’s bookings recent	150	7	~95% faster
Property availability	250	12	~95% faster
Complex join	280	30	~89% faster
Ranking properties	210	120	~43% faster

(Replace with your actual timings from EXPLAIN ANALYZE)

✅ Key Takeaways
Always monitor with EXPLAIN ANALYZE before and after changes.

Composite indexes tailored to queries (e.g., (user_id, created_at)) give huge speedups.

Avoid SELECT * in production queries.

Partitioning + indexing = scalable performance for large datasets.

Performance refinement is continuous: keep profiling as data grows.

