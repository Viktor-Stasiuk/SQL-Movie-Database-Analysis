# SQL Movie Database Analysis & Data Cleaning Project
A comprehensive SQL portfolio project demonstrating data normalization, ETL data cleaning, and relational database analysis in DB Browser for SQLite using a movie and reviewer dataset.

**Author:** Viktor Stasiuk | Data Analytics & AI  
**Tools Used:** DB Browser for SQLite, SQL (DDL, DML, DQL)  
**Core Competencies:** Data Extraction, Data Transformation (ELT/ETL), Relational Database Normalization, SQL Querying, Data Quality Audit.

## Project Overview

This project demonstrates a complete end-to-end data analysis workflow using SQL. Starting with raw spreadsheet data, the project involves database normalization (splitting single sheets into relational tables to resolve duplicate primary keys), rigorous data cleaning (handling `NULL` values, whitespace, and formatting inconsistencies), and executing analytical queries to extract business insights.

---

## Task 0: Comprehensive Data Importing and Cleaning (ELT Process)

Before analyzing the data, the raw files required formatting. The initial datasets contained trailing spaces, empty rows, and European decimal formats (commas instead of periods) which prevented accurate mathematical calculations.

**SQL Query:**

```sql
-- 1. Remove empty rows
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
```

**Syntax Explanation:**
* `DELETE FROM ... WHERE IS NULL`: Removes empty artifact rows generated during CSV export.
* `UPDATE ... SET TRIM()`: Cleans leading and trailing whitespace from text strings.
* `REPLACE()`: Converts European commas (`,`) to standard decimal periods (`.`) for numeric evaluation.
* `CREATE VIEW ... AS`: Generates a virtual table combining data from multiple relational tables.
* `INNER JOIN ... ON`: Merges tables based on a shared column (`mov_id`).
* `CAST(... AS REAL)`: Converts text-based numbers into floating-point numeric data types for accurate mathematical comparisons.

---

## Analytical Questions & Business Insights

### Question 1: Find the name and year of the movies.
**SQL Query:**
```sql
SELECT mov_name, mov_year 
FROM All_Movies_Combined;
```
* **Detailed Explanation:** Uses the `SELECT` statement to project specific columns from the view, filtering out unnecessary metadata.
* **Beginner-Friendly Explanation:** We are asking the database to output a simple list containing only movie titles and their release years.
* **Expected Output:** 28 rows displaying all movies.
* **Business Insight:** Allows content managers to quickly assess catalog size and chronological distribution for licensing planning.

### Question 2: Find the year when the movie American Beauty was released.
**SQL Query:**
```sql
SELECT mov_year 
FROM All_Movies_Combined 
WHERE mov_name = 'American Beauty';
```
* **Detailed Explanation:** The `WHERE` clause filters the result set to retain only the record where `mov_name` matches the exact string literal.
* **Beginner-Friendly Explanation:** We search the entire list for an exact movie title to find out what year it was made.
* **Expected Output:** 1 row returning `1999`.
* **Business Insight:** Enables targeted metadata retrieval, which is highly useful for customer support tools responding to specific user queries.

### Question 3: Find the movies released in the year 1999.
**SQL Query:**
```sql
SELECT mov_name, mov_year 
FROM All_Movies_Combined 
WHERE mov_year = 1999;
```
* **Detailed Explanation:** Applies the `WHERE` clause to filter on an `INTEGER` data type (`mov_year`).
* **Beginner-Friendly Explanation:** We filter the list to keep only the movies released specifically in the year 1999.
* **Expected Output:** 2 rows (*Eyes Wide Shut*, *American Beauty*).
* **Business Insight:** Facilitates content analysis for a specific calendar year, ideal for curating annual retrospectives on streaming platforms.

### Question 4: Find the movies released before 1998.
**SQL Query:**
```sql
SELECT mov_name, mov_year 
FROM All_Movies_Combined 
WHERE mov_year < 1998 
ORDER BY mov_year ASC;
```
* **Detailed Explanation:** Uses the strict inequality operator (`<`) and the `ORDER BY ... ASC` clause to sort chronologically from oldest to newest.
* **Beginner-Friendly Explanation:** We request all movies older than 1998 and sort them chronologically.
* **Expected Output:** 20 rows starting from *Seven Samurai (1954)*.
* **Business Insight:** Highlights retro content, allowing marketing teams to build targeted collections like "Golden Classics".

### Question 5: Return the name of all reviewers and movies together in a single list.
**SQL Query:**
```sql
SELECT rev_name AS Combined_List FROM Movies_Ratings WHERE rev_name IS NOT NULL
UNION
SELECT mov_name AS Combined_List FROM Movies_Info;
```
* **Detailed Explanation:** The `UNION` operator stacks the results of two independent queries vertically into a single column, generating a distinct set of unique values.
* **Beginner-Friendly Explanation:** We combine a column of people and a column of movies into one long, unified list.
* **Expected Output:** A single column `Combined_List` with 56 rows.
* **Business Insight:** Consolidates distinct entities, commonly used to populate unified search engine indexes (where users query both movies and people in one bar).

### Question 6: Find reviewers who have rated 7 or more stars.
**SQL Query:**
```sql
SELECT rev_name, rev_stars 
FROM All_Movies_Combined 
WHERE rev_stars >= 7.0 
ORDER BY rev_stars DESC;
```
* **Detailed Explanation:** Evaluates floating-point values using the mathematical `>=` operator, sorting the results descending via `ORDER BY ... DESC`.
* **Beginner-Friendly Explanation:** We filter the list to include only reviewers who gave highly positive scores (7 or higher).
* **Expected Output:** 17 rows sorted from highest to lowest rating.
* **Business Insight:** Identifies highly satisfied critics or audience members who could be engaged as brand ambassadors for marketing campaigns.

### Question 7: Find the titles of movies that have no ratings.
**SQL Query:**
```sql
SELECT mov_id, mov_name, rev_stars 
FROM All_Movies_Combined 
WHERE rev_stars IS NULL;
```
* **Detailed Explanation:** Missing values in SQL must be identified using the `IS NULL` operator, not an equals sign.
* **Beginner-Friendly Explanation:** We look for specific empty spots in our table where rating data hasn't been entered.
* **Expected Output:** 2 rows where `rev_stars` is missing (*Eyes Wide Shut*, *Titanic*).
* **Business Insight:** Acts as a Data Quality Audit, identifying incomplete database records so metadata teams can fill in the gaps.

### Question 8: Find the titles of the movies with IDs 905, 907, 917.
**SQL Query:**
```sql
SELECT mov_id, mov_name 
FROM All_Movies_Combined 
WHERE mov_id IN (905, 907, 917);
```
* **Detailed Explanation:** The `IN (...)` operator serves as a clean, efficient shorthand for chaining multiple `OR` conditions.
* **Beginner-Friendly Explanation:** We cross-reference our table against a specific target list of ID numbers.
* **Expected Output:** 3 rows (*Amadeus*, *Eyes Wide Shut*, *Deliverance*).
* **Business Insight:** Implements batch processing, allowing analysts to quickly extract information for a curated list of IDs provided by recommendation algorithms.

### Question 9: Find movies with titles that include the words "Boogie Nights".
**SQL Query:**
```sql
SELECT mov_id, mov_name, mov_year 
FROM All_Movies_Combined 
WHERE mov_name LIKE '%Boogie Nights%';
```
* **Detailed Explanation:** The `LIKE` operator is used for string pattern matching. The `%` wildcards indicate any sequence of characters can precede or follow the target phrase.
* **Beginner-Friendly Explanation:** We search for a specific phrase hidden anywhere inside a movie title.
* **Expected Output:** 1 row (*Boogie Nights*).
* **Business Insight:** Demonstrates core Search Engine functionality, empowering users to find content based on partial title recall.

### Question 10: Find the ID number for the actor whose first name is 'Woody' and last name is 'Allen'.
**SQL Query:**
```sql
SELECT act_id, act_fname, act_lname 
FROM Actor 
WHERE act_fname = 'Woody' AND act_lname = 'Allen';
```
* **Detailed Explanation:** The logical `AND` operator mandates that both filtering conditions must be true simultaneously.
* **Beginner-Friendly Explanation:** We apply multiple strict filters at once to pinpoint one exact person in the database.
* **Expected Output:** 1 row returning `act_id = 111`.
* **Business Insight:** Facilitates entity resolution. Relying on unique numerical IDs rather than text names ensures database integrity and prevents duplication.

---

### Bonus Task 11: Create a sample Students table and retrieve records.
**Task:** Retrieve all students enrolled in tech-related majors who are over 21.

**SQL Query:**
```sql
DROP TABLE IF EXISTS Students;
CREATE TABLE Students (ID INTEGER PRIMARY KEY, Name TEXT, Age INTEGER, Major TEXT);

INSERT INTO Students VALUES 
(1, 'Viktor Stasiuk', 25, 'Data Analytics & AI'),
(2, 'Alice Johnson', 20, 'Computer Science'),
(3, 'Marko Kovalenko', 23, 'Software Engineering'),
(4, 'Sarah Connor', 21, 'Cybersecurity');

SELECT * FROM Students 
WHERE Age > 21;
```
* **Detailed Explanation:** Utilizes `DDL` (`CREATE TABLE`) to build a structure, `DML` (`INSERT INTO`) to populate it, and `DQL` (`SELECT`) to filter.
* **Beginner-Friendly Explanation:** We build a mini-database from scratch, fill it with data, and ask a specific question based on age.
* **Expected Output:** 2 rows (*Viktor Stasiuk*, *Marko Kovalenko*).
* **Business Insight:** Demonstrates rapid mock data generation, allowing analysts to securely test script logic before deploying code to live client databases.
