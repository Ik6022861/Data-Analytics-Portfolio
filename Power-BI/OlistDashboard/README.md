\# Olist Dashboard



\## Project Overview



This project uses the Olist real-world dataset for data analysis and dashboard development.



The dataset contains 9 Excel datasets from the Olist company. The data was first uploaded into a database and then pulled from the database using Python for data cleaning and preparation.



\## Data Preparation Process



1\. Collected the 9 Excel datasets from the Olist dataset.

2\. Uploaded the Excel data into a database.

3\. Connected Python to the database.

4\. Pulled the data from the database using Python.

5\. Cleaned and prepared the data using Python.

6\. Used the cleaned data to perform business analysis.

7\. Created Power BI visuals and dashboards based on the analysis requirements.



\## Business Questions and Analysis



\### 1. General Business Information



Created visuals to show:



\- Total Customers

\- Total Orders

\- Total Sales

\- Average Order Value = Total Sales / Total Orders

\- Count of customers who have not purchased in the last 12 months



\### 2. Product Category Contribution to Sales



Analyzed the contribution of each product category to overall sales by calculating its percentage share of total sales.



Category contribution is color-coded:



\- Green: contribution greater than 5%

\- Cream: contribution between 3% and 5%

\- Yellow: contribution less than 3%



Percentage values are displayed using a blue gradient to make comparisons more visually intuitive.



\### 3. Customer Churn Analysis



Identified customers who churned in each year. A customer is considered churned when they made purchases in a previous year but did not place any orders in the following year.



The analysis highlights customer churn year by year to help understand customer retention trends.



\### 4. Product Photos vs Quantity Sold



Analyzed whether there is a relationship between the quantity of products sold and the number of product photos available on the website.



Each order-item row is counted as one quantity. The objective is to determine whether products with more photos tend to sell in higher quantities.



\### 5. Market Basket Analysis



Performed market basket analysis to identify products that are frequently purchased together in the same order.



The analysis can support:



\- Cross-selling

\- Product bundling

\- Targeted marketing

\- Product recommendations



\### 6. New Product Performance



Evaluated category performance based on recently launched products.



A product is considered recently launched when it was introduced within the last 6 months from the latest date available in the dataset.



The analysis includes:



\- Total sales from new products

\- Total orders from new products

\- Category-level performance



\### 7. Product Seasonality



Identified products that exhibit seasonality in their sales.



The analysis examines recurring monthly sales patterns and fluctuations to support:



\- Inventory planning

\- Promotions

\- Marketing strategies

\- Demand forecasting



\### 8. Product Price Changes vs Sales



Calculated the average change in product prices over the last year for each category and analyzed the relationship between price changes and sales performance.



The objective is to understand whether price increases or decreases were associated with changes in customer purchasing behavior and category sales.



\### 9. Buy One Get One Free Simulation



Simulated the potential impact of a Buy One Get One Free promotion on profit margin.



The simulation was performed on the top 10 selling products based on quantity.



Assumptions:



\- The promotion would double the quantity sold.

\- Every second item would be sold at zero price.

\- The simulation estimates the potential financial impact of the promotion.



\### 10. Payment Method Analysis



Analyzed customer payments grouped by payment type to understand the distribution of sales across different payment methods.



This analysis helps identify the most preferred payment options and can support financial and promotional strategies.



\### 11. On-Time vs Late Delivery



Compared the average review score for orders delivered on time versus orders delivered late.



The objective is to understand whether delivery performance is associated with customer satisfaction.



\### 12. Order Fulfillment Time



Calculated the average time, in hours, for each stage of the order fulfillment process.



This analysis helps identify stages that may require additional operational attention.



\### 13. First 90 Days vs Most Recent 90 Days



Compared product category revenue from the first 90 days on the platform with revenue from the most recent 90 days.



The objective is to identify which product categories are maturing successfully and how their revenue performance has changed over time.



\### 14. Highly Rated but Underperforming Local Sellers



Identified sellers who have an average review score greater than 4.5 but appear to be underperforming in their local market.



An underperforming seller is defined as a seller where less than 10% of total sales come from customers within the seller's own state.



This analysis can help identify potential missed local marketing opportunities.



\## Tools and Technologies



\- Excel

\- Database

\- Python

\- Pandas

\- SQL

\- Power BI

\- DAX



\## Project Workflow



Excel Data  

↓  

Database  

↓  

Python  

↓  

Data Cleaning and Preparation  

↓  

Cleaned Data  

↓  

Power BI  

↓  

DAX Analysis  

↓  

Dashboard and Business Insights

