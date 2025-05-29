# 🧹 Layoffs Data Cleaning Project

## 📌 Project Overview
This project involves cleaning a dataset containing layoffs information from various companies. The raw data had issues such as duplicate rows, inconsistent formatting, incorrect date formats, and missing values, which could negatively impact further analysis.

## 🛠️ Skills & Technologies Used
- SQL (SELECT, JOIN, WINDOW FUNCTIONS, DELETE, UPDATE)
- Data Cleaning & Transformation
- Data Deduplication and Standardization

## 🧼 Data Cleaning Steps

1. **Duplicate Removal**  
   Created a staging table and used the `ROW_NUMBER()` window function to identify and remove duplicate rows, ensuring each record is unique.

2. **Whitespace Trimming**  
   Trimmed extra spaces from the `company` column to standardize company names.

3. **Standardizing Industry Names**  
   Updated industry names that start with "crypto" to a consistent value `"Crypto"` for uniformity.

4. **Cleaning Country Names**  
   Removed trailing periods from the `country` column, especially for variations of "United States."

5. **Date Conversion**  
   Converted the `date` column from string format (e.g., "3/15/2023") to a proper SQL `DATE` datatype using `STR_TO_DATE`.

6. **Handling Missing Industry Values**  
   Replaced empty industry strings with `NULL`, then filled missing values by referencing other rows from the same company.

7. **Removing Incomplete Records**  
   Deleted rows missing both `total_laid_off` and `percentage_laid_off`, as they lacked enough data for meaningful analysis.

8. **Cleanup**  
   Dropped temporary columns used during the cleaning process (e.g., `ROW_NO`).

## ✅ Why This Cleaning Matters
- **Accuracy:** Removes duplicates to avoid double counting.
- **Consistency:** Standardized text helps with filtering and grouping.
- **Querying Efficiency:** Date conversion supports time-based queries.
- **Completeness:** Filling missing data improves reliability of analysis.






