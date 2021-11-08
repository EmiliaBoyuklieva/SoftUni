--1.Database design

CREATE TABLE [Countries]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) UNIQUE,
)


CREATE TABLE [Customers]
(
[Id] INT PRIMARY KEY IDENTITY,
[FirstName] NVARCHAR(25) ,
[LastName] NVARCHAR(25) ,
[Gender] CHAR(1) CHECK([Gender] = 'M' OR [Gender]= 'F'),
[Age] INT,
[PhoneNumber] CHAR(10),
[CountryId] INT FOREIGN KEY REFERENCES [Countries]([Id])
)


CREATE TABLE [Products]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(25) UNIQUE,
[Description] NVARCHAR(250) ,
[Recipe] NVARCHAR(MAX),
[Price] DECIMAL(18,2) CHECK([Price]>=0)
)


CREATE TABLE [Feedbacks]
(
[Id] INT PRIMARY KEY IDENTITY,
[Description] NVARCHAR(255) ,
[Rate] DECIMAL(18,2) CHECK([Rate] BETWEEN 0 AND 10),
[ProductId] INT FOREIGN KEY REFERENCES [Products]([Id]),
[CustomerId] INT FOREIGN KEY REFERENCES [Customers]([Id])
)


CREATE TABLE [Distributors]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(25) UNIQUE,
[AddressText] NVARCHAR(30),
[Summary] NVARCHAR(200) ,
[CountryId]  INT FOREIGN KEY REFERENCES [Countries]([Id])
)

CREATE TABLE [Ingredients]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(30),
[Description] NVARCHAR(200) ,
[OriginCountryId]  INT FOREIGN KEY REFERENCES [Countries]([Id]),
[DistributorId]  INT FOREIGN KEY REFERENCES [Distributors]([Id])
)

CREATE TABLE [ProductsIngredients]
(
[ProductId] INT FOREIGN KEY REFERENCES [Products]([Id]),
[IngredientId] INT FOREIGN KEY REFERENCES [Ingredients]([Id])
PRIMARY KEY([ProductId],[IngredientId])
)

--2.Insert

INSERT INTO [Distributors] ([Name],[Summary],[AddressText], [CountryId]) 
VALUES
('Deloitte & Touche','Customizable neutral traveling','6 Arch St #9757',2),
('Congress Title','Customer loyalty','58 Hancock St',13),
('Kitchen People','Triple-buffered stable delivery','3 E 31st St #77',1),
('General Color Co Inc','Focus group','6185 Bohn St #72',21),
('Beck Corporation','Quality-focused 4th generation hardware','21 E 64th Ave',23)

INSERT INTO [Customers] ([FirstName], [LastName], [Gender], [Age],[PhoneNumber], [CountryId]) 
VALUES
('Francoise','Rautenstrauch','M',15,'0195698399',5),
('Kendra','Loud','F',22,'0063631526',11),
('Lourdes','Bauswell','M',50,'0139037043',8),
('Hannah','Edmison','F',18,'0043343686',1),
('Tom','Loeza','M',31,'0144876096',23),
('Queenie','Kramarczyk','F',30,'0064215793',29),
('Hiu','Portaro','M',25,'0068277755',16),
('Josefa','Opitz','F',43,'0197887645',17)

--3.Update

UPDATE [Ingredients]
SET [DistributorId] = 35
WHERE [Name] IN('Bay Leaf', 'Paprika','Poppy')

UPDATE [Ingredients]
SET [OriginCountryId] = 14
WHERE [OriginCountryId] = 8

--4.Delete

DELETE [Feedbacks]
WHERE [ProductId] = 5 OR [CustomerId] = 14

--5.Products by Price

SELECT [Name],[Price],[Description]
FROM [Products]
ORDER BY [Price] DESC, [Name]

--6.Negative Feedback

SELECT F.[ProductId],F.[Rate],F.[Description],F.[CustomerId],C.[Age],C.[Gender] 
FROM [Feedbacks] AS F
JOIN [Customers] AS C
ON F.[CustomerId] = C.[Id]
WHERE [Rate]<5
ORDER BY [ProductId] DESC,[Rate]

--7.Customers without Feedback

SELECT CONCAT(C.[FirstName],' ' ,C.[LastName]) AS [CustomerName],
              C.[PhoneNumber],C.[Gender] 
FROM [Customers] AS C
WHERE [Id] NOT IN (SELECT [CustomerId] FROM [Feedbacks])
ORDER BY C.[Id]

--8.Customers by Criteria

SELECT [FirstName],[Age],[PhoneNumber]
FROM [Customers] AS C
WHERE ([Age]>=21 AND [FirstName] LIKE'%an%') 
                 OR ([PhoneNumber] LIKE '%38' AND [CountryId]<>31)
ORDER BY [FirstName],[Age] DESC 

--9.Middle Range Distributors

SELECT D.[Name] AS [DistributorName],
       I.[Name] AS [IngredientName],
       P.[Name] AS [ProductName],
       AVG([Rate]) AS [AverageRate]
 FROM [Distributors] AS D
 JOIN [Ingredients] AS I 
 ON D.[Id]=I.[DistributorId]
 JOIN [ProductsIngredients] AS PIN
 ON I.[Id]=PIN.[IngredientId]
 JOIN [Products] AS P 
 ON PIN.[ProductId]=P.[Id]
 JOIN [Feedbacks] AS F 
 ON P.[Id]=F.[ProductId]
 GROUP BY D.[Name],I.[Name],P.[Name]
 HAVING AVG([Rate]) BETWEEN 5 AND 8
 ORDER BY [DistributorName],[IngredientName],[ProductName]

--10.Country Representative

SELECT [CountryName], [DisributorName]
  FROM(
		SELECT *,
			   DENSE_RANK() OVER (PARTITION BY [CountryName] ORDER BY [IngredientCount] DESC) AS [Rank]
		  FROM (
				    SELECT C.[Name] AS [CountryName], 
				    	   D.[Name] AS [DisributorName],
				    	   COUNT(i.[Name]) AS [IngredientCount]
				      FROM [Countries] AS C
				      LEFT JOIN [Distributors] AS D 
					  ON C.[Id] = D.[CountryId]
				      LEFT JOIN [Ingredients] AS I
					  ON D.[Id] = I.[DistributorId]
				      GROUP BY C.[Name], D.[Name]
			    ) AS [RANKED]
	   ) AS [SUBQUERY]
  WHERE [Rank] = 1
  ORDER BY [CountryName], [DisributorName]

--11.Customers with Countries

GO

CREATE VIEW v_UserWithCountries 
AS 
SELECT CONCAT(C.[FirstName],' ',C.[LastName]) AS [CustomerName],
        C.[Age],
		C.[Gender],
		CS.[Name] AS [CountryName]
FROM [Customers] AS C
JOIN [Countries] AS CS
ON C.[CountryId] = CS.[Id]

--12.Delete Products

GO

CREATE OR ALTER TRIGGER tr_Deleted
ON [Products]
INSTEAD OF DELETE
AS
BEGIN 

	DECLARE @ProductID INT 
	SET @ProductID = ( 
	                    SELECT P.[Id]
			            FROM [Products] AS P 
					    JOIN deleted AS d
						ON d.Id = P.[Id]
					   )

	DELETE [Feedbacks]
	WHERE [ProductId] = @ProductID

	DELETE [ProductsIngredients]
    WHERE [ProductId] = @ProductID
   
    DELETE [Products]
    WHERE [Id] = @ProductID
END
