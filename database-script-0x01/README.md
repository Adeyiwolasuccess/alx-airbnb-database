# Database Script – 0x01

This project contains the initial **MySQL schema design** for a property booking platform.  
It defines the tables, constraints, and indexes required to support users, properties, bookings, payments, and reviews.

---

## 📂 Files
- **`schema.sql`** → Contains all table creation scripts with constraints and indexes.
- **`README.md`** → Documentation of the database schema.

---

## 📑 Schema Overview

### 1. Users
- Stores all registered users.
- Indexed on `email` for fast lookups.

**Constraints:**
- `PRIMARY KEY (user_id)`
- `UNIQUE (email)`

**Index:**
- `idx_users_email`

---

### 2. Properties
- Stores property listings created by users.
- Linked to `Users`.

**Constraints:**
- `PRIMARY KEY (property_id)`
- `FOREIGN KEY (user_id)` → `Users(user_id)` (cascade on delete)

**Index:**
- `idx_properties_user_id`

---

### 3. Bookings
- Stores reservations made by users on properties.

**Constraints:**
- `PRIMARY KEY (booking_id)`
- `FOREIGN KEY (property_id)` → `Properties(property_id)` (cascade on delete)
- `FOREIGN KEY (user_id)` → `Users(user_id)` (cascade on delete)

**Index:**
- `idx_bookings_property_id`

---

### 4. Payments
- Tracks payments tied to bookings.

**Constraints:**
- `PRIMARY KEY (payment_id)`
- `FOREIGN KEY (booking_id)` → `Bookings(booking_id)` (cascade on delete)

**Index:**
- `idx_payments_booking_id`

---

### 5. Reviews
- Stores property reviews by users.
- Rating is restricted to **1–5**.

**Constraints:**
- `PRIMARY KEY (review_id)`
- `FOREIGN KEY (property_id)` → `Properties(property_id)` (cascade on delete)
- `FOREIGN KEY (user_id)` → `Users(user_id)` (cascade on delete)
- `CHECK (rating BETWEEN 1 AND 5)`

**Index:**
- `idx_reviews_property_id`

---

## 🛠 Setup Instructions

1. Clone this repo:
   ```bash
   git clone <repo_url>
   cd database-script-0x01
