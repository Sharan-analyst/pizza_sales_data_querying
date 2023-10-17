ALTER TABLE pizza_sales
MODIFY COLUMN pizza_id int,
MODIFY COLUMN order_id int,
MODIFY COLUMN pizza_name_id VARCHAR(50),
MODIFY COLUMN quantity tinyint,
-- MODIFY COLUMN order_date date,
MODIFY COLUMN order_time time,
MODIFY COLUMN unit_price float,
MODIFY COLUMN total_price float,
MODIFY COLUMN pizza_size varchar(50),
MODIFY COLUMN pizza_category varchar(50),
MODIFY COLUMN pizza_ingredients varchar(200),
MODIFY COLUMN pizza_name varchar(50);

ALTER TABLE pizza_sales
ADD COLUMN new_date DATE;
SET SQL_SAFE_UPDATES = 0;
UPDATE pizza_sales
SET new_date = STR_TO_DATE(order_date, '%d-%m-%Y');
SELECT *
FROM pizza_sales;
-- 1. Total Revenue - Sum of Total_price
SELECT ROUND(SUM(total_price),2) as Total_revenue
FROM pizza_sales;
-- 2. Average Order Value = Total revenue / total orders
SELECT ROUND(SUM(total_price) / COUNT(DISTINCT order_id), 2) as Avg_Order_Value
FROM pizza_sales;
-- or
WITH T1 as (
SELECT ROUND(SUM(total_price),2) as Total_revenue
FROM pizza_sales),
T2 as (
SELECT COUNT(DISTINCT Order_id) as Total_orders
FROM pizza_sales)
SELECT ROUND(Total_revenue / Total_orders, 2) AS Avg_Order_Value
FROM T1, T2;
-- 3. Total Pizzas sold
SELECT SUM(quantity) as total_pizzas_sold
FROM pizza_sales;
-- 4 Total Orders
SELECT COUNT(DISTINCT order_id) as Total_orders
FROM pizza_sales;
-- 5 Avg Pizzas Per Order -- Total no. of pizas sold / total no. of orders
SELECT ROUND(SUM(quantity) / COUNT(DISTINCT order_id), 2) as Avg_Pizzas_Per_Order
FROM pizza_sales;
-- 6 Day Trend
SELECT
    DAYNAME(STR_TO_DATE(order_date, '%d-%m-%Y')) AS OrderDay,
    COUNT(DISTINCT order_id) AS TotalOrders
FROM
    pizza_sales
GROUP BY
    OrderDay
ORDER BY
    FIELD(OrderDay, 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');
-- 7 Monthly trend
SELECT
    DATE_FORMAT(STR_TO_DATE(order_date, '%d-%m-%Y'), '%M') AS OrderMonth,
    COUNT(DISTINCT order_id) AS TotalOrders
FROM
    pizza_sales
GROUP BY
    OrderMonth
ORDER BY FIELD
    (OrderMonth, 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');
-- 8 Percentage of sale by Pizza category
WITH T1 AS (
     SELECT pizza_category, SUM(total_price) AS Sales_by_Category
     FROM pizza_sales
     WHERE MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) = 1 -- Filter by the desired month (January)
     GROUP BY pizza_category
 ),
 T2 AS (
     SELECT SUM(total_price) AS Total_Sales
     FROM pizza_sales
     WHERE MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) = 1 -- Filter by the desired month (January)
 ),
 T3 AS (
     SELECT pizza_category, SUM(total_price) AS Total_Revenue
     FROM pizza_sales
     WHERE MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) = 1 -- Filter by the desired month (January)
     GROUP BY pizza_category
 )
 SELECT
     T1.pizza_category,
     ROUND((T1.Sales_by_Category / T2.Total_Sales) * 100, 2) AS Percentage_Sold_by_Category,
     T3.Total_Revenue
 FROM T1
 JOIN T2 ON 1=1
 JOIN T3 ON T1.pizza_category = T3.pizza_category;
-- or
SELECT pizza_category, ROUND(SUM(total_price), 2) as Total_sales, ROUND(sum(total_price) *100 / (SELECT SUM(total_price) FROM pizza_sales WHERE MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) = 2), 2) AS PCT
FROM pizza_sales
WHERE MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) = 2
GROUP BY pizza_category;

SELECT *
FROM pizza_sales;

























