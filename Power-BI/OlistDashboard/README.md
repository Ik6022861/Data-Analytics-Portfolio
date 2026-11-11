# Olist E-Commerce Business Intelligence Dashboard

## 📌 Project Overview

This project uses the Olist Brazilian E-Commerce dataset to perform end-to-end business analysis and dashboard development using SQL Server, Python, and Power BI.

The Olist dataset consists of multiple datasets containing information about customers, orders, products, sellers, reviews, geolocation, payments, and order items.

The objective of this project was to build a complete Business Intelligence solution by extracting data from SQL Server, performing data cleaning and transformation using Python, and developing interactive Power BI dashboards to generate actionable business insights related to sales performance, customer behavior, operational efficiency, product performance, and seller performance.

---

# 🎯 Business Objective

The goal of this project was to help stakeholders understand:

- Overall business performance.
- Customer purchasing behavior.
- Product performance trends.
- Customer retention and churn.
- Order fulfillment efficiency.
- Payment method preferences.
- Product relationships and cross-selling opportunities.
- Revenue growth and decline across categories.
- Seller performance and market opportunities.

---

# 🏗 Solution Architecture

```text
Excel Datasets
       │
       ▼
SQL Server Database
       │
       ▼
Python Data Cleaning & Validation
       │
       ▼
Cleaned & Prepared Data
       │
       ▼
Power BI Data Model
       │
       ▼
DAX Measures & KPIs
       │
       ▼
Interactive Dashboards
       │
       ▼
Business Insights
```

---

# 🐍 Data Preparation & Cleaning

The original Olist dataset was loaded into SQL Server and processed using Python.

## Customer Dataset

Performed:

- Customer city standardization.
- Removal of special characters.
- Data formatting improvements.
- Removal of unnecessary columns.

## Geolocation Dataset

Performed:

- Duplicate removal.
- Removal of latitude and longitude fields.
- City name standardization.
- Accent removal using Unidecode.
- Invalid character handling.
- Manual city corrections.
- Data quality validation.

## Product Dataset

Performed:

- Category translation from Portuguese to English.
- Missing category correction.
- Product category standardization.
- Removal of unnecessary product attributes.

## Seller Dataset

Performed:

- Seller city standardization.
- Duplicate removal.

## Orders Dataset

Performed:

- Invalid date validation.
- Fulfillment sequence validation.
- Removal of logically incorrect order records.
- Payment data integration.
- Order items integration.
- Quantity calculation.
- Aggregated order-level metrics creation.

## Review Dataset

Performed:

- Selection of relevant review attributes.
- Creation of reporting-ready review data.

---

# 📊 Dashboard Overview

The dashboard consists of four business intelligence pages.

---

# Page 1 – Executive Business Overview

### KPI Metrics

- Total Purchasing Customers
- Total Orders
- Total Sales
- Average Order Value (AOV)
- Inactive Customers (Last 12 Months)

### Analysis Included

#### Product Category Contribution to Sales

Analyzed each product category’s percentage contribution toward total sales.

Categories were visually classified based on contribution levels:

- Greater than 5%
- Between 3% and 5%
- Less than 3%

#### Product Photos vs Quantity Sold

Examined whether the number of product photos influences customer purchasing behavior.

#### Review Score by Delivery Status

Compared average review scores between:

- On-Time Deliveries
- Late Deliveries

#### Customer Churn Analysis

Identified customers who stopped purchasing in following years.

#### Promotion Impact Analysis

Simulated the impact of a Buy-One-Get-One-Free promotion on profitability using top-selling products.

---

# Page 2 – Customer Orders & Operations Analysis

### Market Basket Analysis

Performed association analysis using:

- Support
- Confidence
- Lift

The objective was to identify products frequently purchased together.

Business Applications:

- Cross-selling
- Recommendation systems
- Product bundling
- Promotional campaigns

### Order Fulfillment Analysis

Measured average fulfillment time for:

- Order Approval
- Shipment Processing
- Delivery Completion

This analysis helps identify operational bottlenecks.

### Payment Method Analysis

Analyzed sales distribution across:

- Credit Card
- Boleto
- Voucher
- Debit Card

The objective was to understand customer payment preferences.

---

# Page 3 – Product Performance & Sales Trends

### New Product Performance Analysis

Evaluated product categories based on newly launched products.

A product was considered new if introduced within six months of the latest available transaction date.

Key Metrics:

- New Product Sales
- New Product Orders
- Category-Level Performance

### Product Seasonality Analysis

Analyzed how product demand varies across months and years.

Applications:

- Inventory Management
- Demand Forecasting
- Marketing Planning
- Seasonal Promotions

---

# Page 4 – Business Performance & Revenue Insights

### Sales Price vs Order Quantity Analysis

Compared changes in:

- Sales Price
- Customer Order Quantity

to understand category-level performance and pricing impact.

### Category Revenue Trend Analysis

Compared revenue generated during:

- First 90 Days
- Most Recent 90 Days

This analysis identifies categories that are:

- Growing
- Declining
- Stable

### High-Rated Seller Performance Analysis

Identified sellers meeting two conditions:

- Average Review Score greater than 4.5
- Less than 10% of sales from customers located in their home state

This analysis helps identify untapped local market opportunities.

---

# 💡 Key Business Insights

### Customer Insights

- A significant number of customers became inactive after 12 months.
- Customer churn patterns varied by year.
- Customer satisfaction was strongly influenced by delivery performance.

### Product Insights

- A small number of categories generated a large percentage of total sales.
- Product categories displayed clear seasonality patterns.
- Certain newly launched products showed strong market adoption.

### Operational Insights

- Delivery time was the longest stage of fulfillment.
- Faster deliveries were associated with higher review scores.
- Order processing delays impacted customer experience.

### Payment Insights

- Credit Cards accounted for the majority of transaction value.
- Alternative payment methods represented a significantly smaller share of sales.

### Seller Insights

- Several highly-rated sellers had low local market penetration.
- Revenue growth varied substantially across product categories.

### Market Basket Insights

- Product combinations with strong lift values provided cross-selling opportunities.
- Frequently purchased-together categories can be used for recommendation engines and bundled promotions.

---

# 🛠 Technologies Used

## Data Storage

- SQL Server

## Data Processing

- Python
- Pandas
- PyODBC
- Unidecode

## Business Intelligence

- Power BI
- Power Query
- DAX

## Data Source

- Olist Brazilian E-Commerce Dataset
- Excel Files

## Version Control

- Git
- GitHub

---

# 📂 Project Structure

```text
OlistDashboard
│
├── Dashboard
│   └── OlistDataDashboard.pbix
│
├── DataCleaningUsingPython
│   ├── Python Scripts
│   └── Cleaned Data Files
│
├── Dataset
│
├── Screenshots
│
└── README.md
```

---

# 🚀 Business Impact

### Operational Benefits

- Improved visibility into order fulfillment processes.
- Identified inefficiencies affecting customer satisfaction.
- Enabled monitoring of customer churn.

### Revenue Benefits

- Highlighted high-performing product categories.
- Identified revenue growth and decline trends.
- Supported pricing and promotion decisions.

### Customer Benefits

- Improved understanding of customer behavior.
- Supported customer retention initiatives.
- Identified purchasing patterns for targeted marketing.

### Strategic Benefits

- Supported data-driven decision making.
- Revealed market basket opportunities.
- Identified underperforming but highly-rated sellers.
- Improved understanding of long-term category performance.

---

# 📸 Dashboard Pages

### Page 1 – Executive Business Overview

Executive KPIs, Customer Churn, Delivery Performance, Product Contribution, Promotion Impact.

### Page 2 – Customer Orders & Operations Analysis

Market Basket Analysis, Order Fulfillment Performance, Payment Behavior.

### Page 3 – Product Performance & Sales Trends

New Product Analysis, Product Seasonality, Sales Trends.

### Page 4 – Business Performance & Revenue Insights

Revenue Analysis, Price vs Quantity Analysis, Seller Performance.

---

# 👨‍💻 Author

**Ibrar Aman**

**Skills:** SQL Server, Python, Pandas, Power BI, Power Query, DAX, Excel, Data Analytics, Business Intelligence