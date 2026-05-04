USE SkyTrack;

--TABLE Airline_Operator
CREATE TABLE Airline_Operator (
Airline_ID INT IDENTITY(1,1) PRIMARY KEY,
IATA_airline_code CHAR(3) NOT NULL UNIQUE,
Full_name VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE,
country_of_registration VARCHAR(100)
);

--TABLE Departure_Gate
CREATE TABLE Departure_Gate (
Departure_ID INT IDENTITY(1,1) PRIMARY KEY,
gate_code VARCHAR(10) NOT NULL,
terminal_name VARCHAR(50),
Airport_ID INT, 
flight_number VARCHAR(10),
FOREIGN KEY (Airport_ID) REFERENCES Airport(Airport_ID),
FOREIGN KEY (flight_number) REFERENCES Flight(flight_number)
);

--TABLE Flight_Delay_Log
CREATE TABLE Flight_Delay_Log (
FlightDelay_ID INT IDENTITY(1,1) PRIMARY KEY,
duration INT, 
reason VARCHAR(255),
flight_number VARCHAR(10),
FOREIGN KEY (flight_number) REFERENCES Flight(flight_number) ON DELETE CASCADE
);
--TABLE Baggage
CREATE TABLE Baggage (
Baggage_ID INT IDENTITY(1,1) PRIMARY KEY,
tag_number VARCHAR(50) NOT NULL UNIQUE,
baggage_type VARCHAR(20) NOT NULL CHECK (baggage_type IN ('Cabin', 'Checked')), 
weight_kg DECIMAL(5,2), 
BookingID INT,
FOREIGN KEY (BookingID) REFERENCES Booking(BookingID) ON DELETE CASCADE
);
--Add to TABLE Flight
ALTER TABLE Flight ADD Airline_ID INT;

ALTER TABLE Flight 
ADD CONSTRAINT FK_Flight_Airline 
FOREIGN KEY (Airline_ID) REFERENCES Airline_Operator(Airline_ID);
-----------------------------------------------------------------------

--Insert Values with requirments

-- 1.At least 4 airlines with different countries and IATA codes
INSERT INTO Airline_Operator (IATA_airline_code, Full_name, email, country_of_registration) VALUES 
('WY', 'Oman Air', 'ops@omanair.com', 'Oman'),           
('EK', 'Emirates', 'ops@emirates.com', 'UAE'),          
('BA', 'British Airways', 'ops@ba.com', 'UK'),           
('AA', 'American Airlines', 'ops@aa.com', 'USA'),        
('AF', 'Air France', 'ops@airfrance.fr', 'France'); 

--2. Insert at least 8 Gates across 3 Airports
INSERT INTO Departure_Gate (gate_code, terminal_name, Airport_ID, flight_number) VALUES 
('A01', 'Terminal 1', 1, 'SK101'), 
('A02', 'Terminal 1', 1, 'SK707'), 
('A03', 'Terminal 1', 1, NULL),    
('B01', 'Terminal 3', 2, 'SK202'), 
('B02', 'Terminal 3', 2, 'SK606'), 
('B03', 'Terminal 3', 2, NULL),    
('C01', 'Terminal 5', 3, 'SK303'), 
('C02', 'Terminal 5', 3, 'SK808'); 

--3. Update at least 6 existing flights to assign them an airline and a gate. Use UPDATE statements for
--this — do not re-insert the flights.

UPDATE Flight SET Airline_ID = 1 WHERE flight_number = 'SK101';
UPDATE Flight SET Airline_ID = 2 WHERE flight_number = 'SK202';
UPDATE Flight SET Airline_ID = 3 WHERE flight_number = 'SK303';
UPDATE Flight SET Airline_ID = 4 WHERE flight_number = 'SK505';
UPDATE Flight SET Airline_ID = 2 WHERE flight_number = 'SK606';
UPDATE Flight SET Airline_ID = 1 WHERE flight_number = 'SK707';

--4. At least 10 baggage records distributed across different bookings. Include both Cabin and Checked
--types. Vary the weights
INSERT INTO Baggage (tag_number, baggage_type, weight_kg, BookingID) VALUES  
('TAG-101', 'Checked', 23.50, 2),
('TAG-102', 'Cabin', 7.00, 2),
('TAG-201', 'Checked', 30.00, 3),
('TAG-202', 'Cabin', 6.20, 3),
('TAG-301', 'Checked', 15.00, 6),
('TAG-302', 'Cabin', 5.50, 6),
('TAG-401', 'Checked', 20.00, 7),
('TAG-501', 'Checked', 25.00, 8),
('TAG-502', 'Cabin', 8.20, 8),
('TAG-601', 'Checked', 21.00, 10);

--5. At least 4 delay log records. Link them only to flights that have a status of 'Delayed' or 'Cancelled' in
--your existing data.

INSERT INTO Flight_Delay_Log (duration, reason, flight_number) VALUES 
(45, 'Adverse Weather', 'SK303'),
(60, 'Air Traffic Control', 'SK707');

INSERT INTO Flight_Delay_Log (duration, reason, flight_number) VALUES 
(120, 'Technical Maintenance Issue', 'SK505'),
(60, 'Late Arrival of Incoming Crew', 'SK707');

----------------------------------------------------------------------------------

--Basic Level
--1. List all airlines and their country of registration, ordered alphabetically by airline name.
SELECT Full_name, country_of_registration 
FROM Airline_Operator 
ORDER BY Full_name ASC;

--2. Show all gates and the airport they belong to.
SELECT g.gate_code, a.Aname AS Airport_Name
FROM Departure_Gate g
JOIN Airport a ON g.Airport_ID = a.Airport_ID;

--3. List all baggage records and their type, ordered by weight from heaviest to lightest.
SELECT tag_number, baggage_type, weight_kg 
FROM Baggage 
ORDER BY weight_kg DESC;

--4. Show all delay log records and the flight they belong to, ordered by recorded datetime.
SELECT FlightDelay_ID, flight_number, reason, duration 
FROM Flight_Delay_Log 
ORDER BY duration;

--5. List all flights that currently have no gate assigned
SELECT f.flight_number 
FROM Flight f
JOIN Departure_Gate g ON f.flight_number = g.flight_number
WHERE g.gate_code IS NULL;




-----------------------------------------------------------------------


--Medium Level
--1. Show each flight with its flight number, airline name, and gate code.
SELECT f.flight_number, ao.Full_name, dg.gate_code
FROM Flight f
JOIN Airline_Operator ao ON f.Airline_ID = ao.Airline_ID
LEFT JOIN Departure_Gate dg ON f.flight_number = dg.flight_number;

--2. List all baggage items along with the passenger name and flight number they are linked to.
SELECT b.tag_number, p.PName as passenger_name, bo.flight_number
FROM Baggage b
JOIN Booking bo ON b.BookingID = bo.BookingID
JOIN Passenger p ON bo.National_ID = p.National_ID;

--3. Count the total number of baggage items per booking. Show the booking ID, passenger name, and
--baggage count.
SELECT bo.BookingID, p.PName as passenger_name , COUNT(b.Baggage_ID) AS Baggage_Count
FROM Booking bo
JOIN Passenger p ON bo.National_ID = p.National_ID
 JOIN Baggage b ON bo.BookingID = b.BookingID
GROUP BY bo.BookingID, p.PName;

--4. Show all delay logs including the flight number, airline name, delay reason, and duration in minutes.
SELECT d.flight_number, ao.Full_name, d.reason, d.duration
FROM Flight_Delay_Log d
JOIN Flight f ON d.flight_number = f.flight_number
JOIN Airline_Operator ao ON f.Airline_ID = ao.Airline_ID;

--5. Find the total weight of checked baggage per flight. Show the flight number and total checked weight.
SELECT bo.flight_number, SUM(b.weight_kg) AS Total_Weight
FROM Baggage b
JOIN Booking bo ON b.BookingID = bo.BookingID
WHERE b.baggage_type = 'Checked'
GROUP BY bo.flight_number;

--6. Count how many flights each airline operates. Order from highest to lowest.
SELECT ao.Full_name, COUNT(f.flight_number) AS Flight_Count
FROM Airline_Operator ao
JOIN Flight f ON ao.Airline_ID = f.Airline_ID
GROUP BY ao.Full_name;

--7. Show all flights that have been delayed more than once. Display the flight number and total number
--of delay records
SELECT flight_number, COUNT(FlightDelay_ID) AS Delay_Count
FROM Flight_Delay_Log
GROUP BY flight_number
HAVING COUNT(FlightDelay_ID) > 1;



-------------------------------------------------------------------------------
--Advance Level

--4. Show each passenger's full name alongside the total number of baggage items they have across all
--their bookings, broken down by type (Cabin and Checked)
SELECT p.PName as passenger_name, b.baggage_type, COUNT(b.Baggage_ID) AS  number_of_baggage
FROM Passenger p
JOIN Booking bo ON p.National_ID = bo.National_ID
JOIN Baggage b ON bo.BookingID = b.BookingID
GROUP BY p.PName, b.baggage_type;

