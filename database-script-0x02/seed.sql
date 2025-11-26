-- =====================================================
-- AirBnB Database - Sample Seed Data
-- =====================================================
-- Description: Sample data to populate AirBnB database
-- Version: 1.0
-- Date: November 26, 2025
-- Author: Johnson Aboagye
-- Repository: alx-airbnb-database
-- =====================================================

-- Set safe mode off for bulk operations
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;

-- =====================================================
-- CLEAR EXISTING DATA (Optional - use with caution)
-- =====================================================
-- Uncomment the following lines to clear existing data
-- DELETE FROM Message;
-- DELETE FROM Review;
-- DELETE FROM Payment;
-- DELETE FROM Booking;
-- DELETE FROM Property;
-- DELETE FROM Location;
-- DELETE FROM User;

-- =====================================================
-- SEED DATA: User Table
-- =====================================================
-- Creating 15 users with different roles

INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at) VALUES
-- Admins
('550e8400-e29b-41d4-a716-446655440001', 'Sarah', 'Johnson', 'admin@airbnb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1-555-0001', 'admin', '2024-01-15 08:00:00'),
('550e8400-e29b-41d4-a716-446655440002', 'Michael', 'Chen', 'mchen@airbnb.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1-555-0002', 'admin', '2024-01-20 09:30:00'),

-- Hosts
('550e8400-e29b-41d4-a716-446655440003', 'Emily', 'Rodriguez', 'emily.rodriguez@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1-555-1001', 'host', '2024-02-01 10:15:00'),
('550e8400-e29b-41d4-a716-446655440004', 'James', 'Williams', 'j.williams@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1-555-1002', 'host', '2024-02-05 11:20:00'),
('550e8400-e29b-41d4-a716-446655440005', 'Sophia', 'Martinez', 'sophia.m@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1-555-1003', 'host', '2024-02-10 14:30:00'),
('550e8400-e29b-41d4-a716-446655440006', 'David', 'Brown', 'david.brown@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1-555-1004', 'host', '2024-02-15 16:45:00'),
('550e8400-e29b-41d4-a716-446655440007', 'Olivia', 'Taylor', 'olivia.t@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1-555-1005', 'host', '2024-02-20 13:00:00'),

-- Guests
('550e8400-e29b-41d4-a716-446655440008', 'Daniel', 'Anderson', 'daniel.a@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1-555-2001', 'guest', '2024-03-01 09:00:00'),
('550e8400-e29b-41d4-a716-446655440009', 'Isabella', 'Thomas', 'isabella.t@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1-555-2002', 'guest', '2024-03-05 10:30:00'),
('550e8400-e29b-41d4-a716-446655440010', 'Matthew', 'Jackson', 'matt.jackson@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1-555-2003', 'guest', '2024-03-10 11:45:00'),
('550e8400-e29b-41d4-a716-446655440011', 'Emma', 'White', 'emma.white@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1-555-2004', 'guest', '2024-03-15 14:20:00'),
('550e8400-e29b-41d4-a716-446655440012', 'Christopher', 'Harris', 'chris.harris@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1-555-2005', 'guest', '2024-03-20 15:30:00'),
('550e8400-e29b-41d4-a716-446655440013', 'Ava', 'Martin', 'ava.martin@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1-555-2006', 'guest', '2024-03-25 16:00:00'),
('550e8400-e29b-41d4-a716-446655440014', 'Ryan', 'Garcia', 'ryan.garcia@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1-555-2007', 'guest', '2024-04-01 09:15:00'),
('550e8400-e29b-41d4-a716-446655440015', 'Mia', 'Lee', 'mia.lee@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+1-555-2008', 'guest', '2024-04-05 10:45:00');

-- =====================================================
-- SEED DATA: Location Table
-- =====================================================
-- Creating 10 diverse locations

INSERT INTO Location (location_id, street_address, city, state, country, postal_code, latitude, longitude, created_at) VALUES
('650e8400-e29b-41d4-a716-446655440001', '123 Broadway Street', 'New York', 'New York', 'United States', '10001', 40.7505, -73.9934, '2024-01-15 08:00:00'),
('650e8400-e29b-41d4-a716-446655440002', '456 Ocean Drive', 'Miami', 'Florida', 'United States', '33139', 25.7617, -80.1918, '2024-01-16 09:00:00'),
('650e8400-e29b-41d4-a716-446655440003', '789 Golden Gate Ave', 'San Francisco', 'California', 'United States', '94102', 37.7749, -122.4194, '2024-01-17 10:00:00'),
('650e8400-e29b-41d4-a716-446655440004', '321 Parliament Street', 'London', 'England', 'United Kingdom', 'SW1A 0AA', 51.5074, -0.1278, '2024-01-18 11:00:00'),
('650e8400-e29b-41d4-a716-446655440005', '654 Champs-Élysées', 'Paris', 'Île-de-France', 'France', '75008', 48.8566, 2.3522, '2024-01-19 12:00:00'),
('650e8400-e29b-41d4-a716-446655440006', '987 Via Roma', 'Rome', 'Lazio', 'Italy', '00186', 41.9028, 12.4964, '2024-01-20 13:00:00'),
('650e8400-e29b-41d4-a716-446655440007', '147 Shibuya Street', 'Tokyo', 'Tokyo', 'Japan', '150-0002', 35.6762, 139.6503, '2024-01-21 14:00:00'),
('650e8400-e29b-41d4-a716-446655440008', '258 Bondi Beach Road', 'Sydney', 'New South Wales', 'Australia', '2026', -33.8688, 151.2093, '2024-01-22 15:00:00'),
('650e8400-e29b-41d4-a716-446655440009', '369 Yonge Street', 'Toronto', 'Ontario', 'Canada', 'M5B 1R7', 43.6532, -79.3832, '2024-01-23 16:00:00'),
('650e8400-e29b-41d4-a716-446655440010', '741 Camps Bay Drive', 'Cape Town', 'Western Cape', 'South Africa', '8005', -33.9249, 18.4241, '2024-01-24 17:00:00');

-- =====================================================
-- SEED DATA: Property Table
-- =====================================================
-- Creating 12 diverse properties

INSERT INTO Property (property_id, host_id, location_id, name, description, pricepernight, created_at, updated_at) VALUES
-- Properties by Emily Rodriguez
('750e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440001', 'Luxury Manhattan Loft', 'Stunning 2-bedroom loft in the heart of Manhattan with skyline views. Modern amenities, fully equipped kitchen, and walking distance to Times Square.', 299.99, '2024-02-05 10:00:00', '2024-02-05 10:00:00'),
('750e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440002', 'Miami Beach Penthouse', 'Oceanfront penthouse with private rooftop pool. 3 bedrooms, 3 bathrooms, and breathtaking Atlantic Ocean views.', 449.99, '2024-02-06 11:00:00', '2024-02-06 11:00:00'),

-- Properties by James Williams
('750e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440003', 'Victorian SF Home', 'Charming Victorian house in Pacific Heights. 4 bedrooms, classic architecture, modern updates, garden views.', 349.99, '2024-02-10 12:00:00', '2024-02-10 12:00:00'),
('750e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440003', 'Downtown Studio', 'Cozy studio apartment near Union Square. Perfect for solo travelers or couples. WiFi, workspace, all amenities included.', 129.99, '2024-02-11 13:00:00', '2024-02-11 13:00:00'),

-- Properties by Sophia Martinez
('750e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440005', '650e8400-e29b-41d4-a716-446655440004', 'London City Flat', 'Modern 1-bedroom flat in Westminster. Minutes from Big Ben and Parliament. Ideal for business travelers and tourists.', 199.99, '2024-02-15 14:00:00', '2024-02-15 14:00:00'),
('750e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440005', '650e8400-e29b-41d4-a716-446655440005', 'Parisian Apartment', 'Elegant apartment steps from the Champs-Élysées. 2 bedrooms, classic French decor, fully renovated kitchen.', 279.99, '2024-02-16 15:00:00', '2024-02-16 15:00:00'),

-- Properties by David Brown
('750e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440006', '650e8400-e29b-41d4-a716-446655440006', 'Roman Holiday Villa', 'Authentic Italian villa near the Colosseum. 3 bedrooms, terrace with city views, traditional Italian kitchen.', 329.99, '2024-02-20 16:00:00', '2024-02-20 16:00:00'),
('750e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440006', '650e8400-e29b-41d4-a716-446655440007', 'Tokyo Zen Suite', 'Minimalist Japanese apartment in Shibuya. 1 bedroom, tatami room, balcony overlooking Tokyo skyline.', 189.99, '2024-02-21 17:00:00', '2024-02-21 17:00:00'),

-- Properties by Olivia Taylor
('750e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440007', '650e8400-e29b-41d4-a716-446655440008', 'Bondi Beach House', 'Beachfront 4-bedroom house with direct beach access. Surfboards included, outdoor BBQ area, stunning sunsets.', 399.99, '2024-02-25 18:00:00', '2024-02-25 18:00:00'),
('750e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440007', '650e8400-e29b-41d4-a716-446655440009', 'Toronto Downtown Condo', 'Modern condo in financial district. 2 bedrooms, gym access, concierge service, CN Tower views.', 229.99, '2024-02-26 19:00:00', '2024-02-26 19:00:00'),
('750e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440007', '650e8400-e29b-41d4-a716-446655440010', 'Cape Town Seaside Retreat', 'Luxury villa in Camps Bay. 5 bedrooms, infinity pool, mountain and ocean views, private chef available.', 599.99, '2024-02-27 20:00:00', '2024-02-27 20:00:00'),
('750e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440007', '650e8400-e29b-41d4-a716-446655440001', 'NYC Budget Studio', 'Affordable studio in Queens. 20 minutes to Manhattan, clean, safe neighborhood, perfect for budget travelers.', 79.99, '2024-02-28 21:00:00', '2024-02-28 21:00:00');

-- =====================================================
-- SEED DATA: Booking Table
-- =====================================================
-- Creating 20 bookings with various statuses

INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, nightly_rate, total_price, status, created_at) VALUES
-- Confirmed bookings
('850e8400-e29b-41d4-a716-446655440001', '750e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440008', '2024-06-01', '2024-06-05', 299.99, 1199.96, 'confirmed', '2024-04-15 10:00:00'),
('850e8400-e29b-41d4-a716-446655440002', '750e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440009', '2024-07-10', '2024-07-17', 449.99, 3149.93, 'confirmed', '2024-05-01 11:00:00'),
('850e8400-e29b-41d4-a716-446655440003', '750e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440010', '2024-08-05', '2024-08-12', 349.99, 2449.93, 'confirmed', '2024-06-10 12:00:00'),
('850e8400-e29b-41d4-a716-446655440004', '750e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440011', '2024-09-15', '2024-09-18', 129.99, 389.97, 'confirmed', '2024-07-20 13:00:00'),
('850e8400-e29b-41d4-a716-446655440005', '750e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440012', '2024-10-01', '2024-10-08', 199.99, 1399.93, 'confirmed', '2024-08-15 14:00:00'),
('850e8400-e29b-41d4-a716-446655440006', '750e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440013', '2024-11-10', '2024-11-15', 279.99, 1399.95, 'confirmed', '2024-09-01 15:00:00'),
('850e8400-e29b-41d4-a716-446655440007', '750e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440014', '2024-12-20', '2024-12-27', 329.99, 2309.93, 'confirmed', '2024-10-10 16:00:00'),
('850e8400-e29b-41d4-a716-446655440008', '750e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440015', '2025-01-05', '2025-01-10', 189.99, 949.95, 'confirmed', '2024-11-01 17:00:00'),

-- Pending bookings
('850e8400-e29b-41d4-a716-446655440009', '750e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440008', '2025-02-14', '2025-02-21', 399.99, 2799.93, 'pending', '2024-11-15 10:00:00'),
('850e8400-e29b-41d4-a716-446655440010', '750e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440009', '2025-03-01', '2025-03-05', 229.99, 919.96, 'pending', '2024-11-20 11:00:00'),
('850e8400-e29b-41d4-a716-446655440011', '750e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440010', '2025-04-10', '2025-04-20', 599.99, 5999.90, 'pending', '2024-11-22 12:00:00'),
('850e8400-e29b-41d4-a716-446655440012', '750e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440011', '2025-05-01', '2025-05-08', 79.99, 559.93, 'pending', '2024-11-23 13:00:00'),

-- Canceled bookings
('850e8400-e29b-41d4-a716-446655440013', '750e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440012', '2024-05-15', '2024-05-20', 299.99, 1499.95, 'canceled', '2024-03-10 14:00:00'),
('850e8400-e29b-41d4-a716-446655440014', '750e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440013', '2024-06-20', '2024-06-25', 349.99, 1749.95, 'canceled', '2024-04-05 15:00:00'),
('850e8400-e29b-41d4-a716-446655440015', '750e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440014', '2024-07-01', '2024-07-05', 199.99, 799.96, 'canceled', '2024-05-15 16:00:00'),

-- Recent confirmed bookings
('850e8400-e29b-41d4-a716-446655440016', '750e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440015', '2025-06-01', '2025-06-10', 449.99, 4049.91, 'confirmed', '2024-11-24 10:30:00'),
('850e8400-e29b-41d4-a716-446655440017', '750e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440008', '2025-07-15', '2025-07-20', 129.99, 649.95, 'confirmed', '2024-11-24 11:30:00'),
('850e8400-e29b-41d4-a716-446655440018', '750e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440009', '2025-08-01', '2025-08-08', 279.99, 1959.93, 'confirmed', '2024-11-24 12:30:00'),
('850e8400-e29b-41d4-a716-446655440019', '750e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440010', '2025-09-10', '2025-09-15', 189.99, 949.95, 'pending', '2024-11-24 13:30:00'),
('850e8400-e29b-41d4-a716-446655440020', '750e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440011', '2025-10-01', '2025-10-07', 399.99, 2399.94, 'pending', '2024-11-24 14:30:00');

-- =====================================================
-- SEED DATA: Payment Table
-- =====================================================
-- Creating payments for confirmed bookings only

INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method) VALUES
('950e8400-e29b-41d4-a716-446655440001', '850e8400-e29b-41d4-a716-446655440001', 1199.96, '2024-04-15 10:30:00', 'credit_card'),
('950e8400-e29b-41d4-a716-446655440002', '850e8400-e29b-41d4-a716-446655440002', 3149.93, '2024-05-01 11:30:00', 'paypal'),
('950e8400-e29b-41d4-a716-446655440003', '850e8400-e29b-41d4-a716-446655440003', 2449.93, '2024-06-10 12:30:00', 'stripe'),
('950e8400-e29b-41d4-a716-446655440004', '850e8400-e29b-41d4-a716-446655440004', 389.97, '2024-07-20 13:30:00', 'credit_card'),
('950e8400-e29b-41d4-a716-446655440005', '850e8400-e29b-41d4-a716-446655440005', 1399.93, '2024-08-15 14:30:00', 'paypal'),
('950e8400-e29b-41d4-a716-446655440006', '850e8400-e29b-41d4-a716-446655440006', 1399.95, '2024-09-01 15:30:00', 'stripe'),
('950e8400-e29b-41d4-a716-446655440007', '850e8400-e29b-41d4-a716-446655440007', 2309.93, '2024-10-10 16:30:00', 'credit_card'),
('950e8400-e29b-41d4-a716-446655440008', '850e8400-e29b-41d4-a716-446655440008', 949.95, '2024-11-01 17:30:00', 'paypal'),
('950e8400-e29b-41d4-a716-446655440016', '850e8400-e29b-41d4-a716-446655440016', 4049.91, '2024-11-24 10:45:00', 'stripe'),
('950e8400-e29b-41d4-a716-446655440017', '850e8400-e29b-41d4-a716-446655440017', 649.95, '2024-11-24 11:45:00', 'credit_card'),
('950e8400-e29b-41d4-a716-446655440018', '850e8400-e29b-41d4-a716-446655440018', 1959.93, '2024-11-24 12:45:00', 'paypal');

-- =====================================================
-- SEED DATA: Review Table
-- =====================================================
-- Creating reviews for completed bookings

INSERT INTO Review (review_id, property_id, user_id, rating, comment, created_at) VALUES
('a50e8400-e29b-41d4-a716-446655440001', '750e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440008', 5, 'Absolutely stunning loft! The views were incredible and Emily was a wonderful host. The location couldn''t be better - walked to Broadway shows every night. Highly recommend!', '2024-06-06 14:00:00'),
('a50e8400-e29b-41d4-a716-446655440002', '750e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440009', 5, 'Paradise! The ro
