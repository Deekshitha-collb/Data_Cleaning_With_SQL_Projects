-- QUERYING

SELECT * FROM sales;


-- GENERIC 

-- Q1 : HOW MANY UNIQUE CITIES DOES THE DATA HAVE?
SELECT DISTINCT city
FROM sales;

-- Q2 : IN WHICH CITY IS EACH BRANCH?
SELECT DISTINCT city, branch
FROM sales;


-- PRODUCT

-- Q3 : HOW MANY UNIQUE PRODUCT LINES DOES THE DATA HAVE?
SELECT DISTINCT product_line
FROM sales;

-- Q4 : WHAT IS THE MOST SELLING PRODUCT LINE?
SELECT SUM(quantity) as quantity, product_line
FROM sales
GROUP BY product_line
ORDER BY quantity DESC;

-- Q5 : WHAT IS THE TOTAL REVENUE BY MONTH?
SELECT month_name AS month, SUM(total) AS total_revenue
FROM sales
GROUP BY month_name 
ORDER BY total_revenue;

-- Q6 : WICH MONTH HAS THE LARGEST COGS?
SELECT month_name AS month, SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs;

-- Q7 : WHICH PRODUCT LINE HAD THE LARGEST REVENUE?
SELECT product_line, SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- Q8 :WHAT IS THE CITY WITH THE LARGEST REVENUE?
SELECT branch, city, SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue;

-- Q9 : WHAT PRODUCT LINE HAD THE LARGEST VAT?
SELECT product_line, AVG(vat) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Q10 : FETCH EACH PRODUCT LINE AND ADD A COLUMN TO THOSE PRODUCT LINE SHOWING
--       'Good', 'Bad'. GOOD IF IT'S GREATER THAN AVERAGAE SALES?
SELECT  AVG(quantity) AS avg_qnty
FROM sales;
SELECT product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

-- Q11 : WHICH BRANCH SOLD MORE PRODUCTS THAN AVERAGE PRODUCT SOLD?
SELECT  branch, SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) 
                        FROM sales);

-- Q12 : WHAT IS THE MOST COMMON PRODUCT LINE BY GENDER?
SELECT gender, product_line, COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- Q13 : WHAT IS THE AVERAGE RATING OF EACH PRODUCT LINE?
SELECT ROUND(AVG(rating), 2) as avg_rating, product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


-- CUSTOMERS 

-- Q14 : HOW MANY UNIQUE CUSTOMER TYPES DOES THE DATA HAVE?
SELECT DISTINCT customer_type
FROM sales;

-- Q15 : HOW MANY UNIQUE PAYMENT METHODS DOES THE DATA HAVE?
SELECT DISTINCT payment
FROM sales;

-- Q16 : WHAT IS THE MOST COMMON CUSTOMER TYPE?
SELECT customer_type, count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- Q17 : WHICH CUSTOMER TYPE BUYS THE MOST?
SELECT customer_type, COUNT(*)
FROM sales
GROUP BY customer_type;

-- Q18 : WHAT IS THE GENDER OF MOST OF THE CUSTOMERS?
SELECT gender, COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- Q19 : WHAT IS THE GENDER DISTRIBUTION PER BRANCH?
SELECT gender, COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;

-- Q20 : WHICH TIME OF THE DAY DO CUSTOMER GIVE MOST RATINGS?
SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Q21 : WHICH TIME OF THE DAY DO CUSTOMER GIVE MOST RATINGS PER BRANCH?
SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Q22 : WHICH DAY OF THE WEEK HAS THE BEST AVERAGE RATINGS?
SELECT day_name, AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;

-- Q23 : WHICH DAY OF THE WEEK HAS THE BEST AVERAGE RATINGS PER BRANCH?
SELECT day_name, COUNT(day_name) AS total_sales
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;


-- SALES

-- Q24 : NUMBER OF SALES MADE IN EACH TIME OF THE DAY PER WEEKDAY?
SELECT time_of_day, COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;

-- Q25 : WHICH OF THE CUSTOMER TYPES BRINGS THE MOST REVENUE?
SELECT customer_type, SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;

-- Q26 : WHICH CITY HAS THE LARGEST TAX/VAT PERCENT?
SELECT city, ROUND(AVG(vat), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Q27 : WHICH CUSTOMER TYPE PAYS THE MOST IN VAT?
SELECT customer_type, AVG(vat) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;



