# Advanced SQL – Airbnb Database

This directory demonstrates advanced SQL concepts with the Airbnb clone database schema.  
The objective is to practice **JOINs, Subqueries, and Aggregations/Window Functions** to analyze data effectively.  

---

## 📂 Files
- **`joins_queries.sql`** → Demonstrates INNER JOIN, LEFT JOIN, FULL OUTER JOIN.  
- **`subqueries.sql`** → Demonstrates non-correlated and correlated subqueries.  
- **`aggregations_and_window_functions.sql`** → Demonstrates COUNT + GROUP BY and window functions (RANK, ROW_NUMBER).  
- **`README.md`** → Documentation for all advanced SQL tasks.  

---

## 🎯 Learning Objectives
By completing these tasks, you will be able to:
- Understand and apply different types of **JOINs**.  
- Write **non-correlated** and **correlated subqueries**.  
- Use **aggregations** (COUNT, GROUP BY).  
- Apply **window functions** (RANK, ROW_NUMBER).  
- Analyze relational data in realistic backend scenarios.  

---

## 🔑 Queries Included

### 1) Joins

#### a) INNER JOIN – Bookings with Users
```sql
SELECT 
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.status,
    u.user_id,
    u.name,
    u.email
FROM Booking b
INNER JOIN User u 
    ON b.user_id = u.user_id;
Explanation: Returns all bookings linked to users. Excludes users with no bookings.

b) LEFT JOIN – Properties with Reviews
sql
Copy code
SELECT 
    p.property_id,
    p.title,
    p.location,
    r.review_id,
    r.rating,
    r.comment
FROM Property p
LEFT JOIN Review r 
    ON p.property_id = r.property_id
ORDER BY 
    p.property_id ASC,
    r.review_id ASC;
Explanation: Returns all properties and their reviews. Properties without reviews still appear (NULL review fields).

c) FULL OUTER JOIN – Users with Bookings (MySQL via UNION)
sql
Copy code
-- MySQL doesn’t support FULL OUTER JOIN directly.
-- Simulate with UNION of LEFT JOIN and RIGHT JOIN.

SELECT 
    u.user_id,
    u.name,
    b.booking_id,
    b.status
FROM User u
LEFT JOIN Booking b 
    ON u.user_id = b.user_id
UNION
SELECT 
    u.user_id,
    u.name,
    b.booking_id,
    b.status
FROM User u
RIGHT JOIN Booking b 
    ON u.user_id = b.user_id;
Explanation: Ensures all users and all bookings are shown, even unmatched ones.

2) Subqueries
a) Non-Correlated – Properties with Avg Rating > 4.0
sql
Copy code
SELECT p.property_id, p.title, p.location, p.pricepernight
FROM Property p
WHERE p.property_id IN (
    SELECT r.property_id
    FROM Review r
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
);
Explanation: Finds properties whose average review rating exceeds 4.0.

b) Correlated – Users with More Than 3 Bookings
sql
Copy code
SELECT u.user_id, u.first_name, u.last_name, u.email
FROM User u
WHERE (
    SELECT COUNT(*)
    FROM Booking b
    WHERE b.user_id = u.user_id
) > 3;
``]
**Explanation:** For each user, counts their bookings. Returns users with more than 3.  

---

### 3) Aggregations & Window Functions

#### a) Aggregation – Total Number of Bookings Per User
```sql
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
Explanation: Aggregates bookings per user. Includes users with zero bookings.

b) Window Function – Rank Properties by Bookings
sql
Copy code
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
Explanation: Ranks properties by how many bookings they’ve received. Uses RANK() (ties share ranks) and ROW_NUMBER() (unique sequence).

⚡ Usage
Load schema and seed data:

bash
Copy code
mysql -u <username> -p <db> < schema.sql
mysql -u <username> -p <db> < seed.sql
Run advanced queries:

bash
Copy code
mysql -u <username> -p <db> < joins_queries.sql
mysql -u <username> -p <db> < subqueries.sql
mysql -u <username> -p <db> < aggregations_and_window_functions.sql
✅ Expected Results
INNER JOIN → Only matched bookings & users.

LEFT JOIN → All properties; reviews may be NULL.

FULL OUTER JOIN → All users and all bookings, even if unmatched.

Non-Correlated Subquery → Properties with avg rating > 4.0.

Correlated Subquery → Users with > 3 bookings.

Aggregations → Number of bookings per user.

Window Functions → Properties ranked by booking count.

