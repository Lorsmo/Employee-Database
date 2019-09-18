DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS titles;
DROP TABLE IF EXISTS salaries;

CREATE TABLE employees (
    emp_no INTEGER PRIMARY KEY  NOT NULL,
    birth_date DATE   NOT NULL,
    first_name VARCHAR(50)   NOT NULL,
    last_name VARCHAR(50)   NOT NULL,
    gender VARCHAR(5)   NOT NULL,
    hire_date DATE   NOT NULL
);

CREATE TABLE departments (
    dept_no VARCHAR(10) PRIMARY KEY   NOT NULL,
    dept_name VARCHAR(50)   NOT NULL
);

CREATE TABLE dept_emp (
	emp_no INTEGER   NOT NULL,
    dept_no VARCHAR(10)   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL,
	FOREIGN KEY(emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY(dept_no) REFERENCES departments (dept_no)	
);

CREATE TABLE dept_manager (
    dept_no VARCHAR(10)   NOT NULL,
    emp_no INTEGER   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL,
	FOREIGN KEY(dept_no) REFERENCES departments (dept_no),
	FOREIGN KEY(emp_no) REFERENCES employees (emp_no)	
);

CREATE TABLE salaries (
    emp_no INTEGER   NOT NULL,
    salary MONEY   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL,
	FOREIGN KEY(emp_no) REFERENCES employees (emp_no)
);

CREATE TABLE titles (
    emp_no INTEGER   NOT NULL,
    title VARCHAR(50)   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL,
	FOREIGN KEY(emp_no) REFERENCES employees (emp_no)
);

-- List the following details of each employee: employee number, last name, first name, gender, and salary.
SELECT e.emp_no, e.last_name, e.first_name, e.gender, s.salary
FROM employees e
JOIN salaries s
ON e.emp_no = s.emp_no;

-- List employees who were hired in 1986.
SELECT *
FROM employees
WHERE EXTRACT(YEAR FROM "hire_date") = 1986

-- List the manager of each department with the following information: department number, department name,
-- the manager's employee number, last name, first name, and start and end employment dates.
SELECT dm.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name, dm.from_date, dm.to_date
FROM dept_manager dm
JOIN departments d
ON dm.dept_no = d.dept_no
JOIN employees e
ON dm.emp_no = e.emp_no
ORDER BY dm.dept_no;

-- List the department of each employee with the following information: employee number, last name,
-- first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
JOIN dept_emp de
ON e.emp_no = de.emp_no
JOIN departments d
ON de.dept_no = d.dept_no ;

-- List all employees whose first name is "Hercules" and last names begin with "B."
SELECT * 
FROM employees
WHERE 
	first_name = 'Hercules'
	AND last_name LIKE 'B%';
	
-- List all employees in the Sales department, including their employee number, last name, first name,
-- and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
JOIN dept_emp de
ON e.emp_no = de.emp_no
JOIN departments d
ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales'
;

-- List all employees in the Sales and Development departments, including their employee number, last name,
-- first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
JOIN dept_emp de
ON e.emp_no = de.emp_no
JOIN departments d
ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales'
OR d.dept_name = 'Development'
;

-- In descending order, list the frequency count of employee last names, i.e.,
-- how many employees share each last name.
SELECT e.last_name,
COUNT(e.last_name) as count_last_names
FROM employees e
GROUP BY e.last_name
ORDER BY count_last_names DESC
;