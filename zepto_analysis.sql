-- Zepto Inventory & Sales Analytics - SQL Project
-- Tool: PostgreSQL & pgAdmin

-- Q1: Out of Stock vs In-Stock product count
SELECT 
  SUM(CASE WHEN availableQuantity = 0 THEN 1 ELSE 0 END) AS out_of_stock,
  SUM(CASE WHEN availableQuantity > 0 THEN 1 ELSE 0 END) AS in_stock
FROM zepto;

-- Q2: Category-wise Estimated Revenue (price * quantity)
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;

-- Q3: High MRP (>500) but Low Discount (<10%) products
SELECT name, mrp, discountedSellingPrice,
((mrp - discountedSellingPrice)*100.0/mrp) AS discount_percent
FROM zepto
WHERE mrp > 500 AND ((mrp - discountedSellingPrice)*100.0/mrp) < 10;

-- Q4: Top 5 Categories with Highest Average Discount
SELECT category,
AVG((mrp - discountedSellingPrice)*100.0/mrp) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q5: Price Per Gram analysis for products >100g
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND((discountedSellingPrice/weightInGms::numeric),2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- Q6: Inventory Segmentation using CASE WHEN (Low/Medium/Bulk)
SELECT name, weightInGms,
CASE 
  WHEN weightInGms < 1000 THEN 'Low'
  WHEN weightInGms < 5000 THEN 'Medium'
  ELSE 'Bulk'
END AS weight_category
FROM zepto;

-- Q7: Total Inventory Weight per Category
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;

-- Q8: Products with high discount (example)
SELECT name, category, mrp, discountedSellingPrice
FROM zepto
ORDER BY ((mrp - discountedSellingPrice)*100.0/mrp) DESC
LIMIT 10;
