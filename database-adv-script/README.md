# ALX Airbnb Database - Advanced SQL Querying

## Project Overview

This project is part of the ALX Airbnb Database Module, focusing on implementing advanced SQL querying and optimization techniques for a simulated Airbnb database. The goal is to gain hands-on experience with database management, performance tuning, and complex query writing.

## Learning Objectives

- Master advanced SQL techniques including joins, subqueries, and aggregations
- Optimize query performance using tools like EXPLAIN and ANALYZE
- Implement indexing and partitioning strategies
- Monitor and refine database performance
- Develop DBA-level thinking for schema design and optimization

## Directory Structure

```
alx-airbnb-database/
└── database-adv-script/
    ├── joins_queries.sql
    └── README.md
```

## Task 0: Complex Queries with Joins

### Objective
Master SQL joins by writing complex queries using different types of joins to retrieve data from multiple related tables.

### Files
- `joins_queries.sql` - Contains all SQL queries demonstrating different join types

### Queries Implemented

#### 1. INNER JOIN - Bookings with Users
**Purpose**: Retrieve all bookings along with the respective users who made those bookings.

**What it does**:
- Combines the `Booking` and `User` tables
- Returns only records where there's a match between both tables
- Useful for seeing complete booking information with user details

**Use Case**: Generate reports showing who booked which properties and when.

#### 2. LEFT JOIN - Properties with Reviews
**Purpose**: Retrieve all properties and their reviews, including properties that have no reviews.

**What it does**:
- Returns all properties from the `Property` table
- Includes matching reviews from the `Review` table
- Properties without reviews show NULL in review columns
- Ensures no property is excluded from results

**Use Case**: Identify properties that need more reviews or analyze review coverage across all listings.

#### 3. FULL OUTER JOIN - Users and Bookings
**Purpose**: Retrieve all users and all bookings, even if a user has no booking or a booking is not linked to a user.

**What it does**:
- Returns all users, including those who haven't made bookings
- Returns all bookings, including orphaned bookings (if any)
- Provides complete visibility into both tables

**Implementation Note**: MySQL doesn't support FULL OUTER JOIN natively, so the query uses a UNION of LEFT JOIN and RIGHT JOIN to achieve the same result.

**Use Case**: Identify inactive users or data integrity issues with unlinked bookings.

## Database Schema Assumptions

This project assumes the following table structure:

### User Table
- `user_id` (Primary Key)
- `first_name`
- `last_name`
- `email`
- Other user attributes

### Booking Table
- `booking_id` (Primary Key)
- `user_id` (Foreign Key → User)
- `property_id` (Foreign Key → Property)
- `start_date`
- `end_date`
- `total_price`
- `status`
- `created_at`

### Property Table
- `property_id` (Primary Key)
- `name`
- `location`
- `pricepernight`
- Other property attributes

### Review Table
- `review_id` (Primary Key)
- `property_id` (Foreign Key → Property)
- `rating`
- `comment`
- `created_at`

## How to Run

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/alx-airbnb-database.git
   cd alx-airbnb-database/database-adv-script
   ```

2. **Execute the queries**:
   ```bash
   # For MySQL
   mysql -u your_username -p your_database < joins_queries.sql

   # Or run interactively
   mysql -u your_username -p your_database
   source joins_queries.sql;
   ```

3. **View results**: Each query will return results based on your database content.

## Key Concepts

### INNER JOIN
- Returns only matching rows from both tables
- Most restrictive join type
- Use when you need data that exists in both tables

### LEFT JOIN (LEFT OUTER JOIN)
- Returns all rows from the left table
- Matching rows from the right table (NULL if no match)
- Use when you need all records from one table regardless of matches

### FULL OUTER JOIN
- Returns all rows from both tables
- NULL where there's no match
- Use for comprehensive data analysis including orphaned records

## Performance Considerations

- **Indexes**: Ensure foreign key columns (`user_id`, `property_id`) are indexed
- **Query optimization**: Use EXPLAIN to analyze query execution plans
- **Large datasets**: Consider adding WHERE clauses to limit result sets in production

## Next Steps

Future tasks in this project will cover:
- Subqueries (correlated and non-correlated)
- Aggregation functions and window functions
- Query optimization techniques
- Indexing strategies
- Table partitioning
- Performance monitoring

## Author

ALX Africa - Software Engineering Program

## Repository

- **GitHub repository**: `alx-airbnb-database`
- **Directory**: `database-adv-script`
- **Files**: `joins_queries.sql`, `README.md`
