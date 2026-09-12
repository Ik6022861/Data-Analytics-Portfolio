# FinSight Automation System

## Overview

FinSight Automation System is an end-to-end data automation and reporting solution built using Google Apps Script, Google Drive, Google Sheets, and Microsoft Excel.

The system automates the consolidation of multiple Excel files into a centralized master dataset and transforms the consolidated data into an interactive economic dashboard for analytical reporting and decision-making.

---

## Project Objectives

- Automate Excel file ingestion
- Consolidate data into a centralized repository
- Eliminate manual data collection processes
- Generate actionable economic insights
- Create an executive-level dashboard for analysis

---

## Project Workflow

```text
Excel Files
      ↓
01_Incoming_Files (Google Drive)
      ↓
Google Apps Script Automation
      ↓
MasterFile (Google Sheet)
      ↓
Data Connection to Excel
      ↓
Interactive Dashboard
      ↓
Business Insights
```

---

## Google Drive Structure

```text
Field_Operations
│
├── 01_Incoming_Files
│
├── 02_Processed_Archives
│
└── MasterFile
```

### Process

1. Excel files are uploaded to the Incoming Files folder.
2. Google Apps Script automatically processes the files.
3. Data is consolidated into the MasterFile.
4. Processed files are moved to the Archive folder.
5. The master dataset is connected to Excel for reporting and analysis.

---

## Dashboard Features

### Key Performance Indicators (KPIs)

- Average Inflation (2025)
- Average Investment (2025)
- Gross National Saving (2025)
- Total Countries Covered (2025)

### Visualizations

- World Indicator Analysis
- Sweet Spot Score by Countries
- Misery Index by Years
- GDP (PPP) Distribution by Top 10 Countries
- Top 10 Growing Countries
- Worst 10 Countries by Net Lending/Borrowing

---

## Technologies Used

### Data Automation

- Google Apps Script
- Google Drive
- Google Sheets

### Data Analysis

- Microsoft Excel
- Pivot Tables
- Pivot Charts
- Data Modeling

### Dashboard Design

- KPI Cards
- Interactive Charts
- Geographic Visualization
- Executive Dashboard Design

---

## Folder Structure

```text
FinSight-Automation-System
│
├── AppsScript
│   ├── Code.gs
│   └── appsscript.json
│
├── Dashboard
│   └── FinSight_Dashboard.xlsx
│
├── Screenshots
│   ├── Drive_Workflow.png
│   ├── AppsScript_Code.png
│   └── Dashboard_Final.png
│
├── Documentation
│   └── ProblemStatement.docx
│
└── README.md
```

---

## Configuration

Before executing the script, replace the placeholder values with your own IDs:

```javascript
const SOURCE_FOLDER_ID = "YOUR_SOURCE_FOLDER_ID";
const ARCHIVE_FOLDER_ID = "YOUR_ARCHIVE_FOLDER_ID";
const MASTER_SHEET_ID = "YOUR_MASTER_SHEET_ID";
```

---

## Key Achievements

- Automated Excel file consolidation process
- Reduced manual data preparation effort
- Centralized economic data management
- Built a professional analytics dashboard
- Created an end-to-end reporting workflow

---

## Author

**Ibrar Aman**

**Project:** FinSight Automation System

**Description:** Automated Economic Data Integration and Analytics Dashboard