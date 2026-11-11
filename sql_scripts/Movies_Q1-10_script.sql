-- Q1: Find the name and year of the movies
SELECT mov_name, mov_year 
FROM All_Movies_Combined;

-- Q2: Find the year when the movie American Beauty was released
SELECT mov_name, mov_year 
FROM All_Movies_Combined 
WHERE mov_name = 'American Beauty';

-- Q3: Find the movies released in the year 1999
SELECT mov_name, mov_year 
FROM All_Movies_Combined 
WHERE mov_year = 1999;

-- Q4: Find the movies released before 1998
SELECT mov_name, mov_year 
FROM All_Movies_Combined 
WHERE mov_year < 1998 
ORDER BY mov_year ASC;

-- Q5: Return the name of all reviewers and name of movies together in a single list
SELECT rev_name AS Combined_List FROM Movies_Ratings
UNION
SELECT mov_name AS Combined_List FROM Movies_Info;

-- Q6: Find the name of all reviewers who have rated 7 or more stars
SELECT rev_name, rev_stars 
FROM All_Movies_Combined 
WHERE rev_stars >= 7.0 
ORDER BY rev_stars DESC;

-- Q7: Find the titles of movies that have no ratings
SELECT mov_id, mov_name, rev_stars 
FROM All_Movies_Combined 
WHERE rev_stars IS NULL;

-- Q8: Find the titles of the movies with IDs 905, 907, 917
SELECT mov_id, mov_name 
FROM All_Movies_Combined 
WHERE mov_id IN (905, 907, 917);

-- Q9: Find movies with titles that include the words Boogie Nights
SELECT mov_id, mov_name, mov_year 
FROM All_Movies_Combined 
WHERE mov_name LIKE '%Boogie Nights%';

-- Q10: Find the ID number for the actor whose first name is 'Woody' and last name is 'Allen'
SELECT act_id, act_fname, act_lname 
FROM Actor 
WHERE act_fname = 'Woody' AND act_lname = 'Allen';