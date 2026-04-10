-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

# Before performing any EDA, let's see how many null values exist within our three quantitative columns
SELECT SUM(
	CASE WHEN total_laid_off IS NULL
    THEN 1
    ELSE 0
    END) AS null_count
FROM layoffs_staging2;

SELECT SUM(
	CASE WHEN percentage_laid_off IS NULL
    THEN 1
    ELSE 0
    END) AS null_count
FROM layoffs_staging2;

SELECT SUM(
	CASE WHEN funds_raised_millions IS NULL
    THEN 1
    ELSE 0
    END) AS null_count
FROM layoffs_staging2;

# What was the most amount of employees laid off in one company?
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

# Let's see which companies went under
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

# How much did these companies fundraise before going under?
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

# Let's see which companies laid off the most employees
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

# Let's check the date range of this data
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

# Let's see which industries laid off the most employees
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

# Let's see which countries experienced the most layoffs
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

# Time Series Analysis by year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

# Calculate the total layoffs in the dataset
SELECT SUM(total_laid_off)
FROM layoffs_staging2;

# Let's see which funding stage had the most layoffs
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

# Time Series Analysis by year
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC;

# Rolling sum of layoffs by month
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC
)
SELECT `Month`, total_off,
SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
FROM Rolling_Total;

# Top 5 company layoffs per year partitioned by company
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year (company, years, total_laid_off) AS
(SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;