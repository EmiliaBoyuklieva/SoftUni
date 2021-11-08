--CREATE DATABASE [ColonialJourney]

--1.Database Design

CREATE TABLE [Planets]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(30) NOT NULL
)

CREATE TABLE [Spaceports]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
[PlanetId] INT FOREIGN KEY REFERENCES [Planets]([Id]) NOT NULL
)

CREATE TABLE [Spaceships]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
[Manufacturer] VARCHAR(30) NOT NULL,
[LightSpeedRate] INT DEFAULT(0)
)

CREATE TABLE [Colonists]
(
[Id] INT PRIMARY KEY IDENTITY,
[FirstName] VARCHAR(20) NOT NULL,
[LastName] VARCHAR(20) NOT NULL,
[Ucn] VARCHAR(10) UNIQUE NOT NULL,
[BirthDate] DATE NOT NULL
)

CREATE TABLE [Journeys]
(
[Id] INT PRIMARY KEY IDENTITY,
[JourneyStart] DATETIME NOT NULL,
[JourneyEnd] DATETIME NOT NULL,
[Purpose] VARCHAR(11) CHECK([Purpose] IN ('Medical', 'Technical', 'Educational', 'Military')),
[DestinationSpaceportId] INT FOREIGN KEY REFERENCES [Spaceports]([Id]) NOT NULL,
[SpaceshipId] INT FOREIGN KEY REFERENCES [Spaceships]([Id]) NOT NULL
)

CREATE TABLE [TravelCards]
(
[Id] INT PRIMARY KEY IDENTITY,
[CardNumber] CHAR(10) UNIQUE NOT NULL,
[JobDuringJourney] VARCHAR(8) CHECK([JobDuringJourney] IN ('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook')),
[ColonistId] INT FOREIGN KEY REFERENCES [Colonists]([Id]) NOT NULL,
[JourneyId] INT FOREIGN KEY REFERENCES [Journeys]([Id]) NOT NULL
)

--2.Insert

INSERT INTO [Planets]([Name])
VALUES ('Mars'),('Earth'),('Jupiter'),('Saturn')

INSERT INTO [Spaceships]([Name],[Manufacturer],[LightSpeedRate])
VALUES
('Golf','VW',3),
('WakaWaka','Wakanda',4),
('Falcon9','SpaceX',1),
('Bed','Vidolov',6)

--3.Update

UPDATE [Spaceships]
SET [LightSpeedRate] += 1
WHERE [Id] BETWEEN 8 AND 12

--4.Delete

DELETE [TravelCards] 
WHERE [JourneyId] IN (1,2,3)

DELETE [Journeys]
WHERE [Id] IN (1,2,3)

--5.Select All Military Journeys

SELECT [Id],
       FORMAT([JourneyStart],'dd/MM/yyyy') AS [JourneyStart],
	   FORMAT([JourneyEnd],'dd/MM/yyyy') AS [JourneyEnd]
FROM [Journeys]
WHERE [Purpose] = 'Military'
ORDER BY [JourneyStart]

--6.Select all pilots

SELECT C.[Id],
       CONCAT([FirstName],' ',[LastName]) AS [FullName]
FROM [Colonists] AS C
JOIN  [TravelCards] AS TC
ON C.[Id] = TC.[ColonistId]
WHERE [JobDuringJourney] = 'Pilot'
ORDER BY C.[Id]

--7.Count colonists

SELECT COUNT(*) AS [Count]
FROM [Colonists] AS C
JOIN  [TravelCards] AS TC
ON C.[Id] = TC.[ColonistId]
WHERE [JobDuringJourney] = 'Engineer'

--8.Select Spaceships With Pilots younger than 30 years

SELECT S.[Name],S.[Manufacturer]
FROM [Colonists] AS C
JOIN  [TravelCards] AS TC
ON C.[Id] = TC.[ColonistId]
JOIN [Journeys] AS J
ON J.[Id] = TC.[JourneyId]
JOIN [Spaceships] AS  S
ON S.[Id] = J.[SpaceshipId]
WHERE [JobDuringJourney] = 'Pilot' AND [BirthDate] > '1990-01-01'
ORDER BY S.[Name]

--9.Select all planets and their journey count

SELECT P.[Name] AS [PlanetName],
          COUNT(J.[Id]) AS [JourneysCount]
FROM [Planets] AS P
JOIN [Spaceports] AS S
ON S.[PlanetId] = P.[Id]
JOIN [Journeys] AS J
ON J.[DestinationSpaceportId] = S.[Id]
GROUP BY P.[Name]
ORDER BY [JourneysCount] DESC,[PlanetName]

--10.Select Second Oldest Important Colonist

SELECT *
	   FROM(
			  SELECT  [JobDuringJourney],
                      CONCAT([FirstName],' ',[LastName]) AS [FullName],
					  DENSE_RANK () OVER (PARTITION BY TC.[JobDuringJourney] ORDER BY C.[BirthDate]) AS [JobRank]
				FROM [Colonists] AS C
				JOIN  [TravelCards] AS TC
				ON C.[Id] = TC.[ColonistId]
            ) AS [SUBQUERY]
WHERE [JobRank] = 2 

--11.Get Colonists Count

GO

CREATE FUNCTION udf_GetColonistsCount(@PlanetName VARCHAR (30))
RETURNS INT
AS
BEGIN

DECLARE @ValidPlanet VARCHAR(30)
SET @ValidPlanet = (
                    SELECT [Name] 
                    FROM [Planets]
                    WHERE [Name] =@PlanetName 
					)
DECLARE @Count INT
SET @Count =  (
				SELECT COUNT(C.[Id]) 
				FROM [Colonists] AS C
				JOIN [TravelCards] AS TC
				ON TC.[ColonistId] = C.[Id]
				JOIN [Journeys] AS J
				ON TC.[JourneyId] = J.[Id]
				JOIN [Spaceports] AS S
				ON J.[DestinationSpaceportId] = S.[Id]
				JOIN [Planets] AS P
				ON P.[Id] = S.[PlanetId]
				WHERE P.[Name] = @ValidPlanet
		       )

RETURN @Count
END

GO

--12.Change Journey Purpose

CREATE OR ALTER PROC usp_ChangeJourneyPurpose(@JourneyId INT, @NewPurpose VARCHAR(11))
AS
BEGIN

DECLARE @ValidJourneyId INT
SET @ValidJourneyId = (
                    SELECT [Id] 
                    FROM [Journeys]
                    WHERE [Id] = @JourneyId
					)

IF(@ValidJourneyId IS NULL)
 THROW 50001,'The journey does not exist!',1

DECLARE @CurrentPurpose VARCHAR(11)
SET @CurrentPurpose = (
						SELECT [Purpose] 
						FROM [Journeys]
						WHERE [Id] = @JourneyId				
					  )

				
IF(@CurrentPurpose = @NewPurpose)
 THROW 50001,'You cannot change the purpose!',1


UPDATE [Journeys]
SET [Purpose] = @NewPurpose
WHERE [Id] = @JourneyId 

END

EXEC usp_ChangeJourneyPurpose 4, 'Technical'
EXEC usp_ChangeJourneyPurpose 2, 'Educational'
EXEC usp_ChangeJourneyPurpose 196, 'Technical'



     