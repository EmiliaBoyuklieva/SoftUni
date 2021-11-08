USE [SoftUni]

--1.Employee Address

SELECT TOP (5) E.[EmployeeId],E.[JobTitle],E.[AddressId],A.[AddressText]
FROM [Employees] AS E
LEFT JOIN [Addresses] AS A 
ON E.[AddressId] =A.[AddressId]
ORDER BY [AddressId]

--2.Addresses with Towns

SELECT TOP (50) E.[FirstName],E.[LastName],T.[Name] AS [Town],A.[AddressText]
FROM [Employees] AS E
JOIN [Addresses] AS A 
ON E.[AddressId] = A.[AddressId]
JOIN [Towns] AS T 
ON A.[TownID] = T.[TownID]
ORDER BY [FirstName],[LastName]

--3.Sales Employee

SELECT  E.[EmployeeId], E.[FirstName],E.[LastName],D.[Name]
FROM [Employees] AS E
JOIN [Departments] AS D 
ON E.[DepartmentID] = D.[DepartmentID]
WHERE D.[Name] = 'Sales'
ORDER BY [EmployeeId]

--4.Employee Departments

SELECT TOP (5) E.[EmployeeId], E.[FirstName],E.[Salary],D.[Name]
FROM [Employees] AS E
JOIN [Departments] AS D 
ON E.[DepartmentID] = D.[DepartmentID]
WHERE E.[Salary] > 15000
ORDER BY E.[DepartmentID]

--5.Employees Without Project

SELECT TOP (3) E.[EmployeeID], E.[FirstName]
FROM [Employees] AS E
LEFT JOIN [EmployeesProjects] AS EP
ON E.[EmployeeID] = EP.EmployeeID
WHERE EP.[ProjectID] IS NULL
ORDER BY E.[EmployeeID]

--6.Employees Hired After

SELECT  E.[FirstName],E.[LastName],E.[HireDate], D.[Name] AS [DepTName]
FROM [Employees] AS E
JOIN [Departments] AS D ON E.[DepartmentID] = D.[DepartmentID]
WHERE D.[Name] IN ('Sales', 'Finance')
ORDER BY [HireDate]

--7.Employees with Project

SELECT TOP (5) E.[EmployeeID], E.[FirstName],P.[Name] AS [ProjectName]
FROM [Employees] AS E
JOIN [EmployeesProjects] AS EP
ON E.[EmployeeID] = EP.EmployeeID
JOIN [Projects] AS P 
ON P.[ProjectID] = EP.[ProjectID]
WHERE P.[EndDate] IS NULL AND P.[StartDate] > CONVERT(DATETIME2, '08/13/2002')
ORDER BY E.[EmployeeID]

--8.Employee 24

SELECT  E.[EmployeeID], E.[FirstName],
   CASE 
        WHEN  YEAR(P.[StartDate]) >= 2005 THEN NULL
		ELSE P.[Name]
   END AS [ProjectName]
FROM [Employees] AS E
JOIN [EmployeesProjects] AS EP
ON E.[EmployeeID] = EP.EmployeeID
JOIN [Projects] AS P 
ON P.[ProjectID] = EP.[ProjectID]
WHERE E.[EmployeeID] = 24 

--9.Employee Manager

--FIRST WAY
SELECT E.[EmployeeID], E.[FirstName],E.[ManagerID],
M.[FirstName] AS [ManagerName]
FROM [Employees] AS E
JOIN [Employees] AS M 
ON M.[EmployeeID] = E.[ManagerID]
WHERE E.[ManagerID] IN (3,7)
ORDER BY [EmployeeID]

--SECOND WAY
SELECT [EmployeeID], [FirstName],[ManagerID],
    CASE 
        WHEN [ManagerID] = 3 THEN 'Roberto'
		ELSE 'JoLynn'
    END AS [ManagerName]
FROM [Employees] 
WHERE [ManagerID] IN (3,7)
ORDER BY [EmployeeID]

--10.Employee Summary

SELECT TOP (50)  E.[EmployeeId], 
CONCAT(E.[FirstName],' ',E.[LastName]) AS [EmployeeName],
CONCAT(EE.[FirstName],' ',EE.[LastName]) AS [ManagerName],
D.[Name] AS [DepartmentName]
FROM [Employees] AS E
JOIN [Departments] AS D 
ON E.[DepartmentID] = D.[DepartmentID]
JOIN [Employees] AS EE 
ON EE.[EmployeeID] = E.[ManagerID]
ORDER BY [EmployeeID]

--11.Min Average Salary

SELECT MIN([MinAverageSalary]) 
FROM 
(
SELECT AVG([Salary]) AS [MinAverageSalary]
FROM [Employees]
GROUP BY [DepartmentID]
) 
AS [COUNT]


USE [Geography]

--12.Highest Peaks in Bulgaria

SELECT C.[CountryCode],M.[MountainRange],P.[PeakName],P.[Elevation]
FROM [Countries] AS C
JOIN [MountainsCountries] AS MC
ON C.[CountryCode] = MC.[CountryCode]
JOIN [Mountains] AS M 
ON M.[Id] = MC.[MountainId]
JOIN [Peaks] AS P
ON P.[MountainId] = M.[Id]
WHERE C.[CountryCode] = 'BG' AND P.[Elevation] > 2835
ORDER BY P.[Elevation] DESC

--13.Count Mountain Ranges

SELECT C.[CountryCode],
COUNT(MC.[MountainId]) AS [MountainRanges]
FROM [Countries] AS C
JOIN [MountainsCountries] AS MC
ON C.[CountryCode] = MC.[CountryCode]
WHERE C.[CountryCode] IN ('BG','RU','US')
GROUP BY C.[CountryCode]

--14.Countries with Rivers

SELECT TOP (5) C.[CountryName],R.[RiverName]
FROM [Countries] AS C
LEFT JOIN [CountriesRivers] AS CR 
ON C.CountryCode = CR.CountryCode
LEFT JOIN [Rivers] AS R
ON R.[Id] = CR.[RiverId]
WHERE C.[ContinentCode] = 'AF'
ORDER BY C.[CountryName]

--15.*Continents and Currencies

SELECT [ContinentCode],[CurrencyCode],[Currency] AS [CurrencyUsage]
FROM
(
   SELECT *,
        DENSE_RANK() OVER (PARTITION BY [ContinentCode] ORDER BY [Currency] DESC) AS [CurrencyRank]
   FROM
       (
          SELECT [ContinentCode],[CurrencyCode],COUNT ([CurrencyCode]) AS [Currency]
          FROM [Countries]
          GROUP BY [ContinentCode],[CurrencyCode]
       ) 
          AS [CurrencySubQuery]
   WHERE [Currency] > 1
)
AS [CurrencySubQuery]
WHERE [CurrencyRank] = 1

--16.Countries Without any Mountains

SELECT COUNT(C.[CountryName]) AS [Count]
FROM [Countries] AS C
LEFT JOIN [MountainsCountries] AS MC
ON C.[CountryCode] = MC.[CountryCode]
WHERE MC.[MountainId] IS NULL

--17.Highest Peak and Longest River by Country

SELECT TOP (5) C.[CountryName],
               MAX(P.[Elevation]) AS [HighestPeakElevation],
               MAX(R.[Length]) AS [LongestRiverLength]
FROM [Countries] AS C
LEFT JOIN [MountainsCountries] AS MC
ON C.[CountryCode] = MC.[CountryCode]
JOIN [Mountains] AS M 
ON M.[Id] = MC.[MountainId]
LEFT JOIN [Peaks] AS P
ON P.[MountainId] = M.[Id]
LEFT JOIN [CountriesRivers] AS CR
ON C.[CountryCode] = CR.[CountryCode]
LEFT JOIN [Rivers] AS R
ON R.[Id] = CR.[RiverId]
GROUP BY C.[CountryName]
ORDER BY [HighestPeakElevation] DESC ,[LongestRiverLength] DESC ,C.[CountryName]

--18.*Highest Peak Name and Elevation by Country

SELECT TOP (5) [CountryName] AS [Country],
               ISNULL([PeakName],'(no highest peak)') AS [Highest Peak Name],
	           ISNULL([Elevation],0) AS [Highest Peak Elevation],
	           ISNULL([MountainRange],'(no mountain)') AS [Mountain]
FROM
(
        SELECT C.[CountryName],P.[PeakName],P.[Elevation],M.[MountainRange],
               DENSE_RANK() OVER (PARTITION BY [CountryName] ORDER BY P.[Elevation] DESC) AS [PeakRank]
        FROM [Countries] AS C
             LEFT JOIN [MountainsCountries] AS MC
             ON C.[CountryCode] = MC.[CountryCode]
             LEFT JOIN [Mountains] AS M 
             ON M.[Id] = MC.[MountainId]
             LEFT JOIN [Peaks] AS P
             ON P.[MountainId] = M.[Id]
) AS [PeaksRankingSubquery]
WHERE [PeakRank] = 1
ORDER BY [CountryName],[Highest Peak Name]
