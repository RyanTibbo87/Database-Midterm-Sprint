-- Movie Table
CREATE TABLE IF NOT EXISTS Movies (
  movie_id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  year INT NOT NULL,
  genre VARCHAR(50) NOT NULL,
  director VARCHAR(255) NOT NULL
);
-- Customer Table
CREATE TABLE IF NOT EXISTS Customers (
  customer_id SERIAL PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(15)
);
-- Rental Table
CREATE TABLE IF NOT EXISTS Rentals (
  rental_id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES Customers(customer_id),
  movie_id INT REFERENCES Movies(movie_id),
  rental_date DATE NOT NULL,
  return_date DATE,
  due_date DATE NOT NULL
);

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
