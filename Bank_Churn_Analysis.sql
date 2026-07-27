USE austine_portfolio;

-- Query 1: What is the bank’s overall customer churn rate?
SELECT COUNT(customer_id) AS total_customers,
SUM(exited) AS churned_customers,
COUNT(customer_id) - SUM(exited) AS retained_customers,
ROUND(100.0 * SUM(exited) / COUNT(customer_id),2) AS churn_rate_pct
FROM bank_churn_clean;

-- Query 2A: What does the bank’s overall customer base look like?
SELECT COUNT(customer_id) AS total_customers,
ROUND(AVG(credit_score), 2) AS avg_credit_score,
ROUND(AVG(age), 2) AS avg_age,
ROUND(AVG(tenure), 2) AS avg_tenure_years,
ROUND(AVG(balance), 2) AS avg_balance,
ROUND(AVG(num_of_products), 2) AS avg_num_of_products,
ROUND(AVG(estimated_salary), 2) AS avg_estimated_salary,
ROUND(100.0 * AVG(has_cr_card), 2) AS credit_card_holder_pct,
ROUND(100.0 * AVG(is_active_member), 2) AS active_member_pct
FROM bank_churn_clean;

-- Query 2B.1: Customer composition by geography
SELECT geography,
COUNT(*) AS customer_count,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bank_churn_clean),2) AS customer_pct
FROM bank_churn_clean
GROUP BY geography
ORDER BY customer_count DESC;

-- Query 2B.2: Customer composition by gender
SELECT gender,
COUNT(*) AS customer_count,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bank_churn_clean),2) AS customer_pct
FROM bank_churn_clean
GROUP BY gender
ORDER BY customer_count DESC;

-- Query 3A: Which numeric and account characteristics differ between churners and non-churners
SELECT
    CASE
        WHEN exited = 1 THEN 'Churned'
        ELSE 'Retained'
    END AS customer_status,
COUNT(*) AS customer_count,
ROUND(AVG(credit_score), 2) AS avg_credit_score,
ROUND(AVG(age), 2) AS avg_age,
ROUND(AVG(tenure), 2) AS avg_tenure_years,
ROUND(AVG(balance), 2) AS avg_balance,
ROUND(AVG(num_of_products), 2) AS avg_num_of_products,
ROUND(AVG(estimated_salary), 2) AS avg_estimated_salary,
ROUND(AVG(has_cr_card) * 100, 2) AS credit_card_holder_pct,
ROUND(AVG(is_active_member) * 100, 2) AS active_member_pct
FROM bank_churn_clean
GROUP BY exited
ORDER BY exited DESC;

-- Query 3B.1: Churn by geography
SELECT geography,
COUNT(*) AS total_customers,
SUM(exited) AS churned_customers,
COUNT(*) - SUM(exited) AS retained_customers,
ROUND(SUM(exited) * 100.0 / COUNT(*),2) AS churn_rate_pct
FROM bank_churn_clean
GROUP BY geography
ORDER BY churn_rate_pct DESC;

-- Query 3B.2: Churn by gender
SELECT gender,
COUNT(*) AS total_customers,
SUM(exited) AS churned_customers,
COUNT(*) - SUM(exited) AS retained_customers,
ROUND(SUM(exited) * 100.0 / COUNT(*),2) AS churn_rate_pct
FROM bank_churn_clean
GROUP BY gender
ORDER BY churn_rate_pct DESC;

-- Query 3C.1: Churn by number of products
SELECT num_of_products,
COUNT(*) AS total_customers,
SUM(exited) AS churned_customers,
COUNT(*) - SUM(exited) AS retained_customers,
ROUND(SUM(exited) * 100.0 / COUNT(*),2) AS churn_rate_pct
FROM bank_churn_clean
GROUP BY num_of_products
ORDER BY churn_rate_pct DESC;

-- Query 3C.2: Churn by activity status
SELECT
    CASE
        WHEN is_active_member = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS activity_status,
COUNT(*) AS total_customers,
SUM(exited) AS churned_customers,
COUNT(*) - SUM(exited) AS retained_customers,
ROUND(SUM(exited) * 100.0 / COUNT(*),2) AS churn_rate_pct
FROM bank_churn_clean
GROUP BY is_active_member
ORDER BY churn_rate_pct DESC;

-- Query 3C.3: Churn by credit-card ownership
SELECT
    CASE
        WHEN has_cr_card = 1 THEN 'Credit card holder'
        ELSE 'No credit card'
    END AS credit_card_status,
COUNT(*) AS total_customers,
SUM(exited) AS churned_customers,
COUNT(*) - SUM(exited) AS retained_customers,
ROUND(SUM(exited) * 100.0 / COUNT(*),2) AS churn_rate_pct
FROM bank_churn_clean
GROUP BY has_cr_card
ORDER BY churn_rate_pct DESC;

-- Query 3D.1: Churn by age group
SELECT
    CASE
        WHEN age < 30 THEN '18–29'
        WHEN age < 40 THEN '30–39'
        WHEN age < 50 THEN '40–49'
        WHEN age < 60 THEN '50–59'
        ELSE '60+'
    END AS age_group,
COUNT(*) AS total_customers,
SUM(exited) AS churned_customers,
COUNT(*) - SUM(exited) AS retained_customers,
ROUND(SUM(exited) * 100.0 / COUNT(*),2) AS churn_rate_pct
FROM bank_churn_clean
GROUP BY age_group
ORDER BY churn_rate_pct DESC;

-- Query 3D.2: Churn by balance band
SELECT
    CASE
        WHEN balance = 0 THEN '€0'
        WHEN balance <= 50000 THEN '€0.01–€50,000'
        WHEN balance <= 100000 THEN '€50,000.01–€100,000'
        WHEN balance <= 150000 THEN '€100,000.01–€150,000'
        ELSE 'Above €150,000'
    END AS balance_band,
COUNT(*) AS total_customers,
SUM(exited) AS churned_customers,
COUNT(*) - SUM(exited) AS retained_customers,

ROUND(SUM(exited) * 100.0 / COUNT(*),2) AS churn_rate_pct
FROM bank_churn_clean
GROUP BY balance_band
ORDER BY churn_rate_pct DESC;

-- Query 3E.1: Churn by credit-score band
SELECT
    CASE
        WHEN credit_score < 450 THEN '350–449'
        WHEN credit_score < 550 THEN '450–549'
        WHEN credit_score < 650 THEN '550–649'
        WHEN credit_score < 750 THEN '650–749'
        ELSE '750–850'
    END AS credit_score_band,
    COUNT(*) AS total_customers,
    SUM(exited) AS churned_customers,
    COUNT(*) - SUM(exited) AS retained_customers,
    ROUND(SUM(exited) * 100.0 / COUNT(*),2) AS churn_rate_pct
FROM bank_churn_clean
GROUP BY credit_score_band
ORDER BY churn_rate_pct DESC;

-- Query 3E.2: Churn by tenure group
SELECT
    CASE
        WHEN tenure <= 2 THEN '0–2 years'
        WHEN tenure <= 5 THEN '3–5 years'
        WHEN tenure <= 8 THEN '6–8 years'
        ELSE '9–10 years'
    END AS tenure_group,
COUNT(*) AS total_customers,
SUM(exited) AS churned_customers,
COUNT(*) - SUM(exited) AS retained_customers,
ROUND(SUM(exited) * 100.0 / COUNT(*),2) AS churn_rate_pct
FROM bank_churn_clean
GROUP BY tenure_group
ORDER BY churn_rate_pct DESC;

-- Query 4: Customer profile and account behavior by geography
SELECT geography,
COUNT(*) AS total_customers,
ROUND(AVG(age), 2) AS avg_age,
ROUND(AVG(credit_score), 2) AS avg_credit_score,
ROUND(AVG(tenure), 2) AS avg_tenure_years,
ROUND(AVG(balance), 2) AS avg_balance_eur,
ROUND(AVG(num_of_products), 2) AS avg_num_of_products,
ROUND(AVG(has_cr_card) * 100, 2) AS credit_card_holder_pct,
ROUND(AVG(is_active_member) * 100, 2) AS active_member_pct,
SUM(exited) AS churned_customers,ROUND(SUM(exited) * 100.0 / COUNT(*),2) AS churn_rate_pct
FROM bank_churn_clean
GROUP BY geography
ORDER BY churn_rate_pct DESC;

-- Query 5: Churn by geography, gender, and activity status
SELECT geography,
gender,
CASE
	WHEN is_active_member = 1 THEN 'Active'
	ELSE 'Inactive'
END AS activity_status,
COUNT(*) AS total_customers,
SUM(exited) AS churned_customers,
COUNT(*) - SUM(exited) AS retained_customers,
ROUND(SUM(exited) * 100.0 / COUNT(*),2) AS churn_rate_pct
FROM bank_churn_clean
GROUP BY geography, gender, is_active_member
ORDER BY churn_rate_pct DESC, churned_customers DESC;