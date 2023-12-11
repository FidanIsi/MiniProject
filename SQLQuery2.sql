CREATE DATABASE ECommerce
go

USE ECommerce
GO

CREATE TABLE Brands(
ID INT IDENTITY PRIMARY KEY,
Name VARCHAR(255)
)

CREATE TABLE Laptops(
ID INT IDENTITY PRIMARY KEY,
Name VARCHAR(255),
Price MONEY,
BrandID INT FOREIGN KEY REFERENCES Brands(ID)
)

CREATE TABLE Phones(
ID INT IDENTITY PRIMARY KEY,
Name VARCHAR(255),
Price MONEY,
BrandID INT FOREIGN KEY REFERENCES Brands(ID)
)
GO

INSERT INTO Brands
VALUES 
('Dell'),
('Lenovo'),
('HP'),
('Apple'),
('Asus');

INSERT INTO Laptops
VALUES
('MacBook Air 14', 1099.99, 4),
('Dell XPS 13', 1299.99, 1),
('Lenovo ThinkPad X1 Carbon', 1299.99, 2),
('HP Spectre x360', 1499.99, 3),
('MacBook Pro', 2099.99, 4),
('MacBook Air 13', 999.99, 4),
('ASUS Zenbook Pro 16X OLED', 1259.99, 5);

INSERT INTO Phones
VALUES
('iPhone 13', 999.99, 4),
('Dell Phone', 799.99, 1),
('HP Mobile', 749.99, 3),
('Lenovo Phone', 699.99, 2),
('iPhone 14 Pro', 1099.99, 4);
GO

SELECT L.Name, L.Price, B.Name AS BrandName
FROM Laptops L
JOIN Brands B ON L.BrandID = B.ID

SELECT P.Name, P.Price, B.Name AS BrandName
FROM Phones P
JOIN Brands B ON P.BrandID = B.ID

SELECT L.Name, L.Price, B.Name AS BrandName
FROM Laptops L
JOIN Brands B ON L.BrandID = B.ID
WHERE CHARINDEX('s', B.Name) > 0;
-- WHERE B.Name LIKE('%s%')

SELECT * FROM Laptops
WHERE Price BETWEEN 2000 AND 5000 OR Price > 5000

SELECT * FROM Phones
WHERE Price BETWEEN 1000 AND 1500 OR Price > 1500

SELECT B.Name AS BrandName, L.Name AS LaptopName, COUNT(*) AS LaptopCount
FROM Brands B
JOIN Laptops L ON B.ID = L.BrandID
GROUP BY B.Name, L.Name

SELECT B.Name AS BrandName, P.Name AS PhoneName, COUNT(*) AS PhoneCount
FROM Brands B
JOIN Phones P ON B.ID = P.BrandID
GROUP BY B.Name, P.Name

SELECT
    Name,
    BrandID
FROM Phones
UNION
SELECT
    Name,
    BrandID
FROM Laptops;

SELECT
    ID,
    Name,
    Price,
    BrandID
FROM Phones
UNION
SELECT
    ID,
    Name,
    Price,
    BrandID
FROM Laptops;

SELECT
    ID,
    Name,
    Price,
    BrandID,
    (SELECT Name FROM Brands WHERE ID = Phones.BrandID) AS BrandName
FROM Phones
UNION
SELECT
    ID,
    Name,
    Price,
    BrandID,
    (SELECT Name FROM Brands WHERE ID = Laptops.BrandID) AS BrandName
FROM Laptops;

SELECT
    ID,
    Name,
    Price,
    BrandID,
    (SELECT Name FROM Brands WHERE ID = Phones.BrandID) AS BrandName
FROM Phones
WHERE Price > 1000
UNION
SELECT
    ID,
    Name,
    Price,
    BrandID,
    (SELECT Name FROM Brands WHERE ID = Laptops.BrandID) AS BrandName
FROM Laptops
WHERE Price > 1000;

SELECT B.Name AS BrandName,
COUNT(*) AS ProductCount,
SUM(P.Price) AS TotalPrice
FROM Phones P
JOIN Brands B ON P.BrandID = B.ID
GROUP BY B.Name, B.ID;

SELECT B.Name AS BrandName,
COUNT(*) AS ProductCount,
SUM(L.Price) AS TotalPrice
FROM Laptops L
JOIN Brands B ON L.BrandID = B.ID
GROUP BY B.Name, B.ID
HAVING COUNT(*) >= 3;
