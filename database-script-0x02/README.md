# Database Seeding Script – ALX Airbnb Database

This directory contains the SQL script for **seeding** the Airbnb database with sample data.  
The purpose of this seeding process is to populate the schema with realistic sample records that can be used for **testing**, **development**, and **demonstration** purposes.

---

## 📂 Files in this Directory

- **`seed.sql`** → SQL script containing `INSERT` statements for populating all tables with sample data.  
- **`README.md`** → Documentation explaining the purpose of the script, how to run it, and details about the sample dataset.

---

## 🛠️ Purpose of Seeding

Seeding ensures that the database has **ready-to-use data** immediately after schema creation.  
This helps developers and testers simulate **real-world usage scenarios**, such as:

- Multiple users (hosts & guests) with unique emails.  
- Properties linked to valid hosts.  
- Bookings made by users on properties.  
- Payments tied to bookings.  
- Reviews and ratings reflecting real guest feedback.  
- Messages between users (guests ↔ hosts).  

---

## 📊 Tables Covered in Seeding

The following tables are seeded in `seed.sql`:

1. **User** – Inserts multiple users with unique emails.  
2. **Property** – Inserts various property listings tied to host users.  
3. **Booking** – Creates realistic bookings for properties by different users.  
4. **Payment** – Adds payments linked to valid bookings.  
5. **Review** – Seeds reviews with ratings (1–5) and comments for properties.  
6. **Message** – Populates user-to-user messages (e.g., guest ↔ host).

---

## 🚀 How to Run the Seeding Script

### 1. Ensure Database & Schema Exists
Before running this script, you must have already executed the **schema creation script** located in:

