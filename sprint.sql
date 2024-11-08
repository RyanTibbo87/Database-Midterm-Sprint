-- Movie Table
CREATE TABLE IF NOT EXISTS Movies (
  movie_id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  year INT NOT NULL,
  genre VARCHAR(50) NOT NULL,
  director VARCHAR(255) NOT NULL
);
-- The Movies table is in 3NF because:
-- 1. It has no repeating groups, meeting 1NF.
-- 2. All non-primary key columns (title, year, genre, director) depend on the primary key (movie_id), meeting 2NF.
-- 3. No non-primary key column depends on another non-primary key column (e.g., genre doesn't depend on title or director),
--    ensuring no transitive dependencies, thus meeting 3NF.

-- Customer Table
CREATE TABLE IF NOT EXISTS Customers (
  customer_id SERIAL PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(15)
);
-- The Customers table is in 3NF because:
-- 1. It has no repeating groups, meeting 1NF.
-- 2. All non-primary key columns (first_name, last_name, email, phone) depend on the primary key (customer_id), meeting 2NF.
-- 3. No non-primary key column is dependent on another non-primary key column (e.g., email is not dependent on phone),
--    ensuring no transitive dependencies, thus meeting 3NF.

-- Rental Table
CREATE TABLE IF NOT EXISTS Rentals (
  rental_id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES Customers(customer_id),
  movie_id INT REFERENCES Movies(movie_id),
  rental_date DATE NOT NULL,
  return_date DATE,
  due_date DATE NOT NULL
);
-- The Rentals table is in 3NF because:
-- 1. It has no repeating groups, meeting 1NF.
-- 2. All non-primary key columns (customer_id, movie_id, rental_date, return_date, due_date) depend on the primary key (rental_id), meeting 2NF.
-- 3. There are no transitive dependencies; no non-primary key column depends on another non-primary key column.
--    For instance, customer_id and movie_id are foreign keys but do not create transitive dependencies within this table.

-- Sample Data

-- Movies
INSERT INTO Movies (title, year, genre, director) VALUES
  ('Everything Everywhere All at Once', 2022, 'Adventure/Comedy/Drama', 'Daniel Kwan, Daniel Scheinert'),
  ('Dune', 2021, 'Sci-Fi/Adventure', 'Denis Villeneuve'),
  ('The Batman', 2022, 'Action/Crime/Drama', 'Matt Reeves'),
  ('Top Gun: Maverick', 2022, 'Action/Drama', 'Joseph Kosinski'),
  ('Oppenheimer', 2023, 'Biography/Drama/History', 'Christopher Nolan');

-- Customers
INSERT INTO Customers (first_name, last_name, email, phone) VALUES
  ('John', 'Doe', 'john.doe@example.com', '123-456-7890'),
  ('Jane', 'Smith', 'jane.smith@example.com', '098-765-4321'),
  ('Alice', 'Johnson', 'alice.johnson@example.com', '555-123-4567'),
  ('Matthew', 'English', 'matthew.english@example.com', '111-222-3333'),
  ('Ryan', 'Tibbo', 'ryan.tibbo@example.com', '444-555-6666');

  -- Rentals
INSERT INTO Rentals (customer_id, movie_id, rental_date, due_date) VALUES
  (1, 1, '2024-11-01', '2024-11-08'), -- John Doe rented 'Everything Everywhere All at Once'
  (2, 2, '2024-11-02', '2024-11-09'), -- Jane Smith rented 'Dune'
  (3, 3, '2024-11-03', '2024-11-10'), -- Alice Johnson rented 'The Batman'
  (4, 4, '2024-11-04', '2024-11-11'), -- Matthew English rented 'Top Gun: Maverick'
  (5, 5, '2024-11-05', '2024-11-12'), -- Ryan Tibbo rented 'Oppenheimer'
  (1, 3, '2024-11-06', '2024-11-13'), -- John Doe rented 'The Batman'
  (2, 5, '2024-11-07', '2024-11-14'), -- Jane Smith rented 'Oppenheimer'
  (3, 4, '2024-11-08', '2024-11-15'), -- Alice Johnson rented 'Top Gun: Maverick'
  (4, 1, '2024-11-09', '2024-11-16'), -- Matthew English rented 'Everything Everywhere All at Once'
  (5, 2, '2024-11-10', '2024-11-17'); -- Ryan Tibbo rented 'Dune'

-- Find all movies rented by a specific customer
SELECT m.title, r.rental_date, r.due_date
FROM Rentals r
JOIN Customers c ON r.customer_id = c.customer_id
JOIN Movies m ON r.movie_id = m.movie_id
WHERE c.email = 'john.doe@example.com';

-- Given a movie title, list all customers who have rented the movie
SELECT c.first_name, c.last_name, c.email, r.rental_date
FROM Rentals r
JOIN Customers c ON r.customer_id = c.customer_id
JOIN Movies m ON r.movie_id = m.movie_id
WHERE m.title = 'Dune';

-- Get the rental history for a specific movie title
SELECT c.first_name, c.last_name, r.rental_date, r.return_date
FROM Rentals r
JOIN Customers c ON r.customer_id = c.customer_id
JOIN Movies m ON r.movie_id = m.movie_id
WHERE m.title = 'The Batman';

-- For a specific movie director, find customer names, rental dates, and movie titles rented
SELECT c.first_name, c.last_name, r.rental_date, m.title
FROM Rentals r
JOIN Customers c ON r.customer_id = c.customer_id
JOIN Movies m ON r.movie_id = m.movie_id
WHERE m.director = 'Christopher Nolan';

-- List all currently rented out movies
SELECT m.title, r.rental_date, r.due_date
FROM Rentals r
JOIN Movies m ON r.movie_id = m.movie_id
WHERE r.return_date IS NULL OR r.return_date > CURRENT_DATE;
