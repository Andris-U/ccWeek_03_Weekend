DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS screenings;
DROP TABLE IF EXISTS films;
DROP TABLE IF EXISTS customers;


CREATE TABLE customers (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255),
  funds INT4
);

CREATE TABLE films (
  id SERIAL4 PRIMARY KEY,
  title VARCHAR(255),
  price INT4
);

CREATE TABLE screenings (
  id SERIAL4 PRIMARY KEY,
  screening_time VARCHAR(255),
  film_id INT4 REFERENCES films(id) ON DELETE CASCADE,
  seats_sold INT4
);

CREATE TABLE tickets (
  id SERIAL4 PRIMARY KEY,
  customer_id INT4 REFERENCES customers(id),
  screening_id INT4 REFERENCES screenings(id)
);
