-- LAB 3 FILTER DATA
-- Put your answers on the lines after each letter. E.g. your query for question 1A should go on line 6; your query for question 1B should go on line 8...

--  1 
-- A
SELECT * FROM employee WHERE role="manager" OR role="assistant";
-- B
SELECT * FROM stock_item WHERE category="piscine" AND inventory < 24;

--  2
-- A
SELECT * FROM stock_item WHERE item LIKE "% cage";
-- B
SELECT * FROM employee WHERE first_name LIKE "f%";

--  3
-- A
SELECT * FROM stock_item WHERE stock_item_id BETWEEN 1010 AND 1015;
-- B
SELECT * FROM stock_item WHERE price BETWEEN 10 AND 20;

--  4
-- A
SELECT CONCAT(first_name, " ", last_name) AS "staff_member", phone FROM employee WHERE NOT role="manager";
-- B
SELECT item, price, inventory FROM stock_item WHERE NOT(category="canine" OR category="feline" OR inventory>20);

--  5
-- A
SELECT first_name, last_name, role AS "job_title", phone FROM employee ORDER BY last_name ASC;
-- B
SELECT stock_item_id AS "id", item AS "item_name", price, inventory FROM stock_item WHERE inventory > 20 AND category = "murine" ORDER BY price DESC;