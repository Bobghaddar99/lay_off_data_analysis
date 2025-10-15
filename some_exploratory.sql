SELECT *
FROM layoff_cleaned2;

SELECT company, total_laid_off, `date`
FROM layoff_cleaned2
ORDER BY total_laid_off DESC;
-- just imagine 12000 per day --
-- lets see what year the maximum layoff was -- 
SELECT 
    YEAR(date) AS `year`,
    SUM(total_laid_off) AS total
FROM
    layoff_cleaned2
GROUP BY `year`;
-- it was year 2022 -- 
-- lets see what month -- 
SELECT SUBSTRING(`date`, 6, 2) AS `month`, SUM(total_laid_off) AS total
FROM layoff_cleaned2
GROUP BY `month`
ORDER BY total DESC;
-- january -- 
SELECT stage, SUM(total_laid_off) AS total
FROM layoff_cleaned2
GROUP BY stage
ORDER BY total DESC;
-- rolling total -- 
WITH rolling_total AS 
( 
SELECT substring(`date`,1,7) AS `month` , SUM(total_laid_off) AS  total 
FROM layoff_cleaned2 
WHERE substring(`date`,1,7) IS NOT NULL
group by `month`
ORDER by total desc  ) 

SELECT `month` , SUM(total) OVER(ORDER by`month` )
FROM rolling_total;
-- lets rank per month -- 
WITH ranking AS ( 
SELECT company,year(`date`) AS `year` ,SUM(total_laid_off) AS total
From layoff_cleaned2
GROUP by company, year(`date`)
), rankers_query AS
(SELECT *, dense_rank()over( partition by `year` order by total DESC) AS ranks
FROM ranking)
SELECT *
FROM rankers_query
Where ranks > 5;

