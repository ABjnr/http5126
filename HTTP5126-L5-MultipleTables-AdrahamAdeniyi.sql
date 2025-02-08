--  LAB 5 MULTIPLE TABLES

--  Put your answers on the lines after each letter. E.g. your query for question 1A should go on line 5; your query for question 1B should go on line 7...
--  1 
-- A 
SELECT * FROM sale WHERE stock_item_id = 1014;
-- B 
SELECT s.date, si.name FROM sale s INNER JOIN stock_item si ON s.stock_item_id = si.stock_item_id WHERE s.stock_item_id = 1014;

--  2
-- A 
SELECT * FROM sale WHERE employee_id = 111;
-- B
SELECT s.date, e.first_name, e.last_name, s.stock_item_id FROM sale s INNER JOIN employee e ON e.employee_id = s.employee_id WHERE s.employee_id = 111;

--  3
-- A
SELECT s.date, si.name FROM sale s INNER JOIN stock_item si ORDER BY s.date DESC LIMIT 5;
-- B
SELECT e.first_name, e.last_name, s.date, si.name, si.price FROM employee e INNER JOIN sale s ON e.employee_id = s.employee_id INNER JOIN stock_item si ON s.stock_item_id = si.stock_item_id ORDER BY s.date DESC LIMIT 5;

--  4
-- A
SELECT s.date, si.name, e.first_name FROM employee e INNER JOIN sale s ON e.employee_id = s.employee_id INNER JOIN stock_item si ON si.stock_item_id = s.stock_item_id WHERE s.date BETWEEN "2025-01-12" AND "2025-01-18";
-- B
SELECT e.first_name, e.last_name, COUNT(s.employee_id) AS "Number of sales" FROM sale s JOIN employee e ON s.employee_id = e.employee_id GROUP BY s.employee_id ORDER BY COUNT(s.employee_id) DESC;

--  5
-- A
SELECT s.date, si.name, si.price, si.category, e.first_name FROM sale s INNER JOIN employee e ON s.employee_id = e.employee_id INNER JOIN stock_item si ON s.stock_item_id = si.stock_item_id WHERE s.employee_id = (SELECT employee_id FROM sale GROUP BY employee_id ORDER BY COUNT(*) DESC LIMIT 1);
-- B
SELECT si.stock_item_id, si.name, si.price, si.category, COUNT(s.sale_id) AS times_sold FROM stock_item si LEFT JOIN sale s ON si.stock_item_id = s.stock_item_id GROUP BY si.stock_item_id ORDER BY si.stock_item_id;

--  6
-- A 
"Which employee made the highest number of sales for each product category?"
-- B
SELECT si.category, e.first_name, e.last_name, COUNT(s.sale_id) AS total_sales FROM sale s JOIN stock_item si ON s.stock_item_id = si.stock_item_id JOIN employee e ON s.employee_id = e.employee_id GROUP BY si.category, e.employee_id ORDER BY si.category, total_sales DESC;