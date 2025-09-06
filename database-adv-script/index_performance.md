# Index Performance – Airbnb Database (Advanced)

This document explains **what we indexed**, **why**, and **how we measured** performance improvements using `EXPLAIN`/`EXPLAIN ANALYZE`.

## 📦 Scope

Tables covered (per task):
- `User` → lookups by email/role, sorting by created date
- `Property` → filters by host/location/price
- `Booking` → joins to `User`/`Property`, filters by user/property/status, date-range availability

> The SQL to create indexes is in: `database-adv-script/database_index.sql`.

---

## 🔎 High-Usage Columns & Rationale

### `User`
| Column       | Why                                                                 |
|--------------|----------------------------------------------------------------------|
| `email`      | Exact-match login & uniqueness checks.                               |
| `role`       | Admin/host/guest filtering in dashboards.                            |
| `created_at` | “Newest users” listing; ORDER BY performance.                        |

### `Property`
| Column         | Why                                                                |
|----------------|---------------------------------------------------------------------|
| `host_id`      | All listings for a host.                                            |
| `location`     | City/area filters during search.                                    |
| `pricepernight`| Price sorting/range filters.                                        |

### `Booking`
| Column(s)                         | Why                                                                                           |
|----------------------------------|------------------------------------------------------------------------------------------------|
| `user_id`                        | A user’s bookings history.                                                                     |
| `property_id`                    | All bookings for a given property.                                                             |
| `status`                         | Filtering by `pending/confirmed/canceled`.                                                     |
| `(property_id, start_date, end_date)` | Availability windows (date range checks per property).                                      |
| `(user_id, created_at)`          | A user’s bookings sorted by most recent (covering WHERE + ORDER BY).                          |

> **Note on composite indexes:** Column order matters. Place the most selective/equality filters first, then range/sort columns.

---

## 🧪 Methodology

We measured cost before/after adding indexes using:

- **MySQL 8.0+**: `EXPLAIN ANALYZE <query>;`
- **MySQL 5.7/8.0**: `EXPLAIN <query>;` + benchmark timing (`SET profiling = 1;`… deprecated but okay locally)

### Baseline Queries (Representative)

1) **Login lookup**
```sql
EXPLAIN ANALYZE
SELECT user_id, password_hash
FROM `User`
WHERE email = 'alice@example.com';
Host’s property list

sql
Copy code
EXPLAIN ANALYZE
SELECT property_id, name, location, pricepernight
FROM `Property`
WHERE host_id = 'HOST-UUID-123';
Property availability check

sql
Copy code
EXPLAIN ANALYZE
SELECT booking_id
FROM `Booking`
WHERE property_id = 'PROP-UUID-123'
  AND start_date <= '2025-12-20'
  AND end_date   >= '2025-12-15';
User’s bookings (recent first)

sql
Copy code
EXPLAIN ANALYZE
SELECT booking_id, property_id, created_at
FROM `Booking`
WHERE user_id = 'USER-UUID-123'
ORDER BY created_at DESC
LIMIT 20;
Property search by location + sort by price

sql
Copy code
EXPLAIN ANALYZE
SELECT property_id, name, pricepernight
FROM `Property`
WHERE location = 'Lagos'
ORDER BY pricepernight ASC
LIMIT 20;
Run each before and after applying database_index.sql. Capture the plan and timing.

📈 Recording Results (Template)
Query	Before: Plan / Rows / Time	After: Plan / Rows / Time	Delta
1	full table scan / ~N rows / 120ms	range on idx_user_email / ~1 row / 2ms	~98% faster
2	full scan / joined filter / 85ms	ref on idx_property_host_id / few rows / 3ms	~96% faster
3	full scan w/ range / 300ms	range on idx_booking_prop_start_end / few rows / 8ms	~97% faster
4	filesort + scan / 150ms	index range on idx_booking_user_created w/o filesort / 6ms	~96% faster
5	full scan + filesort / 220ms	ref on idx_property_location + idx_property_price / 10ms	~95% faster

Replace the numbers with your actual results from EXPLAIN ANALYZE.

🧠 Interpreting EXPLAIN
type = ref/range is better than ALL (full scan).

key / key_len tells you which index MySQL chose.

rows approximates how many rows MySQL expects to read—lower is better.

filtered shows selectivity.

EXPLAIN ANALYZE adds actual timing per step (8.0+), which is ideal for this task.

⚠️ Indexing Tips
Composite indexes should match your most common WHERE and ORDER BY patterns.

Avoid over-indexing (each index costs write overhead + storage).

Prefer one good composite index over many overlapping single-column indexes.

Revisit indexes periodically as query patterns change.

🔧 How to Run
Apply the indexes:

bash
Copy code
mysql -u <username> -p <database_name> < database-adv-script/database_index.sql
Measure before/after (example):

sql
Copy code
EXPLAIN ANALYZE
SELECT user_id, password_hash FROM `User` WHERE email = 'alice@example.com';
Verify indexes:

sql
Copy code
SHOW INDEX FROM `User`;
SHOW INDEX FROM `Property`;
SHOW INDEX FROM `Booking`;
✅ Deliverables Checklist
 database_index.sql created with appropriate CREATE INDEX statements

 index_performance.md documents targeted columns, rationale, queries, and measurement method

 Evidence of before vs after (paste plans/timings or summarize in the table)

📌 Notes
If you’re on MySQL < 8.0, replace EXPLAIN ANALYZE with EXPLAIN, and measure timing by running the query a few times and using your client’s timing output.

Only keep indexes that your workload actually uses—check with EXPLAIN and SHOW INDEX usage in production.