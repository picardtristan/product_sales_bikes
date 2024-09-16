-- After imported our 5 files in MariaDB we combined them by a union.
CREATE TABLE combined_data AS
SELECT *
FROM data_2021
UNION
SELECT *
FROM data_2020
UNION
SELECT *
FROM data_2019
UNION
SELECT *
FROM data_2018
UNION
SELECT *
FROM data_2017;

-- Let’s try to understand the revenue by year
SELECT year, sum(revenue) AS total_revenue, ROUND(avg(revenue),0) AS avg_revenue
FROM combined_data
GROUP BY year
ORDER BY total_revenue DESC;

-- We can check the revenue by product category and by year
SELECT year, product_category, sum(revenue) AS total_revenue, ROUND(avg(revenue),0) AS avg_revenue
FROM combined_data
GROUP BY year, product_category
ORDER BY total_revenue DESC;

-- We add a filter only for the year 2017
SELECT year, product_category, sum(revenue) AS total_revenue, ROUND(avg(revenue),0) AS avg_revenue
FROM combined_data
WHERE year = 2017
GROUP BY year, product_category
ORDER BY total_revenue DESC;

-- Let’s check the different average indicators by product category
SELECT 	product_category, 
		ROUND(AVG(profit),0) AS avg_profit,
        ROUND(avg(revenue),0) AS avg_revenue,
        ROUND(AVG(cost),0) AS avg_cost,
        ROUND(avg(unit_price),0) AS avg_unit_price,
        ROUND(avg(order_quantity),0) AS avg_quantity,
        ROUND(avg(unit_cost),0) AS avg_unit_cost
FROM combined_data
GROUP BY product_category
ORDER BY avg_profit DESC;

-- We can check the total revenue and average revenue by age group
SELECT age_group, ROUND(sum(revenue),0) AS total_revenue, ROUND(avg(revenue),0) AS avg_revenue
FROM combined_data
GROUP BY age_group
ORDER BY total_revenue DESC;

-- We add the product category
SELECT age_group, product_category, ROUND(sum(revenue),0) AS total_revenue, ROUND(avg(revenue),0) AS avg_revenue
FROM combined_data
GROUP BY age_group, product_category
ORDER BY age_group, total_revenue DESC;

-- Let’s see for which gender is the highest by category
SELECT customer_gender, product_category, ROUND(sum(revenue),0) AS total_revenue, ROUND(avg(revenue),0) AS avg_revenue
FROM combined_data
GROUP BY customer_gender, product_category
ORDER BY product_category, total_revenue DESC;

-- We can check the highest country for the total revenue by category
SELECT country, product_category, COUNT(country) AS nbr_rows, ROUND(sum(revenue),0) AS total_revenue, ROUND(avg(revenue),0) AS avg_revenue
FROM combined_data
GROUP BY country, product_category
ORDER BY product_category, total_revenue DESC;

-- Let’s see the total buying by country
SELECT country, count(country) as nbr_order
FROM combined_data
GROUP BY country
ORDER BY nbr_order DESC;

-- We can also check by year for each country
SELECT country, year, count(country) as nbr_order, sum(revenue) AS total_revenue, ROUND(Avg(revenue),0)AS avg_revenue
FROM combined_data
GROUP BY country, year;

-- Now we analyze the revenue by month
SELECT year, month, sum(revenue) AS total_revenue, ROUND(Avg(revenue),0)AS avg_revenue
FROM combined_data
GROUP BY year, month
ORDER BY year, total_revenue DESC;

-- We want see for each year only the first month in total revenue
SELECT year, month, total_revenue, avg_revenue
FROM (
    SELECT year, 
           month, 
           SUM(revenue) AS total_revenue, 
           ROUND(AVG(revenue), 0) AS avg_revenue,
           RANK() OVER (PARTITION BY year ORDER BY SUM(revenue) DESC) AS revenue_rank
    FROM combined_data
    GROUP BY year, month
) AS ranked_data
WHERE revenue_rank = 1
ORDER BY year;

-- And see for each year only the last month in total revenue
SELECT year, month, total_revenue, avg_revenue
FROM (
    SELECT year, 
           month, 
           SUM(revenue) AS total_revenue, 
           ROUND(AVG(revenue), 0) AS avg_revenue,
           RANK() OVER (PARTITION BY year ORDER BY SUM(revenue) DESC) AS revenue_rank
    FROM combined_data
    GROUP BY year, month
	) AS ranked_data
WHERE (year = 2019 AND revenue_rank = 7) OR (year != 2019 AND revenue_rank = 12)
ORDER BY year;

-- We want to see if there is a seasonality with quarter
SELECT year, month, total_revenue, avg_revenue
FROM (
    SELECT year, 
           month, 
           SUM(revenue) AS total_revenue, 
           ROUND(AVG(revenue), 0) AS avg_revenue,
           RANK() OVER (PARTITION BY year ORDER BY SUM(revenue) DESC) AS revenue_rank
    FROM combined_data
    GROUP BY year, month
	) AS ranked_data
WHERE revenue_rank IN (1,2,3)
ORDER BY year, total_revenue DESC;

-- We add the name of the day in the table
ALTER TABLE combined_data ADD COLUMN day_name VARCHAR(10);
UPDATE combined_data
SET day_name = DAYNAME(STR_TO_DATE(CONCAT(day, ' ', month, ' ', year), '%d %M %Y'));

-- We can check wich day is the more profitable
WITH RevenueByDay AS (
    SELECT country, 
           day_name, 
           SUM(revenue) AS total_revenue
    FROM combined_data
    GROUP BY country, day_name
),
RankedRevenue AS (
    SELECT country, 
           day_name, 
           total_revenue,
           RANK() OVER (PARTITION BY country ORDER BY total_revenue DESC) AS rank
    FROM RevenueByDay
)
SELECT country, 
       day_name, 
       total_revenue
FROM RankedRevenue
WHERE rank = 1
ORDER BY country;

-- We can check the profit by unit for each category:
SELECT product_category,unit_price - unit_cost AS unit_profit
FROM combined_data
GROUP BY product_category;

-- Let's check by country and year for each category
	-- For Bikes
SELECT country, year, product_category,unit_price - unit_cost AS unit_profit
FROM combined_data
WHERE product_category = 'Bikes'
GROUP BY country, year, product_category
ORDER BY country, unit_profit DESC, year;

	-- For Accessories
SELECT country, year, product_category,unit_price - unit_cost AS unit_profit
FROM combined_data
WHERE product_category = 'Accessories'
GROUP BY country, year, product_category
ORDER BY country, unit_profit DESC, year;

	-- For Clothing
SELECT country, year, product_category,unit_price - unit_cost AS unit_profit
FROM combined_data
WHERE product_category = 'Clothing'
GROUP BY country, year, product_category
ORDER BY country, unit_profit DESC, year;

-- We can check the gross margin
	-- By country
SELECT country, ROUND((sum(profit) / sum(revenue)) * 100,2) AS gross_margin_percentage
FROM combined_data
GROUP BY country
ORDER BY gross_margin_percentage DESC;

	-- By year
SELECT year, ROUND((sum(profit) / sum(revenue)) * 100,2) AS gross_margin_percentage
FROM combined_data
GROUP BY year
ORDER BY gross_margin_percentage DESC;

	-- By product category
SELECT product_category, ROUND((sum(profit) / sum(revenue)) * 100,2) AS gross_margin_percentage
FROM combined_data
GROUP BY product_category
ORDER BY gross_margin_percentage DESC;

	-- By age group
SELECT age_group, ROUND((sum(profit) / sum(revenue)) * 100,2) AS gross_margin_percentage
FROM combined_data
GROUP BY age_group
ORDER BY gross_margin_percentage DESC;

	-- By customer gender
SELECT customer_gender, ROUND((sum(profit) / sum(revenue)) * 100,2) AS gross_margin_percentage
FROM combined_data
GROUP BY customer_gender
ORDER BY gross_margin_percentage DESC;

-- We doo a ranking for gross margin by country and product category
SELECT country, product_category, ROUND((sum(profit) / sum(revenue)) * 100,2) AS gross_margin_percentage
FROM combined_data
GROUP BY country, product_category
ORDER BY country, gross_margin_percentage DESC;