-- Exploratory Data Analysis (EDA) SQL Script for Layoffs Data

-- 1. Companies with 100% Layoffs
SELECT * 
FROM layoffs_staging2 
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- 2. Total Layoffs by Company
SELECT company, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY company 
ORDER BY total_layoffs DESC;

-- 3. Date Range of Layoffs
SELECT MIN(date) AS earliest_layoff, MAX(date) AS latest_layoff
FROM layoffs_staging2;

-- 4. Total Layoffs by Industry
SELECT industry, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_layoffs DESC;

-- 5. Total Layoffs by Year
SELECT YEAR(date) AS year, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY year
ORDER BY year DESC;

-- 6. Total Layoffs by Company Stage
SELECT stage, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_layoffs DESC;

-- 7. Monthly Layoffs
SELECT SUBSTRING(date, 1, 7) AS month, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2 
WHERE date IS NOT NULL
GROUP BY month
ORDER BY month ASC;

-- 8. Rolling Total of Layoffs Over Time
WITH monthly_totals AS (
  SELECT 
    SUBSTRING(date, 1, 7) AS month,  
    SUM(total_laid_off) AS total_layoffs
  FROM layoffs_staging2 
  WHERE date IS NOT NULL
  GROUP BY month
)
SELECT 
  month, 
  total_layoffs,
  SUM(total_layoffs) OVER (ORDER BY month) AS rolling_total
FROM monthly_totals;

-- 9. Total Layoffs by Company and Year
SELECT company, YEAR(date) AS year, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2 
GROUP BY company, year
ORDER BY total_layoffs DESC;

-- 10. Top 4 Companies by Layoffs Each Year
WITH company_year AS (
  SELECT 
    company, 
    YEAR(date) AS year, 
    SUM(total_laid_off) AS total_layoffs
  FROM layoffs_staging2 
  GROUP BY company, year
),
company_year_ranking AS (
  SELECT 
    *, 
    DENSE_RANK() OVER (PARTITION BY year ORDER BY total_layoffs DESC) AS ranking
  FROM company_year
)
SELECT * 
FROM company_year_ranking 
WHERE ranking < 5;


