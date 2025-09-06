-- ============================================
-- File: database-adv-script/partitioning.sql
-- Goal: Partition the large Booking table by start_date
-- MySQL 8.x (InnoDB partitioning)
-- NOTE: In MySQL, every UNIQUE/PRIMARY KEY must include the partitioning column.
--       So we make the PK composite: (booking_id, start_date).
-- ============================================

/* 0) (Optional) Check engine + keys */
-- SHOW CREATE TABLE Booking\G

/* 1) Create a safety backup (strongly recommended) */
CREATE TABLE IF NOT EXISTS Booking_backup LIKE Booking;
INSERT INTO Booking_backup SELECT * FROM Booking;

/* 2) Adjust PK to include the partitioning column (start_date)
      (Required because MySQL requires every UNIQUE/PK to include the partition key) */
ALTER TABLE Booking
  DROP PRIMARY KEY,
  ADD PRIMARY KEY (booking_id, start_date);

/* 3) Apply RANGE partitioning on YEAR(start_date)
      Adjust ranges to fit your data distribution.
      We keep a rolling window + MAXVALUE partition as a catch-all. */
ALTER TABLE Booking
PARTITION BY RANGE (YEAR(start_date)) (
  PARTITION p2023 VALUES LESS THAN (2024),
  PARTITION p2024 VALUES LESS THAN (2025),
  PARTITION p2025 VALUES LESS THAN (2026),
  PARTITION p2026 VALUES LESS THAN (2027),
  PARTITION p2027 VALUES LESS THAN (2028),
  PARTITION pmax  VALUES LESS THAN MAXVALUE
);

/* 4) Helpful indexes (if not already present) to keep typical queries fast.
      These are compatible with the new composite PK. */
CREATE INDEX idx_booking_user_id        ON Booking(user_id);
CREATE INDEX idx_booking_property_id    ON Booking(property_id);
CREATE INDEX idx_booking_status         ON Booking(status);
CREATE INDEX idx_booking_prop_start_end ON Booking(property_id, start_date, end_date);
CREATE INDEX idx_booking_user_created   ON Booking(user_id, created_at);

/* 5) Sanity checks */
-- SHOW TABLE STATUS LIKE 'Booking'\G
-- SELECT PARTITION_NAME, TABLE_ROWS FROM INFORMATION_SCHEMA.PARTITIONS
--   WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'Booking';
