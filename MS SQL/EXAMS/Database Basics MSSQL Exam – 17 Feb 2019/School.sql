--CREATE DATABASE [School]

--Section 1. DDL (30 pts)

--1.Database Design

CREATE TABLE [Students]
(
[Id] INT PRIMARY KEY IDENTITY,
[FirstName] NVARCHAR(30) NOT NULL,
[MiddleName] NVARCHAR(25) NULL,
[LastName] NVARCHAR(30) NOT NULL,
[Age] INT CHECK([Age] > 5 AND [Age] <100 AND [Age] > 0),
[Address] NVARCHAR(50) NULL,
[Phone] CHAR(10) NULL
)

CREATE TABLE [Subjects]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(20) NOT NULL,
[Lessons] INT CHECK([Lessons] >0) NOT NULL
)

CREATE TABLE [StudentsSubjects]
(
[Id] INT PRIMARY KEY IDENTITY,
[StudentId] INT FOREIGN KEY REFERENCES [Students]([Id]) NOT NULL,
[SubjectId] INT FOREIGN KEY REFERENCES [Subjects]([Id]) NOT NULL,
[Grade] DECIMAL(8,2) CHECK([Grade] BETWEEN 2 AND 6) NOT NULL
)

CREATE TABLE [Exams]
(
[Id] INT PRIMARY KEY IDENTITY,
[Date] DATETIME,
[SubjectId] INT FOREIGN KEY REFERENCES [Subjects]([Id]) NOT NULL,
)

CREATE TABLE [StudentsExams]
(
[StudentId] INT FOREIGN KEY REFERENCES [Students]([Id]) NOT NULL,
[ExamId] INT FOREIGN KEY REFERENCES [Exams]([Id]) NOT NULL,
[Grade] DECIMAL(8,2) CHECK([Grade] BETWEEN 2 AND 6) NOT NULL,
PRIMARY KEY ([StudentId],[ExamId])
)

CREATE TABLE [Teachers]
(
[Id] INT PRIMARY KEY IDENTITY,
[FirstName] NVARCHAR(20) NOT NULL,
[LastName] NVARCHAR(20) NOT NULL,
[Address] NVARCHAR(20) NOT NULL,
[Phone] CHAR(10) NULL,
[SubjectId] INT FOREIGN KEY REFERENCES [Subjects]([Id]) NOT NULL
)

CREATE TABLE [StudentsTeachers]
(
[StudentId] INT FOREIGN KEY REFERENCES [Students]([Id]) NOT NULL,
[TeacherId] INT FOREIGN KEY REFERENCES [Teachers]([Id]) NOT NULL,
PRIMARY KEY ([StudentId],[TeacherId])
)

--Section 2. DML (10 pts)

--2.Insert

INSERT INTO [Subjects] ([Name], [Lessons]) 
VALUES 
('Geometry',12),
('Health',10),
('Drama', 7),
('Sports', 9)

INSERT INTO [Teachers] ([FirstName], [LastName], [Address], [Phone], [SubjectId]) 
VALUES
 ('Ruthanne', 'Bamb', '84948 Mesta Junction', '3105500146', 6),
('Gerrard', 'Lowin', '370 Talisman Plaza', '3324874824', 2),
('Merrile', 'Lambdin', '81 Dahle Plaza', '4373065154', 5),
('Bert', 'Ivie', '2 Gateway Circle', '4409584510', 4)

--3.Update

UPDATE [StudentsSubjects]
SET [Grade] = 6 
WHERE [SubjectId] IN (1,2) AND [Grade] >= 5.50

--4.Delete

DELETE [StudentsTeachers]
WHERE [TeacherId] IN 
                (
                SELECT [Id]
				FROM  [Teachers]
				WHERE [Phone] LIKE '%72%'
				)

DELETE [Teachers]
WHERE [Phone] LIKE '%72%'

--Section 3. Querying (40 pts)

--5.Teen Students

SELECT [FirstName],[LastName],[Age]
FROM [Students]
WHERE [Age] >=12
ORDER BY [FirstName],[LastName]

--6.Students Teachers

SELECT [FirstName],[LastName],
        COUNT([TeacherId]) AS [TeachersCount]
FROM [Students] AS S
JOIN [StudentsTeachers] AS ST
ON S.[Id] = ST.[StudentId]
GROUP BY [FirstName],[LastName]

--7.Students to Go

SELECT CONCAT([FirstName],' ',[LastName])  AS [Full Name]
FROM [Students] AS S
LEFT JOIN [StudentsExams] AS SE
ON S.[Id] = SE.[StudentId]
WHERE SE.[ExamId] IS NULL
ORDER BY [Full Name]

--8.Top Students

SELECT TOP(10) [FirstName],[LastName],
			   FORMAT(AVG([Grade]),'N2') AS [Grade]
FROM [Students] AS S
JOIN [StudentsExams] AS SE
ON S.[Id] = SE.[StudentId]
GROUP BY [FirstName],[LastName]
ORDER BY [Grade] DESC,[FirstName],[LastName]

--9.Not So In The Studying

SELECT CONCAT(S.[FirstName],' ',S.[MiddleName],' ', S.[LastName])  AS [Full Name]
FROM [Students] AS S
LEFT JOIN [StudentsSubjects] AS SS
ON SS.[StudentId] = S.[Id] 
LEFT JOIN [Subjects] AS SU
ON SU.[Id] = SS.[SubjectId]
WHERE SS.[Id] IS NULL
ORDER BY [Full Name]


--10.Average Grade per Subject

SELECT S.[Name],
        AVG([Grade]) AS [AverageGrade]
FROM [Subjects] AS  S
JOIN [StudentsSubjects] AS SS
ON S.[Id] = SS.[SubjectId]
GROUP BY S.[Id],S.[Name]
ORDER BY S.[Id]

--Section 4. Programmability (20 pts)

--11.Exam Grades

GO

CREATE OR ALTER FUNCTION udf_ExamGradesToUpdate(@studentId INT, @grade DECIMAL(8,2))
RETURNS VARCHAR(MAX) 
AS 
BEGIN 
     
     DECLARE @ValidID INT
	 SET @ValidID = (
					 SELECT TOP(1) [StudentId] 
					 FROM [StudentsExams] 
					 WHERE [StudentId] = @studentId
					 )


     DECLARE @Count INT
     SET @Count = (
					SELECT COUNT([Grade])
					FROM [StudentsExams] 
					WHERE ([Grade] BETWEEN @grade AND @grade + 0.50) AND [StudentId] = @studentId
					GROUP BY [StudentId]
		           )

	 DECLARE @StudentName VARCHAR(30)
	 SET @StudentName = (
							SELECT [FirstName]
							FROM [Students]
							WHERE [Id] = @studentId
					     )

	IF(@grade > 6.00 )
	RETURN ('Grade cannot be above 6.00!')
	IF ( @ValidID IS NULL )
	RETURN ('The student with provided id does not exist in the school!')
	
	RETURN ('You have to update ' + CAST(@Count AS NVARCHAR(10)) + ' grades for the student ' + @StudentName)
	
END

GO

--12.Exclude from school

CREATE PROC usp_ExcludeFromSchool(@StudentId INT)
AS 

 DECLARE @ValidID INT
	 SET @ValidID = (
					 SELECT [Id] 
					 FROM [Students] 
					 WHERE [Id] = @StudentId
					 )

	IF(@ValidID IS NULL)
	BEGIN
	RAISERROR ('This school has no student with the provided id!',16,1)
	RETURN
	END

DELETE [StudentsExams]
WHERE [StudentId] = @StudentId

DELETE [StudentsSubjects]
WHERE [StudentId] = @StudentId

DELETE [StudentsTeachers]
WHERE [StudentId] = @StudentId

DELETE Students
WHERE [Id] = @StudentId

GO