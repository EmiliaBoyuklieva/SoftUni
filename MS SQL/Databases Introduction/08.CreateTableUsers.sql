CREATE TABLE [Users]
(
[Id] BIGINT PRIMARY KEY IDENTITY,
[Username] VARCHAR(30) UNIQUE NOT NULL,
[Password] VARCHAR(26) UNIQUE NOT NULL,
[ProfilePicture] CHAR(900),
[LastLoginTime] DATETIME2,
[IsDeleted] BIT NOT NULL
)


INSERT INTO [Users] ([Username], [Password], [ProfilePicture], [LastLoginTime], [IsDeleted]) VALUES
	('petar123', 'petar123', NULL, '1999-07-25', 'TRUE'),
		('ivan123', 'ivan123',NULL,'1998-02-20', 'FALSE'),
		('iva123', 'iva123', NULL, '1999-01-01', 'TRUE'),
		('jasmin123', 'jasmin123', NULL, '1997-05-07', 'FALSE'),
		('stefan123', 'stefan123',NULL, '1995-10-29', 'FALSE')
