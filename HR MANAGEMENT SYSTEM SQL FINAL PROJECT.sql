# Create Database
CREATE DATABASE hr_payroll;
USE hr_payroll;
SHOW DATABASES;
#Create Tables departments 
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) UNIQUE NOT NULL,
    location VARCHAR(50)
);
#Create Tables employees
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    hire_date DATE NOT NULL,
    dept_id INT,
    job_role VARCHAR(50),
    CONSTRAINT fk_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id),
    CONSTRAINT chk_role CHECK (job_role IN ('Developer','Manager','HR','Accountant','Tester'))
);
#CREATE TABLE projects
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE
);
#CREATE TABL Eemployee_projects (Many-to-Many)
CREATE TABLE employee_projects (
    emp_id INT,
    project_id INT,
    role VARCHAR(50),
    PRIMARY KEY(emp_id, project_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);
#CREATE TABLE salaries
CREATE TABLE salaries (
    salary_id INT PRIMARY KEY,
    emp_id INT,
    basic_salary DECIMAL(10,2) NOT NULL,
    bonus DECIMAL(10,2) DEFAULT 0,
    deductions DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);
#CREATE TABLE ATTENDANCE
CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY,
    emp_id INT,
    date DATE,
    status VARCHAR(10) CHECK (status IN ('Present','Absent','Leave')),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);
#INSERT INTO VALUES DEPARTMENTS
INSERT INTO departments VALUES
(1, 'HR', 'Pune'),
(2, 'Development', 'Pune'),
(3, 'Finance', 'Mumbai'),
(4, 'QA', 'Pune'),
(5, 'Management', 'Mumbai');
#INSERT INTO VALUES employees
INSERT INTO employees VALUES
(101, 'Amit Sharma','amit@company.com','9876543210','2022-01-10',2,'Developer'),
(102, 'Priya Singh','priya@company.com','9922334455','2021-03-15',1,'HR'),
(103, 'Rahul Verma','rahul@company.com','8811223344','2020-07-22',2,'Manager'),
(104, 'Neha Joshi','neha@company.com','9988776655','2023-02-10',4,'Tester'),
(105, 'Karan Patel','karan@company.com','9090909090','2019-11-01',3,'Accountant'),
(106, 'Sonia Mehta','sonia@company.com','8899001122','2021-04-19',2,'Developer');

#INSERT INTO VALUES PROJECTS
INSERT INTO projects VALUES
(1,'Payroll System','2023-01-01','2023-06-30'),
(2,'E-Commerce Portal','2023-02-01','2023-09-30'),
(3,'Mobile App','2023-03-15','2023-12-31');

#INSERT INTO VALUES employee_projects
INSERT INTO employee_projects VALUES
(101,1,'Developer'),
(101,2,'Developer'),
(102,1,'HR Support'),
(103,2,'Manager'),
(106,3,'Developer'),
(104,2,'Tester');

#INSERT INTO VALUES salaries
INSERT INTO salaries VALUES
(1,101,60000,5000,2000),
(2,102,45000,3000,1000),
(3,103,80000,7000,5000),
(4,104,40000,2000,500),
(5,105,55000,4000,1500),
(6,106,62000,6000,2500);

#INSERT INTO VALUES ATTENDANCE
INSERT INTO attendance VALUES
(1,101,'2023-12-01','Present'),
(2,102,'2023-12-01','Absent'),
(3,103,'2023-12-01','Present'),
(4,104,'2023-12-01','Leave'),
(5,105,'2023-12-01','Present'),
(6,106,'2023-12-01','Present');

# SQL Tasks - Actual Project 
#[1]. Basic Queries 

#[1]List all employees 
SELECT * FROM employees;

#[2]Employees hired after 2021
select * from employees
where hire_date>2021;
#[3]HR department employees 
select * from departments
where dept_name="HR";
#----0r----
select e.* from employees e
join departments d
on e.dept_id=d.dept_id
where d.dept_name="HR";

#[2]. Filtering & Sorting

#1. Employees with salary > 50,000
select e.emp_name,s.basic_salary from employees e
join salaries s
on e.emp_id=s.emp_id
where s.basic_salary >5000;

#2. Order employees by hire_date
select hire_date from employees
order by hire_date asc;
#---desc order
select hire_date from employees
order by hire_date desc;
#3. Employees not in Development department
select e.* from employees e
join departments d
on e.dept_id=d.dept_id
where d.dept_name !="Development";

#[3]. Aggregate Functions**

#[1]. Count employees in each department
SELECT dept_id, COUNT(*) AS total_employees
FROM employees
GROUP BY dept_id;
#[2]. Avg salary of developers
SELECT AVG(s.basic_salary) AS avg_salary
FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id
WHERE e.job_role = 'Developer';
#[3]. Max salary in company
SELECT MAX(basic_salary) AS max_salary
FROM salaries;

#[4]D. GROUP BY + HAVING Clause**
#1. Avg salary per department
SELECT dept_id, AVG(basic_salary) AS avg_salary
FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id
GROUP BY dept_id;
#----or---
SELECT d.dept_name, AVG(s.basic_salary) AS avg_salary
FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;
#2. Departments with more than 2 employees
SELECT dept_id, COUNT(*) AS total_employees
FROM employees
GROUP BY dept_id
HAVING COUNT(*) > 2;
#[5]Joins (All Types)**
#1. Employees with departments
SELECT e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id;
#2. Employees with their salary details
SELECT e.emp_name, s.basic_salary, s.bonus, s.deductions
FROM employees e
INNER JOIN salaries s
ON e.emp_id = s.emp_id;
#3. Projects with assigned employees
SELECT p.project_name, e.emp_name
FROM projects p
INNER JOIN employee_projects ep
ON p.project_id = ep.project_id
INNER JOIN employees e
ON ep.emp_id = e.emp_id;

#4. Departments with no employees (RIGHT JOIN)
SELECT d.dept_name
FROM employees e
RIGHT JOIN departments d
ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL;
#5. Full join alternative using UNION
SELECT e.emp_name, d.dept_name
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id
UNION
SELECT e.emp_name, d.dept_name
FROM employees e
RIGHT JOIN departments d
ON e.dept_id = d.dept_id;

#F. Subqueries/ Nested Queries**

#[1]. Employees earning more than company avg
SELECT emp_name, basic_salary
FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id
WHERE s.basic_salary > (SELECT AVG(basic_salary) FROM salaries);

#2. Highest earning employee
SELECT emp_name, basic_salary
FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id
WHERE s.basic_salary = (SELECT MAX(basic_salary) FROM salaries);

#3. Employees not assigned to any project
SELECT emp_name
FROM employees e
WHERE emp_id NOT IN (SELECT emp_id FROM employee_projects);

#8. Nested Subqueries**

#[1]. Second highest salary
SELECT emp_name, basic_salary
FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id
WHERE s.basic_salary = (
    SELECT MAX(basic_salary) 
    FROM salaries
    WHERE basic_salary < (SELECT MAX(basic_salary) FROM salaries)
);

#[2]. Projects with more than 2 employees
SELECT project_name
FROM projects p
WHERE project_id IN (
    SELECT project_id
    FROM employee_projects
    GROUP BY project_id
    HAVING COUNT(emp_id) > 2
);

#[3]. Departments having avg salary > finance
SELECT d.dept_name
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
JOIN salaries s ON e.emp_id = s.emp_id
GROUP BY d.dept_id, d.dept_name
HAVING AVG(s.basic_salary) > (
    SELECT AVG(s.basic_salary)
    FROM employees e
    JOIN salaries s ON e.emp_id = s.emp_id
    WHERE e.dept_id = (SELECT dept_id FROM departments WHERE dept_name = 'Finance')
);


# [9]. Views

# 1. High earners
CREATE VIEW high_earners AS
SELECT emp_id, basic_salary
FROM salaries
WHERE basic_salary > 60000;

# 2. Department-wise salary summary
CREATE VIEW dept_salary_summary AS
SELECT d.dept_name, AVG(s.basic_salary) AS avg_salary
FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id
JOIN departments d ON d.dept_id = e.dept_id
GROUP BY d.dept_name;
# 3. Employee project allocation
CREATE VIEW employee_project_view AS
SELECT e.emp_name, p.project_name, ep.role
FROM employees e
JOIN employee_projects ep ON e.emp_id = ep.emp_id
JOIN projects p ON p.project_id = ep.project_id;
