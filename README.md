# Layoff Analysis (MySQL)

A SQL project that cleans a raw layoffs dataset and explores it to find trends in company, industry, stage, and time-based layoffs.

The whole project lives in one script: [`SQL_DATA.sql`](SQL_DATA.sql).

## Project Overview

The project has two parts:

1. **Data cleaning**: turn the raw `layoff_stagging` table into a clean `layoff_stagging2` table.
2. **Exploratory Data Analysis (EDA)**: run aggregate and window-function queries on the cleaned data.

## Tech Used

- MySQL 8.0+ (window functions and CTEs are required)
- MySQL Workbench (or any MySQL client)

## Table Structure

| Column | Type | Description |
|---|---|---|
| `company` | text | Company name |
| `location` | text | City / location of the company |
| `industry` | text | Industry category |
| `total_laid_off` | int | Number of employees laid off |
| `percentage_laid_off` | text | Share of workforce laid off |
| `date` | date | Date of the layoff (converted from text) |
| `stage` | text | Funding stage of the company |
| `country` | text | Country |
| `funds_raised_millions` | int | Funds raised (in millions) |

## 1. Data Cleaning Steps

1. **Create a staging table** (`layoff_stagging2`) so the raw data stays untouched.
2. **Remove duplicates**: use `ROW_NUMBER() OVER (PARTITION BY ...)` inside a CTE to flag duplicate rows, then delete rows where `row_num > 1`.
3. **Standardize data**
   - Trim extra spaces from `company`.
   - Merge similar industry labels (e.g. `Crypto%` into `Crypto`).
   - Fix inconsistent country names.
   - Convert `date` from text to a proper `DATE` using `STR_TO_DATE(..., '%m/%d/%Y')` and `ALTER TABLE ... MODIFY COLUMN`.
4. **Handle NULL and blank values**: set blank `industry` values to `NULL`, then fill them by self-joining on the same company.
5. **Remove unusable rows**: delete rows where both `total_laid_off` and `percentage_laid_off` are `NULL`.
6. **Drop helper column**: remove `row_num` after cleaning.

## 2. Exploratory Data Analysis

| Analysis | Technique |
|---|---|
| Total layoffs by company | `GROUP BY`, `SUM` |
| Total layoffs by year | `YEAR()`, `GROUP BY` |
| Total layoffs by funding stage | `GROUP BY` |
| Total layoffs by month | `SUBSTR(date, 1, 7)` |
| Rolling (cumulative) total by month | CTE + `SUM() OVER (ORDER BY month)` |
| Layoffs per company per year | multi-column `GROUP BY` |
| Top 5 companies per year | CTEs + `DENSE_RANK() OVER (PARTITION BY year ...)` |

## SQL Concepts Practiced

- Common Table Expressions (CTEs)
- Window functions: `ROW_NUMBER`, `DENSE_RANK`, running `SUM`
- Self joins
- Data type conversion
- `GROUP BY` aggregation
- Data cleaning workflow with staging tables

## How to Run

1. Import the raw layoffs dataset into MySQL as a table named `layoff_stagging`.
2. Open `SQL_DATA.sql` in MySQL Workbench.
3. Run the script section by section (cleaning first, then EDA).

## Author

**Khushi Thakkar**
