-- Step 1: Remove empty rows from both tables automatically
DELETE FROM Movies_Info WHERE mov_id IS NULL OR mov_id = '';
DELETE FROM Movies_Ratings WHERE mov_id IS NULL OR mov_id = '';

-- Step 2: Trim extra spaces and set empty cells to true NULL
UPDATE Movies_Info SET mov_name = TRIM(mov_name), mov_lang = TRIM(mov_lang), mov_rel_country = TRIM(mov_rel_country);
UPDATE Movies_Ratings SET rev_name = TRIM(rev_name), rev_stars = TRIM(rev_stars);
UPDATE Movies_Ratings SET rev_stars = NULL WHERE rev_stars = '';
UPDATE Movies_Ratings SET num_o_ratings = NULL WHERE num_o_ratings = '';

-- Step 3: Replace commas with dots in Movies_Ratings (e.g., '8,4' becomes '8.4')
UPDATE Movies_Ratings SET rev_stars = REPLACE(rev_stars, ',', '.') WHERE rev_stars IS NOT NULL;

-- Step 4: Create the missing Actor table for Question 10
DROP TABLE IF EXISTS Actor;
CREATE TABLE Actor (act_id INTEGER PRIMARY KEY, act_fname TEXT, act_lname TEXT);
INSERT INTO Actor VALUES (111, 'Woody', 'Allen');

-- Step 5: Automatically combine both clean tables into one unified View
DROP VIEW IF EXISTS All_Movies_Combined;
CREATE VIEW All_Movies_Combined AS
SELECT 
    i.mov_id, i.mov_name, i.mov_year, i.mov_time, i.mov_lang, i.mov_dt_rel, i.mov_rel_country,
    r.rev_name, r.rev_id, CAST(r.rev_stars AS REAL) AS rev_stars, r.num_o_ratings
FROM Movies_Info AS i
INNER JOIN Movies_Ratings AS r ON i.mov_id = r.mov_id;