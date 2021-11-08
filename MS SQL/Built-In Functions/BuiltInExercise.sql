--Part I – Queries for SoftUni Database

USE [SoftUni]

--01.Find Names of All Employees by First Name

SELECT [FirstName],[LastName] 
FROM [Employees]
WHERE [FirstName] LIKE 'Sa%'

--02.Find Names of All employees by Last Name

SELECT [FirstName],[LastName] 
FROM [Employees]
WHERE [LastName] LIKE '%ei%'

--03.Find First Names of All Employees

SELECT [FirstName]
FROM [Employees]
WHERE [DepartmentID] IN (3,10) AND YEAR([Hiredate]) BETWEEN 1995 AND 2005

--04.Find All Employees Except Engineers

SELECT [FirstName],[LastName] 
FROM [Employees]
WHERE [JobTitle] NOT LIKE '%engineer%' 

--05.Find Towns with Name Length

SELECT [Name]
FROM [Towns]
WHERE LEN([Name]) IN (5,6)
ORDER BY [Name]

--06.Find Towns Starting With

SELECT *
FROM [Towns]
WHERE LEFT([Name],1) IN ('M','K','B','E')
ORDER BY [Name]

-- WILDCARDS
SELECT *
FROM [Towns]
WHERE [Name] LIKE '[MKEB]%'
ORDER BY [Name]

--07.Find Towns Not Starting With

SELECT *
FROM [Towns]
WHERE LEFT([Name],1) NOT IN ('R','D','B')
ORDER BY [Name]

-- WILDCARDS
SELECT *
FROM [Towns]
WHERE [Name] LIKE '[^RDB]%'
ORDER BY [Name]

--08.Create View Employees Hired After 2000 Year
GO

CREATE VIEW [V_EmployeesHiredAfter2000] AS
( 
SELECT [FirstName],[LastName] 
    FROM [Employees]
	WHERE YEAR([Hiredate]) > 2000
)

GO

--09.Length of Last Name

SELECT [FirstName],[LastName] 
FROM [Employees]
WHERE LEN([LastName]) = 5

--10.Rank Employees by Salary

SELECT [EmployeeID],[FirstName], [LastName], [Salary], 
		DENSE_RANK() OVER (PARTITION BY [Salary] ORDER BY [EmployeeID]) AS [RANK] 
FROM [Employees]
WHERE [Salary] BETWEEN 10000 AND 50000
ORDER BY [Salary] DESC

--11.Find All Employees with Rank 2*

SELECT * 
FROM
(
SELECT [EmployeeID],[FirstName], [LastName], [Salary], 
		DENSE_RANK() OVER (PARTITION BY [Salary] ORDER BY [EmployeeID]) AS [Rank] 
FROM [Employees]
WHERE [Salary] BETWEEN 10000 AND 50000
)
AS [RankedEmployees]
WHERE [Rank] = 2
ORDER BY [Salary] DESC

--Part II – Queries for Geography Database

USE[Geography]

--12.Countries Holding ‘A’ 3 or More Times

SELECT [CountryName] AS [Country Name],[IsoCode] AS [ISO Code]
FROM [Countries]
WHERE [CountryName] LIKE '%A%A%A%'
ORDER BY [IsoCode]

--13.Problem 13. Mix of Peak and River Names

SELECT p.[PeakName],r.[RiverName],
CONCAT(LOWER(LEFT(p.[PeakName], LEN(p.[PeakName]) - 1)),LOWER(r.[RiverName])) 
AS [Mix]
FROM [Peaks] AS p,[Rivers] AS r
WHERE LOWER(RIGHT(p.[PeakName],1)) =LOWER( LEFT(r.[RiverName],1))
ORDER BY [Mix]

--Part III – Queries for Diablo Database

USE [Diablo]

--14.Games from 2011 and 2012 year

SELECT TOP (50) [Name],
FORMAT([Start],'yyyy-MM-dd') AS [Start]
FROM [Games]
WHERE YEAR([Start]) IN (2011,2012)
ORDER BY [Start],[Name]

--15.User Email Providers

SELECT [Username],
SUBSTRING([Email],CHARINDEX('@', Email) + 1,LEN([Email])) AS [Email Provider]
FROM [Users]
ORDER BY [Email Provider],[Username]

--16.Get Users with IPAdress Like Pattern

SELECT [Username],[IpAddress]
FROM [Users]
WHERE [IpAddress] LIKE '___.1%.%.___'
ORDER BY [Username]

--17.Show All Games with Duration and Part of the Day

SELECT [Name] AS [Game],
   CASE
	WHEN DATEPART(HOUR,[Start]) >= 0 AND DATEPART(HOUR,[Start]) <12 THEN 'Morning'
	WHEN DATEPART(HOUR,[Start]) >= 12 AND DATEPART(HOUR,[Start]) <18 THEN 'Afternoon'
	ELSE 'Evening'
   END AS [Part of the Day],

  CASE
	WHEN [Duration] <= 3 THEN 'Extra Short'
	WHEN [Duration] BETWEEN 4 AND 6 THEN 'Short'
	WHEN [Duration]> 6 THEN 'Long'
	WHEN  [Duration] IS NULL THEN 'Extra Long'
  END AS [Duration]

FROM [Games] AS g	
ORDER BY [Game],[Duration],[Part of the Day]

--Part IV – Date Functions Queries

USE[Orders]

--18.Orders Table

SELECT [ProductName],[OrderDate],
DATEADD(DAY,3,[OrderDate]) AS [Pay Due],
DATEADD(MONTH,1,[OrderDate]) AS [Deliver Due]
FROM [Orders]

--19.People Table
 
CREATE TABLE [People]
(
 [Id] INT PRIMARY KEY IDENTITY NOT NULL,
 [Name] NVARCHAR(100) NOT NULL,
 [Birthday] DATETIME2 NOT NULL
)

INSERT INTO [People] ([Name],[Birthday]) VALUES
('Victor','2000-12-07 00:00:00.000'),
('Steven','1992-09-10 00:00:00.000'),
('Stephen','1910-09-19 00:00:00.000'),
('John','2010-01-06 00:00:00.000')


SELECT [Name],
DATEDIFF(YEAR,[Birthday],GETDATE()) AS [Age in Years],
DATEDIFF(MONTH,[Birthday],GETDATE()) AS [Age in Months],
DATEDIFF(DAY,[Birthday],GETDATE()) AS [Age in Days],
DATEDIFF(MINUTE,[Birthday],GETDATE()) AS [Age in Minutes]
FROM [People]