# Retail Sales & Profitability Analysis (SQL + Python)

Analysis of 9,994 orders from a US retail superstore (2014–2017) to find out **why the business
generates strong revenue but leaves profit on the table** — and where to fix it.

**Tools:** MySQL · Python (Pandas, Matplotlib, Seaborn) · Jupyter Notebook

---

## Business Question

Sales revenue looked healthy across the board, but a quick check showed profit wasn't following
the same pattern. This project digs into *where* profit is being lost and *why*, using SQL for
data auditing and aggregation, and Python for deeper exploratory analysis and visualization.

## Dataset

- **9,994 orders**, 21 original columns (Sample Superstore dataset: orders, customers, products,
  sales, profit, discount, region, ship mode, dates)
- No missing values in key fields, but `Order Date` / `Ship Date` were stored as text and
  `Postal Code` was stored as a number — both fixed during cleaning
- Engineered features: profit margin (%), days-to-ship, revenue per unit, discount tier, quarter

## Repo Structure

```
retail-sales-profitability-analysis/
├── README.md
├── sql/
│   └── superstore_analysis.sql        # data cleaning + aggregation queries
├── notebook/
│   └── superstore_analysis.ipynb      # cleaning, EDA, visualizations
└── images/
    └── (charts referenced below)
```

## Data Cleaning

- Checked row counts and confirmed no missing values in `Sales`, `Profit`, `Category`
- Checked for duplicate `Order ID`s
- Converted `Order Date` / `Ship Date` from text to proper `DATE` type in MySQL (`STR_TO_DATE`)
  and in Pandas (`pd.to_datetime`)
- Cast `Postal Code` to string to preserve leading zeros
- Added derived columns: `Year`, `Month`, `Quarter`, `Days to Ship`, `Profit Margin (%)`,
  `Revenue per Unit`, `Discount Tier`

## Key Insights

**1. Discounting past 20% is where profit turns negative.**
Orders with no discount carry a ~34% average profit margin. That margin holds up reasonably well
up to a 20% discount, then flips negative — falling to **-114% average margin** on orders
discounted 50% or more. Discounting is the single biggest lever behind the loss-making orders in
this dataset.

| Discount Tier | Avg. Profit Margin | Orders |
|---|---|---|
| No Discount | 34.0% | 4,798 |
| 1–10% | 15.6% | 94 |
| 11–20% | 17.5% | 3,709 |
| 21–30% | -11.5% | 227 |
| 31–50% | -29.6% | 310 |
| 50%+ | -113.9% | 856 |

![Discount vs Profit](images/discount_vs_profit_scatter.png)

**2. 1,871 orders (~19% of all orders) lost money.**
Nearly 1 in 5 orders in the dataset were sold at a loss — concentrated in the heavy-discount tiers
above.

**3. Furniture drives volume, not profit.**
Furniture and Office Supplies post similar profit levels, but Furniture needs far more sales
volume to get there. Several Furniture and Office Supplies sub-categories (e.g. Tables, Bookcases,
Supplies) are net loss-makers even before accounting for shipping costs.

![Profit by Sub-Category](images/subcategory_profit.png)

**4. Central region: high sales, negative margin.**
The Central region generated **$501K in sales at a -10.4% average margin** — the only region
losing money overall. The West region, by contrast, generated **$725K in sales at a 21.9%
margin**, the strongest of the four regions. Region-level discount policy is the likely driver.

| Region | Sales | Profit | Avg. Margin |
|---|---|---|---|
| Central | $501,240 | $39,706 | -10.4% |
| South | $391,722 | $46,749 | 16.4% |
| East | $678,781 | $91,523 | 16.7% |
| West | $725,458 | $108,418 | 21.9% |

**5. Consumer segment is the most valuable, not Corporate.**
The Consumer segment brings in the most total revenue and profit, but Home Office customers are
the most profitable *per customer* ($407 profit/customer vs. $328 for Consumer) — worth a look for
targeted retention or account-growth strategies.

**6. Standard Class shipping takes over twice as long as Second Class.**
Median ship time is 5 days for Standard Class vs. 3 days for Second Class and 2 days for First
Class — a potential lever for improving customer experience without necessarily needing a full
logistics overhaul.

![Shipping Time by Ship Mode](images/shipping_time_boxplot.png)

**7. Sales are seasonal, peaking in Q4.**
Revenue climbs steadily through the year with a consistent November–December peak across all four
years in the dataset — useful for inventory and staffing planning.

![Monthly Sales Seasonality](images/monthly_seasonality.png)

**8. Sales and profit grew year over year, but not in lockstep.**
Total sales and profit both trended upward from 2014 to 2017, but profit growth lagged sales
growth in some years — consistent with the discounting problem identified above.

![Yearly Sales & Profit Trend](images/yearly_sales_profit_trend.png)

**9. Discount is the strongest negative driver of profit.**
A correlation check across Sales, Quantity, Discount, Profit, Days-to-Ship, and Profit Margin
confirms Discount has the clearest negative relationship with Profit Margin of any variable
tested.

![Correlation Matrix](images/correlation_heatmap.png)

## Recommendations

1. **Cap discretionary discounts around 20%**, or require approval above that threshold — this is
   the point where the data shows margin turning negative.
2. **Audit Central region's discount practices** specifically — the region is out of line with the
   other three despite comparable sales volume.
3. **Review pricing/cost structure for loss-making Furniture and Office Supplies sub-categories**
   rather than continuing to discount them further.
4. **Investigate Standard Class shipping** as a customer-experience lever, given the gap versus
   faster tiers.

## How to Reproduce

1. Load `sample - superstore` data into MySQL and run `sql/superstore_analysis.sql` for the
   cleaning and aggregation queries.
2. Open `notebook/superstore_analysis.ipynb` in Jupyter to reproduce the cleaning, EDA, and all
   charts above.

---
*Ademola Odusanya — [GitHub](https://github.com/Skinnyboss100) · [LinkedIn](https://linkedin.com/in/ademola-nicholas-odusanya)*
