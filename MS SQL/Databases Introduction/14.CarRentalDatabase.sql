
CREATE TABLE [Categories]
(
[Id] INT PRIMARY KEY IDENTITY,
[CategoryName] NVARCHAR(30) NOT NULL,
[DailyRate] INT,
[WeeklyRate] INT,
[MonthlyRate] INT,
[WeekendRate] INT
)


CREATE TABLE [Cars]
(
[Id] INT PRIMARY KEY IDENTITY,
[PlateNumber] NVARCHAR(20) NOT NULL,
[Manufacturer] NVARCHAR(30) ,
[Model] NVARCHAR(30),
[CarYear] INT,
[CategoryId] INT FOREIGN KEY REFERENCES [Categories](Id) NOT NULL,
[Doors] INT,
[Picture] VARBINARY(MAX),
[Condition] NVARCHAR(30),
[Available] BIT  DEFAULT ('true')
)



CREATE TABLE [Employees]
(
[Id] INT PRIMARY KEY IDENTITY,
[FirstName] NVARCHAR(50) NOT NULL,
[LastName] NVARCHAR(50) NOT NULL,
[Title] NVARCHAR(50),
[Notes] NVARCHAR(MAX)
)

CREATE TABLE [Customers]
(
[Id] INT PRIMARY KEY IDENTITY,
[DriverLicenceNumber] NVARCHAR(10),
[FullName] NVARCHAR(50),
[Address] NVARCHAR(30),
[City] NVARCHAR(50),
[ZIPCode] INT,
[Notes] NVARCHAR(MAX)
)


CREATE TABLE [RentalOrders]
(
[Id] BIGINT PRIMARY KEY IDENTITY,
[EmployeeId] INT FOREIGN KEY REFERENCES [Employees](Id) NOT NULL,
[CustomerId] INT FOREIGN KEY REFERENCES [Customers](Id) NOT NULL,
[CarId] INT FOREIGN KEY REFERENCES [Cars](Id)NOT NULL,
[TankLevel] INT NULL,
[KilometrageStart] INT  NOT NULL,
[KilometrageEnd] INT NOT NULL,
[TotalKilometrage] INT NOT NULL,
[StartDate] DATETIME2,
[EndDate] DATETIME2,
[TotalDays] INT,
[RateApplied] INT,
[TaxRate] INT,
[OrderStatus] CHAR(20),
[Notes] NVARCHAR(MAX) NULL
)


INSERT INTO [Categories] ([CategoryName] ,[DailyRate],[WeeklyRate],[MonthlyRate],[WeekendRate] ) 
VALUES
	    ('Off-Road', 8, 8, 8, 8),
		('Track', 10, 10, 10, 10),
		('City', 7, 3, 6, 8)



INSERT INTO [Cars]([PlateNumber],[Manufacturer] ,[Model],[CarYear],[CategoryId],[Doors],[Picture],[Condition],[Available] ) 
VALUES
	        ('A 4936 AT', 'BMW', 'X5', 2007, 3, 4, NULL, 'Perfect', 0),
			('PB 7478 AM', 'Mercedes', 'S500', 2017, 1, 2, NULL, 'Perfect', 1),
			('B 6547 AK', 'Audi', 'A5', 2012, 2, 4, NULL, 'Good', 1)
			

INSERT INTO [Employees] ([FirstName], [LaStName], [Title], [Notes])
VALUES		('Petar', 'Petrov', NULL, NULL),
			('Iva', 'Ivanova', NULL, NULL),
			('Georgi', 'Georgiev', NULL, NULL)


INSERT INTO [Customers] ([DriverLicenceNumber], [FullName], [Address], [City], [ZIPCode], [Notes])
VALUES		('12457', 'Petar Petrov', NULL, 'Plovdiv', 7000, NULL),
			('89657', 'Ivan Ivanov', NULL, 'Varna', 7007, NULL),
			('47535', 'Stefan Stefanov',NULL, 'Ruse', 700, NULL)


INSERT INTO [RentalOrders] ([EmployeeId], [CustomerId],[CarId],[TankLevel],[KilometrageStart],[KilometrageEnd],[TotalKilometrage],[StartDate],[EndDate],[TotalDays],[RateApplied],[TaxRate],[OrderStatus],[Notes]) 
VALUES
            (3, 1, 2, 78, 1000, 1500, 2500, '10/10/2020', '10/19/2020', 9,5,7, 'Complited',NULL),
			(2, 2, 1, 63, 1000, 1800, 2800, '10/10/2020', '10/25/2020', 15,4,8, 'Complited',NULL),
			(1, 1, 2, 95, 1000, 1400, 2400, '10/10/2020', '10/17/2020', 7,3,9, 'Not complited',NULL)
		
		