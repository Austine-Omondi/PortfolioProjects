# Bank Customer Churn Analysis

An end-to-end data analytics project using **MySQL** and **Tableau Public** to identify customer groups with elevated churn risk and support more focused retention analysis.

## Project objective

The project answers a practical stakeholder question:

> Which customer groups show the greatest churn risk, and where should the bank prioritise further investigation and retention testing?

The analysis covers **10,000 customer records** and evaluates churn across country, age, number of products, activity status, gender, and combined customer segments.

## Portfolio links

- **Tableau Public dashboard:** [View the interactive dashboard](https://public.tableau.com/app/profile/austine.omondi/viz/BankCustomerChurnAnalysis_17851856496080/BankCustomerChurnDashboard#1)
- **Case study:** [Read the detailed case study](CASE_STUDY.md)

## Dashboard

The Tableau dashboard includes:

- Total customers, churned customers, retained customers, and churn-rate KPIs
- Country, age-group, and product-count comparisons
- An active-versus-inactive dumbbell chart
- A segment scatter plot comparing churn rate with churned-customer count
- Dropdown filters and click-to-filter interactions

## Key findings

- **2,037 of 10,000 customers churned**, producing an overall churn rate of **20.37%**.
- **Germany** had the highest country-level churn rate at **32.44%**.
- Customers aged **50–59** had the highest age-group churn rate at **56.04%**.
- Inactive customers churned at **26.85%**, compared with **14.27%** for active customers.
- Customers with **three or four products** had very high churn rates, but these groups contained only **266** and **60** customers respectively.
- **Germany · Female · Inactive** had the highest churn rate among the 12 combined segments at **44.64%**.

## Data workflow

### 1. MySQL

- Imported the CSV into a raw staging table.
- Stored uncertain fields as text during the initial import.
- Inspected identifiers, categories, binary fields, numeric formats, and ranges before type conversion.
- Converted validated fields to appropriate data types.
- Checked missing values, duplicate customer IDs, whitespace, invalid categories, and illogical ranges.
- Analysed churn using both rate and customer count.

### 2. Tableau

- Built an interactive dashboard with KPIs, filters, and click-to-filter actions.
- Used bar charts, a dumbbell chart, and a scatter plot to compare churn across customer groups.
- Displayed churn rate alongside churned-customer count to balance risk concentration with business impact.

## Data notes

- The dataset contains one row per customer.
- `Exited = 1` identifies a churned customer; `Exited = 0` identifies a retained customer.
- The analysis is descriptive and identifies associations rather than causes.
- Extreme churn rates among customers with three or four products should be interpreted cautiously because those groups are small.

## SQL topics demonstrated

- Raw-to-clean table workflow
- Data profiling and validation
- Type conversion
- Conditional aggregation
- Calculated churn metrics
- Multi-dimensional grouping
- Segment comparison
- Null-safe rate calculations

## Business recommendations

- Prioritise inactive customers for retention testing.
- Investigate the customer experience in Germany, especially among inactive customers.
- Examine churn drivers among customers aged 40–59.
- Review the experience of customers holding three or four products, while accounting for the small group sizes.
- Use churn rate and churned-customer count together when prioritising segments.

## Limitations

The dataset is a customer snapshot and does not show behaviour over time or explain why customers left. It does not include transaction history, service interactions, customer feedback, or campaign outcomes. The findings should guide further investigation and controlled retention tests rather than be treated as causal conclusions.

## Author

**Austine Omondi**
