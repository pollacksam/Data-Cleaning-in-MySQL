# Data-Cleaning-in-MySQL
Based on the Data Analyst Bootcamp by Alex The Analyst, I performed a multitude of data cleaning techniques, including removing duplicate values, data standardization, dealing with null/blank values, and removing columns/rows. This project uses the dataset provided by: https://www.kaggle.com/datasets/swaptr/layoffs-2022

A Few Notes Regarding This Data Set:
  Prior to performing this exploratory data analysis, we deleted, rather than imputing, all null values contained within both the total_laid_off and percentage_laid_off columns.
    Essentially deleting any rows with no quantitative data.
  Many of the total_laid_off and percentage_laid_off figures are mutually exclusively null within the dataset post-cleanup.
    378 out of 1995 rows (18.9%) with null values in total_laid_off.
    423 out of 1995 rows (21.2%) with null values in percentage_laid_off.
    165 out of 1995 rows (8.3%) with null values in funds_raised_millions.
    Rather than imputing these values, we are leaving them as null, which forces SQL to exclude these data points in aggregation.

Key Findings:
