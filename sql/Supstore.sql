SELECT * FROM superstore.`sample - superstore`;

#TO FIND THE MISSING ROWS 
SELECT
COUNT(*) AS TotalRows
FROM superstore.`sample - superstore` ;

#TO CHECK THE NUMBER OF MISSING VALUES FROM SELECTED COLUMNS
SELECT
COUNT(*)-COUNT(Sales) AS MissingSales,
COUNT(*)-COUNT(Profit) AS MissingProfit,
COUNT(*)-COUNT(Category) AS MissingCategory
FROM superstore.`sample - superstore` ;

#TO CHECK FOR DUPLICATE ORDERS/ MULTIPLE ORDERS FROM ORDER ID
SELECT
`Order ID`,
COUNT(*)
FROM superstore.`sample - superstore`
GROUP BY `Order ID`
HAVING COUNT(*)>1;

#TO CHECK FOR TOTAL SALES 
SELECT
ROUND(SUM(Sales),2) AS TotalSales
FROM superstore.`sample - superstore`;

#TO CHECK FOR TOTAL PROFIT
SELECT
ROUND(SUM(Profit),2) AS TotalProfit
FROM superstore.`sample - superstore` ;

# TO CHECK AVERAGE ORDER VALUE 
SELECT
ROUND(AVG(Sales),2) AS AverageOrderValue
FROM superstore.`sample - superstore`;

#TO CHECK THE SALES BY REGION
SELECT
Region,
ROUND(SUM(Sales),2) AS Revenue
FROM superstore.`sample - superstore`
GROUP BY Region
ORDER BY Revenue DESC;

# TO CHECK PROFIT BY REGION
SELECT
Region,
ROUND(SUM(Profit),2) AS Profit
FROM superstore.`sample - superstore`
GROUP BY Region
ORDER BY Profit DESC;

# SALES PER STATE
SELECT
State,
ROUND(SUM(Sales),2) AS Revenue
FROM superstore.`sample - superstore`
GROUP BY State
ORDER BY Revenue DESC;

# TO FIND THE TOP 10 CUSTOMERS 
SELECT
`Customer Name`,
ROUND(SUM(Sales),2) AS Revenue
FROM superstore.`sample - superstore`
GROUP BY `Customer Name`
ORDER BY Revenue DESC
LIMIT 10;


#TO  CHECK FOR THE MOST PROFITABLE CUSTOMERS 
SELECT
`Customer Name`,
ROUND(SUM(Profit),2) AS Profit
FROM superstore.`sample - superstore`
GROUP BY `Customer Name`
ORDER BY Profit DESC
LIMIT 10;

# TO SEE THE CATEGORY WITH THE MOST SLAES
SELECT
Category,
ROUND(SUM(Sales),2) AS Revenue
FROM superstore.`sample - superstore`
GROUP BY Category
ORDER BY Revenue DESC;

# TO CHECK FOR THE CATEGORIES THE PROFITS
SELECT
Category,
ROUND(SUM(Profit),2) AS Profit
FROM superstore.`sample - superstore`
GROUP BY Category;

# TO CHECK SUB CATEGORY SALES
SELECT
`Sub-Category`,
ROUND(SUM(Sales),2) AS Revenue
FROM superstore.`sample - superstore`
GROUP BY `Sub-Category`
ORDER BY Revenue DESC;

# TO CHECK THE MOST PROFITABLE PRODUCTS 
SELECT
`Product Name`,
ROUND(SUM(Profit),2) AS Profit
FROM superstore.`sample - superstore`
GROUP BY `Product Name`
ORDER BY Profit DESC
LIMIT 10;

#TO CHECK LOSS MAKING PRODUCTS 
SELECT
`Product Name`,
ROUND(SUM(Profit),2) AS Profit
FROM superstore.`sample - superstore`
GROUP BY `Product Name`
HAVING Profit<0
ORDER BY Profit;

#SEGMENT ANALYSIS
SELECT
Segment,
COUNT(*) Orders,
ROUND(SUM(Sales),2) Revenue,
ROUND(SUM(Profit),2) Profit
FROM superstore.`sample - superstore`
GROUP BY Segment;

#AVERAGE DISCOUNT 
SELECT
Category,
ROUND(AVG(Discount),2) AverageDiscount
FROM  superstore.`sample - superstore`
GROUP BY Category;

#TO SEE THE EFFECT OF DISCOUNT
SELECT
Discount,
ROUND(AVG(Profit),2) AvgProfit
FROM superstore.`sample - superstore`
GROUP BY Discount
ORDER BY Discount;

WITH regional_sales AS (
    SELECT Region,
           SUM(Sales) AS Revenue
    FROM superstore.`sample - superstore`
    GROUP BY Region
)
SELECT *
FROM regional_sales;

SELECT
State,
SUM(Sales) AS Revenue,
RANK() OVER (ORDER BY SUM(Sales) DESC) AS RevenueRank
FROM superstore.`sample - superstore`
GROUP BY State;

SELECT
`Order ID`,
`Profit`,
CASE
    WHEN Profit > 100 THEN 'High Profit'
    WHEN Profit >= 0 THEN 'Low Profit'
    ELSE 'Loss'
END AS ProfitCategory
FROM superstore.`sample - superstore`;

#TO CHANGE THE DATA TYPE FROM TEXT TO DATETIME

SELECT
`Order Date`,
`Ship Date`
FROM superstore.`sample - superstore`
LIMIT 10;

#ADD NEW DATE COLUMNS 
ALTER TABLE superstore.`sample - superstore`
ADD COLUMN Order_Date_New DATE,
ADD COLUMN Ship_Date_New DATE;

SET SQL_SAFE_UPDATES = 0;#MYSQL WAS IN SAFE MODE SO I HAD TO CHANGE THAT SO I COULD UPDATE THE TABLE 
UPDATE superstore.`sample - superstore`
SET 
Order_Date_New = STR_TO_DATE(`Order Date`, '%m/%d/%Y'),
Ship_Date_New = STR_TO_DATE(`Ship Date`, '%m/%d/%Y');

SELECT
`Order Date`,
`Ship Date`
FROM superstore.`sample - superstore`
LIMIT 10;

DESCRIBE superstore.`sample - superstore` ;#TO CONFIRM IF THE CHANGES WERE MADE

#NOW TO DROP THE OLD COLUMNS AND RENAME THE NEW COLUMNS
ALTER TABLE superstore.`sample - superstore`
DROP COLUMN `Order Date`,
DROP COLUMN `Ship Date`;

ALTER TABLE superstore.`sample - superstore`
CHANGE COLUMN Order_Date_New `Order Date` DATE;

ALTER TABLE superstore.`sample - superstore`
CHANGE COLUMN Ship_Date_New `Ship Date` DATE;

DESCRIBE superstore.`sample - superstore`;

#TO CHECK SALES BY YEAR
SELECT
YEAR(`Order Date`) AS Year,
SUM(Sales) AS Total_Sales
FROM superstore.`sample - superstore`
GROUP BY YEAR(`Order Date`)
ORDER BY Year;

#TO CHECK SALES BY MONTH 
SELECT
MONTHNAME(`Order Date`) AS Month,
SUM(Sales) AS Total_Sales
FROM superstore.`sample - superstore`
GROUP BY MONTHNAME(`Order Date`);

#TO CHECK  MONTHY REVENUE TREND
SELECT
YEAR(`Order Date`) AS Year,
MONTH(`Order Date`) AS Month,
ROUND(SUM(Sales),2) AS Revenue
FROM superstore.`sample - superstore`
GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`)
ORDER BY
Year,
Month;