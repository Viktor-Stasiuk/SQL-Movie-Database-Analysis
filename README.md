# SQL-Movie-Database-Analysis
A comprehensive SQL portfolio project demonstrating data normalization, ETL data cleaning, and relational database analysis in DB Browser for SQLite using a movie and reviewer dataset.

SQL Movie Database Analysis & Data Cleaning ProjectAuthor: Viktor Stasiuk | Data Analytics & AITools Used: DB Browser for SQLite, SQL (DDL, DML, DQL)Core Competencies: Data Extraction, Data Transformation (ELT/ETL), Relational Database Normalization, SQL Querying, Data Quality Audit.Project OverviewThis project demonstrates a complete end-to-end data analysis workflow using SQL. Starting with raw, unformatted spreadsheet data, the project involves database normalization (splitting single sheets into relational tables to resolve duplicate primary keys), rigorous data cleaning (handling NULL values, whitespace, and formatting inconsistencies), and executing a series of analytical queries to extract business insights.Task 0: Comprehensive Data Importing and Cleaning (ELT Process)Before analyzing the data, it must be thoroughly cleaned and prepared. The initial raw files contained trailing spaces, empty rows, and European decimal formats (commas instead of periods), which prevented accurate mathematical calculations and data type casting in SQL.SQL Query / Solution:-- 1. Remove empty rows
DELETE FROM Movies_Info WHERE mov_id IS NULL OR mov_id = '';
DELETE FROM Movies_Ratings WHERE mov_id IS NULL OR mov_id = '';

-- 2. Trim whitespace and handle empty strings
UPDATE Movies_Info SET mov_name = TRIM(mov_name), mov_lang = TRIM(mov_lang), mov_rel_country = TRIM(mov_rel_country);
UPDATE Movies_Ratings SET rev_name = TRIM(rev_name), rev_stars = TRIM(rev_stars);
UPDATE Movies_Ratings SET rev_stars = NULL WHERE rev_stars = '';
UPDATE Movies_Ratings SET num_o_ratings = NULL WHERE num_o_ratings = '';

-- 3. Standardize decimal format
UPDATE Movies_Ratings SET rev_stars = REPLACE(rev_stars, ',', '.') WHERE rev_stars IS NOT NULL;

-- 4. Create missing related table
DROP TABLE IF EXISTS Actor;
CREATE TABLE Actor (act_id INTEGER PRIMARY KEY, act_fname TEXT, act_lname TEXT);
INSERT INTO Actor VALUES (111, 'Woody', 'Allen');

-- 5. Create a unified relational view
DROP VIEW IF EXISTS All_Movies_Combined;
CREATE VIEW All_Movies_Combined AS
SELECT 
    i.mov_id, i.mov_name, i.mov_year, i.mov_time, i.mov_lang, i.mov_dt_rel, i.mov_rel_country,
    r.rev_name, r.rev_id, CAST(r.rev_stars AS REAL) AS rev_stars, r.num_o_ratings
FROM Movies_Info AS i
INNER JOIN Movies_Ratings AS r ON i.mov_id = r.mov_id;
Detailed Syntax Explanation:DELETE FROM ... WHERE ...: Removes specific rows from the table. The IS NULL condition identifies empty cells generated during the Excel to CSV export.UPDATE ... SET ...: Modifies existing data in the table.TRIM(): A string function that removes leading and trailing spaces (e.g., converts ' Vertigo ' to 'Vertigo').REPLACE(): Searches for a specific character (, in this case) and replaces it with another (.). This is critical for converting localized text formats into valid SQL floating-point numbers.CREATE VIEW ... AS: Creates a virtual table based on the result-set of an SQL statement. It doesn't store data physically but combines data from multiple tables for convenient querying.INNER JOIN ... ON: Combines rows from two or more tables based on a related column between them (the mov_id primary/foreign key).CAST( ... AS REAL): Explicitly converts a text column into a floating-point numeric data type (REAL) to enable mathematical comparisons (like evaluating ratings).Analytical Questions & Business InsightsQuestion 1Find the name and year of the movies.SQL Query:SELECT mov_name, mov_year 
FROM All_Movies_Combined;
Detailed Explanation: Utilized the basic SELECT statement to project specific columns (mov_name, mov_year) from the unified view All_Movies_Combined, ignoring all other metadata.Beginner-Friendly Explanation: We are asking the database to show us a simple list containing only the titles and release years from our large data table.Expected Output: A table with 28 rows and 2 columns, displaying all movies from Vertigo to Braveheart.Business Insight: Allows content managers to quickly assess the catalog size and its chronological span to plan future licensing acquisitions.Question 2Find the year when the movie American Beauty was released.SQL Query:SELECT mov_year 
FROM All_Movies_Combined 
WHERE mov_name = 'American Beauty';
Detailed Explanation: The WHERE clause filters the result set row by row, retaining only the record where the mov_name strictly matches the string literal 'American Beauty'.Beginner-Friendly Explanation: We search through the entire list to find the exact movie name and return only the year it was made.Expected Output: 1 row returning 1999.Business Insight: Targeted metadata retrieval, highly useful for customer support agents answering specific user queries.Question 3Find the movies released in the year 1999.SQL Query:SELECT mov_name, mov_year 
FROM All_Movies_Combined 
WHERE mov_year = 1999;
Detailed Explanation: Applied the WHERE clause to filter on an INTEGER data type (mov_year = 1999). Since 1999 is numeric, no quotation marks are required.Beginner-Friendly Explanation: We apply a filter to keep only the movies that have "1999" in their release year column.Expected Output: 2 rows: Eyes Wide Shut and American Beauty.Business Insight: Content analysis for a specific fiscal or calendar year. Useful for curating annual retrospectives or thematic collections on a streaming platform.Question 4Find the movies released before 1998.SQL Query:SELECT mov_name, mov_year 
FROM All_Movies_Combined 
WHERE mov_year < 1998 
ORDER BY mov_year ASC;
Detailed Explanation: Used the strict inequality operator (<). Additionally, implemented the ORDER BY ... ASC clause to sort the results chronologically from oldest to newest.Beginner-Friendly Explanation: We ask for all movies older than 1998 and sort them chronologically from oldest to newest.Expected Output: 20 rows starting from Seven Samurai (1954).Business Insight: Exploration of retro content within the catalog. Allows marketing teams to build targeted collections like "Golden Classics".Question 5Return the name of all reviewers and name of movies together in a single list.SQL Query:SELECT rev_name AS Combined_List FROM Movies_Ratings WHERE rev_name IS NOT NULL
UNION
SELECT mov_name AS Combined_List FROM Movies_Info;
Detailed Explanation: The UNION operator takes the results of two independent SELECT queries and stacks them vertically into a single column, generating a distinct set of unique values. The AS alias provides a shared name for the new column.Beginner-Friendly Explanation: We take a column of people, stack a column of movies directly underneath it, and present them as one long, combined list.Expected Output: A single column Combined_List with 56 rows (alphabetically sorted, mixing reviewer names and movie titles).Business Insight: Consolidation of distinct entities. Commonly used by developers to populate unified search indexes (search bars) where users can query both movies and people in one input field.Question 6Find the name of all reviewers who have rated 7 or more stars.SQL Query:SELECT rev_name, rev_stars 
FROM All_Movies_Combined 
WHERE rev_stars >= 7.0 
ORDER BY rev_stars DESC;
Detailed Explanation: Applied the mathematical >= (greater than or equal to) operator to the rev_stars column. Because the data was cleaned and cast to a REAL data type in the ELT phase, the database accurately processes the floating-point decimals.Beginner-Friendly Explanation: We filter the list to only include reviewers who gave a highly positive score of 7 or higher.Expected Output: 17 rows filtered and sorted by rating from highest to lowest (8.6 down to 7.0).Business Insight: Identification of highly satisfied audience members or favorable critics. These individuals can be engaged as brand ambassadors for upcoming PR campaigns.Question 7Find the titles of movies that have no ratings.SQL Query:SELECT mov_id, mov_name, rev_stars 
FROM All_Movies_Combined 
WHERE rev_stars IS NULL;
Detailed Explanation: In SQL, identifying missing values requires the IS NULL operator rather than the standard equals sign (=). This safely retrieves records where a rating was never entered.Beginner-Friendly Explanation: We look for specific empty spots in our table where data is missing or hasn't been entered yet.Expected Output: 2 rows where rev_stars is NULL (Eyes Wide Shut, Titanic).Business Insight: Data Quality Audit. Identifying "dead" pages or incomplete records in the database allows content managers to prioritize metadata enrichment and fill in the gaps.Question 8Find the titles of the movies with IDs 905, 907, 917.SQL Query:SELECT mov_id, mov_name 
FROM All_Movies_Combined 
WHERE mov_id IN (905, 907, 917);
Detailed Explanation: The IN (...) operator serves as a clean, efficient shorthand for chaining multiple OR conditions (e.g., mov_id = 905 OR mov_id = 907...).Beginner-Friendly Explanation: We check our table against a specific target list of ID numbers and return only the exact matches.Expected Output: 3 rows: Amadeus, Eyes Wide Shut, Deliverance.Business Insight: Batch processing implementation. Allows analysts to quickly extract information for a specific list of IDs provided by the sales team or a recommendation algorithm.Question 9Find movies with titles that include the words "Boogie Nights".SQL Query:SELECT mov_id, mov_name, mov_year 
FROM All_Movies_Combined 
WHERE mov_name LIKE '%Boogie Nights%';
Detailed Explanation: The LIKE operator is used for string pattern matching. The % wildcard on both sides indicates "any sequence of characters before or after the target phrase."Beginner-Friendly Explanation: We search for a specific word or phrase hidden anywhere inside the movie title, just like using a search bar on a website.Expected Output: 1 row: Boogie Nights (1997).Business Insight: Implements basic Search Engine functionality. Empowers users to find content even when they only recall a fraction of the title.Question 10Find the ID number for the actor whose first name is 'Woody' and last name is 'Allen'.SQL Query:SELECT act_id, act_fname, act_lname 
FROM Actor 
WHERE act_fname = 'Woody' AND act_lname = 'Allen';
Detailed Explanation: Queries the newly created Actor table. The logical AND operator mandates that both filtering conditions (first name AND last name) must be true simultaneously for a record to be returned.Beginner-Friendly Explanation: We use multiple strict filters at the same time to pinpoint one exact person in our database.Expected Output: 1 row returning act_id = 111.Business Insight: Entity resolution for relationship graph building. Identifying a unique numerical ID rather than relying on text names (which are prone to duplication) ensures database integrity.Bonus Question 11Create a sample Students table and retrieve all students enrolled in data or tech-related majors who are over 21.SQL Query:DROP TABLE IF EXISTS Students;
CREATE TABLE Students (ID INTEGER PRIMARY KEY, Name TEXT, Age INTEGER, Major TEXT);
INSERT INTO Students VALUES 
(1, 'Viktor Stasiuk', 25, 'Data Analytics & AI'),
(2, 'Alice Johnson', 20, 'Computer Science'),
(3, 'Marko Kovalenko', 23, 'Software Engineering'),
(4, 'Sarah Connor', 21, 'Cybersecurity');

SELECT * FROM Students 
WHERE Age > 21;
Detailed Explanation: This query utilizes Data Definition Language (DDL: CREATE TABLE) to build a new structure, Data Manipulation Language (DML: INSERT INTO) to populate it, and Data Query Language (DQL: SELECT) to filter by age (> 21).Beginner-Friendly Explanation: We build a brand new mini-database from scratch, fill it with student data, and then ask it a specific question based on their age.Expected Output: 2 rows (Viktor Stasiuk, Marko Kovalenko).Business Insight: Rapid mock data generation. Analysts frequently need to construct artificial datasets to test script logic securely before deploying code against live, sensitive client databases.
