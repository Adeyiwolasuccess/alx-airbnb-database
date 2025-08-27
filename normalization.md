# Database Normalization – AirBnB Schema

## 1. First Normal Form (1NF)
- All attributes are atomic (no repeating groups, no multi-valued fields).
- Example: `User` table stores single values for `email`, `phone_number`, etc.

## 2. Second Normal Form (2NF)
- All non-key attributes depend on the entire primary key.
- Since all primary keys are simple (UUIDs), no partial dependencies exist.

## 3. Third Normal Form (3NF)
- No transitive dependencies (non-key attributes do not depend on other non-key attributes).
- Example: In the `Property` table, `location`, `name`, `pricepernight` all depend only on `property_id`.

## 4. Adjustment
- The schema is already in 3NF.
- Optional refinement: Remove `total_price` from `Booking` and compute it as `DATEDIFF(end_date, start_date) × pricepernight`. This avoids derived data storage but may affect performance.

## ✅ Final Conclusion
The AirBnB schema is in **Third Normal Form (3NF)** and ready for implementation.
