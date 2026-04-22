USE credit_risk;

#question 1: Portfolio Overview
-- What is the default rate and total loan amount across the entire portfolio?

SELECT 
	loan_status,
    COUNT(loan_ID) AS total_customers,
    ROUND(COUNT(loan_ID) * 100.0 / SUM(COUNT(loan_ID)) OVER(), 2) AS percentage_of_portfolio,
    ROUND(SUM(loan_amnt),2) AS total_loan_amt
FROM fact_loan_details
GROUP BY loan_status;

-- ================================================    
#question 2:Age Segmentation
							# (segmentation customer's age by calculating percentile 25 and 75 age using histogram)
--  How does the default rate vary across different age groups?
 
CREATE VIEW v_age_segmented AS
SELECT 
        client_ID,
        CASE 
            WHEN person_age <= 23 THEN '1. Gen Z (<=23)'
            WHEN person_age <= 30 THEN '2. Young Adult (24-30)'
            WHEN person_age <= 50 THEN '3. Middle Age (31-50)'
            ELSE '4. Senior (>50)'
        END AS age_group
FROM dim_customer;

#question 3:  which segment dominates the portfolio in terms of customer volume?	

SELECT 
    v.age_group,
    COUNT(f.client_ID) AS total_customers,
    ROUND(COUNT(f.client_ID) * 100.0 / SUM(COUNT(f.client_ID)) OVER(), 2) AS percentage,
    SUM(f.loan_status) AS Total_default_customers,
    ROUND(AVG(f.loan_status) * 100.0, 2) AS default_rate,
    ROUND(SUM(f.loan_status) * 100.0 / SUM(COUNT(f.loan_ID)) OVER(), 2) AS contribution_to_total_risk,
    ROUND(AVG(f.debt_to_income_ratio) * 100.0, 2) AS avg_dti_ratio,
    ROUND(AVG(f.loan_amnt), 2) AS avg_loan_amount
FROM v_age_segmented v
JOIN fact_loan_details f ON v.client_ID = f.client_ID
GROUP BY v.age_group;
-- ================================================   

#question 4: Income & DTI Analysis
								# (segmentation customer's income by calculating percentile 25 and 75 age using histogram)
CREATE VIEW v_income_segmented AS
SELECT 
    client_ID,
    person_income,
    CASE 
        WHEN person_income < 39366 THEN 'Low Income' -- Percentile 25 = 39.366
        WHEN person_income <= 80000 THEN 'Medium Income'  -- Percentile 75 = 80.000
        ELSE 'High Income'
    END AS income_segment
FROM dim_customer;
SELECT 
    i.income_segment,
    COUNT(f.client_ID) AS total_customers,
    ROUND(COUNT(f.client_ID) * 100.0 / SUM(COUNT(f.client_ID)) OVER(), 2) AS percentage,
    SUM(f.loan_status) AS Total_default_customers,
    ROUND(AVG(f.loan_status) * 100.0, 2) AS default_rate,
    ROUND(SUM(f.loan_status) * 100.0 / SUM(COUNT(f.loan_ID)) OVER(), 2) AS contribution_to_total_risk,
    ROUND(AVG(f.debt_to_income_ratio) * 100.0, 2) AS avg_dti_ratio,
    ROUND(AVG(f.loan_amnt), 2) AS avg_loan_amount 
FROM v_income_segmented i
JOIN fact_loan_details f ON f.client_ID = i.client_ID
GROUP BY i.income_segment;

#question 5:Compare the default rates of bad loan applications and average Debt-to-Income (DTI) ratios across different income segments?
SELECT 
    v_i.income_segment, 
    COUNT(f.client_ID) AS total_customers,
    ROUND(SUM(f.loan_amnt),2) AS total_amt,
    ROUND(AVG(f.debt_to_income_ratio) * 100, 2) AS avg_dti_ratio,
    ROUND(AVG(f.loan_int), 2) AS avg_loan_int
FROM fact_loan_details f
JOIN v_income_segmented v_i ON f.client_ID = v_i.client_ID
WHERE f.loan_status = 1 
GROUP BY v_i.income_segment;

-- ================================================   
#question 6: Loan Grade Performance
-- What is the default rate and average interest rate for each loan grade? 
--  Which grade represents the highest risk?
SELECT 
    f.loan_grade,
    COUNT(f.loan_ID) AS total_loans,
    SUM(f.loan_status) AS total_default_cases,
    ROUND(AVG(f.loan_status) * 100.0, 2) AS default_rate,
    ROUND(AVG(loan_int), 2) AS avg_int_rate,
    ROUND(SUM(f.loan_status) * 100.0 / SUM(COUNT(f.loan_ID)) OVER(), 2) AS contribution_to_total_risk
FROM dim_customer c
JOIN fact_loan_details f ON c.client_ID = f.client_ID
GROUP BY f.loan_grade
ORDER BY f.loan_grade;
-- ================================================   
#question 7: Loan Purpose & Risk overlap
-- Which loan purposes carry the highest default risk?
SELECT 
    f.loan_intent,
    SUM(f.loan_amnt) AS total_loan_,
    COUNT(f.loan_ID) AS total_loans,
    SUM(f.loan_status) AS total_default_cases,
    ROUND(AVG(f.loan_status) * 100.0, 2) AS default_rate,
     ROUND(AVG(loan_int), 2) AS avg_int_rate,
    ROUND(SUM(f.loan_status) * 100.0 / SUM(COUNT(f.loan_ID)) OVER(), 2) AS contribution_to_total_risk
FROM dim_customer c
JOIN fact_loan_details f ON c.client_ID = f.client_ID
GROUP BY f.loan_intent
ORDER BY f.loan_intent;

#question 8: Provide a detailed cross-analysis between loan grades and loan purpose
SELECT 
    f.loan_grade,
    f.loan_intent,
    COUNT(f.loan_ID) AS total_loans,
    SUM(f.loan_status) AS total_default_cases,
    ROUND(SUM(f.loan_status) * 100.0/COUNT(f.loan_status), 2) AS default_rate,
    ROUND(AVG(f.debt_to_income_ratio), 2) AS avg_dti_ratio,
    ROUND(AVG(loan_int), 2) AS avg_int_rate
FROM fact_loan_details f
GROUP BY f.loan_grade, f.loan_intent
ORDER BY f.loan_grade ASC, default_rate DESC;
-- ================================================
#question 9-10: Home Ownership Impact
-- Analyze the correlation between home ownership status (Rent, Mortgage, Own) 

SELECT 
    c.person_home_ownership,
    COUNT(f.loan_ID) AS total_loans,
    SUM(f.loan_status) AS total_default_cases,
    ROUND(AVG(f.loan_status) * 100.0, 2) AS default_rate,
    ROUND(AVG(f.debt_to_income_ratio), 2) AS avg_dti_ratio,
    ROUND(SUM(f.loan_status) * 100.0 / SUM(COUNT(f.loan_ID)) OVER(), 2) AS contribution_to_total_risk,
    ROUND(AVG(c.person_income), 0) AS avg_income
FROM dim_customer c
JOIN fact_loan_details f ON c.client_ID = f.client_ID
GROUP BY c.person_home_ownership
ORDER BY default_rate DESC;

#question 10: Analyze default probability across different loan grades.
SELECT 
    loan_grade,
    COUNT(*) AS total_loans,
    ROUND(AVG(CASE WHEN person_home_ownership = 'RENT' THEN loan_status END) * 100, 2) AS rent_default_rate,
    ROUND(AVG(CASE WHEN person_home_ownership = 'MORTGAGE' THEN loan_status END) * 100, 2) AS mortgage_default_rate,
    ROUND(AVG(CASE WHEN person_home_ownership = 'OWN' THEN loan_status END) * 100, 2) AS own_default_rate
FROM fact_loan_details f
JOIN dim_customer c ON f.client_ID = c.client_ID
GROUP BY loan_grade
ORDER BY loan_grade;
-- ================================================

#question 11: Employment Tenure
-- How does employment length impact default rates across different income segments?
SELECT 
	i.income_segment,
    c.person_emp_length,
    COUNT(c.client_ID) as num_customers,
    ROUND(AVG(f.loan_status) * 100, 2) as default_rate,
    ROUND(AVG(f.loan_int), 2) as avg_interest
FROM dim_customer c
JOIN fact_loan_details f ON c.client_ID = f.client_ID
JOIN v_income_segmented i ON f.client_ID = i.client_ID
GROUP BY c.person_emp_length, i.income_segment
ORDER BY c.person_emp_length ;
-- ================================================

#Question12: Q12: Historical Credit Behavior
 -- Compare current loan performance and financial leverage (DTI) between customers with and without a prior history of default.
SELECT 
    d.cb_person_default_on_file, -- Biến từ bảng Dim
    COUNT(c.client_ID) AS total_customers,
    ROUND(AVG(f.loan_status) * 100, 2) AS default_rate, -- Tỷ lệ nợ xấu hiện tại
    ROUND(AVG(f.debt_to_income_ratio), 2) AS avg_dti, -- Đòn bẩy tài chính hiện tại
    ROUND(AVG(f.loan_int), 2) AS avg_int_rate
FROM fact_loan_details f
JOIN dim_credit_history d ON f.loan_ID = d.loan_ID
JOIN dim_customer c ON f.client_ID = c.client_ID 
GROUP BY d.cb_person_default_on_file;
-- ================================================
#question13: Geographic Risk
-- Which geographic locations (Countries) exhibit the highest concentration of default cases?
SELECT 
    l.country, 
    COUNT(f.loan_ID) AS total_loans,
    SUM(f.loan_status) AS default_cases,
    ROUND(AVG(f.loan_status) * 100, 2) AS city_default_rate
FROM fact_loan_details f
JOIN dim_location l ON f.location_id = l.location_id
GROUP BY l.country;

