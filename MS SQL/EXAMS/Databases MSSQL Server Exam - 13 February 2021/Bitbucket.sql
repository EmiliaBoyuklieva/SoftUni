CREATE DATABASE [Bitbucket]

--1.Database Design

CREATE TABLE [Users]
(
[Id] INT PRIMARY KEY IDENTITY,
[Username] VARCHAR(30) NOT NULL,
[Password] VARCHAR(30) NOT NULL,
[Email] VARCHAR(50) NOT NULL
)

CREATE TABLE [Repositories]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [RepositoriesContributors]
(
[RepositoryId] INT FOREIGN KEY REFERENCES [Repositories]([Id]) NOT NULL,
[ContributorId] INT FOREIGN KEY REFERENCES [Users]([Id]) NOT NULL,
PRIMARY KEY([RepositoryId],[ContributorId])
)

CREATE TABLE [Issues]
(
[Id] INT PRIMARY KEY IDENTITY,
[Title] VARCHAR(255) NOT NULL,
[IssueStatus] CHAR(6) NOT NULL,
[RepositoryId] INT FOREIGN KEY REFERENCES [Repositories]([Id]) NOT NULL,
[AssigneeId] INT FOREIGN KEY REFERENCES [Users]([Id]) NOT NULL
)

CREATE TABLE [Commits]
(
[Id] INT PRIMARY KEY IDENTITY,
[Message] VARCHAR(255) NOT NULL,
[IssueId] INT FOREIGN KEY REFERENCES [Issues]([Id]),
[RepositoryId] INT FOREIGN KEY REFERENCES [Repositories]([Id]) NOT NULL,
[ContributorId] INT FOREIGN KEY REFERENCES [Users]([Id]) NOT NULL
)

CREATE TABLE [Files]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(100) NOT NULL,
[Size] DECIMAL (20,2) NOT NULL,
[ParentId] INT FOREIGN KEY REFERENCES [Files]([Id]),
[CommitId] INT FOREIGN KEY REFERENCES [Commits]([Id]) NOT NULL
)

--Section 2. DML (10 pts)

--2.Insert

INSERT INTO [Issues]([Title], [IssueStatus], [RepositoryId], [AssigneeId])
VALUES
('Critical Problem with HomeController.cs file', 'open', 1, 4),
('Typo fix in Judge.html', 'open', 4, 3),
('Implement documentation for UsersService.cs', 'closed', 8, 2),
('Unreachable code in Index.cs', 'open', 9, 8)

INSERT INTO [Files]([Name], [Size], [ParentId], [CommitId])
VALUES
('Trade.idk', 2598.0, 1, 1),
('menu.net', 9238.31, 2, 2),
('Administrate.soshy', 1246.93, 3, 3),
('Controller.php', 7353.15, 4, 4),
('Find.java', 9957.86, 5, 5),
('Controller.json', 14034.87, 3, 6),
('Operate.xix', 7662.92, 7, 7)

--3.Update

UPDATE [Issues]
SET [IssueStatus] = 'closed'
WHERE [AssigneeId] = 1

--4.Delete

DELETE [Issues]
WHERE [RepositoryId] = 3

DELETE [RepositoriesContributors]
WHERE [RepositoryId] = 3


--Section 3. Querying (40 pts)

--5.Commits

SELECT [Id],[Message],[RepositoryId],[ContributorId]
FROM [Commits]
ORDER BY [Id],[Message],[RepositoryId],[ContributorId]

--6.Front-end

SELECT [Id],[Name],[Size] 
FROM [Files]
WHERE [Size] >1000 AND [Name] LIKE '%html%'
ORDER BY [Size] DESC,[Id],[Name]

--7.Issue Assignment

SELECT I.[Id],
       CONCAT(U.[Username],' : ',I.[Title]) AS [IssueAssignee]
FROM [Users] AS U
RIGHT JOIN [Issues] AS I
ON I.[AssigneeId] = U.[Id]
ORDER BY I.[Id] DESC,I.[Title]

--8.Single Files

SELECT [Id],[Name],
CONCAT([Size],'KB') AS [Size]
FROM [Files]
WHERE [Id] NOT IN  (
					SELECT [ParentId] 
					FROM [Files]
					WHERE [ParentId] IS NOT NULL
				   ) 
ORDER BY [Id], [Name],[Size] DESC

--9.Commits in Repositories

SELECT TOP(5) R.[Id],R.[Name],
COUNT(R.[Name]) AS [Commits]
FROM [Commits] AS C
JOIN [Repositories] AS R 
ON C.[RepositoryId] = R.[Id]
JOIN [RepositoriesContributors] AS RC 
ON RC.[RepositoryId]=R.[Id]
GROUP BY R.[Id],R.[Name]
ORDER BY [Commits] DESC, R.[Id],R.[Name]

--10.Average Size

SELECT U.[Username],
       AVG(F.[Size]) AS [Size]
FROM [Commits] AS C
JOIN [Users] AS U 
ON U.[Id] = C.[ContributorId]
JOIN [Files] AS F
ON C.[Id] = F.[CommitId]
GROUP BY U.[Username]
ORDER BY [Size] DESC,U.[Username]

--Section 4. Programmability (20 pts)

--11.All User Commits

GO

CREATE FUNCTION udf_AllUserCommits(@username VARCHAR(50))
RETURNS INT
AS
BEGIN
      DECLARE @Result INT
	     SET @Result =
		 (
			 SELECT COUNT(C.ContributorId) AS [Commits]
			 FROM [Users] AS U 
			 JOIN [Commits] AS C
			 ON U.Id = C.ContributorId
			 WHERE U.Username = @username
		 )
	  RETURN @Result
END

GO

--12. Search for Files

-- with wildcards

CREATE PROC usp_SearchForFiles(@fileExtension VARCHAR(5))
AS 
BEGIN 
        
		SELECT [Id],[Name],
		       CONCAT([Size],'KB') AS [Size]
		FROM Files
		WHERE [Name] LIKE '%' + @fileExtension + '%'
		ORDER BY [Id],[Name],[Size] DESC
END

GO


-- with variables
GO

CREATE PROC usp_SearchForFiles(@fileExtension VARCHAR(5))
AS 
BEGIN 
        DECLARE @fileExtensionLenght INT = LEN(@fileExtension)
		SELECT [Id],[Name],
		       CONCAT([Size],'KB') AS [Size]
		FROM Files
		WHERE RIGHT([Name], @fileExtensionLenght) = @fileExtension
		ORDER BY [Id],[Name],[Size] DESC
END

GO
EXEC usp_SearchForFiles 'intro'
