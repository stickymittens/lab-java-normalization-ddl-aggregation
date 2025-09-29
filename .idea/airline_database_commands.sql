CREATE DATABASE IF NOT EXISTS airline_database;
USE airline_database;

CREATE DATABASE IF NOT EXISTS airline_database;
USE airline_database;

CREATE TABLE airline_database (
                                  customer_name VARCHAR(100),
                                  customer_status VARCHAR(20),
                                  flight_number VARCHAR(10),
                                  aircraft VARCHAR(50),
                                  total_aircraft_seats INT,
                                  flight_mileage INT,
                                  total_customer_mileage BIGINT
);

INSERT INTO airline_database (
    customer_name, customer_status, flight_number, aircraft, total_aircraft_seats, flight_mileage, total_customer_mileage
) VALUES
      ('Agustine Riviera','Silver','DL143','Boeing 747',400,135,115235),
      ('Agustine Riviera','Silver','DL122','Airbus A330',236,4370,115235),
      ('Alaina Sepulvida','None','DL122','Airbus A330',236,4370,6008),
      ('Agustine Riviera','Silver','DL143','Boeing 747',400,135,115235),
      ('Tom Jones','Gold','DL122','Airbus A330',236,4370,205767),
      ('Tom Jones','Gold','DL53','Boeing 777',264,2078,205767),
      ('Agustine Riviera','Silver','DL143','Boeing 747',400,135,115235),
      ('Sam Rio','None','DL143','Boeing 747',400,135,2653),
      ('Agustine Riviera','Silver','DL143','Boeing 747',400,135,115235),
      ('Tom Jones','Gold','DL222','Boeing 777',264,1765,205767),
      ('Jessica James','Silver','DL143','Boeing 747',400,135,127656),
      ('Sam Rio','None','DL143','Boeing 747',400,135,2653),
      ('Christian Janco','Silver','DL222','Boeing 777',264,1765,14642);


# aircrafts - aircraft, total_aircraft_seats
CREATE TABLE aircrafts (
                           aircraft VARCHAR(50),
                           total_aircraft_seats INT
);

ALTER TABLE aircrafts
    ADD PRIMARY KEY (aircraft);

INSERT INTO aircrafts (aircraft, total_aircraft_seats)
SELECT DISTINCT aircraft, total_aircraft_seats
FROM airline_database;

SELECT * FROM aircrafts;

# flights - flight no, AIRCRAFT, flight mileage
CREATE TABLE flights (
    flight_number VARCHAR(10) UNIQUE PRIMARY KEY,
    aircraft VARCHAR(50),
    flight_mileage INT,
    FOREIGN KEY (aircraft) REFERENCES aircrafts(aircraft)
);

INSERT INTO flights (flight_number, aircraft, flight_mileage)
SELECT DISTINCT flight_number, aircraft, flight_mileage
FROM airline_database;

SELECT * FROM flights;

#customers - name, status, total mileage
CREATE TABLE customers (
    customer_name VARCHAR(100) PRIMARY KEY,
    customer_status VARCHAR(20),
    total_customer_mileage BIGINT
);

INSERT INTO customers(customer_name, customer_status, total_customer_mileage)
SELECT DISTINCT customer_name, customer_status, total_customer_mileage
FROM airline_database;

SELECT * FROM customers;

# bookings - CUSTOMER, FLIGHT_NUMBER
CREATE TABLE bookings (
    customer_name VARCHAR(100),
    flight_number VARCHAR(10),
    PRIMARY KEY (customer_name, flight_number),
    FOREIGN KEY (customer_name) REFERENCES customers(customer_name),
    FOREIGN KEY (flight_number) REFERENCES flights(flight_number)
);

INSERT INTO bookings (customer_name, flight_number)
SELECT DISTINCT customer_name, flight_number
FROM airline_database;

SELECT * FROM bookings;


###


#EXERCISE 3
SELECT COUNT(DISTINCT flight_number) FROM flights;
#4

SELECT AVG(flight_mileage) FROM flights;
#2087

SELECT AVG(total_aircraft_seats) FROM aircrafts;
#300

SELECT customer_status, AVG(customers.total_customer_mileage) FROM customers GROUP BY customer_status;
#Silver,85844.3333
#None,4330.5000
#Gold,205767.0000

SELECT customer_status, MAX(total_customer_mileage) FROM customers GROUP BY customer_status;
#Silver,127656
#None,6008
#Gold,205767

SELECT COUNT(*) FROM aircrafts WHERE aircraft LIKE '%Boeing%';
#2

SELECT * FROM flights WHERE flight_mileage BETWEEN 300 AND 2000;
#DL222,Boeing 777,1765

SELECT c.customer_status, AVG(f.flight_mileage)
FROM bookings b
         JOIN customers c ON b.customer_name = c.customer_name
         JOIN flights f ON b.flight_number = f.flight_number
GROUP BY c.customer_status;
#Silver,1601.2500
#None,2252.5000
#Gold,2737.6667

SELECT a.aircraft, COUNT(*) AS total_bookings
FROM bookings b
         JOIN customers c ON b.customer_name = c.customer_name
         JOIN flights f ON b.flight_number = f.flight_number
         JOIN aircrafts a ON f.aircraft = a.aircraft
WHERE c.customer_status = 'Gold'
GROUP BY a.aircraft
ORDER BY total_bookings DESC
LIMIT 1;
#Boeing 777, 2