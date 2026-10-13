## Databricks SQL analysis
 
A small exploratory analysis of the same retail sales dataset, repeated in Databricks (Free Edition) using SQL in a notebook. The data is 15 orders from 1-8 September 2026 across 8 columns, so this is a practice exercise in SQL and the Databricks workflow rather than a scale exercise.
 
**What I did**
 
- Uploaded `retail_sales.csv` as a table and queried it with Spark SQL in a notebook.
- Wrote nine queries covering KPIs, group-by aggregations, a conditional-aggregation pivot, and window functions (`RANK`, `ROW_NUMBER`, running totals with `SUM() OVER`) plus CTEs.
- Queries are in [`retail_sales_queries.sql`](retail_sales_queries.sql).
**Findings**
 
| Metric | Result |
|---|---|
| Total revenue | £1,924.27 across 15 orders (37 units), average order value £128.28 |
| Top category | Monitors: £909.95 (47.3% of revenue) from just 5 units; Accessories sold 26 units but made £774.38 (40.2%) |
| Top product | Monitor 27in (£459.98), followed by Monitor 24in (£449.97) and Keyboard (£315.00) |
| Customer type | Business orders averaged £194.99 against £69.92 for Retail, so 7 Business orders brought in about 71% of revenue |
| Region | London led with £743.95, mostly Business orders (£609.97); Yorkshire was lowest at £69.98 with no Business orders |
| Trend | Revenue peaked on 4 Sep (£489.97) and the cumulative total reached £1,924.27 by 8 Sep |
 
**Takeaway**: revenue is driven by a small number of high-value Business orders for monitors, while Retail customers buy more units of cheaper accessories.
 
**Limitations**: with 15 rows over eight days, these are descriptive observations only and shouldn't be read as trends.
