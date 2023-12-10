CREATE DATABASE Library
GO

USE Library
GO

CREATE TABLE Books(
ID INT IDENTITY PRIMARY KEY,
Name VARCHAR(100) CHECK (LEN(Name) BETWEEN 2 AND 100) NOT NULL,
PageCount INT CHECK (PageCount >= 10) NOT NULL
)

CREATE TABLE Authors (
ID INT IDENTITY PRIMARY KEY,
Name VARCHAR(100) NOT NULL,
Surname VARCHAR(100) NOT NULL
);

CREATE TABLE AuthorBooks (
ID INT IDENTITY PRIMARY KEY,
AuthorId INT FOREIGN KEY REFERENCES Authors(ID),
BookId INT FOREIGN KEY REFERENCES Books(ID)  
);
GO

INSERT INTO Books 
VALUES 
('One Hundred Years of Solitude', 344),
('War and Peace', 1225),
('Crime and Punishment', 527),
('Sisters', 550)

INSERT INTO Authors
VALUES 
('Gabriel', 'Garcia Marquez'),
('Leo', 'Tolstoy'),
('Fyodor', 'Dostoyevsky'),
('Sasha', 'Nanua'),
('Sarena', 'Nanua')

INSERT INTO AuthorBooks
VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,4)

GO

CREATE VIEW General AS
SELECT Books.Id, Books.Name, Books.PageCount, Authors.Name + ' ' + Authors.Surname AS AuthorFullName
FROM Books
JOIN AuthorBooks ON Books.ID = AuthorBooks.BookId
JOIN Authors ON AuthorBooks.AuthorId = Authors.ID;

SELECT * FROM General;

CREATE PROCEDURE GetBooksByAuthorName @AuthorName VARCHAR(100)
AS
BEGIN
    SELECT
        Books.Id,
        Books.Name,
        Books.PageCount,
        Authors.Name + ' ' + Authors.Surname AS AuthorFullName
    FROM
        Books
    JOIN
        AuthorBooks ON Books.ID = AuthorBooks.BookId
    JOIN
        Authors ON AuthorBooks.AuthorId = Authors.ID
    WHERE
        Authors.Name = @AuthorName;
END;

GetBooksByAuthorName 'Gabriel';

CREATE PROCEDURE InsertAuthor @Name VARCHAR(100), @Surname VARCHAR(100)
AS
BEGIN
    INSERT INTO Authors (Name, Surname)
    VALUES (@Name, @Surname);
END;

InsertAuthor 'CHINGIZ', 'MUSTAFAYEV'

CREATE PROCEDURE UpdateAuthor @AuthorId INT, @Name VARCHAR(100), @Surname VARCHAR(100)
AS
BEGIN
    UPDATE Authors
    SET Name = @Name,
        Surname = @Surname
    WHERE ID = @AuthorId;
END;

UpdateAuthor 6 , 'CHINGIZ', 'MUSTAFAYEV'

CREATE PROCEDURE DeleteAuthor @AuthorId INT
AS
BEGIN
DELETE FROM Authors
WHERE ID = @AuthorId
END;

DeleteAuthor 6

CREATE VIEW AuthorsSummary AS
SELECT
A.ID, 
A.Name + ' ' + A.Surname AS AuthorFullName,
COUNT(B.ID) AS BooksCount,
SUM(B.PageCount) AS MaxPageCount
FROM
    Authors A
LEFT JOIN
    AuthorBooks AB ON A.ID = AB.AuthorId
LEFT JOIN
    Books B ON AB.BookId = B.ID
GROUP BY
    A.ID, A.Name, A.Surname;

SELECT * FROM AuthorsSummary;

GO
