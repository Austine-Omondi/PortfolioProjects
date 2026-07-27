# Bank Customer Churn Analysis — Case Study

## Executive summary

This project analyses **10,000 bank customers** to determine where churn is most concentrated. MySQL was used to import, validate, clean, and analyse the data, while Tableau Public was used to create an interactive dashboard.

The bank’s overall churn rate was **20.37%**. The clearest concentrations of churn appeared among customers in Germany, customers aged 40–59, inactive customers, and customers with three or four products. A combined segment analysis identified **Germany · Female · Inactive** as the highest-rate segment and **France · Female · Inactive** as the segment contributing the most churned customers among the 12 country-gender-activity combinations.

## Business problem

Customer churn reduces the value of the bank’s existing customer base and increases pressure to acquire replacement customers. A useful retention analysis must identify not only groups with high churn rates, but also groups that contribute meaningful numbers of churned customers.

The stakeholder question was:

> Which customer groups show the greatest churn risk, and where should the bank prioritise further investigation and retention testing?

## Analytical questions

1. What is the overall customer churn rate?
2. Which countries have the highest churn rates?
3. Which age groups have the highest churn rates?
4. How does churn vary by number of products?
5. How does churn differ between active and inactive customers?
6. Which combined customer segments have both high churn rates and high churned-customer counts?

## Dataset

The dataset contains **10,000 records**, with one row per customer. The analysed fields include:

- Customer ID
- Country
- Gender
- Age
- Tenure
- Credit score
- Account balance
- Number of products
- Credit-card ownership
- Activity status
- Estimated salary
- Churn status

A customer was classified as churned when `Exited = 1`.

## Tools

- **MySQL:** data import, type verification, validation, cleaning, and analysis
- **Tableau Public:** interactive dashboard development and visual analysis

## Methodology

### 1. Import and type verification

The CSV was first imported into a raw MySQL staging table. Uncertain fields were initially stored as text to reduce the risk of failed imports or silent truncation.

Before converting data types, the fields were inspected for:

- Non-numeric customer IDs
- Unexpected identifier lengths
- Blank surnames
- Invalid categorical or binary values
- Numeric values stored as text
- Leading and trailing whitespace
- Values outside plausible numeric ranges

Validated fields were then converted to suitable numeric and text types in a clean table.

### 2. Data validation and cleaning

The clean dataset was checked for:

- Missing values
- Duplicate customer IDs
- Invalid `0` and `1` indicators
- Inconsistent category names
- Whitespace in text fields
- Numeric ranges inconsistent with the data dictionary

The verified ranges included ages from **18 to 92**, credit scores from **350 to 850**, tenure from **0 to 10**, and product counts from **1 to 4**.

### 3. SQL analysis

The analysis calculated:

- Total, churned, and retained customers
- Churn rate
- Churn metrics by country, gender, age group, number of products, and activity status
- Churn metrics for all 12 country-gender-activity combinations

Churn rate was evaluated as shown below:

Churn rate = (churned customers / Total customers) *  100.0 


Churn rate measures the concentration of churn within a group. Churned-customer count measures the group’s contribution to total churn.

### 4. Tableau dashboard

The dashboard contains:

- Four headline KPIs
- Country and age-group bar charts
- A product-count comparison
- An active-versus-inactive dumbbell chart
- A segment scatter plot comparing churn rate with churned-customer count
- Country, gender, age-group, and activity-status filters
- Click-to-filter actions

[View the interactive dashboard](https://public.tableau.com/app/profile/austine.omondi/viz/BankCustomerChurnAnalysis_17851856496080/BankCustomerChurnDashboard#1)

## Findings

### Overall churn

| Total customers | Churned customers | Retained customers | Churn rate |
|---:|---:|---:|---:|
| 10,000 | 2,037 | 7,963 | 20.37% |

Approximately one in five customers in the dataset had churned.

### Churn by country

| Country | Total customers | Churned customers | Churn rate |
|---|---:|---:|---:|
| Germany | 2,509 | 814 | 32.44% |
| Spain | 2,477 | 413 | 16.67% |
| France | 5,014 | 810 | 16.15% |

Germany had the highest churn rate, at approximately twice the rates in Spain and France. Germany and France contributed similar numbers of churned customers, even though France had roughly twice as many customers.

### Churn by gender

| Gender | Total customers | Churned customers | Churn rate |
|---|---:|---:|---:|
| Female | 4,543 | 1,139 | 25.07% |
| Male | 5,457 | 898 | 16.46% |

Female customers recorded both a higher churn rate and a higher churned-customer count than male customers. This is an observed association and does not establish that gender caused the difference.

### Churn by age group

| Age group | Total customers | Churned customers | Churn rate |
|---|---:|---:|---:|
| 50–59 | 869 | 487 | 56.04% |
| 40–49 | 2,618 | 806 | 30.79% |
| 60+ | 526 | 147 | 27.95% |
| 30–39 | 4,346 | 473 | 10.88% |
| 18–29 | 1,641 | 124 | 7.56% |

Customers aged 50–59 had the highest churn rate. Customers aged 40–49 contributed the largest number of churned customers, demonstrating why rate and volume should be considered together.

### Churn by number of products

| Products | Total customers | Churned customers | Churn rate |
|---:|---:|---:|---:|
| 4 | 60 | 60 | 100.00% |
| 3 | 266 | 220 | 82.71% |
| 1 | 5,084 | 1,409 | 27.71% |
| 2 | 4,590 | 348 | 7.58% |

Customers with three or four products recorded extremely high churn rates. However, these groups contained only **266** and **60** customers respectively, so the results should be investigated rather than generalised. Customers with two products had the lowest churn rate.

### Churn by activity status

| Activity status | Total customers | Churned customers | Churn rate |
|---|---:|---:|---:|
| Inactive | 4,849 | 1,302 | 26.85% |
| Active | 5,151 | 735 | 14.27% |

Inactive customers churned at a rate **12.58 percentage points** higher than active customers. Inactivity was therefore an important retention signal in this dataset.

### Priority combined segments

The combined analysis compared all 12 country-gender-activity segments. The dashboard highlighted three segments that combined above-average churn rates with substantial churned-customer counts:

| Customer segment | Total customers | Churned customers | Churn rate |
|---|---:|---:|---:|
| Germany · Female · Inactive | 634 | 283 | 44.64% |
| Germany · Male · Inactive | 627 | 235 | 37.48% |
| France · Female · Inactive | 1,099 | 288 | 26.21% |

**Germany · Female · Inactive** had the highest churn rate among the 12 segments. **France · Female · Inactive** contributed the most churned customers, with 288.

## Recommendations

### 1. Prioritise inactive customers for retention testing

Inactive customers had both a higher churn rate and more churned customers than active customers. The bank could test targeted re-engagement actions and measure whether they reduce churn.

### 2. Investigate the customer experience in Germany

Germany had the highest country-level churn rate, and two German inactive groups appeared among the three highlighted segments. Further analysis should examine whether product mix, service experience, pricing, or other unobserved factors differ in this market.

### 3. Examine churn among customers aged 40–59

Customers aged 50–59 had the highest rate, while customers aged 40–49 contributed the most churned customers. These groups should be analysed further before selecting an intervention.

### 4. Review customers with three or four products

The extreme churn rates warrant investigation, but the small group sizes mean the bank should avoid broad conclusions until the pattern is validated with additional data.

### 5. Prioritise using both rate and volume

High-rate groups are not always the groups contributing the most churned customers. Using both measures produces a more balanced retention priority.

## Limitations

- The analysis identifies associations, not causes.
- The dataset is a single customer snapshot and does not show behaviour leading up to churn.
- The three- and four-product groups contain relatively few customers.
- No transaction history, product details, service interactions, complaints, customer feedback, or campaign results were available.
- The dataset does not provide a time period or confirm whether it represents the bank’s full customer population.
- Any retention intervention would need to be tested and measured before broader implementation.

## Conclusion

Churn was unevenly distributed across the customer base. Germany, customers aged 40–59, inactive customers, and customers with three or four products showed the strongest concentrations of risk. Combined-segment analysis further identified inactive German customers as high-rate groups, while inactive female customers in France contributed the largest churn volume among the 12 segments.

These findings provide evidence-based priorities for deeper investigation. They do not explain why customers churned, so the next step would be to combine this analysis with behavioural and customer-experience data and evaluate retention actions through controlled testing.
