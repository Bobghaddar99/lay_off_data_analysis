SELECT distinct(company)
FROM layoff_cleaned2;

UPDATE layoff_cleaned2
SET company = TRIM(company);

SELECT distinct company
FROM layoff_cleaned2
order by company;

-- correct country naming --
SELECT distinct country
FROM layoff_cleaned2
order by country;
-- someone putted a do in a country name -- 
UPDATE layoff_cleaned2
SET country =  TRIM(TRAILING '.' FROM country);
-- correct date --
SELECT `date` , str_to_date(`date`, '%m/%d/%Y')
FROM layoff_cleaned2;

-- now push it to the table  --
UPDATE layoff_cleaned2
SET `date` =  str_to_date(`date`, '%m/%d/%Y');

SELECT `date` 
FROM layoff_cleaned2;

ALTER TABLE layoff_cleaned2
MODIFY COLUMN `date` DATE;

-- lets see the industry --
SELECT distinct(industry)
FROM layoff_cleaned2;
-- solve crypto issue --
UPDATE layoff_cleaned2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- remove or solve nulls in industry --
SELECT t1.industry,t2.industry
FROM layoff_cleaned2 t1
 JOIN INNER layoff_cleaned2 t2
 ON t1.company = t2.company
 WHERE (t1.industry IS NULL) OR (t1.industry = '')
 and t2.industry IS NOT NULL and t2.industry != ''; 
-- now update -- 
UPDATE layoff_cleaned2 t1
 JOIN layoff_cleaned2 t2
 ON t1.company = t2.company
 SET t1.industry = t2.industry
 WHERE (t1.industry IS NULL) OR (t1.industry = '')
 and t2.industry IS NOT NULL and t2.industry != ''; 
 -- see nul --
 SELECT industry , company
 FROM layoff_cleaned2
 WHERE company LIKE 'Bally%';
 
 -- remove bally because it has no similar data to populte it -- 
 DELETE
 FROM layoff_cleaned2
 WHERE company LIKE 'Bally%';
 
 -- there is some data where no total or percentage so lets remove them -- 
 DElETE 
 FROM layoff_cleaned2
 WHERE total_laid_off IS NULL and percentage_laid_off IS NULL ;
 
 -- lets check again  -- 
 SELECT total_laid_off,  percentage_laid_off 
 FROM layoff_cleaned2;
 -- done -- 
 SELECT *
 FROM  layoff_cleaned2;