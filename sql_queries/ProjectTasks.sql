USE library_managment;
-- SELECT * FROM books;
-- SELECT * FROM branch;
-- SELECT * FROM employees;
-- SELECT * FROM issued_status;
-- SELECT * FROM return_status;
-- SELECT * FROM members;

-- DELETE FROM members
-- WHERE member_id = 'C118' OR member_id = 'C119';

-- Project Tasks

-- Task 1. Create a New Book Record 
-- "('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
-- INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher) VALUES
-- ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- Task 2: Update an Existing Member's Address
-- UPDATE members
-- SET member_address = '125 Main St'
-- WHERE member_id = 'C101';

-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
-- DELETE FROM issued_status
-- WHERE issued_id = 'IS121'; #Can't delete those data which has relation with return table

-- Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
-- SELECT * FROM issued_status;
-- WHERE issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.
-- SELECT issued_emp_id, COUNT(issued_id) AS total_book_issued
-- FROM issued_status
-- GROUP BY issued_emp_id
-- HAVING COUNT(issued_id) > 1;

-- CTAS
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results 
-- - each book and total book_issued_cnt**
-- CREATE TABLE book_cnts AS
-- SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS no_issued 
-- FROM books AS b
-- JOIN issued_status AS ist
-- ON ist.issued_book_isbn = b.isbn
-- GROUP BY 1, 2; # Numbers are used to refer to the first and second columns in your SELECT list.

-- SELECT * FROM book_cnts

-- Task 7. Retrieve All Books in a Specific Category:
-- SELECT * FROM books
-- WHERE category = 'Classic';

-- Task 8: Find Total Rental Income by Category: 
-- SELECT b.category, SUM(b.rental_price), COUNT(*)
-- FROM books AS b
-- JOIN issued_status AS ist
-- ON ist.issued_book_isbn = b.isbn
-- GROUP BY 1;

-- Task 9: List Members Who Registered in the Last 1420 Days:
-- SELECT * FROM members
-- WHERE reg_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 1420 DAY);

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:
-- Select * FROM employees;
-- Select * FROM branch;
-- SELECT e1.*, e2.emp_name AS manager, #because we need manager details
-- b.manager_id
-- FROM employees AS e1
-- LEFT JOIN branch AS b ON b.branch_id = e1.branch_id #Joining two tables(employee and branch)
-- JOIN employees AS e2 ON b.manager_id = e2.emp_id #self joining by manager id so that we get only manager detail

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold(7 USD):
-- CREATE TABLE books_expensive AS
-- (SELECT * FROM books
-- WHERE rental_price > 7.0);
-- SELECT * FROM books_expensive;

-- Task 12: Retrieve the List of Books Not Yet Returned
-- SELECT DISTINCT ist.issued_book_name FROM issued_status AS ist
-- LEFT JOIN return_status AS rs ON ist.issued_id = rs.issued_id
-- WHERE rs.return_id IS NULL;