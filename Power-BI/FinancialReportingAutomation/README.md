# Financial Reporting Automation & Analytics

## 📌 Project Overview

This project was developed to automate a daily financial reporting process and deliver actionable business insights through Power BI.

The organization received approximately **25 Excel files every day** from multiple survey teams across different locations. The manual process of downloading, consolidating, cleaning, and analyzing these files was time-consuming, error-prone, and resulted in additional operational costs.

To solve this problem, a Python automation workflow was developed to automatically retrieve files from Google Drive, consolidate data into a single dataset, and prepare reporting-ready data. The processed data was then analyzed using Power BI to generate insights around customer behavior, credit utilization, loan products, and customer segmentation.

---

# 🎯 Business Problem

### Existing Challenges

- Daily receipt of approximately 25 data files.
- Manual file downloading process.
- Manual data consolidation.
- Time-consuming data cleaning.
- High probability of reporting errors.
- Additional monthly labor cost of approximately $12,000.
- Strict reporting deadline of 8 PM daily.
- Increased workload affecting other projects.

### Business Objectives

- Reduce reporting time.
- Reduce operational costs.
- Improve data quality.
- Minimize manual interventions.
- Automate repetitive tasks.
- Improve reporting efficiency.
- Generate meaningful business insights.

---

# 🏗 Solution Architecture

```text
Google Drive
       │
       ▼
Python Automation
       │
       ▼
File Download
       │
       ▼
Data Consolidation
       │
       ▼
Data Cleaning
       │
       ▼
Processed Dataset
       │
       ▼
Power BI Dashboard
       │
       ▼
Business Insights
```

---

# 🐍 Python Automation

Python was used to automate the complete data ingestion process.

### Key Functions

- Connect to Google Drive using Service Account Authentication.
- Read files from a Google Drive folder.
- Download Google Sheets, CSV, and Excel files.
- Convert files into Pandas DataFrames.
- Consolidate multiple files into a single dataset.
- Prepare reporting-ready data for Power BI.

### Libraries Used

- pandas
- requests
- google-api-python-client
- google-auth
- openpyxl

### Benefits

- Eliminated manual file downloading.
- Reduced data preparation time.
- Improved reporting consistency.
- Reduced processing errors.

---

# 📊 Dashboard Overview

## Page 1 – Financial Overview Dashboard

### KPI Metrics

- Average Annual Income
- Average Monthly Balance
- Average Delay Days in Payments
- Average Credit Change %

### Analysis Performed

#### Credit Limit Change by Age

Analyzed how customer age impacts average credit limit changes.

#### Customer Age Distribution

Visualized the demographic distribution of customers across different age groups.

#### Credit Mix by Age Group

Analyzed customer credit score profiles across age segments:

- Teen
- Young Adult
- Adult
- Middle Aged
- Older Adult

#### Payment Behavior by Credit Mix

Examined payment behavior trends across credit mix categories to support risk assessment and lending strategies.

---

## Page 2 – Customer Segmentation & Loan Analysis

### Potential Customer Identification

Potential customers were identified using:

```text
Average Credit Enquiries > 7.5
```

Identified customer segments:

- Teen
- Young Adult
- Adult
- Middle Aged

### Average Credit Enquiries by Age Group

Identified customer groups showing higher interest in credit products and loan opportunities.

### Loan Type Distribution

Analyzed popularity of different loan products:

- Personal Loan
- Payday Loan
- Student Loan
- Mortgage Loan
- Home Equity Loan
- Credit Builder Loan
- Debt Consolidation Loan

### Average Loans and Credit Cards by Age

Compared loan ownership and credit card ownership patterns across customer age groups.

### Customer Lifetime Value (LTV) Analysis

LTV was calculated using the following formula:

```text
LTV =
(0.30 × Average Annual Income)
-
(0.15 × Average Delay Days)
+
(0.40 × Credit Score)
+
(0.075 × Average Amount Invested)
+
(0.075 × Average Monthly Balance)
```

### Promotion Strategy

| LTV Score Range | Promotion |
|----------------|------------|
| > 80,000 | 30% Off Online Purchases + Home Loan at 4% Interest |
| 60,000 – 80,000 | 15% Off Online Purchases + $10,000 Gift Hamper |
| 50,000 – 60,000 | Any Loan at 5% Interest |

---

# 💡 Key Business Insights

### Customer Segmentation

- Teen, Young Adult, Adult, and Middle Aged groups generated higher credit enquiry activity.
- These groups were identified as potential targets for future loan campaigns.

### Credit Analysis

- Age influences credit behavior and credit limit changes.
- Payment behavior differs across credit mix categories.

### Loan Analysis

- Loan popularity varies by product category.
- Customer borrowing behavior changes across age groups.

### Marketing Strategy

- LTV analysis enables personalized promotions.
- High-value customers can receive premium financial products and offers.

---

# 🛠 Tools & Technologies

### Data Collection & Processing

- Python
- Pandas
- Requests
- Google Drive API

### Data Transformation

- Power Query

### Data Analysis

- DAX

### Data Visualization

- Power BI

### Version Control

- Git
- GitHub

---

# 📂 Project Structure

```text
FinancialReportingAutomation
│
├── Dashboard
│   └── FinancialReportingAutomation.pbix
│
├── Dashboard Screenshots
│   ├── Page1.png
│   └── Page2.png
│
├── Dataset
│
├── DataCleaningUsingPython
│   └── FinancialReportingAutomation.py
│
├── ProblemStatement.pdf
│
└── README.md
```

---

# 🚀 Business Impact

### Operational Benefits

- Reduced manual effort.
- Reduced reporting time.
- Improved data quality.
- Reduced human errors.
- Automated repetitive reporting tasks.

### Business Benefits

- Improved customer targeting.
- Better loan marketing decisions.
- Enhanced customer segmentation.
- Data-driven promotional strategy.
- Faster delivery of business insights.

---

# 📸 Dashboard Preview

### Page 1 – Financial Overview Dashboard

(Add Screenshot Here)

### Page 2 – Customer Segmentation & Loan Analysis

(Add Screenshot Here)

---

# 👨‍💻 Author

**Ibrar Aman**

**Skills:** Python, Power BI, Power Query, DAX, Excel, Data Analytics, Business Intelligence

