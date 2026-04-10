# Data-Cleaning-in-MySQL
Based on the Data Analyst Bootcamp by Alex The Analyst, I performed a multitude of data cleaning techniques, including removing duplicate values, data standardization, dealing with null/blank values, and removing columns/rows. This project uses the data set provided by: https://www.kaggle.com/datasets/swaptr/layoffs-2022

## A Few Notes Regarding This Data Set:

Prior to performing this exploratory data analysis, we deleted, rather than imputing, all null values contained within both the total_laid_off and percentage_laid_off columns. Essentially deleting any rows with no quantitative data.

Many of the total_laid_off and percentage_laid_off figures are mutually exclusively null within the data set post-cleanup. 378 out of 1995 rows (18.9%) with null values in total_laid_off. 423 out of 1995 rows (21.2%) with null values in percentage_laid_off. 165 out of 1995 rows (8.3%) with null values in funds_raised_millions. Rather than imputing these values, we are leaving them as null, forcing SQL to exclude these data points in aggregation.

## Key Findings:

This data explores layoffs between 3/11/2020 to 3/6/2023, essentially the span of the COVID pandemic.

Many companies included in this data set went under, with one company laying off 12,000 employees before going under.

Many of these companies had raised a significant amount of funds, with Britishvolt, a transportation company based in London, having raised the most funds among companies who went under at $2.4B in funds before going under in January 2023, putting 206 employees out of work.

Amazon saw the most layoffs, letting go of 18,150 employees in the 3 years this data set spans, followed by Google, Meta, and Salesforce.

The consumer industry (i.e., Google, Meta) had the most layoffs with 45,182 total employees laid off, followed by retail, ‘other,’ transportation, and finance. This lines up with the expectation that COVID would primarily impact the industries most dependent on less 'essential' roles.

The United States had by far the most layoffs, with 256,559 total layoffs, followed by India (35,993), Netherlands (17,220), and Sweden (11,264). It’s worth noting that the data collected in this data set might be slightly skewed toward US hiring trends. Further research into the data collection process is warranted.

A large proportion of these layoffs (~53%) were done within post-IPO staged companies. Acquired companies also laid off a significant amount of employees at 27,576 layoffs (~7%).

Time Series Analysis by year:

2020 - 80,998 layoffs.

2021 - 15,823 layoffs.

2022 - 160,661 layoffs.

2023 - 125,677 layoffs.

Biggest takeaway: the aftermath of the pandemic hit the job market harder than the peak of the pandemic itself. 2023 as a year likely experienced a significantly larger volume of layoffs than what’s reported, as the data set only accounts for layoffs up until March 2023. January 2023 had the most layoffs worldwide in one month (84,714), with over 170,000 layoffs spanning November 2022 to February 2023.
