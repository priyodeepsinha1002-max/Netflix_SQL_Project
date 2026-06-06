-- Netflix project
drop table if exists Netflix;
Create table Netflix(
show_id	varchar(20),
type varchar(30),
title varchar(500),
director varchar(500),
casts varchar(3500),	
country	varchar(500),
date_added	varchar(500),
release_year int,
rating varchar(200),
duration varchar(500),
isted_in varchar(500),
description varchar(500)

);

COPY netflix 
FROM 'D:\SQL\project series\Netflix-Project\Netflix\netflix_titles.csv' 
WITH (
    FORMAT csv, 
    HEADER true, 
    DELIMITER ',',
    QUOTE '"', 
    ESCAPE '"', 
    ENCODING 'WIN1252'
);

select * from Netflix;

select count(*) as total_content
from netflix;

select 
distinct type
from netflix;


--1. Count the Number of Movies vs TV Shows
select 
type,
count(*) as number_of_movies_vs_tv_shows
from netflix
group by 1;

-- 2. Find the Most Common Rating for Movies and TV Shows
select
type,
rating
from
(
select
type, 
rating,
count(*),
rank()over(partition by type order by count(*) desc) as ranking
from netflix
group by 1,2
order by 1 desc
) as t1

where ranking= 1;



-- 3. List All Movies Released in a Specific Year (e.g., 2020)
select * 
from Netflix
where release_year=2020;




-- 4. Find the Top 5 Countries with the Most Content on Netflix
select * from Netflix;

select 
country,
count(show_id) as total_content
from Netflix
where country is not null
group by country
order by total_content desc
limit 5;

-- using delimitter
select 
trim(unnest(string_to_array(country,',')))as individual_country,
count(*) as total_content
from netflix
group by 1
order by total_content desc
limit 5;


-- 5. Identify the Longest Movie

select * from Netflix
where 
type= 'Movie'
and 
duration= (select max(duration) from netflix);


-- 6. Find Content Added in the Last 5 Years

select * from Netflix
where to_date(date_added, 'Month DD,YYYY')>= current_date - interval '5 years'; 


-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
select * from Netflix
where director='Rajiv Chilaka';

select * from(
select *, 
trim(unnest(string_to_array(director, ','))) as directors
from netflix) as t1
where director like '%Rajiv Chilaka%'



-- 8. List All TV Shows with More Than 5 Seasons
select * from Netflix
where type='TV Show' 
and 
duration is not null
and
duration like '% %'
and
split_part(duration, ' ', 1):: numeric > 5 ;


-- 9. Count the Number of Content Items in Each Genre
select 
trim(unnest(string_to_array(isted_in,','))) as genre,
count(show_id) as content
from Netflix
group by genre;

-- 10.Find each year and the average numbers of content release in India on netflix.

WITH india_counts_per_year AS (
    SELECT 
        EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS release_year,
        COUNT(*)::NUMERIC AS total_content
    FROM netflix
    WHERE country = 'India'
      AND date_added IS NOT NULL
    GROUP BY 1
)
SELECT 
    release_year,
    total_content,
    ROUND(AVG(total_content) OVER(), 2) AS overall_india_average
FROM india_counts_per_year
ORDER BY release_year DESC;


-- 11. List All Movies that are Documentaries
select * from Netflix;

select * 
from netflix
where isted_in like '%Document%';



-- 12. Find All Content Without a Director
select * from Netflix
where director is null;

-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

select * 
from Netflix
where casts like '%Salman Khan%'
and release_year> extract(year from current_date)-10;

-- 14. Find the Top 10 Actors Who Have Appeared in the Highest
-- Number of Movies Produced in India
select 
trim(unnest(string_to_array(casts,','))) as actors,
count(*) as total_content
from netflix
where country='India'
group by 1
order by 2 desc
limit 10;



-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords





with new_table
as(
    SELECT 
	
    *,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix

)
select
category,
count(*)
from new_table
group by 1;
