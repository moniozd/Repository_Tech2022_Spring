USE Chinook;
-- 1.	How many songs are there in the playlist “Grunge”?
SELECT Count(*)
FROM playlist
         LEFT JOIN playlisttrack ON playlist.PlaylistId = playlisttrack.PlaylistId
WHERE Name = "Grunge";
-- 2.	Show information about artists whose name includes the text “Jack” and about artists whose name includes the text “John”, but not the text “Martin”.
SELECT * FROM Artist
WHERE NAME LIKE '%Jack%'
   OR NAME LIKE '%John%'
HAVING NOT '%Martin%';

-- 3.	For each country where some invoice has been issued, show the total invoice monetary amount, but only for countries where at least $100 have been invoiced. Sort the information from higher to lower monetary amount.
SELECT BillingCountry, SUM(Total) AS "SubTotal"
FROM Invoice
GROUP BY BillingCountry
HAVING SubTotal >= 100
ORDER BY SubTotal DESC;
-- 4.	Get the phone number of the boss of those employees who have given support to clients who have bought some song composed by “Miles Davis” in “MPEG Audio File” format.
SELECT Phone FROM employee WHERE EmployeeId in
                                 ( SELECT ReportsTo FROM employee WHERE (EmployeeId in
                                                                         ( SELECT SupportRepId FROM customer WHERE CustomerId in
                                                                                                                   ( SELECT CustomerId FROM invoice WHERE InvoiceId in
                                                                                                                                                          ( SELECT InvoiceId FROM invoiceline WHERE TrackId in
                                                                                                                                                                                                    ( SELECT TrackId FROM track WHERE Composer = "Miles Davis" AND MediaTypeId=
                                                                                                                                                                                                                                                                   ( SELECT MediaTypeId FROM mediatype WHERE Name="MPEG Audio File" )))))));
-- 5.	Show the information, without repeated records, of all albums that feature songs of the “Bossa Nova” genre whose title starts by the word “Samba”.
SELECT *
from Album
         left join track on album.AlbumId = track.AlbumID
where track.GenreID = '11'
  and track.Name like '%Samba%';


-- 6.	For each genre, show the average length of its songs in minutes (without indicating seconds). Use the headers “Genre” and “Minutes”, and include only genres that have any song longer than half an hour.
SELECT DISTINCT Genre.Name AS 'Genre', ROUND(AVG(Track.Milliseconds / 60000), 0) AS 'Minutes'
FROM Track,
     Genre
WHERE Genre.GenreId = Track.GenreId
GROUP BY Genre.GenreId
HAVING Minutes > 30;
-- 7.	How many client companies have no state?
SELECT COUNT(*)
FROM Customer
where State IS NULL;

-- 8.	For each employee with clients in the “USA”, “Canada” and “Mexico” show the number of clients from these countries s/he has given support, only when this number is higher than 6. Sort the query by number of clients. Regarding the employee, show his/her first name and surname separated by a space. Use “Employee” and “Clients” as headers.
SELECT CONCAT(Employee.FirstName, " ", Employee.LastName) AS Employee, count(*) AS Clients
FROM Employee
         LEFT JOIN Customer C on Employee.EmployeeId = C.SupportRepId
WHERE C.Country IN ('USA', 'Mexico', 'Canada')
GROUP BY Employee.FirstName, Employee.LastName
HAVING count(*) > 6
ORDER BY count(*) DESC;
-- 9.	For each client from the “USA”, show his/her surname and name (concatenated and separated by a comma) and their fax number. If they do not have a fax number, show the text “S/he has no fax”. Sort by surname and first name.
SELECT CONCAT(LastName, ", ", FirstName)
FROM Customer
WHERE Country = 'USA'
ORDER BY LastName;
-- 10.	For each employee, show his/her first name, last name, and their age at the time they were hired.
SELECT FirstName, LastName, DATEDIFF(HireDate, BirthDate) / 365 AS 'Age @ time of hire in years'
FROM Employee;

