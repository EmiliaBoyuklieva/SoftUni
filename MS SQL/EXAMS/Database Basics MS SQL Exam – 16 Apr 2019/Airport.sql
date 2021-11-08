--Section 1. DDL (30 pts)

CREATE DATABASE [Airport]

--1.Database Design

CREATE TABLE [Planes]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL,
	[Seats] INT NOT NULL,
	[Range] INT NOT NULL
);

CREATE TABLE [Flights]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[DepartureTime] DATETIME,
	[ArrivalTime] DATETIME,
	[Origin] VARCHAR(50) NOT NULL,
	[Destination] VARCHAR(50) NOT NULL,
	[PlaneId] INT FOREIGN KEY REFERENCES [Planes]([Id]) NOT NULL
);

CREATE TABLE [Passengers]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] VARCHAR(30) NOT NULL,
	[LastName] VARCHAR(30) NOT NULL,
	[Age] INT NOT NULL,
	[Address] VARCHAR(30) NOT NULL,
	[PassportId] CHAR(11) NOT NULL
);

CREATE TABLE [LuggageTypes]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Type] VARCHAR(30) NOT NULL
);

CREATE TABLE [Luggages]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[LuggageTypeId] INT FOREIGN KEY REFERENCES [LuggageTypes]([Id]) NOT NULL,
	[PassengerId] INT FOREIGN KEY REFERENCES [Passengers]([Id]) NOT NULL
);

CREATE TABLE [Tickets]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[PassengerId] INT FOREIGN KEY REFERENCES [Passengers]([Id]) NOT NULL,
	[FlightId] INT FOREIGN KEY REFERENCES [Flights]([Id]) NOT NULL,
	[LuggageId] INT FOREIGN KEY REFERENCES [Luggages]([Id]) NOT NULL,
	[Price] DECIMAL(18,2) NOT NULL
)

--Section 2. DML (10 pts)

-- 2. INSERT

INSERT INTO [Planes] ([Name], [Seats], [Range]) VALUES
('Airbus 336', 112,	5132),
('Airbus 330', 432,	5325),
('Boeing 369', 231,	2355),
('Stelt 297', 254,	2143),
('Boeing 338', 165,	5111),
('Airbus 558', 387,	1342),
('Boeing 128', 345,	5541)


INSERT INTO [LuggageTypes] ([Type]) VALUES
('Crossbody Bag'),
('School Backpack'),
('Shoulder Bag')

--3.Update

UPDATE [Tickets]
SET [Price] += [Price] * 0.13
WHERE [FlightId] = 41

--4.Delete

DELETE [Tickets]
WHERE [FlightId] IN (
					SELECT [Id]
					FROM [Flights] 
					WHERE [Destination] ='Ayn Halagim'
					)

DELETE [Flights]
WHERE [Destination] = 'Ayn Halagim'
 
 --Section 3. Querying (40 pts)

 --5.The "Tr" Planes

 SELECT [Id], [Name],[Seats],[Range]
 FROM [Planes]
 WHERE [Name] LIKE '%tr%'
 ORDER BY [Id], [Name],[Seats],[Range]

 --6.Flight Profits

 SELECT [FlightId],
        SUM([Price]) AS [Price]
 FROM [Tickets]
 GROUP BY [FlightId]
 ORDER BY [Price] DESC,[FlightId]

 --7.Passenger Trips

 SELECT CONCAT(P.[FirstName],' ',P.[LastName]) AS [Full Name],
        F.[Origin],
		F.[Destination]
 FROM [Passengers] AS P
 JOIN [Tickets] AS T
 ON T.[PassengerId] = P.[Id]
 JOIN [Flights] AS F
 ON F.[Id] = T.[FlightId]
 ORDER BY [Full Name],[Origin],[Destination]

 --8.Non Adventures People

 SELECT P.[FirstName],P.[LastName],P.[Age]
 FROM [Passengers] AS P
 LEFT JOIN [Tickets] AS T
 ON T.[PassengerId] = P.[Id]
 WHERE [Price] IS NULL
 ORDER BY [Age] DESC ,[FirstName],[LastName]

 --9.Full Info

 SELECT CONCAT(P.[FirstName],' ',P.[LastName]) AS [Full Name],
        PL.[Name] AS [Plane Name],
        CONCAT(F.[Origin],' - ',F.[Destination]) AS [Trip],
		LT.[Type] AS [Luggage Type]
 FROM [Tickets] AS T
 JOIN [Passengers] AS P
 ON T.[PassengerId] = P.[Id]
 JOIN [Flights] AS F
 ON F.[Id] = T.[FlightId]
 JOIN [Luggages] AS L
 ON T.[LuggageId] = L.[Id]
 JOIN [LuggageTypes] AS LT
 ON LT.[Id] = L.[LuggageTypeId]
 JOIN [Planes] AS PL
 ON PL.[Id] = F.[PlaneId]
 ORDER BY [Full Name],PL.[Name],F.[Origin],F.[Destination],[Luggage Type]

 --10.PSP

 SELECT [Name],
       PL.[Seats],
	   COUNT(T.[Id]) AS [Passengers Count]
 FROM [Planes] AS PL
 LEFT JOIN [Flights] AS F
 ON F.[PlaneId] = PL.[Id]
LEFT JOIN [Tickets] AS T 
ON T.[FlightId] = F.[Id]
GROUP BY [Name], PL.[Seats]
ORDER BY [Passengers Count] DESC,[Name],[Seats]

--Section 4. Programmability (20 pts)

--11.Vacation

GO

CREATE OR ALTER FUNCTION udf_CalculateTickets(@origin VARCHAR(20), @destination VARCHAR(20), @peopleCount INT)
RETURNS VARCHAR(MAX)
BEGIN

		DECLARE @ValidDestination VARCHAR(20)
		DECLARE @ValidOrigin VARCHAR(20)

     SET @ValidDestination  =   (  
								  SELECT TOP(1)[Destination] 
								  FROM Flights
								  WHERE [Destination] = @destination
								 )

      SET @ValidOrigin =  (      
						  SELECT TOP(1)[Origin] 
						  FROM Flights
						  WHERE [Origin] = @origin
						  )

		IF(@peopleCount <=0)
		RETURN ('Invalid people count!')
		IF( @ValidOrigin IS NULL OR @ValidDestination IS NULL)
		RETURN ('Invalid flight!')

		DECLARE @Price DECIMAL(18,2)

		SET @Price = 
			   (
				(SELECT TOP(1) TS.[Price] 
				FROM [Tickets] AS TS
				JOIN [Flights] AS F ON TS.[FlightId] = F.[Id]
				WHERE F.[Origin] = @origin 
				AND F.[Destination] = @destination) * @peopleCount
				)

RETURN 'Total price ' + CAST(@Price AS VARCHAR(10))
END

GO

SELECT dbo.udf_CalculateTickets('Invalid','Rancabolang', 33)
SELECT dbo.udf_CalculateTickets('Kolyshley','Rancabolang', -1)
SELECT dbo.udf_CalculateTickets('Kolyshley','Rancabolang', 33)

--12.Wrong Data

GO

CREATE PROC usp_CancelFlights
AS
BEGIN 
UPDATE [Flights] 
SET [DepartureTime] = NULL, [ArrivalTime] = NULL
WHERE [ArrivalTime] > [DepartureTime]
END

