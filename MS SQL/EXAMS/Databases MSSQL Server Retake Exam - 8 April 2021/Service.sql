
--Section 1. DDL (30 pts)

CREATE DATABASE[Service]
USE [Service]

--1.Table design

CREATE TABLE [Users]
(
[Id] INT PRIMARY KEY IDENTITY,
[Username] VARCHAR(30) UNIQUE NOT NULL,
[Password] VARCHAR(50) NOT NULL,
[Name] VARCHAR(50)  NULL,
[Birthdate] DATETIME2,
[Age] INT CHECK ([Age] BETWEEN 14 AND 110),
[Email] VARCHAR(50) NOT NULL
)

CREATE TABLE [Status]
(
[Id] INT PRIMARY KEY IDENTITY,
[Label] VARCHAR(30) NOT NULL
)

CREATE TABLE [Departments]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Categories]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
[DepartmentId] INT FOREIGN KEY REFERENCES [Departments]([Id]) NOT NULL
)

CREATE TABLE [Employees]
(
[Id] INT PRIMARY KEY IDENTITY,
[FirstName] VARCHAR(25) NULL,
[LastName] VARCHAR(25) NULL,
[Birthdate] DATETIME2,
[Age] INT CHECK ([Age] BETWEEN 18 AND 110),
[DepartmentId] INT FOREIGN KEY REFERENCES [Departments]([Id]) 
)

CREATE TABLE [Reports]
(
[Id] INT PRIMARY KEY IDENTITY ,
[CategoryId] INT FOREIGN KEY REFERENCES [Categories]([Id]) NOT NULL,
[StatusId] INT FOREIGN KEY REFERENCES [Status]([Id]) NOT NULL,
[OpenDate] DATETIME2 NOT NULL,
[CloseDate] DATETIME2 NULL,
[Description] VARCHAR(200) NOT NULL,
[UserId] INT FOREIGN KEY REFERENCES [Users]([Id]) NOT NULL,
[EmployeeId] INT FOREIGN KEY REFERENCES [Employees]([Id]) 
)


--Section 2. DML (10 pts)


--2.Insert

INSERT INTO [Employees]([FirstName],[LastName],[Birthdate], [DepartmentId]) 
VALUES 
('Marlo', 'O''Malley', '1958-9-21', 1), 
('Niki', 'Stranaghan', '1969-11-26', 4),
('Ayrton', 'Senna', '1960-03-21', 9),
('Ronnie', 'Peterson', '1944-02-14', 9),
('Giovanna', 'Amati', '1959-07-20', 5)

INSERT INTO [Reports]([CategoryId],[StatusId], [OpenDate], [CloseDate],[Description],[UserId], [EmployeeId]) 
VALUES
( 1, 1, '2017-04-13', NULL, 'Stuck Road on Str.133', 6, 2),
( 6, 3, '2015-09-05', '2015-12-06', 'Charity trail running', 3, 5),
( 14, 2, '2015-09-07', NULL, 'Falling bricks on Str.58', 5, 2),
( 4,3, '2017-07-03', '2017-07-06', 'Cut off streetlight on Str.11', 1, 1)

--3.Update

UPDATE [Reports]
SET [CloseDate] = GETDATE()
WHERE [CloseDate] IS NULL

--4.Delete

DELETE [Reports]
WHERE [StatusId] = 4


--Section 3. Querying (40 pts)


--5.Unassigned Reports

SELECT [Description], FORMAT([OpenDate],'dd-MM-yyyy') AS [Open Date]
FROM [Reports]
WHERE [EmployeeId] IS NULL
ORDER BY [OpenDate],[Description]

--6.Reports & Categories

SELECT R.[Description], C.[Name] AS [CategoryName]
FROM [Reports] AS R
LEFT JOIN [Categories] AS C
ON R.[CategoryId] = C.[Id]
WHERE C.[Name] IS NOT NULL
ORDER BY [Description],C.[Name]

--7.Most Reported Category

SELECT TOP(5) C.[Name],COUNT(R.[CategoryId]) AS [ReportsNumber]
FROM [Reports] AS R
LEFT JOIN [Categories] AS C
ON R.[CategoryId] = C.[Id]
GROUP BY C.[Name],R.CategoryId
ORDER BY [ReportsNumber] DESC, C.[Name]

--8.Birthday Report

SELECT U.[Username], C.[Name] AS [CategoryName]
FROM [Users] AS U
JOIN [Reports] AS R
ON R.[UserId] = U.[Id]
JOIN [Categories] AS C
ON R.[CategoryId] = C.[Id]
WHERE DATEPART(DAY,R.[OpenDate]) = DATEPART(DAY,U.[Birthdate])
ORDER BY U.[Username],[CategoryName]

--9.Users per Employee

SELECT CONCAT([FirstName],' ',[LastName]) AS [FullName],
       COUNT([Count]) AS [UsersCount]
FROM
(
	SELECT E.[FirstName],E.[LastName],(R.[EmployeeId]) AS [Count]
	FROM [Employees] AS E
	LEFT JOIN [Reports] AS R
	ON R.[EmployeeId] = E.[Id]
	LEFT JOIN [Users] AS U
	ON R.[UserId] = U.[Id]
) AS [SUBQUERY]
GROUP BY [FirstName],[LastName],[Count]
ORDER BY [UsersCount] DESC,[FullName]

--10.Full Info

SELECT        
              ISNULL(E.FirstName + ' ' + E.LastName,'None') AS [Employee],
              ISNULL(D.[Name],'None') AS [Department],
			  ISNULL(C.[Name],'None') AS [Category],
			  ISNULL(R.[Description],'None') AS [Description],
			  ISNULL(FORMAT(R.[OpenDate],'dd.MM.yyyy'),'None') AS [Open Date],
			  ISNULL(S.[Label],'None') AS [Status],
			  ISNULL(U.[Name],'None') AS [User]
FROM [Reports] AS R
LEFT JOIN [Employees] AS E 
ON R.[EmployeeId]=E.[Id]
LEFT JOIN [Departments] AS D 
ON E.[DepartmentId]=D.[Id]
LEFT JOIN [Categories] AS C 
ON R.[CategoryId]=C.[Id]
LEFT JOIN [Status] AS S 
ON R.[StatusId]=S.Id
LEFT JOIN [Users] AS U 
ON R.[UserId]=U.[Id]
ORDER BY E.[FirstName] DESC, E.[LastName] DESC,
[Department],[Category],R.[Description],R.[OpenDate],[Status],[User]


--Section 4. Programmability (20 pts)

--11.Hours to Complete

GO

CREATE FUNCTION udf_HoursToComplete(@StartDate DATETIME, @EndDate DATETIME)
RETURNS INT 
AS
BEGIN
		DECLARE @DIFF INT

		IF @StartDate IS NULL
		SET @DIFF = 0
		ELSE IF @EndDate IS NULL 
		SET @DIFF = 0
		ELSE
		SET @DIFF =DATEDIFF(HOUR,@StartDate,@EndDate)

		RETURN @DIFF
END

GO

--12.Assign Employee

CREATE PROC usp_AssignEmployeeToReport(@EmployeeId INT, @ReportId INT)
AS 
BEGIN
	  DECLARE @Employee INT = (SELECT E.[DepartmentId]
								 FROM [Employees] AS E
								WHERE E.[Id] = @EmployeeId)

	  DECLARE @Report INT = (SELECT C.[DepartmentId]
						       FROM [Reports] AS R
						       JOIN [Categories] AS C 
						         ON C.[Id] = R.[CategoryId]
						      WHERE R.[Id] = @ReportId )

	IF @Employee != @Report
	THROW 50005,'Employee doesn''t belong to the appropriate department!', 1;
	ELSE
			UPDATE [Reports] 
			SET [EmployeeId] = @EmployeeId
			WHERE [Id] = @ReportId
END