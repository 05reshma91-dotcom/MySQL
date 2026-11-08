CREATE DATABASE Employee;
use Employee; 

-- table Departments

CREATE TABLE Departments(
department_id INT PRIMARY KEY AUTO_INCREMENT,
department_name VARCHAR(100) Not NULL UNIQUE);

-- inserting values into table Departments

Insert into Departments (department_name)
 values 
	('Human Resources'),
    ('Finance'),
    ('IT'),
    ('Marketing'),
    ('Sales'),
    ('Operations'),
    ('Research and Development'),
    ('Customer Service'),
    ('Administration'),
    ('Legal');
Insert into Departments (department_name)
 values   
     ('Security'),
    ('Logistics'),
    ('Training'); 
-- display TABLE departments

SELECT * FROM Departments;

-- table 2 : Location

CREATE TABLE Location ( 
location_id int PRIMARY KEY AUTO_INCREMENT,
location VARCHAR(30) NOT NULL UNIQUE);

-- inserting values into table Location

INSERT INTO Location (location)
VALUES 
 ('Chennai'),
    ('Bangalore'),
    ('Mumbai'),
    ('Delhi'),
    ('Hyderabad');
    
-- display TABLE Location

SELECT * FROM Location;

-- table 3 : Employees

CREATE TABLE Employees (
employee_id INT PRIMARY KEY AUTO_INCREMENT,
employee_name VARCHAR(50) NOT NULL UNIQUE,
gender ENUM('F','M'),
age int CHECK (age >= 18),
hire_date Date DEFAULT (current_date()),
designation Varchar(100),
department_id int,
location_id int,
salary Decimal(10,2),
Foreign Key (department_id)
	references Departments(department_id),
Foreign Key (location_id)
	references Location(location_id));
    
-- inserting VALUES into table employees

INSERT INTO employees
(employee_name, gender, age, hire_date, designation,
 department_id, location_id, salary)
VALUES
('Arun Kumar', 'M', 25, DEFAULT, 'Manager', 1, 1, 45000),
('Priya Sharma', 'F', 28, DEFAULT, 'HR Executive', 2, 2, 35000),
('Rahul Verma', 'M', 30, DEFAULT, 'Software Developer', 3, 3, 50000),
('Anjali Nair', 'F', 24, DEFAULT, 'Accountant', 4, 4, 32000),
('Vijay Kumar', 'M', 35, DEFAULT, 'Sales Executive', 5, 5, 40000),
('Sneha Reddy', 'F', 27, DEFAULT, 'Operations Manager', 6, 1, 55000),
('Amit Patel', 'M', 29, DEFAULT, 'Research Analyst', 7, 2, 42000),
('Divya Menon', 'F', 26, DEFAULT, 'Customer Support', 8, 3, 30000),
('Kiran Das', 'M', 32, DEFAULT, 'Administrator', 9, 4, 38000),
('Meera Joseph', 'F', 31, DEFAULT, 'Legal Advisor', 10, 5, 60000);

INSERT INTO Employees
(employee_name, gender, age, hire_date, designation,
 department_id, location_id, salary)
VALUES
('Ravi Kumar', 'M', 25, '2017-05-12', NULL, 1, 1, 55000),
('Sneha Nair', 'F', 28, '2018-08-20', NULL, 2, 2, 60000),
('Arun Das', 'M', 30, '2019-03-15', NULL, 3, 3, 65000),
('Priya Menon', 'F', 26, '2020-11-10', NULL, 4, 4, 48000),
('Vijay Sharma', 'M', 32, '2021-06-25', NULL, 5, 5, 70000);

INSERT INTO Employees
(employee_name, gender, age, hire_date, designation,
 department_id, location_id, salary)
VALUES
('Akhil Kumar', 'M', 25, '2018-01-15', 'Software Developer', 1, 1, 45000),
('Rahul Sharma', 'M', 29, '2018-05-10', 'Accountant', 3, 3, 42000);

-- display table Employees

SELECT * FROM Employees;

-- a query to retrieve distinct salaries from the Employees table.

SELECT DISTINCT salary FROM employees;

-- Provide aliases for the "age" and "salary" columns as "Employee_Age" and "Employee_Salary", respectively.

SELECT 
employee_name, 
age AS Employee_Age, 
salary AS Employee_Salary 
FROM employees;

-- Retrieve employees with a salary greater than ₹50000 and hired before 2016-01-01.

SELECT * 
FROM employees 
WHERE salary > 50000 
AND hire_date < '2016-01-01';

-- Find the employee whose designation is missing and fill it with "Data Scientist".

SELECT *
FROM Employees
WHERE designation IS NULL;

SET SQL_SAFE_UPDATES = 0;

UPDATE Employees
SET designation = 'Data Scientist'
WHERE designation IS NULL;

SELECT *
FROM Employees;

-- ORDER BY : Find employees sorted by department ID in ascending order and salary in descending order.

SELECT * 
FROM employees
ORDER BY department_id ASC, salary DESC;

-- Display the first 5 employees hired in the year 2018.

SELECT *
FROM Employees
WHERE year(hire_date)='2018'
ORDER BY hire_date ASC
LIMIT 5;

-- Calculate the sum of all salaries in the Finance department.

SELECT department_id 
FROM departments 
WHERE department_name='Finance';

SELECT SUM(salary) AS Total_Salary
FROM employees
WHERE department_id=2;

-- OR

SELECT SUM(e.salary) AS Total_Salary
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE d.department_name='Finance';

-- Find the minimum age among all employees.

SELECT MIN(age) AS Minimum_age
FROM Employees;

-- List the maximum salary for each location.

SELECT l.location, MAX(e.salary) as Maximum_Salary
FROM employees e
JOIN location l
ON e.location_id=l.location_id
GROUP BY l.location;

-- Calculate the average salary for each designation containing the word 'Analyst'.

SELECT designation, avg(salary) AS Average_Salary
FROM employees 
WHERE designation LIKE "%analyst%"
GROUP BY designation;

-- Find departments with less than 3 employees.

SELECT d.department_id,d.department_name, COUNT(*) as Countof_employees
FROM employees e
join departments d
WHERE e.department_id=d.department_id
GROUP BY department_id
HAVING count(*)< 3;

-- Find locations with female employees whose average age is below 30.

SELECT location_id, AVG(age) AS Average_Age
FROM Employees
WHERE gender = 'F'
GROUP BY location_id
HAVING AVG(age) < 30;

-- INNER JOIN : List employee names, their designations, and department names where employees are assigned to a department.

SELECT e.employee_name, e.designation, d.department_name
FROM employees e
INNER JOIN departments d
ON e.department_id=d.department_id;

-- LEFT JOIN: List all departments along with the total number of employees in each department, including departments with no employees.

SELECT d.department_name, count(e.employee_id) AS Total_numof_Employees
FROM departments d
LEFT JOIN employees e
ON d.department_id=e.department_id
GROUP BY d.department_id,d.department_name;

-- RIGHT JOIN: Display all locations along with the names of employees assigned to each location. If no employees are assigned to a location, display NULL for employee name.

SELECT 
    l.location,
    e.employee_name
FROM Employees e
RIGHT JOIN Location l
ON e.location_id = l.location_id;
