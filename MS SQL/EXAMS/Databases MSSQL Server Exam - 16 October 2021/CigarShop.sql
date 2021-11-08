CREATE DATABASE [CigarShop]

--1.Database design

CREATE TABLE [Sizes]
(
  [Id] INT PRIMARY KEY IDENTITY,
  [Length] INT CHECK([Length] BETWEEN 10 AND 25) NOT NULL,
  [RingRange] DECIMAL(18,2) CHECK([RingRange] BETWEEN 1.5 AND 7.5) NOT NULL,
)


CREATE TABLE [Tastes]
(
  [Id] INT PRIMARY KEY IDENTITY,
  [TasteType] VARCHAR(20) NOT NULL,
  [TasteStrength] VARCHAR(15) NOT NULL,
  [ImageURL] NVARCHAR(100) NOT NULL
  )

  CREATE TABLE [Brands]
  (
  [Id] INT PRIMARY KEY IDENTITY,
  [BrandName] VARCHAR(20) UNIQUE NOT NULL,
  [BrandDescription] VARCHAR(MAX)
  )

  CREATE TABLE [Cigars]
  (
  [Id] INT PRIMARY KEY IDENTITY,
  [CigarName] VARCHAR(80) NOT NULL,
  [BrandId] INT FOREIGN KEY REFERENCES [Brands](Id) NOT NULL,
  [TastId] INT FOREIGN KEY REFERENCES [Tastes](Id) NOT NULL,
  [SizeId] INT FOREIGN KEY REFERENCES [Sizes](Id) NOT NULL,
  [PriceForSingleCigar] DECIMAL(18,2) NOT NULL, 
  [ImageURL] NVARCHAR(100) NOT NULL
  )

  CREATE TABLE[Addresses]
  (
    [Id] INT PRIMARY KEY IDENTITY,
  [Town] VARCHAR(30) NOT NULL,
  [Country] VARCHAR(30) NOT NULL UNIQUE,
   [Streat] NVARCHAR(100) NOT NULL,
   [ZIP] VARCHAR(20) NOT NULL
  )

  CREATE TABLE[Clients]
  (
   [Id] INT PRIMARY KEY IDENTITY,
  [FirstName] NVARCHAR(30) NOT NULL,
  [LastName] NVARCHAR(30) NOT NULL,
  [Email] NVARCHAR(50) NOT NULL,
  [AddressId] INT FOREIGN KEY REFERENCES [Addresses](Id) NOT NULL
  )

  CREATE TABLE [ClientsCigars]
  (
    [ClientId] INT FOREIGN KEY REFERENCES [Clients](Id),
	  [CigarId] INT FOREIGN KEY REFERENCES [Cigars](Id),
	  PRIMARY KEY([ClientId],[CigarId])
  )


--2.Insert

INSERT INTO [Cigars] ([CigarName], [BrandId], [TastId], [SizeId], [PriceForSingleCigar], [ImageURL]) 
VALUES
('COHIBA ROBUSTO', 9, 1, 5, 15.50,'cohiba-robusto-stick_18.jpg'),
('COHIBA SIGLO I', 9, 1, 10, 410.00,'cohiba-siglo-i-stick_12.jpg'),
('HOYO DE MONTERREY LE HOYO DU MAIRE', 14, 5, 11, 7.50,'hoyo-du-maire-stick_17.jpg'),
('HOYO DE MONTERREY LE HOYO DE SAN JUAN', 14, 4, 15, 32.00,'hoyo-de-san-juan-stick_20.jpg'),
('TRINIDAD COLONIALES', 2, 3, 8, 85.21,'trinidad-coloniales-stick_30.jpg')

INSERT INTO [Addresses] ([Town], [Country], [Streat], [ZIP]) 
VALUES
('Sofia','Bulgaria','18 Bul. Vasil levski','1000'),
('Athens','Greece','4342 McDonald Avenue','10435'),
('Zagreb','Croatia','4333 Lauren Drive','10000')

--3.Update

UPDATE [Cigars]
SET [PriceForSingleCigar] += [PriceForSingleCigar]*0.20
WHERE [TastId] = 1

UPDATE [Brands]
SET [BrandDescription] = 'New description'
WHERE [BrandDescription] IS NULL

--4.Delete

DELETE [Clients]
WHERE [AddressId] IN (
                      SELECT [Id] 
                      FROM [Addresses]
                      WHERE [Country] LIKE 'C%'
					  )

DELETE [Addresses]
WHERE [Country] LIKE 'C%'

--5.Cigars by Price

SELECT  [CigarName],
        [PriceForSingleCigar],
        [ImageURL]
FROM [Cigars]
ORDER BY [PriceForSingleCigar], [CigarName] DESC

--6.Cigars by Taste

SELECT  C.[Id],
     [CigarName],
     [PriceForSingleCigar],
     [TasteType],
     [TasteStrength]
FROM [Cigars] AS C
LEFT JOIN [Tastes] AS T
ON C.[TastId] = T.[Id]
WHERE [TasteType] in ('Earthy','Woody')
order by [PriceForSingleCigar] DESC

--7.Clients without Cigars

SELECT [Id],
       CONCAT([FirstName],' ', [LastName]) AS  [ClientName] ,
       [Email]
FROM [Clients] AS C
LEFT JOIN [ClientsCigars] AS CC
ON CC.[ClientId] = C.[Id]
WHERE [Id] NOT IN (
					SELECT [ClientId]  
					FROM [ClientsCigars]
				  )
ORDER BY [ClientName]

--8.First 5 Cigars

SELECT TOP(5) [CigarName],
     [PriceForSingleCigar],
     [ImageURL]
FROM [Sizes] AS S
JOIN [Cigars] AS C
ON S.[Id] = C.[SizeId]
WHERE S.[Length] >= 12 AND ([CigarName] LIKE '%ci%' OR [PriceForSingleCigar] > 50) AND S.[RingRange] >2.55
ORDER BY [CigarName],[PriceForSingleCigar] DESC

--9.Clients with ZIP Codes

SELECT  CONCAT([FirstName],' ', [LastName]) AS [FullName] ,
        A.[Country],A.ZIP,
        CONCAT('$', MAX([PriceForSingleCigar])) AS [CigarPrice] 
FROM [Clients] AS C
JOIN [Addresses] AS A
ON C.[AddressId] = A.[Id]
JOIN [ClientsCigars] AS CC
ON CC.[ClientId] = C.[Id]
JOIN [Cigars] AS CI
ON CC.[CigarId] = CI.[Id]
WHERE A.[ZIP]  LIKE '_____' 
GROUP BY [FirstName],[LastName],A.[Country],A.[ZIP]
ORDER BY [FullName]

--10.Cigars by Size

SELECT CS.[LastName],
       AVG(S.[Length]) AS [CiagrLength],
       CEILING(AVG(S.[RingRange])) AS [CiagrRingRange]
FROM [Cigars] AS C
JOIN [ClientsCigars] AS CC
ON CC.[CigarId] = C.[Id]
JOIN [Clients] AS CS
ON CS.[Id] = CC.[ClientId]
JOIN [Sizes] AS S
ON S.[Id] = C.[SizeId]
WHERE CC.[CigarId] IS NOT NULL
GROUP BY [LastName]
ORDER BY [CiagrLength] DESC

--11.Client with Cigars

GO

CREATE FUNCTION udf_ClientWithCigars(@name VARCHAR(30))
RETURNS INT
AS 
BEGIN
DECLARE @Count INT  = (
						SELECT COUNT(CC.[CigarId])
						FROM [Clients] AS C
						JOIN [ClientsCigars] AS CC
						ON C.[Id] = CC.[ClientId]
						WHERE C.[FirstName] = @name
                       )
RETURN @Count
END

GO

--12.Search for Cigar with Specific Taste

GO

CREATE PROC usp_SearchByTaste(@taste VARCHAR(20))
AS
BEGIN 

SELECT  [CigarName],
		CONCAT('$',[PriceForSingleCigar]) AS [Price],
		[TasteType],
		[BrandName],
		CONCAT(S.[Length],' cm') AS [CigarLength],
		CONCAT(S.[RingRange],' cm')  AS [CigarRingRange]
FROM [Cigars] AS C
JOIN [Brands] AS B
ON C.[BrandId] = B.[Id]
JOIN [Tastes] AS T
ON T.[Id] = C.[TastId]
JOIN [Sizes] AS S
ON S.[Id] = C.[SizeId]
WHERE [TasteType] = @taste
ORDER BY [CigarLength],[CigarRingRange] DESC

END

GO

EXEC usp_SearchByTaste 'Woody'