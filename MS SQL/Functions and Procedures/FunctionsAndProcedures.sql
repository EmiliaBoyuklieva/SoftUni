--1. Queries for SoftUni Database

USE [SoftUni]

--1.Employees with Salary Above 35000

GO

CREATE PROC usp_GetEmployeesSalaryAbove35000
AS 
SELECT [FirstName],[LastName]
FROM [Employees]
WHERE [Salary] > 35000

--2.

GO

CREATE PROC usp_GetEmployeesSalaryAboveNumber(@NUMBER DECIMAL (18,4))
AS 
SELECT [FirstName],[LastName]
FROM [Employees]
WHERE [Salary] >= @NUMBER

--3.Town Names Starting With
GO

CREATE PROCEDURE usp_GetTownsStartingWith (@InputStr VARCHAR(MAX))
AS
BEGIN
	SELECT [Name] 
	FROM [Towns]
	WHERE [Name] LIKE (@InputStr + '%')
END 

EXECUTE usp_GetTownsStartingWith 'b'

--4.Employees from Town

GO

CREATE PROC usp_GetEmployeesFromTown(@TOWN VARCHAR(30))
AS 
SELECT [FirstName],[LastName]
FROM [Employees] AS E 
JOIN [Addresses] AS A 
ON E.[AddressID] = A.[AddressID]
JOIN [Towns] AS T
ON T.[TownID] = A.[TownID]
WHERE T.[Name] = @TOWN

--5.Salary Level Function

GO

CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(10) AS      
BEGIN
	            DECLARE @salaryLevel VARCHAR(10)
				IF (@salary < 30000)
				SET @salaryLevel = 'Low'
				ELSE IF(@salary <= 50000)
				SET @salaryLevel = 'Average'
				ELSE
				SET @salaryLevel = 'High'
				RETURN @salaryLevel
END

--6.Employees by Salary Level

GO

CREATE OR ALTER PROC usp_EmployeesBySalaryLevel(@levelOfSalary VARCHAR(10))
AS 
SELECT [FirstName],[LastName]
FROM 
(
	        SELECT [FirstName],
				   [LastName],
				   dbo.ufn_GetSalaryLevel([Salary]) AS [Level]
			  FROM [Employees]
)  AS [SUBQUERY]
WHERE [Level] = @levelOfSalary

GO

--7.Define Function

GO

CREATE FUNCTION ufn_IsWordComprised(@SetOfLetters NVARCHAR(20), @word NVARCHAR(20))
RETURNS BIT
AS
BEGIN
		SET @SetOfLetters = LOWER(@SetOfLetters)
		SET @word = LOWER(@word)
		DECLARE @CurrentIndex INT
		SET @CurrentIndex = 1
		WHILE (@CurrentIndex <= LEN(@word))
			BEGIN
					DECLARE @CurrentChar CHAR
					SET @CurrentChar = SUBSTRING(@word,@CurrentIndex,1 )
					IF (CHARINDEX(@CurrentChar,@SetOfLetters) = 0)
					BEGIN
						RETURN 0
					END
					SET @CurrentIndex += 1
			END
   RETURN 1
END

--8.* Delete Employees and Departments

GO

CREATE PROCEDURE usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS
BEGIN
    ---First we need to delete all records from EmployeesProjects where EmployeeID is one of the lately deleted
    DELETE FROM [EmployeesProjects]
    WHERE [EmployeeID] IN (
                            SELECT [EmployeeID]
                              FROM [Employees]
                             WHERE [DepartmentID] = @departmentId
                          )
    
    ---We need to set ManagerID to NULL of all Employees which have their Manager lately deleted
    UPDATE [Employees]
    SET [ManagerID] = NULL
    WHERE [ManagerID] IN (
                            SELECT [EmployeeID]
                              FROM [Employees]
                             WHERE [DepartmentID] = @departmentId
                          )
 
    ---We need to alter ManagerID column from Departments in order to be nullable because we need to set
    ---ManagerID to NULL of all Departments that have their Manager lately deleted
    ALTER TABLE [Departments]
    ALTER COLUMN [ManagerID] INT
 
    ---We need to set ManagerID to NULL (no Manager) to all departments that have their Manager lately deleted
    UPDATE [Departments]
    SET [ManagerID] = NULL
    WHERE [ManagerID] IN (
                            SELECT [EmployeeID]
                              FROM [Employees]
                             WHERE [DepartmentID] = @departmentId
                          )
    
    ---We need to delete all employees from the lately deleted department
    DELETE FROM [Employees]
    WHERE [DepartmentID] = @departmentId
 
    ---Lastly we delete wanted department
    DELETE FROM [Departments]
    WHERE [DepartmentID] = @departmentId
 
    SELECT COUNT(*)
      FROM [Employees]
     WHERE [DepartmentID] = @departmentId
END

GO

--2. Queries for Bank Database

USE [Bank]

--9.Find Full Name

GO

CREATE PROC usp_GetHoldersFullName
AS 
SELECT CONCAT([FirstName],' ',[LastName]) AS [Full Name]
FROM [AccountHolders]

--10.People with Balance Higher Than

GO

CREATE PROC usp_GetHoldersWithBalanceHigherThan(@NUMBER MONEY)
AS
SELECT [FirstName], [LastName]
FROM(
		SELECT AH.[FirstName], 
		       AH.[LastName],
			   SUM(A.Balance) AS [Total]
		FROM [Accounts] AS A
		JOIN [AccountHolders] AS AH
		ON A.[AccountHolderId] = AH.[Id]
		GROUP BY [FirstName],[LastName]
) AS [SUBQUERY]
WHERE [Total] > @NUMBER
ORDER BY [FirstName],[LastName]

--11.Future Value Function

GO

CREATE FUNCTION ufn_CalculateFutureValue 
(
        --параметри на функцията
		@sum DECIMAL(18,4), 
		@yearlyInterest FLOAT(53),
		@numberOfYears INT
)
RETURNS DECIMAL(18,4)
AS 
BEGIN
		DECLARE @futureValue DECIMAL(18,4);
		SELECT @futureValue = @sum*(POWER((1 + @yearlyInterest),@numberOfYears));
		RETURN @futureValue
END

GO

--12.Calculating Interest

CREATE PROC usp_CalculateFutureValueForAccount(@accountId INT, @interestRate FLOAT)
AS
BEGIN 
	SELECT A.Id AS [Account Id],
		   AH.FirstName AS [First Name], 
		   AH.LastName  AS [Last Name], 
		   A.Balance AS [Current Balance],
		   dbo.ufn_CalculateFutureValue(A.Balance, @interestRate, 5)  AS [Balance in 5 years]        
	FROM Accounts AS A
	JOIN AccountHolders AS AH 
	ON A.AccountHolderId = AH.Id
	WHERE A.Id = @accountId
END


--3. Queries for Diablo Database

USE [Diablo]

--13.*Scalar Function: Cash in User Games Odd Rows

GO

CREATE FUNCTION ufn_CashInUsersGames (@gameName NVARCHAR(50))
RETURNS TABLE
AS 
RETURN SELECT(
            SELECT SUM([Cash]) AS [SumCash]
            FROM (
                    SELECT g.[Name],
                           ug.[Cash],
                           ROW_NUMBER() OVER(PARTITION BY g.[Name] ORDER BY ug.[Cash] DESC) AS [RowNumber]
                      FROM [UsersGames] AS ug
                    JOIN [Games] AS g
                    ON ug.[GameId] = g.[Id]
                    WHERE g.[Name] = @gameName
                 ) AS [RowNumberSubQuery]
            WHERE [RowNumber] % 2 <> 0
         ) AS [SumCash]
 
GO
 
SELECT * FROM ufn_CashInUsersGames('Love in a mist')