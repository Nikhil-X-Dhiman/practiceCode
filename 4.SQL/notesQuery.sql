SELECT datname FROM pg_database;
SELECT table_name
FROM information_schema.tables
WHERE table_schema='public';
SELECT conname, contype, conkey
FROM pg_constraint
WHERE conrelid = 'users'::regclass;

-- List all the employees
SELECT * FROM customer;
SELECT * FROM invoice;
SELECT * FROM invoice_line;
SELECT * FROM employee;
SELECT * FROM track;
SELECT * FROM album;
SELECT * FROM media_type;
SELECT * FROM genre;
-- Customer from India
SELECT * FROM customer WHERE country = 'India';
-- Customer with Phone Number +91 with OR & LIMIT
SELECT * FROM customer WHERE phone LIKE '+91%' OR phone ~ '\+1' LIMIT 5;
-- using regex
SELECT * FROM customer WHERE phone ~ '^(\+91)';
-- IN OPERATOR
SELECT * FROM customer WHERE country IN ('Norway', 'Brazil', 'Poland');
-- BETWEEN
SELECT * FROM invoice WHERE total BETWEEN 4 AND 10;
-- IS NULL & ORDER BY
SELECT * FROM invoice WHERE billing_state IS NULL ORDER BY total DESC;
-- DISTINCT
SELECT DISTINCT billing_country FROM invoice ORDER BY billing_country;

-- INNER JOIN
SELECT c.customer_id, c.first_name, c.state, i.billing_state, i.total
FROM customer c
JOIN invoice i
ON c.customer_id = i.customer_id
ORDER BY total DESC;
-- SELF JOIN
SELECT e.first_name, e.last_name, e.title, m.first_name, m.last_name, m.title
FROM employee e
JOIN employee m
ON e.reports_to = m.employee_id;
-- JOIN MULTIPLE TABLES && AS Keyword
SELECT t.track_id, t.name, a.title, m.name, g.name,
t.milliseconds / 1000 AS "Time(Seconds)",
t.bytes/1024 AS "Size(KB)"
FROM track t
JOIN album a
	ON t.album_id = a.album_id
JOIN media_type m
	ON t.media_type_id = m.media_type_id
JOIN genre g
	ON t.genre_id = g.genre_id;

-- COMPOUND JOIN (It Just uses AND Operator between two similar columns to make a Primary Key)
SELECT * FROM abc a JOIN xyz x ON a.col1 = x.col1 AND a.col2 = x.col2;

-- IMPLICIT JOIN (Result is same that of JOIN but in simpler term. NOT RECOMMENDED)
SELECT c.customer_id, c.first_name, c.state, i.billing_state, i.total
FROM customer c, invoice i
WHERE c.customer_id = i.customer_id
ORDER BY c.customer_id;

-- OUTER JOIN: We have 2 types of it:
-- LEFT JOIN & RIGHT JOIN
-- LEFT JOIN: Means it includes all the entry of customer table even if they didn't have any invoice
SELECT c.customer_id, first_name, country, billing_city, total
FROM customer c
LEFT JOIN invoice i
	ON i.customer_id = c.customer_id
ORDER BY c.customer_id;
-- RIGHT JOIN: Means it includes all the entry of invoice table even if any invoice doesn't have any customer. Which does not happen in real life
SELECT c.customer_id, first_name, country, billing_city, total
FROM customer c
RIGHT JOIN invoice i
	ON i.customer_id = c.customer_id
ORDER BY c.customer_id;
-- MULTIPLE JOIN: Avoid using RIGHT JOIN...i.e only use one type of JOIN as it gets confusing when we use LEFT JOIN then RIGHT JOIN & vice versa...

-- OUTER SELF JOIN
SELECT e.employee_id, e.first_name, m.first_name AS manager
FROM employee e
LEFT JOIN employee m
	ON m.employee_id = e.reports_to;

-- USING Keyword (Replace complex ON with USING if same column is referenced)
SELECT customer_id, first_name, invoice_id, total
FROM customer
JOIN invoice
	USING (customer_id);
-- If we have COMPOSITE KEY
SELECT * FROM abc JOIN xyz USING (column_from_abc, column_from_xyz);
-- NATURAL JOIN: (NOT RECOMMENDED) here, we let the db guss the column to JOIN which is dangerous & produce unexpected query results
SELECT * FROM employee NATURAL JOIN invoice;
-- CROSS JOIN(Explicite): Pair all the recors of table A with all the recors of table B
SELECT * FROM employee CROSS JOIN invoice;
-- CROSS JOIN (Implicite):
SELECT * FROM employee, invoice;
-- UNIONS:
SELECT
	c.customer_id,
	first_name,
	total,
	'poor' AS status
FROM customer c
JOIN invoice i
	USING (customer_id)
WHERE total<8
UNION
SELECT
	c.customer_id,
	first_name,
	total,
	'rich' AS status
FROM customer c
JOIN invoice i
	USING (customer_id)
WHERE total>=8
ORDER BY total DESC;

-- CREATING TABLES
CREATE TABLE IF NOT EXISTS users
	(
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	age INT,
	phone VARCHAR(20)
	);
-- INSERT VALUES: You need to specify which are DEFAULT VALUES IN VALUE FIELDS
INSERT INTO users VALUES (DEFAULT, 'Nikhil', 19, '+917018419491');
-- INSERT SPECIFIED COLUMN: Here, skip writing columns about DEFAULT Values
INSERT INTO users ("name", age, phone) VALUES ('ABC', 33, '+9135749203843');

-- MULTIPLE INSERTS
INSERT INTO users ("name", age, phone)
VALUES ('XYZ', 38, '+9138348264937'),
	   ('MNO', 22, '+9149264947938');

-- RETURN LAST ID
INSERT INTO users
VALUES
	(DEFAULT, 'BBB', 34, '+9137494739578')
RETURNING id;
-- RETURNING id: use 'WITH', 'AS' which are discussed later

-- COPY an entire TABLE: But looses PRIMARY KEY & AUTO INCREMENT Flags for new table
CREATE TABLE IF NOT EXISTS users_archive AS SELECT * FROM users;
-- COPY a TABLE using SUBQUERY:	Here user overriding because of IDENTITY COLUMN RULES, as i used "GENERATED ALWAYS", means db will generate PK & user cannot add PK to it, but here we overriden it & remember to use it sparingly.
CREATE TABLE IF NOT EXISTS users_archive (LIKE users INCLUDING ALL);
INSERT INTO users_archive OVERRIDING SYSTEM VALUE SELECT * FROM users;
-- UPDATE:
UPDATE users SET age=28, name='Nikhil Dhiman' WHERE id=1;
-- UPDATE: Using SUBQUERY
UPDATE users SET age=21, name='ND' WHERE id=(SELECT id FROM users WHERE name='Nikhil Dhiman');
-- UPDATE: Using IN
UPDATE users
SET
	age=21,
	name='ND'
WHERE id IN (
	SELECT id
	FROM users
	WHERE name IN (
		'Nikhil Dhiman', 'AAA'
		));
-- 2
UPDATE users
SET
	phone='+149264947938'
WHERE age=22;
-- PRAC
UPDATE orders SET comments='Gold Members' WHERE order_id IN (
	SELECT order_id FROM orders WHERE comments IS NULL AND customer_id IN (
		SELECT customer_id FROM customer WHERE points > 3000
	)
);
UPDATE orders SET comments='Gold Members' WHERE order_id IN (
	SELECT o.order_id FROM orders o JOIN customers c USING (customer_id) WHERE o.comments IS NULL AND c.points > 3000
);
-- PRAC: MORE EFFICIENT as no IN Keyword is used
UPDATE orders o
SET comments = 'Gold Members'
FROM customers c
WHERE o.customer_id = c.customer_id
  AND o.comments IS NULL
  AND c.points > 3000;

-- DELETE:
DELETE FROM users WHERE id = (SELECT id FROM users WHERE name = 'AAA');

-- AGGREGATION
-- COUNT: It does not count NULL values so if we have NULL present it will not count it, so we write "*" to get all the records
-- By Default, all these Functoins take Duplicate values, but if you don't want duplicate use "DISTINCT" Keyword
SELECT MIN(age), MAX(age), AVG(age), COUNT(*), SUM(age) FROM users;

-- prac
SELECT
	'First Half of 2019' AS date_range,
	SUM(invoice_total) AS total_sale,
	SUM(payment_total) AS payment_total,
	SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date BETWEEN '2019-01-01' AND '2019-07-01'
UNION
SELECT
	'Second Half of 2019' AS date_range,
	SUM(invoice_total) AS total_sale,
	SUM(payment_total) AS payment_total,
	SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date BETWEEN '2019-07-01' AND '2020-01-01'
UNION
SELECT
	'Total' AS date_range,
	SUM(invoice_total) AS total_sale,
	SUM(payment_total) AS payment_total,
	SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices
WHERE invoice_data > '2019-01-01' AND invoice_data < '2020-01-01';

-- GROUP BY: single column
SELECT COUNT(phone) FROM users WHERE age<40 GROUP BY phone LIKE '+1%' ORDER BY count;
-- multiple column
SELECT COUNT(phone) FROM users WHERE age<40 GROUP BY phone, age;
-- correct way
SELECT
    CASE
        WHEN phone LIKE '+1%' THEN 'US/Canada (+1)'
		WHEN phone LIKE '+9%' THEN 'India (+91)'
        ELSE 'Other'
    END AS phone_label,
    COUNT(*) AS user_count
FROM users
WHERE age < 40
GROUP BY phone_label
ORDER BY user_count;

-- prac
SELECT
	i.invoice_date,
	p.payment_method,
	SUM(i.invoice_amount) AS payment_total
FROM invoices i
JOIN payment_methods p
ON i.payment_method = p.payment_id
GROUP BY i.invoice_date, p.payment_method

-- HAVING:
-- here, WHERE is calculated before aggregation so no same_of_age found
SELECT SUM(age) AS sum_of_age FROM users WHERE sum_of_age>30 GROUP BY age;
-- here, WHERE is allowed for mySQL but postgreSQL does not allow it as it is stricter
SELECT id, SUM(age) AS sum_of_age FROM users GROUP BY id HAVING sum_of_age > 30;
-- it works perfectly & SUM(age) is also calculated only once per group by
-- IMP: also the colums used in HAVING should also be present in SELECT clause whereas in WHERE clasuse we can use any column wheather it is used inside SELECT or not
SELECT id, SUM(age) AS sum_of_age FROM users GROUP BY id HAVING COUNT(age) > 30;

-- EXERCISE: PRAC -> Get the customer located in delhi & have spent more than ₹100
SELECT
	c.name,
	SUM(i.payment) AS total_spent
FROM customer c
JOIN invoice i
USING (customer_id)
WHERE c.state='Delhi'
GROUP BY c.name
HAVING SUM(i.payment) > 100;

-- WITH ROLLUP:
SELECT id, COUNT(age) FROM users GROUP BY ROLLUP (id);
-- Exercise
SELECT
	pm.payment_method AS payment_method,
	SUM(p.amount)
FROM payments p
JOIN payment_methods pm
	ON pm.payment_method.id = p.payment_method
GROUP BY ROLLUP (pm.payment_method)

-- SUB-QUERY:
SELECT * FROM products WHERE product_price > (
	SELECT product_price FROM products WHERE id = 3
);
SELECT * FROM users WHERE age > (
	SELECT age FROM users WHERE id = 2
);
-- Exercise: Print name of users with age more than avg. age
SELECT * FROM users WHERE age < (
	SELECT AVG(age) FROM users
);

-- EXERCISE: Products that are never bought
SELECT * FROM products WHERE product_id NOT IN (
	SELECT DISTINCT product_id FROM order_items
)
SELECT * FROM products WHERE product_id NOT IN (
	SELECT product_id FROM order_items GROUP BY product_id
)
-- Above example with JOIN
SELECT * FROM products p
LEFT JOIN order_items o
	USING (product_id)
WHERE order_id IS NULL;

-- Exercise: Customers who have ordered lettuce (id=3)
-- using JOINS
SELECT customer_id, first_name, last_name
FROM customers c
JOIN orders o
	USING (customer_id)
JOIN order_items oi
	USING (order_item_id)
WHERE order_item_id = 3;
-- using subquery
SELECT customer_id, first_name, last_name
	FROM customers WHERE customer_id IN (
		SELECT customer_id FROM orders WHERE order_id IN (
			SELECT order_id FROM order_items WHERE order_item_id = 3
		)
	)
-- Exercise: select invoices larger than all invoices of client 3
-- MAX is safer(if no invoice is found the return is 0) & more optimised
SELECT * FROM invoices WHERE invoice_total > (
	SELECT MAX(invoice_total) FROM invoices WHERE client_id = 3
)
-- ALL: if no invoice is found the comparision with ALL (NULL) will represent X > NULL which will be true for all the columns & therefore will print all the invoices
SELECT * FROM invoices WHERE invoice_total > ALL (
	SELECT invoice_total FROM invoices WHERE client_id = 3
)
-- Exercise: Select client with atleast 2 invoices
SELECT client_name FROM clients WHERE client_id IN (
	SELECT client_id FROM invoices GROUP BY client_id HAVING COUNT(*) >= 2;
)
-- Above exercise with ANY Keyword
SELECT client_name FROM clients WHERE client_id = ANY (
	SELECT client_id FROM invoices GROUP BY client_id HAVING COUNT(*) >= 2;
)

-- CORELATED SUBQUERRY: Here, each subquery will be executed for every outer query unlike in previous example using IN operator where the query just runs once
-- Exercise: Select Employees whose salary is above avg in their office
SELECT * FROM employees e WHERE salary > (
	SELECT AVG(salary) FROM employees WHERE office_id = e.office_id
)

-- Exercise: Get the invoices that are larger than the clients avg. invoice amount
SELECT * FROM invoices i WHERE amount > (
	SELECT AVG(amount) FROM invoices WHERE client_id = i.client_id
)

-- Exercise: Select client that has invoice
-- using JOIN
SELECT DISTINCT c.* FROM clients c JOIN invoices i USING (client_id);
-- using IN subquery
SELECT * FROM clients WHERE client_id IN (
	SELECT client_id FROM invoices
)
-- Using EXISTS SUBQUERY
SELECT * FROM clients c WHERE EXISTS (
	SELECT client_id FROM invoices WHERE client_id = c.client_id
)
-- Exercise: Find the products that have never been ordered
SELECT * FROM products LEFT JOIN orders USING (product_id) WHERE order_id IS NULL;
SELECT * FROM products p WHERE NOT EXISTS (
	SELECT 1 FROM orders WHERE product_id = p.product_id
)

-- SubQuerry in SELECT CLAUSE
SELECT invoice_id,
	invoice_total,
	(SELECT AVG(invoice_total) FROM invoices) AS invoice_average,
	invoice_total - (SELECT invoice_average)
FROM invoices;

-- Exercise: No Ques
SELECT c.client_id,
	c.name,
	(SELECT SUM(invoice_amount) FROM invoices WHERE client_id=c.client_id) AS total_sales,
	(SELECT AVG(invoice_amount) FROM invoices) AS average,
	(SELECT total_sales - average) AS difference
FROM clients c;

-- SubQuery in the FROM CLAUSE: Just move the abovev SELECT QUERY into FROM CLAUSE, also give an alias to the QUERY
-- Here, you can use the virtual table you generated with the query like any other real table & perform other QUERY on them
SELECT *
FROM (
	SELECT c.client_id,
	c.name,
	(SELECT SUM(invoice_amount) FROM invoices WHERE client_id=c.client_id) AS total_sales,
	(SELECT AVG(invoice_amount) FROM invoices) AS average,
	(SELECT total_sales - average) AS difference
FROM clients c
) AS sales_summary
WHERE total_sales IS NOT NULL;

SELECT NOW();
-- Exercise: Orders Placed in current year
SELECT * FROM orders WHERE YEAR(order_date) = YEAR(NOW());
-- Less INDEX friendly
SELECT * FROM orders WHERE EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM NOW());
-- INDEX Friendly
SELECT * FROM orders WHERE order_date>=date_trunc('year', CURRENT_DATE) AND order_date<date_trunc('year', CURRENT_DATE) + INTERVAL '1 year';
-- DATE FORMATTING
SELECT TO_CHAR(NOW(), 'YY');
-- COALESCE Statement
SELECT order_id, COALESCE(shipper_id, backup_shipper_id, 'Not Assigned') FROM orders;
-- IF Statement (Previously we use to do this by union)
SELECT order_id, order_date, IF(EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM NOW()), 'ACTIVE', 'ARHIVED') AS category;
-- CASE Statement
SELECT order_id, order_date,
	CASE
		WHEN EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM NOW()) THEN 'ACTIVE'
		WHEN EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM NOW()) - 1 THEN 'LAST YEAR'
		WHEN EXTRACT(YEAR FROM order_date) < EXTRACT(YEAR FROM NOW()) - 1 THEN 'ARCHIVED'
		ELSE 'UPCOMING'
		END AS category
FROM orders;

-- VIEWS
-- Total sales from each client
CREATE VIEW total_sales_by_client AS
SELECT
	SUM(invoice_amount) AS total_sales
FROM client c
JOIN invoice i
	USING client_id
GROUP BY i.client_id;

SELECT * FROM total_sales_by_client;

-- See the balance for each clients
CREATE VIEW clients_balance AS
SELECT
	c.client_id,
	c.name,
	SUM(i.payment_total - i.invoice_total) AS balance
FROM clients c
JOIN invoices i
	USING client_id
GROUP BY client_id, name;

-- DROP VIEW
DROP VIEW total_sales_by_client;

-- ALTERING VIEW
CREATE OR REPLACE VIEW total_sales_by_client AS
SELECT
	SUM(invoice_amount) AS total_sales
FROM client c
JOIN invoice i
	USING client_id
GROUP BY i.client_id;

-- UPDATABLE VIEW
-- When a VIEW is updateble? : VIEW should not contain 1) DISTINCT 2) AGGREGATE FUNCTIONS 3) GROUP BY / HAVING 4) UNION
CREATE OR REPLACE VIEW total_sales AS
SELECT
	SUM(invoice_amount) AS total_sales
FROM client c
JOIN invoice i
	USING client_id

DELETE FROM total_sales WHERE invoice_id=1;
UPDATE total_sales SET name="ABC" WHERE invoice_id=2;

-- WITH CHECK OPTION: WHen we make changes in the UPDATABLE VIEW the changes are make in the original tables & if the updates are such, where after updating the values used in where, the updated record disappears by no longer valid acc to the view..So, this prevents such updates so that records are no disappear & all the changes statisfies the where clause in the VIEW also
CREATE OR REPLACE VIEW total_sales AS
SELECT
	SUM(invoice_amount) AS total_sales
FROM client c
JOIN invoice i
	USING client_id
WITH CHECK OPTION



-- STORED PROCEDURE: we use DELIMITER($$: most used) to tell the end of the procedure & take all these statements as one  & then change it back to default delimiter(;)
-- in MYSQL
DELIMITER $$
CREATE PROCEDURE get_clients()
BEGIN
	SELECT * FROM clients;
END$$
DELIMITER ;
-- POSTGRES SQL
CREATE OR REPLACE PROCEDURE get_clients()
LANGUAGE plpgsql
AS $$
BEGIN
    -- just return all rows
    -- but in procedures, you cannot directly SELECT to caller
    -- need to use RAISE NOTICE or return via OUT param
    RAISE NOTICE 'Listing clients:';

    -- Example: loop through and print
    FOR r IN SELECT * FROM clients LOOP
        RAISE NOTICE 'Client ID: %, Name: %', r.client_id, r.name;
    END LOOP;
END;
$$;

CALL get_clients();
DROP PROCEDURE IF EXISTS get_clients;

-- PROCEDURE with PARAMETERS and DEFAULT VALUES
CREATE OR REPLACE PROCEDURE get_client_by_id(client_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
	IF client_id IS NULL THEN
		SET client_id=0
	END IF;
	SELECT * FROM clients c WHERE c.client_id = client_id;
	RAISE NOTICE 'SHOWING DETALS OF CLIENT: %', client_id
END;
$$;

CALL get_client_by_id(5);
CALL get_client_by_id();

-- Exercise
CREATE OR REPLACE PROCEDURE get_payments(client_id INT, payment_method_id TINYINT)
LANGUAGE plpgsql
AS $$
BEGIN
	SELECT *
	FROM clients c
	JOIN payments p
		USING client_id
	JOIN payment_method pm
		USING payment_method_id
	WHERE c.client_id = IFNULL(client_id, c.client_id)
		AND
		  pm.payment_method_id = IFNULL(payment_method_id, pm.payment_method_id);
END;
$$;
CALL get_payments(NULL, NULL);
CALL get_payments(2, 2);
CALL get_payments(2, NULL);

-- PARAMETER VALIDATION
CREATE OR REPLACE PROCEDURE make_payments(invoice_id INT, payment_amount DECIMAL(9, 2), payment_date DATE)
LANGUAGE plpgsql
AS $$
BEGIN
	IF payment_amount <=0 THEN
		SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'INVALID PAYMENT AMOUNT'
	END IF;

	UPDATE invoice i
	SET
		i.invoice_total = payment_amount,
		i.payment_date = payment_date
	WHERE i.invoice_id = invoice_id;
END;
$$;
CALL make_payments(3, -100.00, "xxxx-xx-xx")

-- OUTPUT PARAMETERS
CREATE OR REPLACE PROCEDURE get_unpaid_invoice(client_id INT, OUT invoices_count SMALLINT, OUT invoices_total DECIMAL(9, 2))
LANGUAGE plpgsql
AS $$
BEGIN
	SELECT COUNT(*), SUM(invoice_total) INTO  invoices_count, invoices_total
	FROM invoices i
	WHERE i.client_id = client_id
		AND payment_total = 0;
END;
$$;

SET @invoices_count = 0;
SET @invoices_total = 0;
CALL get_unpaid_invoice(2, @invoices_count, @invoices_total);
SELECT @invoices_count, @invoices_total;

-- VARIABLES
-- User or Sessions VARIABLES: Stores data upto the connections is maintained
SET @invoice_count = 0;

-- LOCAL VARIABLES: Only stores data until the stored procedure or function is executing
DECLARE invoice_total DECIMAL(9, 2) DEFAULT 0;
DECLARE abc DECIMAL(9, 2) DEFAULT 0;
SELECT SUM(invoice_total) INTO invoice_total FROM invoices;
SET abc = invoice_total * 2;
SELECT abc;

-- FUNCTION
CREATE OR REPLACE FUNCTION calculate_tax(amount DECIMAL(9, 2))
RETURN DECIMAN(9,2)
LANGUAGE plpgsql
IMMUTABLE
PARALLEL SAFE
AS $$
BEGIN
	DECLARE tax_amount = amount * 0.18;
	RETURN IFNULL(tax_amount, 0);
END;
$$;

SELECT calculate_tax(100);
SELECT name, pay, calculate_tax(pay) FROM employees;

-- More FUNCTION
CREATE OR REPLACE FUNCTION get_customers_by_city(p_city TEXT)
RETURNS TABLE (id INT, name TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
   RETURN QUERY
   SELECT customer_id, name
   FROM customers
   WHERE city = p_city;
END;
$$;

-- TRIGGERS: Made of two parts
-- 1) TRIGGER FUNCTION (Returns TRIGGER type) 2) TRIGGER DEFINATION (when & where)
-- Exercise: Prevent Negarive Salaries
CREATE OR REPLACE FUNCTION prevent_negative_salary()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	IF NEW.salary < 0 THEN
	RAISE EXCEPTION 'Salary Cannot be Negative'
	END IF;
	RETURN NEW;
END;
$$;

CREATE TRIGGER check_salary_trigger
	BEFORE INSERT OR UPDATE ON employees
	FOR EACH ROW
	EXECUTE FUNCTION prevent_negarive_salary();

-- Exercise: TRIGGERS when we delete a payment what happens to the invoices total_payment
CREATE OR REPLACE FUNCTION reduce_payment()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE invoices
	SET payment_total = payment_total - OLD.amount
	WHERE invoice_id = OLD.invoice_id
	RETURN NULL;
END;
$$;

CREATE TRIGGER reduce_total_payment
	AFTER DELETE ON employees
	FOR EACH ROW
	EXECUTE FUNCTION reduce_payment;

DELETE FROM payments WHERE payment_id = 3;

-- DROP the TRIGGER
DROP TRIGGER IF EXISTS reduce_total_payment;

-- EVENTS: But Postgres has no Event Schedular unlike mysql...to schedule events in postgres use OS CRON JOBS instead!!!
-- Event Triggers (DDL-level events)
CREATE OR REPLACE FUNCTION log_drop()
RETURNS event_trigger
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE 'Something was dropped: %', tg_tag;
END;
$$;

CREATE EVENT TRIGGER log_drop_trigger
ON sql_drop
EXECUTE FUNCTION log_drop();

-- TRANSACTION
BEGIN;

UPDATE accounts SET balance = balance - 500 WHERE id = 1;
UPDATE accounts SET balance = balance + 500 WHERE id = 2;

COMMIT;

-- Rollback Example
BEGIN;

UPDATE accounts SET balance = balance - 500 WHERE id = 1;
UPDATE accounts SET balance = balance + 500 WHERE id = 999; -- oops, no such user

ROLLBACK;

-- Savepoints (partial rollbacks)

You can mark points inside a transaction.

BEGIN;

UPDATE accounts SET balance = balance - 100 WHERE id = 1;

SAVEPOINT sp1;

UPDATE accounts SET balance = balance + 100 WHERE id = 2;
-- Suppose this fails

ROLLBACK TO sp1;  -- undo only second update

COMMIT;  -- first update still applies

-- TRANSACTION ISOLATION LEVELS & DIFFERENT CONCURRENCY PROBLEMS

-- DATATYPES


-- 1NF: Every Record in the table should have singular value like firstName & secondName & the column should not repeat
-- 2NF: should follow 1NF & all the entities(column names) should belong to the relation(table) in which they are present... so, teacher_name should not be present inside students table OR Every column should depend on the whole primary key (not just part of it)
-- 3NF: should follow 2NF & the value of any column should not be derived from the other columns of the same record like invoice, payment_done, balance: here it can be derived from other 2 entities so it should not be stored in the table
-- all these efforts makes the data more consistent, error free, increase data integrity, reduce duplication

-- Modify Table
ALTER TABLE abc
	ADD 'last_name' VARCHAR(255) DEFAULT '' AFTER 'first_name',
	MODIFY COLUMN first_name VARCHAR(255) DEFAULT '',
	DROP calculated_age;

-- Create INDEX: Stored as Binary Tree
EXPLAIN SELECT customer_id FROM customers;
-- it tells us weather the query will read data from all table or the index also the number of rows to search
CREATE INDEX ix_firstName ON customers (firstName);
-- here the number of rows to search will be minimun compared to prev.

-- Show INDEXES
SHOW INDEXES IN customers;
-- CARDINALITY: No. of unique values in a column

-- PREFIX INDEXES: Happens in String Column where the length of string can be very large & the resultant index will be less performant
-- It is optional for CHAR & VARCHAR but compulsory for STRING & BLOB columns
CREATE INDEX idx_lastName FROM customers (lastName(5));
-- here, first 5 char will be used from every record of the lastName column to create the index of balance between cardinality & prefix indexes length

-- FULL-TEXT INDEXES: It removes the words like is, the, or, and & make indexes of the remaining words...It also search words in any order or the atomic words with relevance points to the searches record...the result is also sorted based upon relevance points...but it uses different functions to search in the db
-- MATCH(A, B): Here, A, B are the indexes column used to built the INDEX
-- AGAINST: it is followed by the keyword that is being searched in the table
-- EXERCISE: search all the post for word "react redux"
CREATE FULLTEXT INDEX idx_title_body FROM posts (title, body);
SELECT * FROM posts MATCH(title, body) AGAINST ('react redux')
SELECT * FROM posts MATCH(title, body) AGAINST ('react -redux +follow' IN BOOLEAN MODE)
SELECT * FROM posts MATCH(title, body) AGAINST ('"handling a form"' IN BOOLEAN MODE)
-- IN BOOLEAN MODE: Here, we omit redux keyword appearance result & madatory presence of follow keyword & also the exact match using ""

-- COMPOSITE INDEX: Use it if the query has multiple filters
CREATE INDEX idx_title_body FROM posts (title(7), body(7))
EXPLAIN SELECT customer_id FROM customers WHERE state='CA' AND points >= 1000;

-- List all INDEXES in a TABLE
SHOW INDEXES IN customers;
DROP INDEX idx_title_body ON customers;

-- ORDER of Columns in Composite INDEXS: 1) Put the most frequently used column first in composite index 2) Put the column with the higher cardinality(unique or distinct values in index) first 3) The first column is sorted alphabetically

-- Check the CARDINALITY of columns: Higher the value, higher the CARDINALITY
SELECT COUNT(DISTINCT column1) FROM customers;

-- Some Problems with the order of COLUMNS: Here, we should use state first & then last_name 2nd to get efficient result but does not follow 2nd rule of Composite INDEXES, also here the first where condition is highly restrictive than 2nd one with LIKE...
SELECT customer_id FROM cusstomers WHERE state='DL' AND last_name LIKE 'A%';

-- Another Misc Problem: Using OR OPERATOR
EXPLAIN SELECT customer_id FROM customers WHERE state='DL' OR points>1000;
-- 1) Here, we select all the customers in state & then all cutomers with points greater than 1000 & then we do the UNION of 2 queries
-- 2) Even if you don't do the union, then the query will read all the rows of the table but the source will not be table from disk, rather it is index of column from ram memory which is fast compared to disk access
EXPLAIN SELECT customer_id FROM customers WHERE points+10 > 1000;
-- here, you need to isolate your columns from points+10>1000 to points>990....

-- SORTING INDEXES: If we apply sort to the table with index, then the index is already sorted acc. to the index columns & table primary key...
-- But if we use sort on a table or column with no index for them then, sql uses filesort algo to sort the columns which reads data from disk, uses more time to read & also need to sort the data

-- GET LAST QUERY EXECUTION TIME
SHOW STATUS LIKE 'last_query_cost';

-- SECURING DATABASES:
-- CREATING USER: it accepts username@(ip_address/host_name/domain_name)
-- So here abc user can only connect to the db if they are in the same local machine
-- IDENTIFIED BY: It is followed by the password for the user
CREATE USER abc@127.0.0.1 IDENTIFIED BY 'qwerty'

-- VIEWING USERS(for mySQL)
SELECT * FROM mysql.user

-- DROPING USER
DROP USER abc@127.0.0.1

-- CHANGE/REPLACE PASSWORD
-- for user: 'abc'
SET PASSWORD FOR abc='12345'
-- for admin or current active account:
SET PASSWORD='12345'


-- Granting PRIVILIGES
-- for 'abc' user
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON sql_store.* TO abc@127.0.0.1
-- for admin
GRANT ALL TO *.* TO 'abc'

-- View PROVIIGIES of 'abc' user
SHOW GRANTS FROM 'abc'


-- How to REVOKE any unintended permission given
REVOKE CREATE VIEW ON sql_store FOR 'abc';


-- TRUNCATE: REMOVE Every Record from a TABLE
TRUNCATE TABLE users_archive;
-- DROP: DELETE a TABLE
DROP TABLE users_archive;
SELECT * FROM users;
SELECT * FROM users_archive;
