-- 1. DATA UNDERSTANDING

-- 1. Find total number of transactions
SELECT COUNT(*) AS total_transactions FROM sales;

-- 2. Find total revenue generated
SELECT SUM(amount) AS total_revenue FROM sales;

-- 3. Find total unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM sales;

-- 4. Find average order value
SELECT AVG(amount) AS avg_order_value FROM sales;

-- 5. Find total quantity sold
SELECT SUM(quantity) AS total_quantity FROM sales;

-- 6. Find minimum and maximum sale amount
SELECT MIN(amount) AS min_sale, MAX(amount) AS max_sale FROM sales;

-- 7. Find average discount given
SELECT AVG(NVL(discount, 0)) AS avg_dis FROM sales;

-- 8. Find total sales per store
SELECT store_id, SUM(amount) AS total_sales FROM sales GROUP BY store_id;

-- 9. Find total sales per category
SELECT p.category, SUM(s.amount) AS total_sales
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category;

-- 10. Find number of transactions per day
SELECT sale_date, COUNT(*) AS transactions
FROM sales
GROUP BY sale_date
ORDER BY sale_date;



-- 2. DATA CLEANING

-- 11. Replace NULL discount with 0
SELECT sale_id, NVL(discount, 0) AS dis FROM sales;

-- 12. Find number of NULL discounts
SELECT COUNT(*) AS null_dis FROM sales WHERE discount IS NULL;

-- 13. Calculate net revenue (amount - discount)
SELECT sale_id, amount - NVL(discount, 0) AS net_rev FROM sales;

-- 14. Replace NULL quantity with 1
SELECT sale_id, NVL(quantity, 1) AS quan FROM sales;

-- 15. Identify rows where amount is NULL
SELECT * FROM sales WHERE amount IS NULL;

-- 16. Use COALESCE to handle multiple NULL columns
SELECT sale_id, COALESCE(amount, 0), COALESCE(quantity, 1), COALESCE(discount, 0) FROM sales;

-- 17. Create a cleaned column for revenue
SELECT sale_id, amount - NVL(discount, 0) AS cleaned_rev FROM sales;

-- 18. Check percentage of missing data
SELECT ((COUNT(*) - COUNT(discount)) * 100) / COUNT(*) AS missing_per FROM sales;

-- 19. Flag rows with missing values
SELECT sale_id,
CASE 
WHEN amount IS NULL OR quantity IS NULL OR discount IS NULL 
THEN 'Missing'
ELSE 'Not Missing'
END AS status
FROM sales;

-- 20. Prepare dataset for analysis
SELECT sale_id, 
COALESCE(amount, 0),
COALESCE(quantity, 1),
COALESCE(discount, 0),
COALESCE(amount, 0) - COALESCE(discount, 0) AS net_rev
FROM sales;


-- 3. FILTERING

-- 21. Find sales in last 30 days
SELECT * FROM sales WHERE sale_date >= SYSDATE - 30;

-- 22. Find sales above 5000
SELECT * FROM sales WHERE amount > 5000;

-- 23. Find sales between 1000 and 5000
SELECT sale_id, amount FROM sales WHERE amount BETWEEN 1000 AND 5000;

-- 24. Find sales from CMR store
SELECT s.sale_id, s.amount, st.store_name
FROM sales s
JOIN stores st ON s.store_id = st.store_id
WHERE st.store_name = 'CMR';

-- 25. Find Electronics category sales
SELECT s.sale_id, s.amount, p.category
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE p.category = 'Electronics';

-- 26. Find sales excluding Grocery category
SELECT s.sale_id, s.amount, p.category
FROM sales s JOIN products p ON s.product_id = p.product_id
WHERE p.category !='Grocery';

-- 27. Find customers from specific store
SELECT DISTINCT c.customer_id, c.customer_name
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN stores st ON s.store_id = st.store_id
WHERE st.store_name = 'CMR';

-- 28. Find high discount transactions
SELECT sale_id, amount, discount FROM sales
WHERE NVL(discount, 0) > 300;

-- 29. Find low quantity sales
SELECT sale_id, quantity FROM sales WHERE quantity < 5;

-- 30. Find recent transactions
SELECT sale_id, sale_date, amount
FROM sales
WHERE sale_date >= (SELECT MAX(sale_date) - 7 FROM sales);


-- 4. AGGREGATION

-- 31. Revenue per store
SELECT store_id, SUM(amount) AS revenue FROM sales
GROUP BY store_id;

-- 32. Revenue per category
SELECT p.category, SUM(s.amount) AS revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category;

-- 33. Revenue per customer
SELECT customer_id, SUM(amount) AS revenue FROM sales
GROUP BY customer_id;

-- 34. Monthly revenue
SELECT TO_CHAR(sale_date, 'YYYY-MM') AS month, SUM(amount) AS revenue
FROM sales
WHERE sale_date BETWEEN DATE '2025-03-01' AND DATE '2025-03-31'
GROUP BY TO_CHAR(sale_date, 'YYYY-MM');

-- 35. Daily revenue
SELECT sale_date, SUM(amount) AS revenue FROM sales
GROUP BY sale_date
ORDER BY sale_date;

-- 36. Average sales per store
SELECT store_id, AVG(amount) AS avg_sales FROM sales
GROUP BY store_id;

-- 37. Total quantity per category
SELECT p.category, SUM(s.quantity) AS total_quantity
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category;

-- 38. Total discount per store
SELECT store_id, SUM(NVL(discount, 0)) AS total_discount
FROM sales
GROUP BY store_id;

-- 39. Customer-wise total spending
SELECT customer_id, SUM(amount) AS total_spen
FROM sales
GROUP BY customer_id;

-- 40. Store-wise transaction count
SELECT store_id, COUNT(*) FROM sales GROUP BY store_id;


-- 5. HAVING

-- 41. Customers with revenue > 20000
SELECT customer_id, SUM(amount) AS total FROM sales
GROUP BY customer_id
HAVING SUM(amount) > 20000;

-- 42. Stores with revenue > 100000
SELECT store_id, SUM(amount) AS rev FROM sales
GROUP BY store_id
HAVING SUM(amount) > 100000;

-- 43. Categories with avg sales > 3000
SELECT product_id, AVG(amount) AS avg_sales FROM sales
GROUP BY product_id
HAVING AVG(amount) > 3000;

-- 44. Customers with more than 5 transactions
SELECT customer_id, COUNT(*) FROM sales
GROUP BY customer_id
HAVING COUNT(*) > 5;

-- 45. Stores with high discount usage
SELECT store_id, SUM(NVL(discount,0)) AS high_dis FROM sales
GROUP BY store_id
HAVING SUM(NVL(discount,0)) > 5000;

-- 46. Categories with low performance
SELECT product_id, SUM(amount) AS low_per FROM sales
GROUP BY product_id
HAVING SUM(amount) < 2000;

-- 47. Customers with high avg order value
SELECT customer_id, AVG(amount) AS high_avg FROM sales
GROUP BY customer_id
HAVING AVG(amount) > 3000;

-- 48. Find top 5 customers
SELECT customer_id, SUM(amount) AS total
FROM sales
GROUP BY customer_id
ORDER BY total DESC
FETCH FIRST 5 ROWS ONLY;

-- 49. Stores with max transactions
SELECT store_id, COUNT(*) cnt
FROM sales
GROUP BY store_id
HAVING COUNT(*) = (
    SELECT MAX(cnt) FROM (
        SELECT COUNT(*) cnt FROM sales GROUP BY store_id
    )
);

-- 50. Categories with high growth
SELECT product_id, SUM(amount)
FROM sales
GROUP BY product_id
HAVING SUM(amount) > 30000;


-- 6. CASE WHEN

-- 51. Classify customers as High/Medium/Low spenders
SELECT customer_id,
CASE 
WHEN SUM(amount) >= 40000 THEN 'High'
WHEN SUM(amount) >= 20000 THEN 'Medium'
ELSE 'Low'
END AS category
FROM sales
GROUP BY customer_id;

-- 52. Classify transactions as Big/Small
SELECT sale_id,
CASE WHEN amount > 5000 THEN 'Big' ELSE 'Small' END AS transac FROM sales;

-- 53. Create discount flag
SELECT sale_id,
CASE WHEN discount > 0 THEN 'Yes' ELSE 'No' END AS dis
FROM sales;

-- 54. Segment stores based on revenue
SELECT store_id,
CASE WHEN SUM(amount) > 100000 THEN 'Top' ELSE 'Normal' END AS segment
FROM sales
GROUP BY store_id;

-- 55. Categorize customers based on frequency
SELECT customer_id,
CASE WHEN COUNT(*) > 10 THEN 'Frequent' ELSE 'Rare' END AS cust_freq
FROM sales
GROUP BY customer_id;

-- 56. Create sales buckets
SELECT sale_id,amount,
CASE 
WHEN amount < 1000 THEN 'Low'
WHEN amount < 5000 THEN 'Medium'
ELSE 'High'
END AS sales_buck
FROM sales;

-- 57. Identify premium customers
SELECT customer_id,
CASE WHEN SUM(amount) > 25000 THEN 'Premium' END AS prem_cust
FROM sales GROUP BY customer_id;

-- 58. Mark high-value transactions
SELECT sale_id,
CASE WHEN amount > 7000 THEN 'High Value' END AS high_val
FROM sales;

-- 59. Classify categories based on performance
SELECT product_id,
CASE WHEN SUM(amount)>20000 THEN 'Good' ELSE 'Average' END AS cat_per
FROM sales GROUP BY product_id;

-- 60. Create custom labels for reporting
SELECT sale_id,
CASE WHEN quantity>3 THEN 'Bulk' ELSE 'Normal' END AS cust_label
FROM sales;

-- 7. JOINS (Multiple Tables)

-- 61. Join sales with customers table
SELECT s.sale_id, s.amount, c.customer_name
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id;

-- 62. Join sales with stores table
SELECT s.sale_id, s.amount, st.store_name
FROM sales s
JOIN stores st ON s.store_id = st.store_id;

-- 63. Join sales with products table
SELECT s.sale_id, s.amount, p.category
FROM sales s
JOIN products p ON s.product_id = p.product_id;

-- 64. Find customer name with store name and sales
SELECT s.sale_id, c.customer_name, st.store_name, s.amount
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN stores st ON s.store_id = st.store_id;

-- 65. Find category-wise revenue using joins
SELECT p.category, SUM(s.amount) AS REV
FROM sales s 
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category;

-- 66. Find store-wise customer count
SELECT st.store_name, COUNT(DISTINCT s.customer_id) AS cust_count
FROM sales s 
JOIN stores st ON s.store_id = st.store_id
GROUP BY st.store_name;

-- 67. Find top product per store
SELECT store_id, product_id, SUM(amount) AS total_sales
FROM sales
GROUP BY store_id, product_id
HAVING SUM(amount) = (
    SELECT MAX(SUM(amount)) 
    FROM sales s2 
    WHERE s2.store_id = sales.store_id 
    GROUP BY product_id
);

-- 68. Find customers who purchased from multiple stores
SELECT c.customer_id, c.customer_name 
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name 
HAVING COUNT(DISTINCT s.store_id) > 1;

-- 69. Find sales with product category
SELECT s.sale_id, s.store_id, s.product_id, p.category, s.amount 
FROM sales s
JOIN products p ON s.product_id = p.product_id;

-- 70. Find revenue per customer per store
SELECT c.customer_name, st.store_name, SUM(s.amount) AS revenue
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN stores st ON s.store_id = st.store_id
GROUP BY c.customer_name, st.store_name;

-- 71. Find customers with no transactions
SELECT c.customer_id, c.customer_name 
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.customer_id IS NULL;

-- 72. Find missing product mappings
SELECT * 
FROM sales s 
LEFT JOIN products p ON s.product_id = p.product_id
WHERE p.product_id IS NULL;

-- 73. Find store performance using joins
SELECT st.store_name,
       SUM(s.amount) AS total_rev,
       COUNT(s.sale_id) AS total_transac
FROM sales s
JOIN stores st ON s.store_id = st.store_id
GROUP BY st.store_name;

-- 74. Find cross-category purchases
SELECT c.customer_id, c.customer_name
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN products p ON s.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT p.category) > 1;

-- 75. Find total revenue using joins
SELECT SUM(s.amount) AS total_revenue
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN products p ON s.product_id = p.product_id
JOIN stores st ON s.store_id = st.store_id;


-- 8. WINDOW FUNCTIONS

-- 76. Calculate total spend per customer
SELECT sale_id, customer_id, amount,
SUM(amount) OVER (PARTITION BY customer_id) AS total_spend
FROM sales;

-- 77. Rank customers by revenue
SELECT customer_id, SUM(amount) AS TOTAL,
RANK() OVER(ORDER BY SUM(amount) DESC) AS rank
FROM sales GROUP BY customer_id;

-- 78. Find top customer per store
SELECT * FROM (
SELECT store_id, customer_id, SUM(amount) AS TOTAL,
RANK() OVER(PARTITION BY store_id ORDER BY SUM(amount) DESC) RANK
FROM sales GROUP BY store_id, customer_id
) WHERE RANK=1;

-- 79. Running total of sales
SELECT sale_id, sale_date, amount,
SUM(amount) OVER (ORDER BY sale_date) AS running_total 
FROM sales;

-- 80. Previous sale using LAG
SELECT sale_id, amount,
LAG(amount) OVER(ORDER BY sale_id) AS prev_sale 
FROM sales;

-- 81. Next sale using LEAD
SELECT sale_id, amount,
LEAD(amount) OVER(ORDER BY sale_id) AS next_sale 
FROM sales;

-- 82. Sales growth
SELECT sale_id, amount,
amount - LAG(amount) OVER(ORDER BY sale_id) AS sale_growth 
FROM sales;

-- 83. Difference between transactions
SELECT sale_id,
amount - LAG(amount) OVER(ORDER BY sale_id) AS differ 
FROM sales;

-- 84. Cumulative revenue
SELECT sale_id, sale_date, amount,
SUM(amount) OVER (ORDER BY sale_date 
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue 
FROM sales;

-- 85. Moving average of sales
SELECT sale_id, amount,
AVG(amount) OVER (ORDER BY sale_id 
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM sales;

-- 86. Rank stores by revenue
SELECT store_id, SUM(amount) AS total_revenue,
RANK() OVER (ORDER BY SUM(amount) DESC) AS rank 
FROM sales 
GROUP BY store_id;

-- 87. Second highest sale
SELECT *
FROM (
    SELECT sale_id, amount,
    RANK() OVER (ORDER BY amount DESC) AS rnk 
    FROM sales
)
WHERE rnk = 2;

-- 88. Partition data by store
SELECT sale_id, store_id, amount,
SUM(amount) OVER (PARTITION BY store_id) AS store_total 
FROM sales;

-- 89. Customer ranking per store
SELECT store_id, customer_id, SUM(amount) AS total_spend,
RANK() OVER (PARTITION BY store_id ORDER BY SUM(amount) DESC) AS rnk 
FROM sales 
GROUP BY store_id, customer_id;

-- 90. Frequency using window
SELECT sale_id, customer_id,
COUNT(*) OVER (PARTITION BY customer_id) AS frequency 
FROM sales;


-- 9. NTILE / SEGMENTATION

-- 91. Divide customers into 4 segments
SELECT customer_id, total_spend,
NTILE(4) OVER (ORDER BY total_spend DESC) AS segment
FROM (
    SELECT customer_id, SUM(amount) AS total_spend
    FROM sales
    GROUP BY customer_id
);

-- 92. Identify top 25% customers
SELECT *
FROM (
SELECT customer_id, SUM(amount) AS total_spend,
NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS seg FROM sales
GROUP BY customer_id
) WHERE seg = 1;

-- 93. Identify bottom 25% customers
SELECT * FROM (
SELECT customer_id, SUM(amount) AS total_spend,
NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS seg FROM sales
GROUP BY customer_id
)WHERE seg = 4;

-- 94. Segment stores into 3 groups
SELECT store_id, total_revenue,
NTILE(3) OVER (ORDER BY total_revenue DESC) AS segment
FROM (
    SELECT store_id, SUM(amount) AS total_revenue
    FROM sales
    GROUP BY store_id
);

-- 95. Create quartiles based on revenue
SELECT customer_id, total_spend,
NTILE(4) OVER (ORDER BY total_spend DESC) AS quartile
FROM (
    SELECT customer_id, SUM(amount) AS total_spend FROM sales
    GROUP BY customer_id
);

-- 96. Segment customers per store
SELECT store_id, customer_id, total_spend,
NTILE(4) OVER (PARTITION BY store_id ORDER BY total_spend DESC) AS segment
FROM (
    SELECT store_id, customer_id, SUM(amount) AS total_spend FROM sales
    GROUP BY store_id, customer_id
);

-- 97. Identify premium segment
SELECT * FROM (
SELECT customer_id, SUM(amount) AS total_spend,
NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS seg FROM sales
GROUP BY customer_id
)WHERE seg = 1;

-- 98. Find mid-level customers
SELECT * 
FROM (
SELECT customer_id, SUM(amount) AS total_spend,
NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS seg 
FROM sales
GROUP BY customer_id
) 
WHERE seg IN (2,3);

-- 99. Analyze bucket distribution
SELECT seg, COUNT(*) AS customer_count 
FROM (
SELECT customer_id,
NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS seg 
FROM sales
GROUP BY customer_id
)
GROUP BY seg
ORDER BY seg;

-- 100. Create marketing segments
SELECT customer_id, total_spend,
CASE 
     WHEN seg = 1 THEN 'Premium'
     WHEN seg = 2 THEN 'High Value'
     WHEN seg = 3 THEN 'Medium Value'
     ELSE 'Low Value'
END AS segment_label
FROM (
    SELECT customer_id, SUM(amount) AS total_spend,
    NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS seg FROM sales
    GROUP BY customer_id
);

-- 11. DATE ANALYSIS

-- 111. Find daily sales
SELECT sale_date, SUM(amount) AS daily_sales 
FROM sales
GROUP BY sale_date 
ORDER BY sale_date;

-- 112. Find monthly sales
SELECT SUM(amount) AS monthly_sales 
FROM sales
WHERE sale_date >= DATE '2025-01-01'
AND sale_date < DATE '2025-02-01';

-- 113. Find weekend sales
SELECT sale_date, SUM(amount) AS weekend_sales 
FROM sales
WHERE TO_CHAR(sale_date, 'DY') IN ('SAT', 'SUN') 
GROUP BY sale_date;

-- 114. Find first sale date
SELECT MIN(sale_date) AS first_sale_date FROM sales;

-- 115. Find last sale date
SELECT MAX(sale_date) AS last_sale_date FROM sales;

-- 116. Find sales in specific month
SELECT * FROM sales
WHERE TO_CHAR(sale_date, 'YYYY-MM') = '2025-01';

-- 117. Find sales growth month-wise
SELECT month, total_sales,
total_sales - LAG(total_sales) OVER (ORDER BY month) AS growth
FROM (
    SELECT TO_CHAR(sale_date, 'YYYY-MM') AS month,
    SUM(amount) AS total_sales
    FROM sales
    GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
);

-- 118. Find inactive customers (30 days)
SELECT customer_id 
FROM sales
GROUP BY customer_id
HAVING MAX(sale_date) < SYSDATE - 30;

-- 119. Find repeat customers
SELECT customer_id, COUNT(*) AS transac_count 
FROM sales
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- 120. Find sales trend
SELECT sale_date,
SUM(amount) AS daily_sales,
SUM(SUM(amount)) OVER (ORDER BY sale_date) AS cumul_sales
FROM sales
GROUP BY sale_date
ORDER BY sale_date;