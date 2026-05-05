# SkyTrack Airline System

Description:

The SkyTrack Airline System is a database designed to manage flight schedules, passenger bookings, and aircraft maintenance. It ensures data integrity across complex relationships between travelers and flight logistics.

ERD Summary:

Main Parts: We track Airports, Flights, Aircraft, Crew Members, Passengers, and Bookings.  
How they connect:
A Flight links a departure airport to an arrival airport.  
An Aircraft is assigned to a specific flight.  
A Booking connects a Passenger to a specific Flight.  

Mapping Decisions :
Flight Connections:
I put IATA_Code_Departs and IATA_Code_Arrives in the Flight table to show the start and end of a trip. 

Linking Everything:
The Booking table uses National_ID and flight_number to link people to their flights.
The Crew_Flights table links many crew members to many different flights.


 Fixing Errors:
 I faced two main technical problems during this project:
 Multiple Cascade Paths:
 While creating the Flight table, i got an error because having multiple "ON DELETE CASCADE" paths to the same table can confuse the database. I resolved this by using ON DELETE NO ACTION for the airport connections.
 
 Syntax Errors:
I tried to use WHERE to filter a count. I learned that you must use HAVING when you are filtering groups of data, like a count of bookings. 

WHERE vs. HAVING :
WHERE: This is like a filter for a single row. Use it to find a specific person or one flight.
HAVING: This is like a filter for a big group. Use it when you want to find flights with "more than 5" passengers.

My Most Useful Query:

SELECT flight_number, SUM(Price_Paid) AS revenue 
FROM Booking 
GROUP BY flight_number 
HAVING SUM(Price_Paid) > 500;

This query is the most useful because it tells the airline which flights are making the most money. It helps them decide which routes are successful.


# After Change Request – CR-001: Extended System Information

1.Modified and New Tables:
A.Modified Existing Tables:
Flight: Modified using ALTER TABLE to add an Airline_ID. This  many-to-one relationship between flights and their operators, allowing the system to track which   airline is responsible for which flight.

B.Newly Added Tables
Airline_Operator: Stores  details of airlines.

Departure_Gate: Tracks gate within specific airport terminals.

Flight_Delay_Log: Captures data for every incident that causes a delay.

Baggage: Links physical luggage to specific passenger bookings.

3. Challenges in Altering Data-Rich Tables:
Adding the Airline_ID to the Flight table after data was already inserted presented a common SQL challenge:

A.Nullable Columns: When adding a new Foreign Key column to a table with existing rows, the column must initially allow NULL values (or have a default value). Otherwise, the ALTER TABLE statement would fail because existing rows wouldn't have an airline assigned yet.

B.Referential Integrity: I had to ensure that the Airline_Operator table was populated before attempting to update the Flight table with Airline_ID values, or the constraints would have conflict error.


4. Justification referential actions
You used ON DELETE CASCADE for Baggage and Flight_Delay_Log.

Baggage: If a booking is deleted (cancelled trip), the baggage records are automatically removed. This prevents keeping "leftover" data that no longer belongs to an active booking.

Delay Logs: If a flight is deleted from the system, its delay history is no longer needed. The cascade keeps the database clean.

5.The most complex query 
Multiple Joins: I connect three tables (Flight_Delay_Log, Flight, and Airline_Operator) to show a delay reason alongside the actual Airline's name.

Aggregation ): I use COUNT(Baggage_ID) and GROUP BY to calculate exactly how many bags each passenger has per booking.

Filtering with HAVING: I use HAVING COUNT() > 1. This is used to filter groups, specifically showing only the flights that have been delayed more than once
