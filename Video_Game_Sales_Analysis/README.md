# Video Game Sales Analysis

An end-to-end data analytics portfolio project using **MySQL, Excel, and Tableau** to examine historical video-game sales across genres, consoles, publishers, regions, critic-score bands, release years, and titles.

## Project objective

The project answers a practical stakeholder question:

> What historical sales patterns can help a video-game publisher or distributor benchmark genres, platforms, regional markets, publishers, and major titles?

The source contains **64,016 cleaned records** and **39,585 unique title names**. The principal performance analysis covers release-dated records from **1971 through 2018**, because sales-data coverage declines materially after 2018.

## Portfolio links

- **Tableau Public dashboard:** [View the interactive dashboard](https://public.tableau.com/views/VideoGamesSalesAnalysis_17848429164650/VideoGamesSalesDashboard?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)
- **Case study:** [Video-Game-Sales-Case-Study.md](Video-Game-Sales-Case-Study.md)
- **MySQL analysis:** [Video Games sales-clean exploratory analysis.sql](Video%20Games%20sales-clean%20exploratory%20analysis.sql)
- **Excel analysis:** [Video-Game-Sales-Excel-Analysis-Portfolio.xlsx](outputs/video_game_sales_excel/Video-Game-Sales-Excel-Analysis-Portfolio.xlsx)

## Dashboard

The Tableau dashboard includes:

- Reported global sales, average sales, eligible-record, and coverage KPIs
- Genre, console, and title rankings
- Annual reported-sales and coverage trends
- Regional sales comparison
- Regional genre rankings
- Filters for genre, console, publisher, and release year

## Key findings

- Sports led the full genre analysis with **1,187.51M** units in reported sales, followed by Action with **1,125.89M** and Shooter with **995.50M**.
- PS2 led the through-2018 console ranking with **1,025.36M** units in reported sales.
- In the 2,222 complete regional records, North America represented **44.72%** of sales, followed by PAL markets at **34.52%**.
- Shooter ranked first in North America, PAL markets, and Other regions, while Role-Playing ranked first in Japan.
- Records scoring 9.0–10.0 averaged **2.068M** units, compared with **0.314M** for records below 6.0.
- Activision led the publisher ranking through 2018 with **722.32M** units in reported sales.
- Grand Theft Auto V led combined title sales with **64.29M** units.

## Data workflow

### 1. MySQL

- Imported the CSV into a raw staging table.
- Initially stored uncertain fields as text to avoid import truncation.
- Inspected dates, numeric text, blanks, null markers, and category values.
- Converted verified fields to appropriate data types in a clean table.
- Checked missingness, duplicates, inconsistent labels, outliers, and suspicious dates.
- Built 11 documented analytical queries using CTEs, conditional aggregation, `UNION ALL`, and window functions.

### 2. Excel

- Used Power Query and PivotTables to reproduce selected SQL outputs.
- Built formula-driven coverage checks and a genre explorer.
- Applied data validation and conditional formatting.
- Verified the Top 10 title ranking independently.

### 3. Tableau

- Built an interactive dashboard for rankings, trends, regional comparisons, critic-score groups, and data coverage.
- Kept reported-sales coverage visible so users can judge the strength of each comparison.

## Repository structure

```text
.
├── README.md
├── Video-Game-Sales-Case-Study.md
├── Video-Game-Sales-Portfolio-Analysis.sql
└── outputs/
    └── video_game_sales_excel/
        └── Video-Game-Sales-Excel-Analysis-Portfolio.xlsx
```

## Data notes

- Sales values are measured in millions of units.
- Missing sales values are treated as unreported rather than zero.
- Only **29.56%** of all records contain reported total sales.
- Only **10.43%** contain a critic score.
- Regional comparisons use the **2,222 records** with values reported for all four regions.
- Publisher labels are analyzed as recorded and are not consolidated.
- Findings represent the available dataset, not the complete video-game market.

## SQL topics demonstrated

- Data profiling and eligibility checks
- Conditional aggregation
- Common table expressions
- Complete-case analysis
- Long-format reshaping with `UNION ALL`
- Ranking with `DENSE_RANK()`
- Partitioned window functions
- Multi-level aggregation
- Null-aware calculations

## Business recommendations

- Use Sports, Action, and Shooter as historical demand benchmarks.
- Tailor genre positioning by region rather than applying one global mix.
- Use critic reception as one performance indicator, not as proof of causation.
- Benchmark planned titles against leading franchises and platform-specific releases.
- Use newer, more complete data before making forward-looking investment decisions.

## Limitations

The dataset contains substantial missing sales and critic-score data. Coverage varies by field and period, and release-date anomalies were investigated separately. The analysis is descriptive and historical; it does not establish causation or predict future sales.
