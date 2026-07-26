# Video Game Sales Analysis (1971–2018)

## Project summary

This project examines historical video-game sales to identify performance patterns across genres, consoles, publishers, regions, critic-score bands, release years, and individual titles. The analysis was designed for a publisher or distributor seeking evidence to support portfolio planning, regional positioning, and title benchmarking.

The source contains 64,016 cleaned records and 39,585 unique title names. Because sales reporting becomes materially less complete after 2018, the main performance views focus on release-dated records from 1971 through 2018.

## Business questions

The project addresses the following questions:

- How complete is the available sales data?
- Which genres, consoles, publishers, and titles generated the strongest reported sales?
- How did reported sales and reporting coverage change over time?
- How does the sales mix differ across regions?
- Which genres lead within each region?
- How does sales performance vary across critic-score bands?

## Tools

- **MySQL:** import staging, type verification, cleaning, validation, aggregation, CTEs, conditional logic, and window functions
- **Microsoft Excel:** Power Query, PivotTables, formulas, data validation, conditional formatting, and independent result checks
- **Tableau:** interactive dashboard, KPIs, rankings, trends, filters, and coverage context

## Data preparation and validation

The CSV was first imported into a raw MySQL table with uncertain fields stored as text. Values were inspected before being converted to appropriate numeric and date types in a clean table.

The validation process examined missing values, blanks, duplicate candidates, inconsistent categories, suspicious release dates, and reporting coverage. Missing sales values were retained as `NULL` because they represent unreported data rather than confirmed zero sales.

Coverage varied substantially across the dataset:

| Field | Records reported | Coverage |
|---|---:|---:|
| Release date | 56,965 | 88.99% |
| Total sales | 18,922 | 29.56% |
| Critic score | 6,678 | 10.43% |
| North America sales | 12,637 | 19.74% |
| Japan sales | 6,726 | 10.51% |
| PAL sales | 12,824 | 20.03% |
| Other-region sales | 15,128 | 23.63% |

These checks shaped the analysis. Global-sales queries use records with reported total sales, while regional comparisons use only the 2,222 records containing reported values for all four regions.

## Analysis approach

Eleven MySQL queries were used to:

1. Measure overall data coverage.
2. Count records eligible for each analysis.
3. Compare genre performance.
4. examine annual sales and reporting coverage.
5. Rank historical console performance through 2018.
6. Compare regional sales using complete cases.
7. Rank genres separately within each region.
8. Compare sales across critic-score bands.
9. Rank publishers through 2018.
10. Identify the highest-selling title-console records within each genre.
11. Rank title names after combining their console releases.

Excel independently reproduced selected genre and title results. Tableau then presented the principal findings through an interactive dashboard with genre, console, publisher, and release-year filters.

## Key findings

### Genre performance

Sports generated the highest reported global sales in the full genre analysis at 1,187.51 million units, followed by Action at 1,125.89 million and Shooter at 995.50 million. Together, these three genres represented 50.09% of reported sales in that analysis.

Reporting coverage differed by genre, so sales totals were evaluated alongside record counts and coverage rather than treated as complete market totals.

### Console performance

Among release-dated records through 2018, the leading consoles by reported global sales were:

| Rank | Console | Reported sales |
|---:|---|---:|
| 1 | PS2 | 1,025.36M |
| 2 | Xbox 360 | 859.41M |
| 3 | PS3 | 838.66M |
| 4 | PlayStation | 546.21M |
| 5 | PS4 | 538.47M |

PS2 led the historical console ranking, while Xbox 360 and PS3 produced similar reported totals.

### Regional sales mix

Within the 2,222 complete regional records, North America accounted for 44.72% of reported regional sales. PAL markets represented 34.52%, Other regions 11.82%, and Japan 8.94%.

Genre leadership also differed by region:

- Shooter ranked first in North America, PAL markets, and Other regions.
- Role-Playing ranked first in Japan.
- Action and Sports appeared among the top three genres in all four regional rankings.

These findings describe only the complete-case subset and should not be generalized to records with missing regional values.

### Critic scores and sales

Records in higher critic-score bands had higher average reported sales:

| Critic-score band | Eligible records | Average sales per record |
|---|---:|---:|
| 9.0–10.0 | 282 | 2.068M |
| 8.0–8.9 | 1,051 | 1.103M |
| 7.0–7.9 | 1,191 | 0.576M |
| 6.0–6.9 | 853 | 0.444M |
| Below 6.0 | 749 | 0.314M |

The highest score band averaged about 6.6 times the reported sales of the below-6.0 band. This is an association, not evidence that critic scores cause higher sales.

### Publishers and titles

Activision led the publisher ranking through 2018 with 722.32 million units in reported sales, followed by Electronic Arts at 643.73 million and EA Sports at 485.60 million. Publisher labels were analyzed exactly as recorded, so related labels such as Electronic Arts and EA Sports were not consolidated.

After combining matching title names across consoles, the leading titles were:

| Rank | Title | Reported sales |
|---:|---|---:|
| 1 | Grand Theft Auto V | 64.29M |
| 2 | Call of Duty: Black Ops | 30.99M |
| 3 | Call of Duty: Modern Warfare 3 | 30.71M |
| 4 | Call of Duty: Black Ops II | 29.59M |
| 5 | Call of Duty: Ghosts | 28.80M |

Grand Theft Auto V recorded more than twice the reported sales of the second-ranked title. Call of Duty titles occupied seven of the top ten positions.

## Recommendations

For historical portfolio or catalog planning:

- Use Sports, Action, and Shooter as high-demand benchmark genres, while reviewing coverage before comparing categories.
- Adapt regional genre positioning: Shooter is the strongest complete-case genre in North America, PAL markets, and Other regions, while Role-Playing leads in Japan.
- Treat critic reception as a useful performance signal, but combine it with audience, franchise, platform, marketing, and release-timing evidence.
- Benchmark new releases against leading franchises and console-specific title records rather than relying only on broad genre totals.
- Validate any forward-looking decision with newer and more complete market data because this project is historical and reporting is incomplete.

## Limitations

- Sales values are reported in millions of units and do not form a complete record of the global market.
- `NULL` sales values mean unreported, not zero.
- The main performance scope ends in 2018 because coverage declines materially afterward.
- Regional comparisons use only complete cases.
- Critic-score coverage is limited to 10.43% of all records.
- Publisher names remain as recorded and may split related organizations across multiple labels.
- Results describe associations and historical patterns; they do not establish causation or forecast future performance.

## Outcome

The project converts a large, incomplete source file into a documented analytical workflow spanning MySQL, Excel, and Tableau. It demonstrates data-quality judgment, transparent eligibility rules, reproducible SQL, cross-tool validation, and clear communication of limitations.
