# Credit Quality & Customer Risk Profiling Report

## 📌 Executive Overview
This project provides an end-to-end data analysis and predictive modeling solution for **Nova Bank**, focusing on across global markets including the USA, UK, and Canada. The primary mission is to **optimize lending decisions**: expanding credit access for reliable borrowers while accurately filtering out high-risk profiles to prevent financial loss.

### 🎯 Strategic Focus
* **Risk Identification:** Identifying specific borrower profiles and behaviors that lead to default.
* **Capital Preservation:** Mitigating financial losses by highlighting high-risk segments (Current NPL: ~$75M).
* **Policy Balancing:** Refining lending thresholds and interest rate policies to ensure long-term profitability.

---
## 🏗 Project Architecture & Workflow

### Data Dictionaries

<img width="500" height="500" alt="image" src="https://github.com/user-attachments/assets/cee08d17-f2d5-4467-8c3f-e8f010d3e7b1" />

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

<img width="250" height="420" alt="image" src="https://github.com/user-attachments/assets/b57e5457-2bb0-471f-bda7-83a30f9bca93" />
<img width="300" height="200" alt="image" src="https://github.com/user-attachments/assets/c55cac51-a2b7-456d-882e-10cb5015b7ca" />
<img width="570" height="370" alt="Screenshot 2026-04-23 at 11 39 29" src="https://github.com/user-attachments/assets/30ffaf02-13d8-4081-8272-26e4cb339a13" /><img width="570" height="450" alt="Screenshot 2026-04-23 at 11 51 14" src="https://github.com/user-attachments/assets/68dc9c25-1486-4f56-a1f0-f8e1d698c81d" />



### b) Data Architecture & Modeling (MySQL)
To ensure high-performance analytics, the cleaned dataset was structured into a **Star Schema**:
* **Fact Table:** `fact_loan_details` (Loan amount, interest, status).
* **Dimension Tables:** `dim_customer`, `dim_location`, `dim_credit_history`.
* **EER Modeling:** Established One-to-Many (1:N) relationships to ensure referential integrity.
* **Dynamic Segmentation:** Engineered custom SQL Views to categorize borrowers by statistical percentiles.
<img width="500" height="400" alt="EER Modeling" src="https://github.com/user-attachments/assets/b28c0830-6f28-401c-9e26-d0273d60307c" />

  
### c)	Data Visualization (Power BI)
Connected Power BI directly to the MySQL Star Schema to translate data into actionable insights:
* **Interactive Dashboards:**  Developed dynamic reports to track the $306M portfolio, visualizing risk hotspots across USA, UK, and Canada.
* **Analytics:**  Leveraged DAX (Data Analysis Expressions), including a 21.5% Default Rate and 24.6% NPL Ratio based on the cleaned 31,679 records.

<img width="2150" height="1197" alt="image" src="https://github.com/user-attachments/assets/ca451403-bd0d-4ced-b854-ed6488a74b36" />


### d) Predictive Modeling & Evaluation (XGBoost)
The **XGBoost model** delivered exceptional predictive performance:
* **ROC-AUC:** **0.93**
* **Recall:** **0.75** (Proactively identified 75% of actual defaults at the pre-disbursement stage).

  
<img width="350" height="180" alt="image" src="https://github.com/user-attachments/assets/b7e73fd7-778b-418f-926e-65a64c3ea03e" />
<img width="600" height="400" alt="Screenshot 2026-04-23 at 13 14 38" src="https://github.com/user-attachments/assets/1168f35e-b49b-4d78-9605-bee146d36ae4" />
<img width="600" height="396" alt="Screenshot 2026-04-23 at 12 26 09" src="https://github.com/user-attachments/assets/924b8ccd-941d-4f41-8cc8-5704d1738624" />
<img width="600" height="393" alt="image" src="https://github.com/user-attachments/assets/f1a1dd4e-b805-4af8-8ea5-a115b857297c" />

---
## 💡 Recommedation
### 1.Underwriting Policy
AI-Integrated Assessment: Deploy XGBoost models for real-time risk scoring; automatically flag High-Risk Grades (D-G) and risky purposes (Medical/Debt Consolidation).

Strict Control Thresholds: Implement a hard interest rate cap (<15%) for borrowers with DTI >50% to avoid the 78.8% NPL "trap".

Enhanced Screening: Mandate high-liquidity collateral for applicants with prior delinquencies.

### 2.Targeting Strategy
Safe Zone Expansion: Aggressively prioritize Grade A/B applicants and stable loan purposes (Venture & Education).

Newbie Policy: Apply lower initial limits for young renters/new employees to monitor repayment behavior before increasing exposure.

### 3.Early Warning System (EWS)
Automated Red-Flag Triggers: Alert system for the high-risk "Default Formula": Gen Z + Low Income + Renting + DTI > 70% (Mandatory manual review).

Pricing Optimization: Keep interest rates below the 15% "Breaking Point" to maintain borrower solvency and long-term retention.

# 📂 Project Structure

```
Credit-Risk-Portfolio/
│
├── 📁 Dataset/
│   ├── credit_risk_dataset_raw.csv                    # Original 32,581 records, 29 columns
│   └── credit_risk_dataset_cleaned.csv                # Cleaned 31,679 records , 29 columns
│
├── 📁 Scripts/
│   ├── Python EDA_Cleaning_Modeling.ipynb            # Data cleaning & exploratory analys
    └── screenshots/                                  #Screenshot importance visualizations
│
├── 📁 SQL/
│   ├── EER Modeling.png                              # Star Schema definition
│   └── SQL Query questions.sql                       # Analytical queries & KPI calculations
│
├── 📁 Dashboard/
    ├── credit_risk_dashboard.pbix                     # Power BI interactive dashboard
│   └── screenshots/                                   # Dashboard visualizations sreenshots
│
├── 📁 Report/
│   └── summary.pdf                                    # Executive summary report
│
├── 📄 README.md                                       # Project documentation
└── 📄 LICENSE                                         # MIT License
```

