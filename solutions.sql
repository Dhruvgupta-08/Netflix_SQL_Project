-- Netflix Project
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(6),
	type	VARCHAR(10),
	title	Varchar(150),
	director	Varchar(208),	
	casts	Varchar(1000),
	country	Varchar(150),	
	date_added	Varchar(50),
	release_year	INT,
	rating	Varchar(10),
	duration	Varchar(15),
	listed_in	Varchar(100),
	description	Varchar(250)
);
 
Select * from netflix;

Select
	count(*) as total_content
From netflix;

Select
	Distinct type
From netflix;

Select * from netflix;

-- 15 Business Problems

-- 1. Count the number of Movies vs TV Shows

Select 
	type,
	Count(*) as total_content
from netflix
Group by type

-- 2. Find the most common rating for movies and TV shows

Select
	type,
	rating 
FROM
(
	Select
		type,
		rating,
		Count(*),
		Rank() Over(Partition by type Order by Count(*) DESC) as ranking
	from netflix
	Group BY 1, 2
) as t1 
Where
	ranking = 1

-- 3. List all the movies released in a specific year (e.g., 2020)

-- filter 2020
-- movies

Select * From netflix
Where
	type = 'Movie'
	And
	release_year = 2020


-- 4. Find the top 5 countries with the most content on Netflix

SELECT
	UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
	COUNT(show_id) as total_content
from netflix
Group By 1
Order By 2 DESC
Limit 5


-- 5. Identify the longest movie?

Select * from netflix
Where
	type = 'Movie'
	And
	duration = (Select Max(duration) From netflix)


 -- 6. Find content added in the last 5 years

Select
 	*
From netflix
Where
	TO_DATE(date_added, 'Month DD, YYYY') >= Current_Date - Interval '5 years'
	
Select CURRENT_DATE - INTERVAL '5 years'


-- 7. Find all the movies/TV shows by director 'Rajiv Chilka'!

Select * from netflix
Where director ILike '%Rajiv Chilaka%'


-- 8. List all TV shows with more than 5 seasons

Select 
	* 
From netflix
Where
	type = 'TV Show'
	AND
	SPLIT_PART(duration,' ',1)::numeric > 5

-- Select
-- Split_Part('Apple Banana Cherry',' ', 1)

-- 9. Count the number of content items in each genre

Select
	Unnest(String_To_Array(listed_in,',')) as genre,
	Count(show_id) as total_content
from netflix
Group By 1


-- 10. Find each year and the average numbers of content release by India on netflix.
return top 5 year with highest avg content release !

total content 333/972

Select
	Extract(Year From TO_DATE(date_added, 'Month DD, YYYY')) as year,	
	Count(*),
	Round(
	Count(*)::numeric/(Select Count(*) From netflix Where country = 'India')::numeric * 100 
	,2) as avg_content_per_year
From netflix
Where country = 'India'
Group By 1


-- 11. List all movies that are documentaries

Select * from netflix
Where
	listed_in ILike '%documentaries%'
 

-- 12. Find all the content without a director

Select * from netflix
Where
	director IS NULL


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 year!

Select * from netflix
Where 
	casts ILike '%Salman Khan%'
	And
	release_year > Extract(Year From Current_Date) - 10


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

Select
Unnest(STRING_TO_ARRAY(casts,',')) as actors,
Count(*) as total_content
from netflix
Where country ILIKE '%india'
Group By 1
Order By 2 DESC
Limit 10


-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

With new_table
AS
(
Select 
*,
	Case
	When 
		description ILike '%kill%' OR
		description ILike '%violence%' Then 'Bad_Content'
		Else 'Good Content'
	End category
From netflix	
)
Select
	category
	Count(*) as total_content
From new_table
Group By 1




