CREATE TABLE [Directors]
(
[Id] INT PRIMARY KEY IDENTITY,
[DirectorName] NVARCHAR(30) UNIQUE NOT NULL,
[Notes] NVARCHAR(MAX) NULL
)

CREATE TABLE [Genres]
(
[Id] INT PRIMARY KEY IDENTITY,
[GenreName] NVARCHAR(30) UNIQUE NOT NULL,
[Notes] NVARCHAR(MAX) NULL
)

CREATE TABLE [Categories]
(
[Id] INT PRIMARY KEY IDENTITY,
[CategoryName] NVARCHAR(30) UNIQUE NOT NULL,
[Notes] NVARCHAR(MAX) NULL
)

CREATE TABLE [Movies]
(
[Id] BIGINT PRIMARY KEY IDENTITY,
[Title] NVARCHAR(30)  NOT NULL,
[DirectorId] INT FOREIGN KEY REFERENCES [Directors](Id),
[CopyrightYear] DATETIME2 NOT NULL,
[Length] CHAR(20) NULL,
[GenreId] INT FOREIGN KEY REFERENCES [Genres](Id),
[CategoryId] INT FOREIGN KEY REFERENCES [Categories](Id),
[Rating] INT NULL,
[Notes] NVARCHAR(MAX) NULL
)

INSERT INTO [Directors] ([DirectorName], [Notes]) VALUES
	    ('petar123', 'Have homework'),
		('ivan123', 'go shopping'),
		('iva123', 'clean'),
		('jasmin123', 'eat'),
		('stefan123', 'drink water')

INSERT INTO [Genres] ([GenreName], [Notes]) VALUES
	    ('horror', 'horror'),
		('comedy', 'comedy'),
		('criminal', 'criminal'),
		('romantic', 'romantic'),
		('drama', 'drama')

INSERT INTO [Categories] ([CategoryName], [Notes]) VALUES
	    ('easy', 'horror'),
		('medium', 'comedy'),
		('hard', 'criminal'),
		('hard level 2', 'romantic'),
		('hard level 3', 'drama')

INSERT INTO [Movies] ([Title], [DirectorId],[CopyrightYear],[Length],[GenreId],[CategoryId],[Rating],[Notes]) VALUES
	    ('Escape room', 3, '2012-05-05',20,2,1,10,'good'),
		('Escape room', 1, '2012-05-05',10,4,2,10,'good'),
		('Escape room', 4, '2012-05-05',15,5,4,10,'good'),
		('Escape room', 5, '2012-05-05',8,3,3,10,'good'),
		('Escape room', 2, '2012-05-05',10,1,5,10,'good')
		