
-- LAB 4 AGGREGATE FUNCTIONS
-- Put your answers on the lines after each letter. E.g. your query for question 1A should go on line 6; your query for question 1B should go on line 8...

--  1 
-- A
SELECT MIN(price) FROM stock_item;
-- B
SELECT MAX(inventory) FROM stock_item;
-- C
SELECT AVG(price) FROM stock_item;
-- D
SELECT SUM(inventory) FROM stock_item;

--  2
-- A
SELECT COUNT(*), role FROM employee GROUP BY role;
-- B
SELECT COUNT(category) AS "Mammals" FROM stock_item WHERE NOT category = "piscine";
-- C
SELECT AVG(price)  AS "Average Price ($)", category FROM stock_item GROUP BY category;

--  3
-- A
SELECT SUM(inventory) AS "In Stock", category AS "Species" FROM stock_item GROUP BY category ORDER BY "In Stock" ASC;
-- B
SELECT SUM(inventory), AVG(price), category FROM stock_item GROUP BY category HAVING SUM(inventory) < 100 && AVG(price) < 100;

--  4
-- A
SELECT item AS "Product", CONCAT("$", FORMAT(price, 0)) AS "Price", inventory AS "Stock Remaining", category AS "Species", CONCAT("$", FORMAT(inventory * price, 0)) AS "potential_earnings", category FROM stock_item ORDER BY (inventory * price) DESC LIMIT 20;