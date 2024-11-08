const { Pool } = require("pg");

// PostgreSQL connection
const pool = new Pool({
  user: "postgres", //This _should_ be your username, as it's the default one Postgres uses
  host: "localhost",
  database: "midterm_sprint", //This should be changed to reflect your actual database
  password: "password", //This should be changed to reflect the password you used when setting up Postgres
  port: 5432,
});

/**
 * Creates the database tables, if they do not already exist.
 */
async function createTable() {
  const createMoviesTable = `
    CREATE TABLE IF NOT EXISTS Movies (
      movie_id SERIAL PRIMARY KEY,
      title VARCHAR(255) NOT NULL,
      year INT NOT NULL,
      genre VARCHAR(50) NOT NULL,
      director VARCHAR(255) NOT NULL
    );
  `;

  const createCustomersTable = `
    CREATE TABLE IF NOT EXISTS Customers (
      customer_id SERIAL PRIMARY KEY,
      first_name VARCHAR(100) NOT NULL,
      last_name VARCHAR(100) NOT NULL,
      email VARCHAR(255) UNIQUE NOT NULL,
      phone VARCHAR(15)
    );
  `;

  const createRentalsTable = `
    CREATE TABLE IF NOT EXISTS Rentals (
      rental_id SERIAL PRIMARY KEY,
      customer_id INT REFERENCES Customers(customer_id),
      movie_id INT REFERENCES Movies(movie_id),
      rental_date DATE NOT NULL,
      return_date DATE,
      due_date DATE NOT NULL
    );
  `;

  try {
    await pool.query(createMoviesTable);
    await pool.query(createCustomersTable);
    await pool.query(createRentalsTable);
    console.log("Tables created successfully!");
  } catch (error) {
    console.error("Error creating tables:", error);
  }
}

/**
 * Inserts a new movie into the Movies table.
 *
 * @param {string} title Title of the movie
 * @param {number} year Year the movie was released
 * @param {string} genre Genre of the movie
 * @param {string} director Director of the movie
 */
async function insertMovie(title, year, genre, director) {
  const query = `
    INSERT INTO Movies (title, year, genre, director)
    VALUES ($1, $2, $3, $4)
    RETURNING *;
  `;
  try {
    const res = await pool.query(query, [title, year, genre, director]);
    console.log("Movie inserted:", res.rows[0]);
  } catch (error) {
    console.error("Error inserting movie:", error);
  }
}

/**
 * Prints all movies in the database to the console
 */
async function displayMovies() {
  try {
    const res = await pool.query("SELECT * FROM Movies;");
    console.log("Movies:");
    res.rows.forEach((movie) => {
      console.log(
        `${movie.title} (${movie.year}) - Genre: ${movie.genre}, Director: ${movie.director}`
      );
    });
  } catch (error) {
    console.error("Error retrieving movies:", error);
  }
}

/**
 * Updates a customer's email address.
 *
 * @param {number} customerId ID of the customer
 * @param {string} newEmail New email address of the customer
 */
async function updateCustomerEmail(customerId, newEmail) {
  try {
    const res = await pool.query(
      "UPDATE Customers SET email = $1 WHERE customer_id = $2 RETURNING *;",
      [newEmail, customerId]
    );
    if (res.rowCount > 0) {
      console.log(`Customer email updated to ${newEmail}`);
    } else {
      console.log("Customer not found.");
    }
  } catch (error) {
    console.error("Error updating customer email:", error);
  }
}

/**
 * Removes a customer from the database along with their rental history.
 *
 * @param {number} customerId ID of the customer to remove
 */
async function removeCustomer(customerId) {
  try {
    await pool.query("DELETE FROM Rentals WHERE customer_id = $1;", [
      customerId,
    ]);
    const res = await pool.query(
      "DELETE FROM Customers WHERE customer_id = $1 RETURNING *;",
      [customerId]
    );
    if (res.rowCount > 0) {
      console.log("Customer and their rental history removed successfully.");
    } else {
      console.log("Customer not found.");
    }
  } catch (error) {
    console.error("Error removing customer:", error);
  }
}

/**
 * Prints a help message to the console
 */
function printHelp() {
  console.log("Usage:");
  console.log("  insert <title> <year> <genre> <director> - Insert a movie");
  console.log("  show - Show all movies");
  console.log("  update <customer_id> <new_email> - Update a customer's email");
  console.log("  remove <customer_id> - Remove a customer from the database");
}

/**
 * Runs our CLI app to manage the movie rentals database
 */
async function runCLI() {
  await createTable();

  const args = process.argv.slice(2);
  switch (args[0]) {
    case "insert":
      if (args.length !== 5) {
        printHelp();
        return;
      }
      await insertMovie(args[1], parseInt(args[2]), args[3], args[4]);
      break;
    case "show":
      await displayMovies();
      break;
    case "update":
      if (args.length !== 3) {
        printHelp();
        return;
      }
      await updateCustomerEmail(parseInt(args[1]), args[2]);
      break;
    case "remove":
      if (args.length !== 2) {
        printHelp();
        return;
      }
      await removeCustomer(parseInt(args[1]));
      break;
    default:
      printHelp();
      break;
  }
}

runCLI();
