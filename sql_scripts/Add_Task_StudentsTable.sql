-- Create and populate the Students table
DROP TABLE IF EXISTS Students;
CREATE TABLE Students (ID INTEGER PRIMARY KEY, Name TEXT, Age INTEGER, Major
TEXT);
INSERT INTO Students VALUES
(1, 'Viktor Stasiuk', 25, 'Data Analytics & AI'),
(2, 'Alice Johnson', 20, 'Computer Science'),
(3, 'Marko Kovalenko', 23, 'Software Engineering'),
(4, 'Sarah Connor', 21, 'Cybersecurity');
-- 1. Select all records:
SELECT * FROM Students;
-- 2. Select only names and majors:
SELECT Name, Major FROM Students;
-- 3. Select students older than 21:
SELECT * FROM Students WHERE Age > 21;