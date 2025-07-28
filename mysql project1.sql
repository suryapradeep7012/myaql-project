CREATE DATABASE CompanyHR;
USE CompanyHR;
-- create table employees
CREATE TABLE Employees (
  employee_id INT AUTO_INCREMENT PRIMARY KEY,
  employee_name VARCHAR(255) NOT NULL,
  department VARCHAR(100),
  position VARCHAR(100),
  hire_date DATE,
  base_salary DECIMAL(10,2) NOT NULL
);
-- create table attendance
CREATE TABLE Attendance (
  attendance_id INT AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  attendance_date DATE NOT NULL,
  status ENUM('Present','Absent','Leave') NOT NULL
);
-- create table salaries
CREATE TABLE Salaries (
  salary_id INT AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  base_salary DECIMAL(10,2) NOT NULL,
  bonus DECIMAL(10,2) DEFAULT 0,
  deductions DECIMAL(10,2) DEFAULT 0,
  month VARCHAR(20) NOT NULL,
  year INT NOT NULL
);
-- create table payroll
CREATE TABLE Payroll (
  payroll_id INT AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  total_salary DECIMAL(10,2) NOT NULL,
  payment_date DATE NOT NULL
  );
  -- insert datas into employees
  INSERT INTO Employees (employee_name, department, position, hire_date, base_salary) VALUES
  ('Alan Vince',   'Finance', 'Manager',        '2020-01-15', 50000.00),
  ('Alex Kent',    'HR',      'HR Specialist',  '2019-03-10', 40000.00),
  ('Jennith Kery', 'Sales',   'Sales Executive','2023-10-01', 30000.00);
-- insert datas into attendance
INSERT INTO Attendance (employee_id, attendance_date, status) VALUES
  (1, '2023-09-01', 'Present'),
  (2, '2023-09-01', 'Leave'),
  (1, '2023-09-02', 'Present'),
  (3, '2023-10-01', 'Present');
-- insert data into salaries
INSERT INTO Salaries (employee_id, base_salary, bonus, deductions, month, year) VALUES
  (1, 50000.00, 5000.00, 2000.00, 'September', 2023),
  (2, 40000.00, 3000.00, 1000.00, 'September', 2023),
  (3, 30000.00, 2000.00, 500.00,  'October',   2023);
-- INSERT DATAS INTO payroll
INSERT INTO Payroll (employee_id, total_salary, payment_date) VALUES
  (1, 53000.00, '2023-09-30'),
  (2, 42000.00, '2023-09-30'),
  (3, 31500.00, '2023-10-31');
 -- updated employee details
 UPDATE Employees
SET department = 'IT',
    position   = 'Manager',
    base_salary = 75000
WHERE employee_id = 123;
  -- Delete irrelevant records
  DELETE FROM Employees WHERE employee_id = 123;
SELECT * FROM Attendance;

select 
employees.employee_name as Name_EMP,
SUM(salaries.base_salary)AS total_base_salary,
SUM(salaries.bonus)AS total_bonus,
SUM(salaries.deductions)AS total_deductions,
SUM(salaries.base_salary+salaries.bonus-salaries.deductions)AS total_salary 
from employees
inner join 
salaries on employees.employee_id = salaries.salary_id
group by employees.employee_name;

SET SQL_SAFE_UPDATES=1;

SET SQL_SAFE_UPDATES=0;
-- manage deductions and bonuses
UPDATE Salaries SET bonus=6000,deductions=400
where employee_id=1;
UPDATE Salaries SET bonus=4000,deductions=300
where employee_id=2;
UPDATE Salaries SET bonus=2000,deductions=200
where employee_id=3;
UPDATE Salaries SET bonus=2000,deductions=200
where employee_id=3;
UPDATE Salaries SET bonus=1000,deductions=100
where employee_id=4;
--  payroll records
SELECT 
  e.employee_id,
  e.employee_name,
  p.total_salary,
  p.payment_date
FROM Employees AS e
INNER JOIN Payroll AS p
  ON e.employee_id = p.employee_id;
-- generate payment slip
 SELECT
  e.employee_id,
  e.employee_name,
  SUM(s.base_salary)    AS total_base_salary,
  SUM(s.bonus)          AS total_bonus,
  SUM(s.deductions)     AS total_deductions,
  SUM(s.base_salary + s.bonus - s.deductions) AS total_salary
FROM Employees AS e
INNER JOIN Salaries AS s
  ON e.employee_id = s.employee_id
WHERE e.employee_id = 1
GROUP BY
  e.employee_id, e.employee_name;
    
SELECT
  e.employee_id,
  e.employee_name,
  SUM(s.base_salary)    AS total_base_salary,
  SUM(s.bonus)          AS total_bonus,
  SUM(s.deductions)     AS total_deductions,
  SUM(s.base_salary + s.bonus - s.deductions) AS total_salary
FROM Employees AS e
INNER JOIN Salaries AS s
  ON e.employee_id = s.employee_id
WHERE e.employee_id = 2
GROUP BY
  e.employee_id, e.employee_name;
  
  SELECT
  e.employee_id,
  e.employee_name,
  SUM(s.base_salary)    AS total_base_salary,
  SUM(s.bonus)          AS total_bonus,
  SUM(s.deductions)     AS total_deductions,
  SUM(s.base_salary + s.bonus - s.deductions) AS total_salary
FROM Employees AS e
INNER JOIN Salaries AS s
  ON e.employee_id = s.employee_id
WHERE e.employee_id = 3
GROUP BY
  e.employee_id, e.employee_name;

SELECT
  e.employee_id,
  e.employee_name,
  SUM(s.base_salary)    AS total_base_salary,
  SUM(s.bonus)          AS total_bonus,
  SUM(s.deductions)     AS total_deductions,
  SUM(s.base_salary + s.bonus - s.deductions) AS total_salary
FROM Employees AS e
INNER JOIN Salaries AS s
  ON e.employee_id = s.employee_id
WHERE e.employee_id = 4
GROUP BY
  e.employee_id, e.employee_name;

SELECT 
  e.employee_id,
  e.employee_name,
  s.month,
  s.year,
  s.base_salary,
  s.bonus,
  s.deductions,
  (s.base_salary + s.bonus - s.deductions) AS total_salary,
  p.payment_date
FROM Employees e
JOIN Salaries s ON e.employee_id = s.employee_id
JOIN Payroll p ON e.employee_id = p.employee_id
WHERE s.month = 'September' AND s.year = 2023;
-- payroll reports overall
SELECT
  s.year,
  s.month,
  SUM(s.base_salary + s.bonus - s.deductions) AS total_net_pay,
  COUNT(DISTINCT s.employee_id) AS num_employees
FROM Salaries s
GROUP BY s.year, s.month
ORDER BY s.year DESC, FIELD(s.month,
  'January','February', 'March','April','May','June',
  'July','August','September','October','November','December');
