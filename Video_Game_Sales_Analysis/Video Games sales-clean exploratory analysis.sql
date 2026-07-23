/*
Video Game Sales Analysis
Database: MySQL
Table: video_game_sales_clean

Dataset notes:
- Sales values are reported in millions of units.
- NULL sales values represent unreported data and are not treated as zero.
- Results describe the available dataset, not the complete video-game market.
- Release-dated performance analyses use data through 2018 where stated,
  because reported-sales coverage declines sharply after 2018.

SQL techniques demonstrated:
- GROUP BY and HAVING
- Common table expressions (CTEs)
- Window functions
- Ranking with DENSE_RANK()
- Reshaping columns into rows with UNION ALL
- Conditional aggregation with CASE
*/




/*
QUERY 1: Genre performance

   Which genres generated the strongest reported global sales?
Scope:
Sales metrics include only records where total_sales is reported.
Results describe the available data, not the complete video-game market.
*/

WITH genre_performance AS (
    SELECT genre,
    ROUND(SUM(total_sales),2) AS reported_global_sales_millions
FROM video_game_sales_clean
GROUP BY genre
HAVING COUNT(total_sales) > 0
)
SELECT
    DENSE_RANK() OVER (ORDER BY reported_global_sales_millions DESC) AS sales_rank,
    genre,
    reported_global_sales_millions
FROM genre_performance
ORDER BY sales_rank, genre;


/*
 QUERY 2 — Annual sales trend and coverage
How have reported global video-game sales and sales-data coverage changed by release year?

Scope:
- Only records with a release date can be assigned to a year.
- The coverage columns help distinguish genuine sales movement
from changes in the number of records containing sales data.
*/

SELECT
    YEAR(release_date) AS release_year,
    ROUND(SUM(total_sales),2) AS reported_global_sales_millions
FROM video_game_sales_clean
WHERE release_date IS NOT NULL
GROUP BY YEAR(release_date)
ORDER BY release_year;


/*
QUERY 3: Console performance through 2018

Which consoles generated the strongest reported historical sales?

Scope:
Only release-dated records through 2018 are included because sales coverage collapses after 2018.

NB:
Total sales reflect reported values, not complete market sales.
*/

WITH console_performance_cte AS (
    SELECT
        console,

        MIN(YEAR(release_date)) AS first_release_year,
        MAX(YEAR(release_date)) AS last_release_year,
        COUNT(DISTINCT YEAR(release_date)) AS years_with_releases,
        ROUND(SUM(total_sales),2) AS reported_global_sales_millions
FROM video_game_sales_clean
WHERE release_date <= '2018-12-31'
GROUP BY console
HAVING COUNT(total_sales) > 0
),
ranked_consoles AS (
    SELECT
        DENSE_RANK() OVER (ORDER BY reported_global_sales_millions DESC) AS sales_rank,
        console,
        first_release_year,
        last_release_year,
        years_with_releases,
        reported_global_sales_millions
        
    FROM console_performance_cte
)
SELECT *
FROM ranked_consoles
ORDER BY sales_rank, console;


/*
QUERY 4: Complete-case regional comparison

Which regions accounted for the largest share of reported sales? (I'm using only the records with complete regional data) because 
using complete cases prevents differences in missing-data coverage from determining the regional ranking.
*/

WITH complete_regional_sales AS (
    SELECT
        raw_id,
        na_sales,
        jp_sales,
        pal_sales,
        other_sales
    FROM video_game_sales_clean
    WHERE na_sales IS NOT NULL
      AND jp_sales IS NOT NULL
      AND pal_sales IS NOT NULL
      AND other_sales IS NOT NULL
),
regional_long AS (
    SELECT raw_id,
	'North America' AS region,
	na_sales AS regional_sales_millions
    FROM complete_regional_sales
    UNION ALL
    SELECT raw_id,
	'Japan',
	jp_sales
    FROM complete_regional_sales
    UNION ALL
    SELECT raw_id,
	'PAL markets',
	pal_sales
    FROM complete_regional_sales
    UNION ALL
    SELECT raw_id,
	'Other regions',
	other_sales
    FROM complete_regional_sales
),
regional_summary AS (
    SELECT region,
	COUNT(*) AS complete_records,
	ROUND(SUM(regional_sales_millions),2) AS reported_sales_millions,
	ROUND(AVG(regional_sales_millions),3) AS average_sales_per_record
    FROM regional_long
    GROUP BY region
)
SELECT
region,
complete_records,
reported_sales_millions,
ROUND(100.0 * reported_sales_millions/ SUM(reported_sales_millions) OVER (),2) AS regional_sales_share_pct,
average_sales_per_record
FROM regional_summary
ORDER BY reported_sales_millions DESC;


/*
QUERY 5: Top genres within each region

Which genres generated the highest reported sales within each region?

Scope:
Only records with all four regional sales values are used as this creates a consistent comparison base across regions.
Rankings are calculated separately within each region.
*/

WITH complete_regional_sales AS (
    SELECT
        raw_id,
        genre,
        na_sales,
        jp_sales,
        pal_sales,
        other_sales
    FROM video_game_sales_clean
    WHERE na_sales IS NOT NULL
      AND jp_sales IS NOT NULL
      AND pal_sales IS NOT NULL
      AND other_sales IS NOT NULL
),
regional_long AS (
    SELECT
        raw_id,
        genre,
        'North America' AS region,
        na_sales AS regional_sales_millions
    FROM complete_regional_sales
    UNION ALL
    SELECT
        raw_id,
        genre,
        'Japan',
        jp_sales
    FROM complete_regional_sales
    UNION ALL
    SELECT
        raw_id,
        genre,
        'PAL markets',
        pal_sales
    FROM complete_regional_sales
    UNION ALL
    SELECT
        raw_id,
        genre,
        'Other regions',
        other_sales
    FROM complete_regional_sales
),
genre_region_summary AS (
    SELECT
        region,
        genre,
        COUNT(*) AS complete_records,
        ROUND(SUM(regional_sales_millions),2) AS reported_sales_millions,
        ROUND(AVG(regional_sales_millions),3) AS average_sales_per_record
    FROM regional_long
    GROUP BY region, genre
),
ranked_genres AS (
    SELECT
        region,
        genre,
        complete_records,
        reported_sales_millions,
        average_sales_per_record,
DENSE_RANK() OVER (PARTITION BY region ORDER BY reported_sales_millions DESC) AS genre_rank
    FROM genre_region_summary
)
SELECT
    region,
    genre_rank,
    genre,
    complete_records,
    reported_sales_millions,
    average_sales_per_record
FROM ranked_genres
WHERE genre_rank <= 5
ORDER BY region, genre_rank, genre;


/*
QUERY 6: Critic-score bands and sales

How does reported global sales performance vary across critic-score bands?

Scope:
Only records containing both critic_score and total_sales have been used
*/

WITH score_band_data AS (
SELECT critic_score,
total_sales,

CASE
	WHEN critic_score >= 9.0 THEN '9.0–10.0'
	WHEN critic_score >= 8.0 THEN '8.0–8.9'
	WHEN critic_score >= 7.0 THEN '7.0–7.9'
	WHEN critic_score >= 6.0 THEN '6.0–6.9'
		ELSE 'Below 6.0'
	END AS score_band,

CASE
	WHEN critic_score >= 9.0 THEN 5
	WHEN critic_score >= 8.0 THEN 4
	WHEN critic_score >= 7.0 THEN 3
	WHEN critic_score >= 6.0 THEN 2
		ELSE 1
	END AS band_order
FROM video_game_sales_clean
WHERE critic_score IS NOT NULL
AND total_sales IS NOT NULL
)
SELECT score_band,
COUNT(*) AS eligible_records,
ROUND(SUM(total_sales),2) AS reported_global_sales_millions,
ROUND(AVG(total_sales),3) AS average_sales_per_record,
MIN(total_sales) AS minimum_sales,
MAX(total_sales) AS maximum_sales
FROM score_band_data
GROUP BY score_band,band_order
ORDER BY band_order DESC;


/*
QUERY 7: Top publishers by reported sales

Which publishers generated the highest reported global sales through 2018?

Scope:
- Records must have a known publisher.
- Releases after 2018 are excluded because sales coverage collapses.
- Publishers need at least 10 records with reported sales.
- Publisher names are analyzed exactly as recorded in the dataset.
*/

SELECT publisher,
COUNT(*) AS total_publisher_records,
COUNT(total_sales) AS records_with_sales,
ROUND(100.0 * COUNT(total_sales) / COUNT(*),2) AS sales_coverage_pct,
ROUND(SUM(total_sales),2) AS reported_global_sales_millions,
ROUND(AVG(total_sales),2) AS average_sales_per_reported_record
FROM video_game_sales_clean
WHERE publisher IS NOT NULL
AND release_date <= '2018-12-31'
GROUP BY publisher
HAVING COUNT(total_sales) >= 10
ORDER BY reported_global_sales_millions DESC
LIMIT 15;



/*
QUERY 8: Top-selling records within each genre

Which title-console records generated the highest sales within each genre?

Scope:
- Only records with reported total sales are included.
- Only releases through 2018
- Rankings are calculated separately for each genre
- Title-console records are ranked individually; identical titles are not combined across consoles in this query.
*/

WITH ranked_genre_titles AS (
SELECT genre,
title,
console,
publisher,
YEAR(release_date) AS release_year,
total_sales AS global_sales_millions,
DENSE_RANK() OVER (PARTITION BY genre ORDER BY total_sales DESC) AS sales_rank_within_genre
FROM video_game_sales_clean
WHERE total_sales IS NOT NULL
AND release_date <= '2018-12-31'
)
SELECT genre,
sales_rank_within_genre,
title,
console,
publisher,
release_year,
global_sales_millions
FROM ranked_genre_titles
WHERE sales_rank_within_genre <= 3
ORDER BY genre, sales_rank_within_genre, title;

/*
QUERY 9: Top titles by reported global sales
 
Which titles generated the most sales?

- Identical titles are combined across consoles.
- Only release-dated records from 1971 through 2018 are included.
- Titles must be non-NULL and nonblank.
*/

SELECT title,
ROUND(SUM(total_sales),2) As reported_sales_millions
FROM video_game_sales_clean
WHERE total_sales IS NOT NULL
  AND release_date BETWEEN '1971-01-01' AND '2018-12-31'
  AND title IS NOT NULL
GROUP BY title
ORDER BY reported_sales_millions DESC
LIMIT 10;




/*
 Appendix A — Console release-date investi
Purpose:
Inspecting the earliest release-date records for consoles whose
observed dates appear inconsistent with their platform eras.
*/

WITH earliest_console_records AS (
    SELECT
        raw_id,
        title,
        console,
        genre,
        publisher,
        release_date,
        total_sales,

        ROW_NUMBER() OVER (PARTITION BY console ORDER BY release_date, raw_id) AS release_order
FROM video_game_sales_clean
WHERE console IN ('PS','PS3','DS','Wii','3DS','PSV','NS','WiiU')
      AND release_date IS NOT NULL
)

SELECT
    raw_id,
    title,
    console,
    genre,
    publisher,
    release_date,
    total_sales
FROM earliest_console_records
WHERE release_order <= 5
ORDER BY console, release_date, raw_id;
