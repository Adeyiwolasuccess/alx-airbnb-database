# Advanced SQL Joins – Airbnb Database

This directory demonstrates the use of **SQL JOINs** with the Airbnb clone database schema.  
The objective is to practice complex queries that retrieve related data across multiple tables using different types of JOINs.

---

## 📂 Files

- **`joins_queries.sql`** → Contains SQL queries demonstrating INNER JOIN, LEFT JOIN, and FULL OUTER JOIN.  
- **`README.md`** → Documentation explaining the queries, usage, and expected results.  

---

## 🎯 Learning Objectives

By completing this task, you will be able to:

- Understand how JOINs combine rows from multiple tables.  
- Write **INNER JOIN** queries to retrieve only matched rows.  
- Write **LEFT JOIN** queries to include unmatched rows from the left table.  
- Simulate a **FULL OUTER JOIN** in MySQL using `UNION`.  
- Apply these queries in real-world scenarios such as retrieving bookings, reviews, and user data.  

---

## 🔑 Queries Included

### 1. INNER JOIN – Bookings with Users
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
--- 
Explanation:

Retrieves all bookings and the respective users who made them.

Only shows bookings that have a matching user.

Users without bookings are excluded.

2. LEFT JOIN – Properties with Reviews
SELECT 
    p.property_id,
    p.title,
    p.location,
    r.review_id,
    r.rating,
    r.comment
FROM Property p
LEFT JOIN Review r 
    ON p.property_id = r.property_id;
ORDER BY 
   p.property_id ASC;
   r.review_id ASC;
---
### Explanation:

Retrieves all properties and any reviews tied to them.

Properties without reviews will still appear, with NULL values for review fields.

Useful for generating a complete list of properties, regardless of feedback.
---
3. FULL OUTER JOIN – Users with Bookings
-- MySQL does not support FULL OUTER JOIN directly.
-- We can simulate it using a UNION of LEFT JOIN and RIGHT JOIN.

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


Explanation:

Returns a union of users and bookings.

Ensures the result includes:

Users who have bookings.

Users who don’t have bookings.

Bookings not linked to any user.

⚡ Usage Instructions

Load the schema and seed data first:
Make sure you’ve executed schema.sql (from database-script-0x01) and seed.sql (from database-script-0x02).

Run the JOIN queries:
From the MySQL shell or CLI, run:

mysql -u <username> -p <database_name> < joins_queries.sql


Check results manually:
You can also copy-paste individual queries into MySQL Workbench or CLI to see outputs.

✅ Expected Results

INNER JOIN → Only shows bookings that are linked to valid users.

LEFT JOIN → Shows all properties; reviews may appear as NULL if none exist.

FULL OUTER JOIN → Shows all users and all bookings, including unmatched ones.

📌 Example Use Cases

INNER JOIN → “List all bookings made by registered users.”

LEFT JOIN → “List all properties and include reviews if available.”

FULL OUTER JOIN → “Show all users and all bookings, even if some don’t have a match.”

🔗 Related Tasks

database-script-0x01 → Schema definition (schema.sql).

database-script-0x02 → Seed data (seed.sql).

database-adv-script → Current directory with JOIN queries.

👨‍💻 Author

Part of the ALX ProDev Backend Engineering – Airbnb Clone project.


# Advanced SQL Subqueries – Airbnb Database

This directory demonstrates the use of **subqueries** with the Airbnb clone database schema.  
The objective is to practice both **non-correlated** and **correlated** subqueries.

---

## 📂 Files
- **`subqueries.sql`** → SQL queries implementing non-correlated and correlated subqueries.  
- **`README.md`** → Documentation explaining the queries, usage, and expected results.  

---

## 🔑 Queries Included

### 1. Non-Correlated Subquery – Properties with Avg Rating > 4.0
```sql
SELECT p.property_id, p.title, p.location, p.pricepernight
FROM Property p
WHERE p.property_id IN (
    SELECT r.property_id
    FROM Review r
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
);
Explanation:

The inner query (SELECT r.property_id ...) groups reviews by property and computes the average rating.

It only returns property IDs with AVG(rating) > 4.0.

The outer query retrieves full property details for those IDs.

Non-correlated → the inner query runs independently of the outer query.

2. Correlated Subquery – Users with More Than 3 Bookings
sql
Copy code
SELECT u.user_id, u.first_name, u.last_name, u.email
FROM User u
WHERE (
    SELECT COUNT(*)
    FROM Booking b
    WHERE b.user_id = u.user_id
) > 3;
Explanation:

For each user, the inner query counts the number of bookings they made.

The outer query checks if the count is greater than 3.

Correlated → the inner query depends on the outer query’s u.user_id.

⚡ Usage Instructions
Ensure schema (schema.sql) and seed data (seed.sql) are loaded.

Run the queries in the MySQL shell or client:

bash
Copy code
mysql -u <username> -p <database_name> < subqueries.sql
Verify results:

First query should list properties with average rating > 4.0.

Second query should list users with more than 3 bookings.

✅ Expected Results
Non-Correlated Subquery → Returns properties that have strong reviews (avg rating > 4).

Correlated Subquery → Returns frequent users with more than 3 bookings.

📌 Learning Outcome
Understand the difference between independent (non-correlated) and dependent (correlated) subqueries.

Apply subqueries to filter aggregated results.

Strengthen SQL skills for real-world backend scenarios.