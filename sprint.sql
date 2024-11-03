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