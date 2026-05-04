# SkyTrack Airline System
Description:
The SkyTrack Airline System is a database designed to manage flight schedules, passenger bookings, and aircraft maintenance. It ensures data integrity across complex relationships between travelers and flight logistics.

ERD Summary 
Based on the project ERD.png, here is the plan:
Main Parts: We track Airports, Flights, Aircraft, Crew Members, Passengers, and Bookings.  
How they connect:
A Flight links a departure airport to an arrival airport.  
An Aircraft is assigned to a specific flight.  
A Booking connects a Passenger to a specific Flight.  

Mapping Decisions :

Looking at the project MAP.png, here is how the data is stored:
Flight Connections: I put IATA_Code_Departs and IATA_Code_Arrives in the Flight table to show the start and end of a trip. 

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
