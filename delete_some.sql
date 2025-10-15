INSERT INTO layoff_cleaned
SELECT *
FROM layoffs;
SET SQL_SAFE_UPDATES = 0;
DELETE
FROM layoff_cleaned
WHERE country = "Israel";

SELECT *
FROM layoff_cleaned;

-- now we want to remove any duplicate --

CREATE TABLE `layoff_cleaned2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM layoff_cleaned2;

INSERT INTO layoff_cleaned2
SELECT *,
row_number() over(PARTITION BY company,location,stage,funds_raised_millions,country,`date`,industry,total_laid_off,percentage_laid_off) AS row_num
FROM layoff_cleaned;

DELETE 
FROM layoff_cleaned2
WHERE row_num > 1 ;

SELECT row_num
FROM layoff_cleaned2
ORDER BY row_num desc;