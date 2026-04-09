-- Data Cleaning Project
## Begin by importing the dataset using New Schema -> layoffs.csv

SELECT *
FROM layoffs;

-- Table of Contents
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank Values
-- 4. Remove Any Columns or Rows

# Let's create a staging table so we don't manipulate the raw data table
CREATE TABLE layoffs_staging
LIKE layoffs;

# You'll notice that the table we created is empty
SELECT *
FROM layoffs_staging;

# Let's insert the data!
INSERT layoffs_staging
SELECT *
FROM layoffs;

# Now we have a populated table
SELECT *
FROM layoffs_staging;

-- 1. Remove Duplicates

# Creating a duplicate identifier (would be much easier if we had a unique ID column, but this is our workaround)
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

# Checking one example of a duplicate value
SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

# Let's create a second staging table to more easily filter on the duplicate rows (right click layoffs_staging table -> Copy to Clipboard -> Create Statement)
CREATE TABLE `layoffs_staging2` (
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
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

# Let's finally delete the duplicates
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

# Check the results of the DELETE statement (should be an empty table)
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

# Check the cleaned table!
SELECT *
FROM layoffs_staging2;

-- 2. Standardize the Data

# Let's work to trim (remove excess spaces) the company column
SELECT DISTINCT(company)
FROM layoffs_staging2;

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

# TRIM completed!
SELECT company, TRIM(company)
FROM layoffs_staging2;

# Next, let's fix the industry column
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

# Let's make it so anything in the Crypto industry is standardized as 'Crypto'
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

# Fixed!
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

# Now let's look at some other columns
SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

# We noticed that there's two distinct values for the U.S. ('United States' and 'United States.'), let's fix that
SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

# We made the correction, now let's combine the duplicates into one
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2;

# We want to change the date column to date values
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;

-- 3. Null Values or Blank Values

# Ex. checking null values
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

# We won't be able to update any blank values unless they're null, so let's update them as such
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

# Let's start with the industry column
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

# Let's standardize the industry column based on other populated industry data points from the same company
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

# To make this easier to view across the full table, let's JOIN the table on itself
SELECT *
FROM layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;

# Here's an even simpler version
SELECT t1.industry, t2.industry
FROM layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;

# Check the results of the UPDATE statement (should be an empty table because we don't expect any null values)
SELECT t1.industry, t2.industry
FROM layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;

# Check the cleaned table!
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

# Let's see which industry values are still null
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

# Unforunately only one instance remaining, meaning there isn't another row with which we can reference the same company to populate the null value with the corresponding industry value
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

SELECT *
FROM layoffs_staging2;

-- 4. Remove Any Columns or Rows

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

# Let's delete the null values in these two columns (NOTE: THIS IS HIGHLY ILL-ADVISED UNDER MOST CIRCUMSTANCES WITHOUT PERFORMING OTHER METHODS OF DEALING WITH NULL VALUES)
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

# Let's also delete our row_num column
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

# Final cleaned table!
SELECT *
FROM layoffs_staging2;