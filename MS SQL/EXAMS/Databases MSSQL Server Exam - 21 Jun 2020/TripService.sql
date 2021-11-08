--1.Database design
--USE [TripService]

CREATE TABLE [Cities]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(20) NOT NULL,
[CountryCode] CHAR(2) NOT NULL
)

CREATE TABLE [Hotels]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(30) NOT NULL,
[CityId] INT FOREIGN KEY REFERENCES [Cities]([Id]) NOT NULL,
[EmployeeCount] INT NOT NULL,
[BaseRate] DECIMAL(18,2)
)

CREATE TABLE [Rooms]
(
[Id] INT PRIMARY KEY IDENTITY,
[Price] DECIMAL(18,2) NOT NULL,
[Type] NVARCHAR(30) NOT NULL,
[Beds] INT NOT NULL,
[HotelId] INT FOREIGN KEY REFERENCES [Hotels]([Id]) NOT NULL
)

CREATE TABLE [Trips]
(
[Id] INT PRIMARY KEY IDENTITY,
[RoomId] INT FOREIGN KEY REFERENCES [Rooms]([Id]) NOT NULL,
[BookDate] DATE NOT NULL,
[ArrivalDate] DATE  NOT NULL,
[ReturnDate] DATE  NOT NULL,
[CancelDate] DATE,

CHECK ([BookDate] < [ArrivalDate]),
CHECK ([ArrivalDate]<[ReturnDate])
)

CREATE TABLE [Accounts]
(
[Id] INT PRIMARY KEY IDENTITY,
[FirstName] NVARCHAR(50) NOT NULL,
[MiddleName] NVARCHAR(20),
[LastName] NVARCHAR(50) NOT NULL,
[CityId] INT FOREIGN KEY REFERENCES [Cities]([Id]) NOT NULL,
[BirthDate] DATE NOT NULL,
[Email] VARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE [AccountsTrips]
(
[AccountId] INT FOREIGN KEY REFERENCES [Accounts]([Id]) NOT NULL,
[TripId] INT FOREIGN KEY REFERENCES [Trips]([Id]) NOT NULL,
[Luggage] INT CHECK([Luggage] >=0) NOT NULL,
PRIMARY KEY([AccountId],[TripId])
)

--2.Insert

INSERT INTO [Accounts] ([FirstName],[MiddleName],[LastName],[CityId],[BirthDate],[Email])
VALUES
('John','Smith' , 'Smith',34,'1975-07-21','j_smith@gmail.com'),
('Gosho',NULL,'Petrov',11,'1978-05-16','g_petrov@gmail.com'), 
('Ivan','Petrovich'	,'Pavlov',59,'1849-09-26','i_pavlov@softuni.bg'),
('Friedrich','Wilhelm','Nietzsche', 2,'1844-10-15','f_nietzsche@softuni.bg')

INSERT INTO [Trips] ([RoomId],[BookDate],[ArrivalDate],[ReturnDate],[CancelDate]) 
VALUES
(101,'2015-04-12','2015-04-14',	'2015-04-20','2015-02-02'),
(102,'2015-07-07','2015-07-15',	'2015-07-22','2015-04-29'),
(103,'2013-07-17','2013-07-23',	'2013-07-24',NULL),	   
(104,'2012-03-17','2012-03-31',	'2012-04-01','2012-01-10'),
(109,'2017-08-07','2017-08-28',	'2017-08-29',NULL)

--3.Update

UPDATE [Rooms]
SET [Price] += [Price]*0.14
WHERE [HotelId] IN (5,7,9)

--4.Delete

DELETE [AccountsTrips]
WHERE [AccountId] = 47

--5.EEE-Mails

SELECT A.[FirstName],A.[LastName],
       FORMAT( [BirthDate],'MM-dd-yyyy'),C.[Name],A.[Email]
FROM [Accounts] AS A
JOIN [Cities] AS C
ON C.[Id] = A.[CityId]
WHERE [Email] LIKE 'e%'
ORDER BY C.[Name]

--6.City Statistics

SELECT C.[Name] AS [City],
       COUNT(H.[Id]) AS [Hotels]
FROM [Cities] AS C
JOIN [Hotels] AS H
ON C.[Id] = H.[CityId]
GROUP BY C.[Name] 
ORDER BY [Hotels] DESC,[City]

--7.Longest and Shortest Trips

SELECT ACT.[AccountId], 
      CONCAT(A.[FirstName],' ',A.[LastName]) AS [FullName],
      MAX(DATEDIFF(DAY,[ArrivalDate],[ReturnDate])) AS [LongestTrip],
	  MIN(DATEDIFF(DAY,[ArrivalDate],[ReturnDate])) AS [ShortestTrip]
FROM [Trips] AS T
JOIN [AccountsTrips] AS ACT
ON T.[Id] = ACT.[TripId]
JOIN [Accounts] AS A
ON A.[Id] = ACT.[AccountId]
WHERE A.[MiddleName] IS NULL AND T.[CancelDate] IS NULL
GROUP BY ACT.[AccountId],A.[FirstName],A.[LastName]
ORDER BY [LongestTrip] DESC,[ShortestTrip]

--8.Metropolis

SELECT TOP(10) 
       C.[Id],C.[Name] AS [City],
       C.[CountryCode] AS [Country],
      COUNT(A.[Id]) AS [Accounts]
FROM [Cities] AS C
JOIN [Accounts] AS A
ON A.[CityId] = C.[Id]
GROUP BY  C.[Id],C.[Name],C.[CountryCode]
ORDER BY [Accounts] DESC

--9. Romantic Getaways

SELECT  AC.[Id],AC.[Email],
	   C.[Name] AS [City],[Trips]
FROM
	   (
		SELECT ACT.[AccountId],
			  COUNT(ACT.[AccountId]) AS [Trips]
		FROM [AccountsTrips] AS ACT
		JOIN [Accounts] AS [A] 
		ON A.[Id]=ACT.[AccountId]
		JOIN [Trips] AS T
		ON T.[Id] = ACT.[TripId]
		JOIN [Rooms] AS R 
		ON R.[Id] = T.[RoomId]
		JOIN [Hotels] AS H
		ON R.[HotelId] = H.[Id]
		WHERE H.[CityId] = A.[CityId]
		GROUP BY ACT.[AccountId]
		) 
	AS [SUBQUERY]
JOIN [Accounts] AS AC
ON [SUBQUERY].[AccountId] = AC.[Id]
JOIN [Cities] AS C
ON AC.[CityId] = C.[Id]
ORDER BY [Trips] DESC ,AC.[Id] 

--10.GDPR Violation

SELECT T.Id,
    CASE
	WHEN a.MiddleName IS NULL THEN CONCAT(a.FirstName, ' ', a.LastName)
	ELSE CONCAT(a.FirstName, ' ' + a.MiddleName, ' ', a.LastName)
END AS [Full Name],

	   CA.[Name] AS [From],
	   CH.[Name] AS [To],

	 CASE
	 WHEN T.CancelDate IS NULL THEN CONCAT(DATEDIFF(DAY,T.ArrivalDate, T.ReturnDate), ' ', 'days')
	 ELSE 'Canceled'
	  END AS [Duration]

FROM Trips AS T
 JOIN AccountsTrips AS ATR 
 ON T.Id=ATR.TripId
 JOIN Accounts AS A 
 ON ATR.AccountId=A.Id
 JOIN Cities AS CA
 ON A.CityId=CA.Id
 JOIN Rooms AS R 
 ON R.Id=T.RoomId
 JOIN Hotels AS H 
 ON H.Id=R.HotelId
 JOIN Cities AS CH 
 ON CH.Id=H.CityId
 ORDER BY [Full Name], T.Id

--11.Available Room

GO

CREATE FUNCTION udf_GetAvailableRoom(@HotelId INT, @Date DATE, @People INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
			
		DECLARE @RoomId INT = (SELECT TOP(1) R.Id 
							   FROM Trips AS T
								   JOIN Rooms  AS R ON R.Id = T.RoomId
								   JOIN Hotels AS H ON H.Id = R.HotelId
								   WHERE H.Id = @HotelId 
								   AND @Date NOT BETWEEN T.ArrivalDate AND T.ReturnDate
								   AND T.CancelDate IS NULL
								   AND R.Beds >= @People
								   AND YEAR(@Date) = YEAR(t.ArrivalDate))
IF(@RoomId IS NULL)
RETURN 'No rooms available'

DECLARE @RoomType NVARCHAR(20) = (SELECT [Type]
									    FROM Rooms
									    WHERE Id = @RoomId)

DECLARE @Beds INT              = (SELECT R.Beds 
									    FROM Rooms AS R 
									    WHERE R.Id = @RoomId)

DECLARE @HotelBaseRate DECIMAL(15,2) = (SELECT H.BaseRate 
									    FROM Hotels AS H 
									    WHERE H.Id = @HotelId)

DECLARE @RoomPrice DECIMAL(18,2)     = (SELECT R.Price 
									    FROM Rooms AS R
									    WHERE R.Id = @RoomId)

DECLARE @TotalPrice DECIMAL(18,2)    = (@HotelBaseRate + @RoomPrice) * @People

RETURN CONCAT('Room',' ',@RoomId,':',' ',@RoomType,' ','(',@Beds,' ','beds',')',' ','-',' ','$',@TotalPrice )
END

GO

--12. Switch Room

GO

CREATE PROC usp_SwitchRoom(@TripId INT, @TargetRoomId INT)
AS
BEGIN

DECLARE @tripHotelId INT
DECLARE @targetHotelId INT

SET @tripHotelId = 
				(
				SELECT h.[Id]
				FROM [Rooms] AS r
				JOIN [Trips] AS t 
				ON r.[Id] = t.[RoomId]
				JOIN [Hotels] AS h 
				ON r.[HotelId] = h.[Id]
				WHERE t.[Id] = @TripId
				)

SET @targetHotelId = 
				(
				SELECT h.[Id]
				FROM [Hotels] AS h
				JOIN [Rooms] AS r 
				ON h.[Id] = r.[HotelId]
				WHERE r.[Id] = @TargetRoomId
				)

IF @tripHotelId <> @targetHotelId
THROW 51000, 'Target room is in another hotel!', 2

DECLARE @tourists INT
DECLARE @targetRoomBeds INT

SET @tourists =
				(
				SELECT COUNT([AccountId])
				FROM [Trips] AS t
				JOIN [AccountsTrips] AS [at] 
				ON t.[Id] = [at].[TripId]
				WHERE t.[Id] = @TripId
				)

SET @targetRoomBeds =
					(
					SELECT [Beds]
					FROM [Rooms]
					WHERE [Id] = @TargetRoomId
					)

IF @tourists > @targetRoomBeds
THROW 51000, 'Not enough beds in target room!', 1

UPDATE [Trips]
SET [RoomId] = @TargetRoomId
WHERE [Id] = @TripId







