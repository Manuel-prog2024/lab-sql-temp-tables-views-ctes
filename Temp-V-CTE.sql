USE sakila;
-- Step 1: First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW customer_rental_summary AS
SELECT cus.customer_id, CONCAT(cus.first_name, '  ', cus.last_name) AS customer_name, cus.email, COUNT(ren.rental_id) AS rental_count
FROM customer as cus
-- 2 tables (customer and rental) with 1 join (common column: customer_id)
JOIN rental as ren
ON cus.customer_id = ren.customer_id
GROUP BY cus.customer_id; 
 

-- Step 2: Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table 
-- and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
		customer_rental_summary.customer_id,
		customer_rental_summary.customer_name,
		customer_rental_summary.email,
		customer_rental_summary.rental_count,
		SUM(payment.amount) AS total_paid
FROM customer_rental_summary
JOIN rental 
ON customer_rental_summary.customer_id = rental.customer_id
JOIN payment 
ON rental.rental_id = payment.rental_id
GROUP BY customer_rental_summary.customer_id;


-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.
-- Next, using the CTE, create the query to generate the final customer summary report, which should include: 
-- customer name, email, rental_count, total_paid and average_payment_per_rental, 
-- this last column is a derived column from total_paid and rental_count.


WITH final_customer_summary_report AS (
  SELECT
    customer_rental_summary.customer_name,
    customer_rental_summary.email,
    customer_rental_summary.rental_count,
    customer_payment_summary.total_paid
  FROM customer_rental_summary
  JOIN customer_payment_summary 
  ON customer_rental_summary.customer_id = customer_payment_summary.customer_id
 ) 
