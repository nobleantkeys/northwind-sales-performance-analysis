# 🍊 Northwind Traders — Sales Performance Analysis

## 📋 Overview
End-to-end data analysis project using the Northwind Traders database, a fictional food import/export company. The project covers the full analyst workflow — data auditing, cleaning, modelling, analysis, and visualisation.

## 🛠️ Tools
- **SQL Server** — data cleaning, modelling, and analysis
- **Power BI** — interactive dashboard and visualisation

## 📦 Dataset
The Northwind Traders database is a classic Microsoft sample database containing sales data for a fictional specialty foods company. Tables include Customers, Employees, Orders, Order Details, Products, Categories, Suppliers, and Shippers.

Source: [Microsoft SQL Server Samples](https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/northwind-pubs)

## 🗂️ Project Structure

### 🧹 1. Data Cleaning
- Replaced NULL regions and postal codes with 'N/A' using `COALESCE`
- Standardised date columns from DATETIME to DATE using `CAST`
- Encapsulated cleaning logic into reusable SQL views:
  - `CustomersClean`
  - `EmployeesClean`
  - `OrdersClean`
  - `SuppliersClean`

### 🔗 2. Data Modelling
Built a master analytical view `MasterOrders` joining six tables:
- `OrdersClean`
- `CustomersClean`
- `EmployeesClean`
- `Order Details`
- `Products`
- `Categories`

All analysis queries run against `MasterOrders` rather than raw tables.

| Question | Technique |
|---|---|
| Total revenue per customer | GROUP BY, SUM |
| Revenue per country | GROUP BY, SUM |
| Revenue lost to discounts | Conditional aggregation |
| Best selling products by quantity and revenue | GROUP BY, SUM |
| Employee revenue and order performance | GROUP BY, COUNT DISTINCT |
| Average products per order | CTE, AVG |
| Month over month revenue growth | CTE, LAG window function |

### 📈 3. Dashboard
Interactive Power BI dashboard featuring:
- **Line chart** — month over month revenue comparison
- **Filled map** — total revenue by country
- **Treemap** — best selling products by revenue
- **Clustered bar chart** — gross vs net revenue lost to discounts
- **Table** — employee performance by revenue, orders, and average order value
- **Bar chart** — top 10 customers by revenue

### 📊 4. Analysis
Key business questions answered using SQL:

<img width="336" height="246" alt="Screenshot 2026-05-19 104207" src="https://github.com/user-attachments/assets/c148ae8f-3382-4b0e-b1b7-5e1730aa7f87" />

## Month over Month Revenue Comparison (1996–1998)
Revenue grew sharply from approximately $0.2M in 1996 to a peak of $0.6M in 1997, a threefold increase year on year. This represents the strongest growth period in the dataset and suggests 1997 was a landmark year for the business, likely driven by expanded customer relationships and increased order volumes.
The previous month revenue line tracks closely beneath the current month line throughout the entire period, confirming that growth was steady and compounding rather than the result of isolated large orders. The consistent gap between the two lines indicates that each month was reliably outperforming the same period one month prior.
Revenue declined from the 1997 peak into 1998, dropping back toward $0.4M. However this decline should be interpreted with caution: the 1998 data is incomplete as the dataset cuts off mid-year, meaning the full year figure would likely be higher than what is shown.

<img width="300" height="248" alt="Screenshot 2026-05-19 104244" src="https://github.com/user-attachments/assets/ea1b0119-a283-4673-a678-250b3eb96827" />

## Top 10 Total Revenue per Customer
QUICK-Stop leads all customers by a considerable margin, generating approximately $0.11M in total revenue, noticeably ahead of second-placed Ernst Handel and third-placed Save-a-lot Markets, which are closely matched. These three accounts form a clear tier of top performers that are significantly ahead of the rest of the top 10.
From Rattlesnake Canyon Grocery downward, revenue drops sharply and the remaining seven customers are clustered closely together between approximately $0.04M and $0.06M, suggesting a relatively even spread among mid-tier accounts with no other standout performers.

<img width="402" height="323" alt="Screenshot 2026-05-19 104257" src="https://github.com/user-attachments/assets/da013c1c-335a-4a0d-8f14-9948184ce04c" />

## Total Revenue by Country

Revenue is heavily concentrated in Europe, with the largest and densest cluster of bubbles visible across the continent, particularly in Western Europe. The USA shows a notable presence in North America, while Brazil appears as the only meaningful market in South America. Africa and Asia show no activity whatsoever, representing completely untapped markets. The geographic concentration in Europe suggests the business has a strong regional focus but limited global diversification.

<img width="333" height="218" alt="Screenshot 2026-05-19 104314" src="https://github.com/user-attachments/assets/f63b8703-6d1f-4e0a-bc87-aa485b7ad0c2" />

## Best Selling Products by Revenue

Côte de Blaye dominates the treemap by a significant margin, its box dwarfing all other products, a reflection of its premium price point rather than necessarily its order volume. Raclette Courdavault, Thüringer Rostbratwurst, Gnocchi di nonna Alice, and Manjimup Dried Apples form a second tier of solid performers. The remainder of the treemap is fragmented into many small boxes, revealing a long tail of low revenue products that collectively underperform relative to the top handful.

<img width="296" height="215" alt="Screenshot 2026-05-19 104320" src="https://github.com/user-attachments/assets/7d0664b8-bdc4-494a-9288-20cd5233df64" />

## Employee Performance

Margaret Peacock is the standout performer across all three metrics : highest total revenue at $232,890, most orders processed at 156, and by implication the highest average order value. Janet Leverling and Nancy Davolio follow as strong second and third place performers. The bottom of the table tells a different story. Steven Buchanan (42 orders, $68,792) and Anne Dodsworth (43 orders, $77,308) are significantly behind their peers, with roughly a quarter of Margaret's order volume. The total across all employees of $1,265,793 across 830 orders confirms the business is generating healthy overall activity.

<img width="398" height="262" alt="Screenshot 2026-05-19 104328" src="https://github.com/user-attachments/assets/90760112-aef7-4e59-a207-9e676046d10f" />

## Revenue Lost to Discounts

QUICK-Stop shows the largest gap between gross and net revenue of any customer: the difference between the dark and pink bars is more pronounced here than anywhere else in the chart. Save-a-lot Markets and Ernst Handel follow a similar pattern. Notably these are the same three customers who top the revenue chart, meaning the business's biggest accounts are also its biggest discount recipients. For customers at this purchase volume, discounts are likely unnecessary to maintain the relationship and represent a direct and avoidable margin loss. Customers further down the list such as Hanari Carnes and Folk och fä HB show much smaller gaps, suggesting more disciplined discount management for mid-tier accounts.

## 💡 Key Findings

### 📅 Revenue Trend
Revenue grew sharply from 1996 into a peak in 1997, reaching approximately $0.6M, before declining into 1998. The previous month revenue line tracks closely with current month revenue, confirming that growth was sustained and consistent rather than driven by isolated spikes. Note that 1998 data is incomplete as the dataset cuts off mid-year, which accounts for the apparent decline.

### 🏆 Top Customers
QUICK-Stop is the highest revenue customer by a significant margin, followed by Ernst Handel and Save-a-lot Markets. The top three customers alone account for a disproportionate share of total revenue of $1,265,793 across 830 orders, highlighting a concentration risk where the business is heavily dependent on a small number of accounts.

### 🗺️ Revenue by Country
Revenue is heavily concentrated in Europe, with a dense cluster of high-value bubbles visible across the continent. North America and South America show smaller but meaningful activity. Several regions including Africa and parts of Asia show no presence, representing potential expansion opportunities.

### 🛍️ Best Selling Products
Côte de Blaye dominates the treemap by a significant margin, reflecting its high unit price relative to other products. Raclette Courdavault, Thüringer Rostbratwurst, and Gnocchi di nonna Alice follow as strong performers. The treemap reveals a long tail of lower revenue products that may warrant a portfolio review.

### 👥 Employee Performance
Margaret Peacock leads the team in both total revenue ($232,890) and total orders processed (156), making her the standout performer. Janet Leverling and Nancy Davolio follow closely behind. Steven Buchanan has the lowest order count (42) and revenue ($68,792), a gap that warrants further investigation into whether it reflects territory allocation, tenure, or capacity constraints.

### 💸 Revenue Lost to Discounts
QUICK-Stop and Save-a-lot Markets top the revenue lost to discounts chart — the same customers who generate the most revenue are also receiving the largest discounts. The gap between gross and net revenue is most pronounced for these accounts, suggesting discounts may not be necessary to retain customers who are already buying at high volumes.

## 💼 Recommendations

### 🎯 Customer Strategy
- **Protect top accounts** — QUICK-Stop, Ernst Handel, and Save-a-lot Markets drive a disproportionate share of total revenue. These relationships should be prioritised for retention and account management.
- **Review discount policy** — top revenue customers are also the biggest recipients of discounts. Given their purchase volumes, discounting may be unnecessary and is directly reducing margins.

### 🛍️ Product Strategy
- **Protect Côte de Blaye** — as the dominant revenue product, any supply or pricing disruption would have an outsized impact on total revenue. It warrants close monitoring.
- **Review the long tail** — the treemap reveals many low revenue products. Consolidating the product range could improve operational efficiency and margin.

### 👥 Employee Strategy
- **Recognise Margaret Peacock** — highest orders and highest revenue. Her approach should be used as a benchmark for the wider team.
- **Investigate Steven Buchanan and Anne Dodsworth** — significantly lower orders and revenue than peers. Understanding whether this is a territory, training, or capacity issue could unlock additional revenue.

### 🌍 Geographic Strategy
- **Double down on Europe** — the clear revenue concentration in Europe suggests strong existing demand. Further investment in these markets is likely to yield returns.
- **Explore untapped regions** — Africa and parts of Asia show no activity. A targeted expansion strategy could open new revenue streams.

### 📅 Trend Strategy
- **Understand the 1997 peak** — revenue peaked mid-1997. Identifying the drivers — whether seasonal, product-led, or customer-led — could help replicate that performance.
- **Monitor 1998 trajectory** — even accounting for incomplete data, the downward trend into 1998 warrants attention and a deeper follow-up analysis.

## ✅ Skills Demonstrated
- Data auditing and quality assessment
- NULL handling and date standardisation
- Multi-table JOIN modelling
- Aggregations and GROUP BY
- Subqueries and CTEs
- Window functions (LAG)
- Dashboard design and visual selection
