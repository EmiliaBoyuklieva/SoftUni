CREATE TABLE [Employees]
(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[FirstName] NVARCHAR(50) NOT NULL,
	[LastName] NVARCHAR(50) NOT NULL,
	[Title] NVARCHAR(50) NULL,
	[Notes] NVARCHAR(MAX)
)


CREATE TABLE[Customers]
(
	[AccountNumber] NVARCHAR(30)PRIMARY KEY ,
	[FirstName] NVARCHAR(50) NOT NULL,
	[LastName] NVARCHAR(50) NOT NULL,
	[PhoneNumber] INT NULL,
	[EmergencyName] NVARCHAR(100) NULL,
	[EmergencyNumber] INT NULL,
	[Notes] NVARCHAR(MAX) 
)



CREATE TABLE [RoomStatus]
(
	[RoomStatus] NVARCHAR(30) PRIMARY KEY NOT NULL,
	[Notes] NVARCHAR(MAX) 
)




CREATE TABLE[RoomTypes]
(
	[RoomType] NVARCHAR(50) PRIMARY KEY NOT NULL,
	[Notes] NVARCHAR(MAX) 
)

CREATE TABLE[BedTypes]
(
	[BedType] NVARCHAR(30) PRIMARY KEY NOT NULL,
	[Notes] NVARCHAR(MAX)
)

CREATE TABLE[Rooms]
(
	[RoomNumber] NVARCHAR(10) PRIMARY KEY NOT NULL ,
	[RoomType] NVARCHAR(50) FOREIGN KEY REFERENCES [RoomTypes](RoomType) NOT NULL,
	[BedType] NVARCHAR(30) FOREIGN KEY REFERENCES [BedTypes](BedType) NOT NULL,
	[Rate] INT NULL,
	[RoomStatus] NVARCHAR(30) FOREIGN KEY REFERENCES [RoomStatus](RoomStatus) NOT NULL,
	[Notes] NVARCHAR(MAX)
)



CREATE TABLE [Payments]
(
    [Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[EmployeeId] INT FOREIGN KEY REFERENCES [Employees](Id),
	[PaymentDate] DATETIME2 NULL,
	[AccountNumber] NVARCHAR(30)FOREIGN KEY REFERENCES [Customers](AccountNumber) NOT NULL,
	[FirstDateOccupied] DATETIME2 NOT NULL,
	[LastDateOccupied] DATETIME2 NOT NULL,
	[TotalDays] INT  NULL,
	[AmountCharged] INT  NULL,
	[TaxRate] INT NULL,
	[TaxAmount] INT NULL,
	[PaymentTotal] INT NOT NULL,
	[Notes] NVARCHAR(MAX)
)



CREATE TABLE [Occupancies]
(
    [Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[EmployeeId] INT FOREIGN KEY REFERENCES [Employees](Id) NOT NULL,
	[DateOccupied] DATETIME2 NULL,
	[AccountNumber] NVARCHAR(30) FOREIGN KEY REFERENCES [Customers](AccountNumber) NOT NULL,
	[RoomNumber] NVARCHAR(10) FOREIGN KEY REFERENCES [Rooms](RoomNumber) NOT NULL,
	[RateApplied] INT  NULL,
	[PhoneCharge] INT  NULL,
	[Notes] NVARCHAR(MAX)
)



INSERT INTO [Employees] ([FirstName], [LastName], [Title], [Notes])
VALUES		('Petar', 'Petrov', NULL, NULL),
			('Iva', 'Ivanova', NULL, NULL),
			('Georgi', 'Georgiev', NULL, NULL)




INSERT INTO [Customers] ([AccountNumber],[FirstName], [LastName],[PhoneNumber], [EmergencyName],[EmergencyNumber], [Notes])
VALUES		('1A','Petar', 'Petrov', 0874596312, 'PPP', 7000, NULL),
			('2A','Ivan', 'Ivanov', 0874247125, 'III', 7007, NULL),
			('3A','Stefan' ,'Stefanov',0887413529, 'SSS', 700, NULL)
			


INSERT INTO [RoomStatus]([RoomStatus],[Notes]) 
VALUES
	    ('Occupied', NULL),
		('Vacant & Dirty', NULL),
		('Check Out', NULL)

INSERT INTO [RoomTypes]([RoomType],[Notes]) 
VALUES
	    ('Single', NULL),
		('Double', NULL),
		('Triple', NULL)

INSERT INTO [BedTypes]([BedType],[Notes]) 
VALUES
	    ('Single bed', NULL),
		('Standard Double', NULL),
		('3 beds', NULL)


INSERT INTO [Rooms] ([RoomNumber],[RoomType], [BedType],[Rate],[RoomStatus],[Notes]) 
VALUES
       (1,'Single','Single bed',10,'Occupied',NULL),
      (2,'Double','Standard Double',10,'Vacant & Dirty',NULL),
      (3,'Triple','3 beds',10,'Check Out',NULL)


INSERT INTO [Payments] ([EmployeeId],[PaymentDate], [AccountNumber],[FirstDateOccupied],[LastDateOccupied],[TotalDays],[AmountCharged],[TaxRate],[TaxAmount],[PaymentTotal],[Notes]) 
VALUES
            (3, '10/10/2020', '1A', '10/10/2020', '10/15/2020',5,12,10,10,100,NULL),
			(2, '10/10/2020', '2A', '10/10/2020', '10/25/2020',15,12,10,10,100,NULL),
			(1, '10/10/2020', '3A', '10/10/2020', '10/17/2020',7,12,10,10,100,NULL)


INSERT INTO  [Occupancies]([EmployeeId], [DateOccupied],[AccountNumber],[RoomNumber],[RateApplied],[PhoneCharge],[Notes]) 
VALUES
            (3, '10/10/2020', '1A', 1,10,20 ,NULL),
			(2, '10/10/2020', '2A', 3, 7,23,NULL),
			(1, '10/10/2020', '3A', 2,15,30 ,NULL)
		


