-- partitioning.sql
-- Task 5: Implementing Table Partitioning for Booking Table

-- Step 1: Create a new partitioned table structure
CREATE TABLE Booking_Partitioned (
    id INT AUTO_INCREMENT PRIMARY KEY,
    guest_id INT NOT NULL,
    property_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES User(id),
    FOREIGN KEY (property_id) REFERENCES Property(id)
)
PARTITION BY RANGE (YEAR(start_date)) (
    PARTITION p2020 VALUES LESS THAN (2021),
    PARTITION p2021 VALUES LESS THAN (2022),
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- Step 2: Copy data from original Booking table to partitioned table
INSERT INTO Booking_Partitioned 
SELECT * FROM Booking;

-- Step 3: Verify partition creation and data distribution
SELECT 
    PARTITION_NAME,
    TABLE_ROWS
FROM information_schema.PARTITIONS 
WHERE TABLE_NAME = 'Booking_Partitioned';

-- Step 4: Create indexes on partitioned table for better performance
CREATE INDEX idx_booking_partitioned_dates ON Booking_Partitioned (start_date, end_date);
CREATE INDEX idx_booking_partitioned_guest ON Booking_Partitioned (guest_id);
CREATE INDEX idx_booking_partitioned_property ON Booking_Partitioned (property_id);
CREATE INDEX idx_booking_partitioned_status ON Booking_Partitioned (status);

-- Step 5: Sample queries to test partition pruning
-- This query should only scan the p2024 partition
EXPLAIN SELECT * FROM Booking_Partitioned 
WHERE start_date BETWEEN '2024-01-01' AND '2024-12-31';

-- This query should scan multiple partitions
EXPLAIN SELECT * FROM Booking_Partitioned 
WHERE start_date BETWEEN '2023-01-01' AND '2024-12-31';
