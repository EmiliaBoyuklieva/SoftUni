CREATE TABLE [People]
(
[Id] BIGINT PRIMARY KEY IDENTITY,
[Name] VARCHAR(200) NOT NULL,
[Picture] VARCHAR(200),
[Height] DECIMAL(3,2),
[Weight] DECIMAL(5,2),
[Gender] CHAR(1) NOT NULL,
[Birthdate] DATE NOT NULL,
[Biography] NVARCHAR(MAX)
)

INSERT INTO [People] ([Name], [Picture], [Height], [Weight], [Gender], [Birthdate], [Biography]) VALUES
	('Petar', NULL, 1.70, 84.20, 'm', '1999-07-25', 'Hi, I am Petar Petrov and I live in Sofia,Bulgaria.')
		

