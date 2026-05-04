CREATE DATABASE SkyTrack;

CREATE TABLE Airport (
Airport_ID INT IDENTITY(1,1) PRIMARY KEY,
IATA_Code CHAR(3) NOT NULL UNIQUE,
Aname VARCHAR(100) NOT NULL,
city VARCHAR(100) NOT NULL,
country VARCHAR(100) NOT NULL
);

CREATE TABLE Aircraft (
Aircraft_ID INT IDENTITY(1,1) PRIMARY KEY,
Registration_Number VARCHAR(20) NOT NULL UNIQUE,
Total_Seating_Capacity INT NOT NULL CHECK (Total_Seating_Capacity > 0),
Year_of_Manufacture INT,
Model VARCHAR(50) NOT NULL,
Manufacturer VARCHAR(50) NOT NULL
);

CREATE TABLE Flight (
flight_number VARCHAR(10) NOT NULL PRIMARY KEY,
Departure_Datetime DATETIME NOT NULL,
arrival_datetime DATETIME NOT NULL,
status VARCHAR(20) NOT NULL DEFAULT 'Scheduled' 
   CHECK (status IN ('Scheduled', 'Delayed', 'Cancelled', 'Completed')),
IATA_Code_Departs CHAR(3),
IATA_Code_Arrives CHAR(3),
Registration_Number VARCHAR(20),
CONSTRAINT CHK_Flight_Time CHECK (arrival_datetime > Departure_Datetime),
FOREIGN KEY (IATA_Code_Departs) REFERENCES Airport(IATA_Code) 
ON DELETE NO ACTION ON UPDATE NO ACTION,
FOREIGN KEY (IATA_Code_Arrives) REFERENCES Airport(IATA_Code) 
ON DELETE NO ACTION ON UPDATE NO ACTION,
FOREIGN KEY (Registration_Number) REFERENCES Aircraft(Registration_Number) 
ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Crew_Member (
Crew_ID INT IDENTITY(1,1) PRIMARY KEY,
License_Number VARCHAR(20) NOT NULL UNIQUE,
Full_Name VARCHAR(100) NOT NULL,
Role VARCHAR(20) NOT NULL 
CHECK (Role IN ('Pilot', 'Co-Pilot', 'Flight Attendant', 'Engineer'))
);


CREATE TABLE Crew_Flights (
Crew_ID INT, 
flight_number VARCHAR(10),
PRIMARY KEY (Crew_ID, flight_number),
FOREIGN KEY (Crew_ID) REFERENCES Crew_Member(Crew_ID) 
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (flight_number) REFERENCES Flight(flight_number) 
ON DELETE CASCADE ON UPDATE CASCADE
);



CREATE TABLE Passenger (
Passenger_ID INT IDENTITY(1,1) PRIMARY KEY,
National_ID VARCHAR(20) NOT NULL UNIQUE,
PName VARCHAR(100) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE,
phone VARCHAR(20),
nationality VARCHAR(50) NOT NULL,
DOB DATE NOT NULL
);

CREATE TABLE Booking (
BookingID INT IDENTITY(1,1) PRIMARY KEY,
Seat_Number VARCHAR(10) NOT NULL,
Price_Paid DECIMAL(10, 2) NOT NULL CHECK (Price_Paid > 0),
Class VARCHAR(20) NOT NULL 
CHECK (Class IN ('Economy', 'Business', 'First')),
Booking_Date DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
National_ID VARCHAR(20),
flight_number VARCHAR(10),
FOREIGN KEY (National_ID) REFERENCES Passenger(National_ID) 
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (flight_number) REFERENCES Flight(flight_number) 
ON DELETE CASCADE ON UPDATE CASCADE
);


-- 1. DATA SET FOR Airports
INSERT INTO Airport (IATA_Code, Aname, city, country) VALUES 
('MCT', 'Muscat International', 'Muscat', 'Oman'),
('DXB', 'Dubai International', 'Dubai', 'UAE'),
('LHR', 'Heathrow Airport', 'London', 'UK'),
('JFK', 'John F. Kennedy', 'New York', 'USA'),
('CDG', 'Charles de Gaulle', 'Paris', 'France');


-- 2. DATA SET Aircraft
INSERT INTO Aircraft (Registration_Number, Total_Seating_Capacity, Year_of_Manufacture, Model, Manufacturer) VALUES 
('A6-EEO', 500, 2015, 'A380', 'Airbus'),
('G-XWB', 300, 2018, 'A350', 'Airbus'),
('N787J', 250, 2019, '787 Dreamliner', 'Boeing'),
('A4O-BA', 180, 2017, '737 MAX', 'Boeing'),
('F-GZCP', 350, 2016, '777', 'Boeing');



-- 3. DATA SET FOR Flights

INSERT INTO Flight (flight_number, Departure_Datetime, arrival_datetime, status, IATA_Code_Departs, IATA_Code_Arrives, Registration_Number) VALUES 
('SK101', '2026-05-10 08:00', '2026-05-10 09:30', 'Completed', 'MCT', 'DXB', 'A4O-BA'),
('SK202', '2026-05-11 10:00', '2026-05-11 18:00', 'Scheduled', 'DXB', 'LHR', 'A6-EEO'),
('SK303', '2026-05-12 14:00', '2026-05-12 23:00', 'Delayed', 'LHR', 'JFK', 'G-XWB'),
('SK404', '2026-05-13 09:00', '2026-05-13 11:00', 'Cancelled', 'JFK', 'CDG', 'N787J'),
('SK505', '2026-05-14 20:00', '2026-05-15 05:00', 'Scheduled', 'CDG', 'MCT', 'F-GZCP'),
('SK606', '2026-05-15 12:00', '2026-05-15 14:00', 'Completed', 'DXB', 'MCT', 'A4O-BA'),
('SK707', '2026-05-16 11:00', '2026-05-16 19:00', 'Scheduled', 'MCT', 'LHR', 'G-XWB'),
('SK808', '2026-05-17 01:00', '2026-05-17 06:00', 'Scheduled', 'LHR', 'DXB', 'A6-EEO');






-- 4.DATA SET FOR  Passengers
INSERT INTO Passenger (National_ID, PName, email, phone, nationality, DOB) VALUES 
('O001', 'Ahmed Al-Said', 'ahmed@mail.om', '99112233', 'Omani', '1985-05-10'),
('O002', 'Fatma Al-Balushi', 'fatma@mail.om', '99445566', 'Omani', '1990-12-15'),
('U001', 'John Smith', 'john@mail.com', '44123456', 'British', '1975-03-20'),
('A001', 'Sarah Jones', 'sarah@mail.us', '15550101', 'American', '1988-07-04'),
('F001', 'Pierre Dubois', 'pierre@mail.fr', '33061234', 'French', '1992-11-30'),
('E001', 'Mohammed Rashid', 'mo@mail.ae', '97150123', 'Emirati', '1982-01-25'),
('O003', 'Salim Al-Harthy', 'salim@mail.om', '99887700', 'Omani', '1995-06-18'),
('I001', 'Ravi Kumar', 'ravi@mail.in', '91987654', 'Indian', '1980-08-12');



-- 5. DATA SET FOR Booking

INSERT INTO Booking (Seat_Number, Price_Paid, Class, Booking_Date, National_ID, flight_number) VALUES 
('12A', 150.00, 'Economy', '2026-05-01', 'O001', 'SK101'),
('01K', 600.00, 'First', '2026-05-01', 'O002', 'SK101'),
('15C', 450.00, 'Business', '2026-05-02', 'U001', 'SK202'),
('05D', 800.00, 'First', '2026-05-02', 'A001', 'SK303'),
('22B', 120.00, 'Economy', '2026-05-03', 'F001', 'SK404'),
('10A', 550.00, 'Business', '2026-05-03', 'E001', 'SK505'),
('18F', 140.00, 'Economy', '2026-05-04', 'O003', 'SK606'),
('02A', 900.00, 'First', '2026-05-04', 'I001', 'SK707'),
('14D', 160.00, 'Economy', '2026-05-05', 'O001', 'SK202'),
('08C', 480.00, 'Business', '2026-05-05', 'U001', 'SK101');


-- 6. DATA SET FOR Crew Members
INSERT INTO Crew_Member (License_Number, Full_Name, Role) VALUES 
('L001', 'Capt. Khalid', 'Pilot'),
('L002', 'Capt. Emily', 'Pilot'),
('L003', 'First Officer Ali', 'Co-Pilot'),
('L004', 'Mona Zaki', 'Flight Attendant'),
('L005', 'Jack Wilson', 'Flight Attendant'),
('L006', 'Steve Jobs', 'Engineer');




-- 7. DATA SET FOR Assigning Crew to Flight
INSERT INTO Crew_Flights (Crew_ID, flight_number) VALUES 
(1, 'SK101'), (4, 'SK101'), 
(2, 'SK202'), (5, 'SK202'),
(1, 'SK303'), (4, 'SK303'),
(2, 'SK404'), (5, 'SK404'),
(1, 'SK505'), (4, 'SK505'),
(2, 'SK606'), (5, 'SK606'),
(1, 'SK707'), (4, 'SK707'),
(2, 'SK808'), (5, 'SK808');




-- UPDATE Tasks
--1. Update one flight status from 'Scheduled' to 'Completed':
UPDATE Flight SET status = 'Completed' WHERE flight_number = 'SK202';

--2. Change one flight status from 'Delayed' to 'Cancelled':
UPDATE Flight SET status = 'Cancelled' WHERE flight_number = 'SK303';

--3. Increase all Economy class booking prices by 10%.
UPDATE Booking SET Price_Paid = Price_Paid * 1.10 WHERE Class = 'Economy';

--4. Update one passenger's phone number.
UPDATE Passenger SET phone ='92672178' WHERE Passenger_ID ='1';

--5. Move one crew member to a different role.
UPDATE Crew_Member SET Role = 'Pilot' WHERE Full_Name = 'First Officer Ali';

--DELETE Tasks
--1. Delete one cancelled flight.
SELECT * FROM Flight WHERE flight_number = 'SK404';
DELETE FROM Flight WHERE flight_number = 'SK404';

SELECT * FROM Crew_Member;
--2. Delete one booking linked to a cancelled flight.

SELECT * FROM Booking WHERE flight_number = 'SK303';
DELETE FROM Booking WHERE flight_number = 'SK303' AND Seat_Number = '05D';


--3. Try to delete a passenger who has existing bookings. Observe what happens and write a short
--comment in your SQL file explaining the result.
SELECT * FROM Passenger WHERE National_ID = 'O001';
DELETE FROM Passenger WHERE National_ID = 'O001';

--Result : 
--because we set (ON DELETE CASCADE) on the Booking table foreign key, 
--the delete will succeed and automatically delete all bookings associated 
--with this passenger.




--Part 3: Data Queries
--Basic Level

--1. List all flights and their current status, 
--ordered by departure datetime from earliest to latest.
SELECT flight_number, status, Departure_Datetime FROM Flight
ORDER BY Departure_Datetime ASC;



--2. Show all passengers, ordered alphabetically by full name.
SELECT * FROM Passenger ORDER BY PName ASC;

--3. List all aircraft and their seating capacity, ordered from largest to smallest.

SELECT Model, Total_Seating_Capacity FROM Aircraft ORDER BY Total_Seating_Capacity DESC;

--4. Show all bookings and their class. Display only distinct class values that exist in the system.
SELECT DISTINCT Class FROM Booking;

 --5. List all flights that have a status of 'Delayed' or 'Cancelled'.
 SELECT * FROM Flight WHERE status IN ('Delayed', 'Cancelled');

 --6. Show all passengers whose nationality is 'Omani'.
 SELECT * FROM Passenger WHERE nationality = 'Omani';

 --7. List all airports, ordered by country.
 SELECT * FROM Airport ORDER BY country;


 --Medium Level
--1. For each flight, show the flight number, the name of the origin airport, and the name of the destination
--airport
SELECT f.flight_number, Aa.Aname AS Arrives , Ab.Aname AS Departs 
FROM Flight f
JOIN Airport Aa ON f.IATA_Code_Departs = Aa.IATA_Code
JOIN Airport Ab ON f.IATA_Code_Arrives = Ab.IATA_Code;


--2. Show each booking along with the full name of the passenger who made it and the flight number it
--belongs to.

SELECT B.BookingID, P.PName, B.flight_number 
FROM Booking B
JOIN Passenger P ON B.National_ID = P.National_ID;

--3. List all crew members assigned to flight 'SK101', showing their full name and role.
SELECT CM.Full_Name, CM.Role 
FROM Crew_Flights CF
JOIN Crew_Member CM ON CF.Crew_ID = CM.Crew_ID
WHERE CF.flight_number = 'SK101';

--4. Show all completed flights along with the aircraft model used on each flight.

SELECT F.flight_number, A.Model ,F.status
FROM Flight F
JOIN Aircraft A ON F.Registration_Number = A.Registration_Number
WHERE F.status = 'Completed';


--5. For each passenger, show their full name and the total number of bookings they have made. Order
--by booking count from highest to lowest.

SELECT P.PName , COUNT(B.BookingID) AS total_bookings
FROM Passenger P
JOIN Booking B ON P.National_ID=B.National_ID
GROUP BY P.PName
ORDER BY total_bookings DESC;

--6. Show the total revenue collected from each booking class

SELECT Class, SUM(Price_Paid) AS Revenue FROM Booking 
GROUP BY Class;

--7. Count how many flights each aircraft has been assigned to.
SELECT Registration_Number, COUNT(flight_number) AS NO_OF_FLIGHTS
FROM Flight 
GROUP BY Registration_Number;

--8. List all flights that have more than one booking
SELECT flight_number , COUNT(BookingID) AS Total_Bookings FROM Booking
GROUP BY flight_number
HAVING COUNT(BookingID) > 1 ;



--9. Show the full details of all bookings — passenger name, flight number, origin airport, destination
--airport, class, and price paid
SELECT P.PName as name, B.flight_number, F.IATA_Code_Departs as Departs , F.IATA_Code_Arrives as Arrives, B.Class, B.Price_Paid
FROM Booking B
JOIN Passenger P ON B.National_ID = P.National_ID
JOIN Flight F ON B.flight_number = F.flight_number;

--Advanced Level
--1. Show each flight with its flight number, origin airport, destination airport, aircraft model, and the total
--number of passengers booked on it. Include flights that have no bookings.

SELECT F.flight_number, F.IATA_Code_Departs as Departs, F.IATA_Code_Arrives as Arrives, A.Model, COUNT(B.BookingID) AS Total_Passengers
FROM Flight F
JOIN Booking B ON F.flight_number = B.flight_number
JOIN Aircraft A ON F.Registration_Number = A.Registration_Number
GROUP BY F.flight_number, F.IATA_Code_Departs, F.IATA_Code_Arrives, A.Model;


--2. List all passengers who have never made a booking
SELECT P.PName
FROM Passenger P
LEFT JOIN Booking B ON P.National_ID = B.National_ID
WHERE B.National_ID IS NULL;

--For each flight, show the flight number and the total revenue generated from its bookings. Show only
--flights where the total revenue exceeds 500. Order from highest to lowest.
SELECT flight_number, SUM(Price_Paid) AS revenue 
FROM Booking 
GROUP BY flight_number 
HAVING SUM(Price_Paid) > 500 
ORDER BY revenue DESC;

--4. Show each crew member's full name and the total number of flights they have been assigned to.
--Show only crew members assigned to more than one flight.

SELECT CM.Full_Name, COUNT(CF.flight_number) AS NO_OF_FLIGHT
FROM Crew_Member CM
JOIN Crew_Flights CF ON CM.Crew_ID = CF.Crew_ID
GROUP BY CM.Full_Name
HAVING COUNT(CF.flight_number) > 1;


--7. For each booking class, show the total revenue, the number of bookings, the average price, the
--highest price, and the lowest price.

SELECT Class, SUM(Price_Paid) AS Total_Rev, COUNT(*) AS Count_of_booking, AVG(Price_Paid) AS Avg, MAX(Price_Paid) AS Max, MIN(Price_Paid) AS Min
FROM Booking 
GROUP BY Class;


--I didn't understand the other questions