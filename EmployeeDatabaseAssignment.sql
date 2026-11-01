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

-- display table Employees

SELECT * FROM Employees;

-- Add a new column named "email" to the Employees table to store employee email addresses.

ALTER TABLE employees
ADD COLUMN email VARCHAR(100);
    
DESC Employees;

-- Modify the data type of the "designation" column in the Employees table to support a wider range of values.

ALTER TABLE employees
MODIFY COLUMN designation VARCHAR(255);

DESC Employees;

-- Drop the “age” column from the Employees table

ALTER TABLE employees
DROP COLUMN age;

DESC Employees;

-- Rename the “hire_date” column to “date_of_joining”.

ALTER TABLE employees
RENAME COLUMN hire_date TO date_of_joining;

DESC Employees;

-- Rename the "Departments" table to "Departments_Info".

RENAME TABLE Departments to Department_Info;

SHOW tables;

-- Rename the "Location" table to "Locations".

RENAME TABLE Location to Locations;

SHOW tables;

-- Table Truncation (TRUNCATE): Write an SQL statement to truncate the Employees table.

TRUNCATE TABLE employees;

-- Database & Table Dropping (DROP): Write the SQL statements to drop the Employees table and then the “employee” database Constraints
DROP TABLE employees;
    
DROP DATABASE Employee;