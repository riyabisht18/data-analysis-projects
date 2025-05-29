-- layoffs_data_cleaning.sql


-- Step 1: View original data
SELECT * FROM LAYOFFS;

-- Step 2: Create staging table to work on data without altering original
CREATE TABLE LAYOFFS_STAGING LIKE LAYOFFS;

INSERT INTO LAYOFFS_STAGING
SELECT * FROM LAYOFFS;

-- Step 3: Remove duplicates using ROW_NUMBER partitioned by all columns
CREATE TABLE LAYOFFS_STAGING2 AS
SELECT *,
  ROW_NUMBER() OVER (
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
  ) AS ROW_NO
FROM LAYOFFS_STAGING;

DELETE FROM LAYOFFS_STAGING2
WHERE ROW_NO > 1;

-- Step 4: Trim whitespace from 'company' column
UPDATE LAYOFFS_STAGING2
SET company = TRIM(company);

-- Step 5: Standardize 'industry' column values for crypto-related entries
UPDATE LAYOFFS_STAGING2
SET industry = 'Crypto'
WHERE industry LIKE 'crypto%';

-- Step 6: Clean trailing periods from 'country' column, especially for United States variants
UPDATE LAYOFFS_STAGING2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'united states%';

-- Step 7: Convert 'date' column from string to DATE datatype (format: m/d/YYYY)
UPDATE LAYOFFS_STAGING2
SET `date` = STR_TO_DATE(`date`, '%c/%e/%Y');

-- Step 8: Replace empty strings in 'industry' with NULL
UPDATE LAYOFFS_STAGING2
SET industry = NULL
WHERE industry = '';

-- Step 9: Fill missing 'industry' values by joining with other rows from the same company
UPDATE LAYOFFS_STAGING2 AS T1
JOIN LAYOFFS_STAGING2 AS T2
  ON T1.company = T2.company
SET T1.industry = T2.industry
WHERE T1.industry IS NULL
  AND T2.industry IS NOT NULL;

-- Step 10: Delete rows where both total_laid_off and percentage_laid_off are NULL (not useful data)
DELETE FROM LAYOFFS_STAGING2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

-- Step 11: Remove the ROW_NO column as it was only for deduplication purposes
ALTER TABLE LAYOFFS_STAGING2
DROP COLUMN ROW_NO;

-- Step 12: Final check on cleaned data 
SELECT * FROM LAYOFFS_STAGING2;
