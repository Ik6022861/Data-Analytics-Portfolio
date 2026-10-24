# Electronics Product Analysis Using SQL Server

## Project Overview

This project demonstrates an end-to-end data analytics workflow using SQL Server. The objective was to clean raw electronics product data, perform exploratory data analysis (EDA), apply statistical techniques, and generate actionable business insights.

The project covers the complete analytics lifecycle:

- Data Cleaning
- Feature Engineering
- Data Quality Assessment
- Exploratory Data Analysis (EDA)
- Statistical Analysis
- Business Insights Generation

---

## Dataset

The dataset contains electronics product information collected from an online retail source.

### Key Attributes

- Product Title
- Product Category
- Price
- Discount Information
- Product Features
- Customer Rating
- Number of Reviews

---

## Tools & Technologies

- SQL Server
- T-SQL
- Microsoft Excel
- Statistical Analysis
- Exploratory Data Analysis (EDA)

---

## Project Objectives

1. Clean and transform raw product data.
2. Extract meaningful analytical features.
3. Explore product pricing and customer review patterns.
4. Identify outliers and pricing anomalies.
5. Analyze customer satisfaction across brands.
6. Generate business insights to support decision-making.

---

# Data Cleaning

The following cleaning operations were performed:

### Price Column

- Removed currency symbols (`$`)
- Removed commas from numeric values
- Converted text prices into numeric format
- Processed price ranges such as:
  
  ```
  1000 through-2000
  ```

- Replaced price ranges with their average value
- Converted Price column to `DECIMAL(10,2)`

### Discount Column

- Created `Discount_Given` flag
- Created `MRP` column
- Standardized discount descriptions into categories:

  - Amount Discount
  - No Discount
  - Free Shipping
  - Validity Promotion
  - Special Event
  - Other

### Rating Column

Extracted:

- Average Rating
- Reviews Count

Created:

- `Average_Rating`
- `Reviews_Count`

Removed original raw rating column after extraction.

### Title Column

Created:

- `Brand_Name`

Brand names were extracted and standardized from product titles.

### Feature Column

Removed encoding issues such as:

- Â®
- â„¢
- â€™

---

# Feature Engineering

The following new analytical features were created:

| Feature | Description |
|----------|------------|
| Brand_Name | Product brand extracted from title |
| Average_Rating | Customer rating |
| Reviews_Count | Number of customer reviews |
| Discount_Given | Indicates discount availability |
| MRP | Original product price |
| DiscountType | Standardized discount category |

---

# Data Quality Assessment

Performed data quality checks including:

### Missing Value Analysis

Checked missing values for:

- Price
- Average Rating
- Reviews Count
- Brand Name
- Sub Category

### Duplicate Detection

Identified duplicate product records using product titles.

---

# Exploratory Data Analysis (EDA)

## Univariate Analysis

Performed analysis on product prices using:

- Minimum Price
- Maximum Price
- Average Price
- Standard Deviation
- Percentiles
- Quartiles
- Histograms
- Outlier Detection

### Statistical Measures Used

- Mean
- Median
- Standard Deviation
- Quartiles (Q1, Q2, Q3)
- Interquartile Range (IQR)

---

## Outlier Detection

Outliers were identified using the IQR method:

```
IQR = Q3 - Q1

Lower Bound = Q1 - 1.5 × IQR

Upper Bound = Q3 + 1.5 × IQR
```

Products with prices greater than the upper bound were classified as outliers.

---

## Bivariate Analysis

### Numerical vs Numerical

Analyzed relationship between:

- Average Rating
- Reviews Count

Techniques used:

- Covariance
- Correlation
- Regression Slope

### Numerical vs Categorical

Analyzed:

- Brand Name vs Product Price

Metrics:

- Average Price
- Minimum Price
- Maximum Price
- Standard Deviation

### Categorical vs Categorical

Analyzed:

- Brand Name
- Product Categories

---

## Multivariate Analysis

Performed covariance analysis between:

- Price
