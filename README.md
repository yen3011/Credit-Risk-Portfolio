# Credit Quality & Customer Risk Profiling Report

## 📌 Executive Overview
This project provides an end-to-end data analysis and predictive modeling solution for **Nova Bank**, focusing on a **$306M loan portfolio** across global markets including the USA, UK, and Canada. The primary mission is to **optimize lending decisions**: expanding credit access for reliable borrowers while accurately filtering out high-risk profiles to prevent financial loss.

### 🎯 Strategic Focus
* **Risk Identification:** Identifying specific borrower profiles and behaviors that lead to default.
* **Capital Preservation:** Mitigating financial losses by highlighting high-risk segments (Current NPL: ~$75M).
* **Policy Balancing:** Refining lending thresholds and interest rate policies to ensure long-term profitability.

---

## 🏗 Project Architecture & Workflow
The project follows a structured data pipeline to ensure high-performance analytics and reliable predictions:
1. **Data Cleaning & Pre-processing (Python):** Refined raw data into a high-quality dataset for modeling.
2. **Data Architecture (MySQL):** Structured data into a **Star Schema** for efficient analytical querying.
3. **Data Visualization (Power BI):** Developed dynamic dashboards to track KPIs and risk hotspots.
4. **Predictive Modeling (XGBoost):** Trained an AI model to handle class imbalance and forecast defaults.

---

## 🛠 Technical Implementation Detail

### a) Data Cleaning & Pre-processing (Python)
The project began with a raw dataset comprising **32,581 records and 29 columns**. Rigorous cleaning and exploratory analysis were prioritized to ensure data integrity:
* **Missing Values:** Removed records with missing employment length and imputed missing interest rates using median values grouped by Grade and Purpose.
* **Outliers:** Filtered unrealistic data points (Age > 100 and cases where employment length was inconsistent with age).
* **EDA & Visualization:** Utilized Boxplots and Scatter plots to analyze distributions, skewness, and feature correlations.
* **Final Cleaned Dataset:** Resulted in **31,679 records and 29 features**.

### b) Data Architecture & Modeling (MySQL)
To ensure high-performance analytics, the cleaned dataset was structured into a **Star Schema**:
* **Fact Table:** `fact_loan_details` (Loan amount, interest, status).
* **Dimension Tables:** `dim_customer`, `dim_location`, `dim_credit_history`.
* **EER Modeling:** Established One-to-Many (1:N) relationships to ensure referential integrity.
* **Dynamic Segmentation:** Engineered custom SQL Views to categorize borrowers by statistical percentiles.

### c) Predictive Modeling & Evaluation (XGBoost)
The **XGBoost model** delivered exceptional predictive performance:
* **ROC-AUC:** **0.93**
* **Recall:** **0.75** (Proactively identified 75% of actual defaults at the pre-disbursement stage).

---

## 📂 Project Structure
```bash
├── dataset/
│   └── credit risk dataset raw      # Detailed description of all features
    └── credit risk dataset cleaned 
├── sql/
│   ├── schema screenshot.sql           # SQL screeshot Star Schema
│   └── sql questions.sql                # SQL questions analytic
├── notebooks/
│   ├── eda_and_cleaning.ipynb     # Python scripts for data cleaning and modeling ML 
│   
├── dashboard/
│   ├── credit_risk_dashboard.pbix # Main Power BI project file
│   └── screenshots/               # Visuals of the interactive reports
├── reports/
│   └── summary.pdf               # Final PDF report for stakeholders
└── README.md                      # Project documentation
