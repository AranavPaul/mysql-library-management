USE library_managment;

-- ALTER TABLE return_status
-- ADD Column book_quality VARCHAR(15) DEFAULT('Good');

-- UPDATE return_status
-- SET book_quality = 'Damaged'
-- WHERE issued_id 
--     IN ('IS112', 'IS117', 'IS118');
-- SELECT * FROM return_status;

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;

/*
Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.
-- */

-- Pseudocode
-- issued_status == member == books == return_status
-- filter books which is return
-- overdue > 30

-- -- SELECT ist.issued_member_id,  m.member_name, bk.book_title, ist.issued_date,
-- -- CURRENT_DATE - ist.issued_date AS overdue_date  FROM issued_status AS ist
-- -- INNER JOIN members AS m ON m.member_id = ist.issued_member_id
-- -- INNER JOIN books AS bk ON bk.isbn = ist.issued_book_isbn
-- -- LEFT JOIN return_status AS rs ON rs.issued_id = ist.issued_id
-- -- WHERE rs.return_date IS NULL AND (CURRENT_DATE - ist.issued_date) > 30
-- -- ORDER BY 5;

/*
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned 
(based on entries in the return_status table).
*/

-- Check issued_status first 
-- Change the return status
 -- INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
--  VALUES ('RS125', 'IS130', CURRENT_DATE, 'Good');
 -- Change status in book table to 'yes'
-- UPDATE books
-- SET status = 'yes'
-- WHERE isbn = '978-0-451-52994-2'
-- DROP PROCEDURE IF EXISTS add_return_records;
-- Stored Procedures
-- DELIMITER //
-- CREATE PROCEDURE add_return_records(
--     IN p_return_id VARCHAR(10),
--     IN p_issued_id VARCHAR(10),
--     IN p_book_quality VARCHAR(15) 
-- )
-- BEGIN
-- 	DECLARE v_isbn VARCHAR(50);
-- 	DECLARE v_book_name VARCHAR(80);
--     -- inserting into returns based on users_input
--     INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
--     VALUES (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);
--     
--     SELECT issued_book_isbn, issued_book_name
--     INTO v_isbn, v_book_name
--     FROM issued_status
--     WHERE issued_id = p_issued_id;
--     UPDATE books
-- 	SET status = 'yes'
-- 	WHERE isbn = v_isbn;
--     
--     SELECT 'Thank you for returning the book:', v_book_name;
-- END //
-- -- Change the delimiter back to the default
-- DELIMITER ;
-- CALL add_return_records('RS140', 'IS135', 'Good');

-- Task 15: Branch Performance Report
-- Create a query that generates a performance report for each branch, showing the number of books issued, 
-- the number of books returned, and the total revenue generated from book rentals.

-- CREATE TABLE branch_reports AS
-- SELECT b.branch_id, b.manager_id, COUNT(ist.issued_id) AS number_books_issued, 
-- COUNT(rs.return_id) AS number_of_book_return, SUM(rental_price) AS total_revenue 
-- FROM issued_status AS ist #issued table
-- JOIN employees AS e #employee table
-- ON e.emp_id = ist.issued_emp_id
-- JOIN branch AS b #branch table
-- ON e.branch_id = b.branch_id
-- LEFT JOIN return_status AS rs #return_status table
-- ON rs.issued_id = ist.issued_id
-- JOIN books AS bk #book table
-- ON ist.issued_book_isbn = bk.isbn
-- GROUP BY 1,2;

-- SELECT * FROM branch_reports;

-- Task 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members 
-- containing members who have issued at least one book in the last 2 months.

-- CREATE TABLE active_members AS
-- SELECT * FROM members
-- WHERE member_id IN(
-- 	SELECT DISTINCT issued_member_id FROM issued_status
-- 	WHERE issued_date >= CURRENT_DATE - INTERVAL 2 MONTH);
-- SELECT * FROM active_members;

-- Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. 
-- Display the employee name, number of books processed, and their branch.

SELECT e.emp_name, b.*, COUNT(ist.issued_id) AS no_book_issued
FROM issued_status AS ist
LEFT JOIN employees AS e
ON e.emp_id = ist.issued_emp_id
JOIN branch AS b
ON e.branch_id = b.branch_id
GROUP BY 1,2
ORDER BY no_book_issued DESC
LIMIT 3;


/*
Task 18: Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system. 
Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 
The procedure should function as follows: 
The stored procedure should take the book_id as an input parameter. 
The procedure should first check if the book is available (status = 'yes'). 
If the book is available, it should be issued, and the status in the books table should be updated to 'no'. If 
the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
*/

-- DROP PROCEDURE IF EXISTS issue_book;

-- DELIMITER $$

-- CREATE PROCEDURE issue_book(
--     IN p_issued_id VARCHAR(10),
--     IN p_issued_member_id VARCHAR(30),
--     IN p_issued_book_isbn VARCHAR(30),
--     IN p_issued_emp_id VARCHAR(10)
-- )
-- BEGIN
--     DECLARE v_status VARCHAR(10);

--     -- Fetch current status of the book
--     SELECT status INTO v_status
--     FROM books
--     WHERE isbn = p_issued_book_isbn;

--     -- Check if book is available
--     IF v_status = 'yes' THEN
--         INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
--         VALUES (p_issued_id, p_issued_member_id, CURRENT_DATE(), p_issued_book_isbn, p_issued_emp_id);

--         UPDATE books
--         SET status = 'no'
--         WHERE isbn = p_issued_book_isbn;

--         SELECT CONCAT('Book records added successfully for book ISBN: ', p_issued_book_isbn) AS message;
--     ELSE
--         SELECT CONCAT('Sorry, the book you requested is unavailable. Book ISBN: ', p_issued_book_isbn) AS message;
--     END IF;
-- END $$

-- DELIMITER ;
-- SELECT * FROM books;
-- -- "978-0-553-29698-2" -- yes
-- -- "978-0-375-41398-8" -- no
-- SELECT * FROM issued_status;

-- CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
-- CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');

-- SELECT * FROM books
-- WHERE isbn = '978-0-375-41398-8'