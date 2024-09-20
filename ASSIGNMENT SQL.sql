create database assignmenthr ;
use assignmenthr ;
/* *************************************************************** 
***************************CREATING TABLES************************
**************************************************************** */
CREATE TABLE regions (
	region_id INT (11) UNSIGNED NOT NULL,
	region_name VARCHAR(25),
	PRIMARY KEY (region_id)
	);

CREATE TABLE countries (
	country_id CHAR(2) NOT NULL,
	country_name VARCHAR(40),
	region_id INT (11) UNSIGNED NOT NULL,
	PRIMARY KEY (country_id)
);


CREATE TABLE locations (
	location_id INT (11) UNSIGNED NOT NULL AUTO_INCREMENT,
	street_address VARCHAR(40),
	postal_code VARCHAR(12),
	city VARCHAR(30) NOT NULL,
	state_province VARCHAR(25),
	country_id CHAR(2) NOT NULL,
	PRIMARY KEY (location_id)
	);

CREATE TABLE departments (
	department_id INT (11) UNSIGNED NOT NULL,
	department_name VARCHAR(30) NOT NULL,
	manager_id INT (11) UNSIGNED,
	location_id INT (11) UNSIGNED,
	PRIMARY KEY (department_id)
	);

CREATE TABLE jobs (
	job_id VARCHAR(10) NOT NULL,
	job_title VARCHAR(35) NOT NULL,
	min_salary DECIMAL(8, 0) UNSIGNED,
	max_salary DECIMAL(8, 0) UNSIGNED,
	PRIMARY KEY (job_id)
	);

CREATE TABLE employees (
	employee_id INT (11) UNSIGNED NOT NULL,
	first_name VARCHAR(20),
	last_name VARCHAR(25) NOT NULL,
	email VARCHAR(25) NOT NULL,
	phone_number VARCHAR(20),
	hire_date DATE NOT NULL,
	job_id VARCHAR(10) NOT NULL,
	salary DECIMAL(8, 2) NOT NULL,
	commission_pct DECIMAL(2, 2),
	manager_id INT (11) UNSIGNED,
	department_id INT (11) UNSIGNED,
	PRIMARY KEY (employee_id)
	);

CREATE TABLE job_history (
	employee_id INT (11) UNSIGNED NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	job_id VARCHAR(10) NOT NULL,
	department_id INT (11) UNSIGNED NOT NULL
	);

ALTER TABLE job_history ADD UNIQUE INDEX (
	employee_id,
	start_date
	);


CREATE VIEW emp_details_view
AS
SELECT e.employee_id,
	e.job_id,
	e.manager_id,
	e.department_id,
	d.location_id,
	l.country_id,
	e.first_name,
	e.last_name,
	e.salary,
	e.commission_pct,
	d.department_name,
	j.job_title,
	l.city,
	l.state_province,
	c.country_name,
	r.region_name
FROM employees e,
	departments d,
	jobs j,
	locations l,
	countries c,
	regions r
WHERE e.department_id = d.department_id
	AND d.location_id = l.location_id
	AND l.country_id = c.country_id
	AND c.region_id = r.region_id
	AND j.job_id = e.job_id;
    
                                                                   -- Assignment Questions--
 -- 1.) Display all information in the tables EMP and DEPT.--     
select * from employees ;
select * from departments ;
-- 2.) Display only the hire date and employee name for each employee.  --
select hire_date,concat(first_name,'',last_name) as full_name from employees ;
-- 3.)  Display the ename concatenated with the job ID, separated by a comma and space, and name the column Employee and Title --
SELECT CONCAT(first_name, ' ', last_name, ', ', job_id) AS `Employee and Title` 
FROM employees;
-- 4.)  Display the hire date, name and department number for all clerks.  --
SELECT e.hire_date,CONCAT(e.first_name, ' ', e.last_name) AS employee_name,e.department_id 
FROM employees e
 WHERE e.job_id = 'pu_clerk';
-- 5.) Create a query to display all the data from the EMP table. Separate each column by a comma. Name the column THE OUTPUT --
SELECT CONCAT(
       employee_id, ', ',
       first_name, ', ',
       last_name, ', ',
       email, ', ',
       phone_number, ', ',
       hire_date, ', ',
       job_id, ', ',
       salary, ', ',
       IFNULL(commission_pct, 'NULL'), ', ',
       IFNULL(manager_id, 'NULL'), ', ',
       department_id
) AS `THE OUTPUT`
FROM employees;
-- 6.) Display the names and salaries of all employees with a salary greater than 2000. --
select concat(first_name,'',last_name) as full_name, salary 
from employees 
where salary > 2000 ;
-- 7.)  Display the names and dates of employees with the column headers "Name" and "Start Date" -- 
select concat(first_name,'',last_name) as Name,hire_date AS `Start Date`FROM employees ;
-- 8.) Display the names and hire dates of all employees in the order they were hired. --
select concat(first_name,'',last_name) as names,hire_date
 from employees 
 order by hire_date ;
-- 9.)  Display the names and salaries of all employees in reverse salary order.  --
select first_name,last_name,salary 
from employees 
order by salary desc ;
-- 10.) Display 'ename" and "deptno" who are all earned commission and display salary in reverse order.--
select first_name as ename,department_id as deptno 
from employees 
where commission_pct is not null 
order by salary desc ;
-- 11.) Display the last name and job title of all employees who do not have a manager   --
select e.last_name,j.job_title 
from employees e 
join jobs j on e.job_id = j.job_id 
where e.manager_id is null ;
-- 12.) Display the last name, job, and salary for all employees whose job is sales representative or stock clerk and whose salary is not equal to $2,500, $3,500, or $5,000 --
SELECT e.last_name, j.job_title, e.salary 
FROM employees e 
JOIN jobs j ON e.job_id = j.job_id
 WHERE (j.job_title = 'Sales Representative' OR j.job_title = 'Stock Clerk')
 AND e.salary NOT IN (2500, 3500, 5000) ;
                                                              -- 2-- 
-- 1.) Display the maximum, minimum and average salary and commission earned.--
select max(salary) as max_salary,min(salary) as min_salary,avg(salary) as avg_salary,max(commission_pct) as max_commission,min(commission_pct) as min_commission,avg(commission_pct) as avg_commission from employees ;
-- 2.) Display the department number, total salary payout and total commission payout for each department.--
select department_id as deptno,sum(salary) as total_salary_payout, sum(commission_pct) as total_commission_payout 
from employees 
group by department_id ;
-- 3.)  Display the department number and number of employees in each department. --
select department_id as deptno, count(employee_id) as num_employees from employees group by department_id ;
-- 4.)  Display the department number and total salary of employees in each department.--
select department_id as deptno,sum(salary) as total_salary from employees group by department_id ; 
-- 5.) Display the employee's name who doesn't earn a commission. Order the result set without using the column name --
select concat(first_name,'',last_name) as employee_name from employees where commission_pct is null order by 1 ;
use assignmenthr ;
-- 6.) Display the employees name, department id and commission. If an Employee doesn't earn the commission, 
-- then display as 'No commission'. Name the columns appropriately --
select concat(first_name,'',last_name) as employee_name,department_id,concat(commission_pct,'no commission') as commission from employees ;
-- 7.) Display the employee's name, salary and commission multiplied by 2. If an Employee doesn't earn the commission, then display as 
-- 'No commission. Name the columns appropriately.--
select concat(first_name,'',last_name) as employee_name,salary,
case 
	 when commission_pct is null then " No commission"
     else commission_pct*2
end as commssion
from employees ;
-- 8.)  Display the employee's name, department id who have the first name same as another employee in the same department --
select distinct e.first_name, e.department_id
from employees e
join employees em
on e.first_name = em.first_name 
where e.department_id = em.department_id 
and e.employee_id<>em.employee_id ;
use assignmenthr ;
-- 9.)  Display the sum of salaries of the employees working under each Manager.--
select sum(salary) as total_salary,manager_id from employees where manager_id is not null group by manager_id ;    
-- 10.) Select the Managers name, the count of employees working under and the department ID of the manager.--
select e.employee_id,count(e.employee_id) as employee_count,e.department_id,concat(first_name,'',last_name) as manager_name 
from departments d 
left join employees e on e.employee_id = d.manager_id 
group by e.employee_id,d.department_id 
order by e.employee_id ;
use assignmenthr ;
-- 11.) Select the employee name, department id, and the salary. 
-- Group the result with the manager name and the employee last name should have second letter 'a!--
select concat(e.first_name,'',e.last_name) as employee_name,e.department_id,e.salary,concat(m.first_name,"",m.last_name) as manager_name 
from employees e 
join employees m 
on e.employee_id = m.manager_id
where e.last_name like "_a%" ;
-- 12.) Display the average of sum of the salaries and group the result with the department id. Order the result with the department id.--
select department_id,avg(salary) as average from employees group by department_id order by department_id ;                                                                          
-- 13.) Select the maximum salary of each department along with the department id --
select department_id,max(salary) from employees group by department_id ;
-- 14.) Display the commission, if not null display 10% of salary, if null display a default value 1 --
select case 
           when commission_pct is not null then (salary*0.1)
		   else 1
           end as commmission
from employees ;

                                                              -- 3 --
-- 1.) Write a query that displays the employee's last names only from the string's 2-5th position with the first letter capitalized and all other letters lowercase, 
-- Give each column an appropriate label.--
select last_name,concat(upper(substring(last_name,2,1)), lower(substring(last_name,33))) as new_last_name from employees ;

-- 2.) Write a query that displays the employee's first name and last name along with a " in between 
-- for e.g.: first name : Ram; last name : Kumar then Ram-Kumar. Also displays the month on which the employee has joined.--
select concat(first_name,'',last_name) as full_name,monthname(hire_date) as month from employees 
where first_name like "%a%" and last_name like "%a%" ;
-- 3.) Write a query to display the employee's last name and if half of the salary is greater than ten thousand then increase the salary 
-- by 10% else by 11.5% along with the bonus amount of 1500 each. Provide each column an appropriate label.--
select last_name, case when salary/2 > 10000 then salary*(1+0.10)
else salary*(1+0.115)
end as new_salary, 1500 as bonus from employees ;

-- 4.) Display the employee ID by Appending two zeros after 2nd digit and 'E' in the end, id, salary and the manager name 
-- all in Upper case, if the Manager name consists of 'z' replace it with '$! --
select concat(substring(employee_id,1,2),"00",substring(employee_id,3,length(employee_id)),"E") as new_employee_id,department_id, salary,
replace(upper(first_name),"Z","$") as manager_name from employees
where first_name in (select distinct e.first_name from employees e 
join employees m
on e.employee_id = m.manager_id) ;

-- 5.) Write a query that displays the employee's last names with the first letter capitalized 
-- and all other letters lowercase, and the length of the names, for all employees whose name starts with J, A, or M.
-- Give each column an appropriate label. Sort the results by the employees last names--
select concat(upper(substring(last_name,1,1)),lower(substring(last_name,2))) as formatted_last_name, length(last_name) as name_length from employees 
where last_name like 'j%'or last_name like 'a%' or last_name like 'm%'
 order by last_name ;
-- 6.) Create a query to display the last name and salary for all employees. 
-- Format the salary to be 15 characters long, left-padded with $. Label the column SALARY--
select last_name,concat('$',lpad(cast(salary as char),14,'')) as salary from employees ;
-- 7.) Display the employee's name if it is a palindrome --
select concat(first_name,'',last_name) as full_name from employees
 where lower(first_name) = lower(reverse(first_name)) or lower(last_name) = lower(reverse(last_name)) ;
-- 8.) Display First names of all employees with initcaps.--
select concat(upper(substring(first_name,1,1)),lower(substring(first_name,2))) as new_name from employees ;
-- 9.) From LOCATIONS table, extract the word between first and second space from the STREET ADDRESS column.--
SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(street_address, ' ', 2), ' ', -1) AS second_word
FROM locations;

-- 10.)  Extract first letter from First Name column and append it with the Last Name. Also add "@systechusa.com" at the end.
--  Name the column as e-mail address. All characters should be in lower case. Display this along with their First Name.--
select first_name,lower(concat(substring(first_name,1,1),last_name,"@systechusa.com")) as "e-mail address" from employees ;

-- 11.) Display the names and job titles of all employees with the same job as Trenna.--
select e.first_name, j.job_title 
from employees e 
join jobs j 
on e.job_id = j.job_id 
where e.job_id in (select job_id from employees where first_name = "trenna") ;

-- 12.) Display the names and department name of all employees working in the same city as Trenna. -- 
select first_name, department_name 
from employees e 
join departments d 
on e.department_id = d.department_id 
join locations l 
on d.location_id = l.location_id
where l.location_id in (select location_id from departments where department_id in (select department_id from employees where first_name = "trenna")) ;
-- 13.) Display the name of the employee whose salary is the lowest.--
select concat(first_name,'',last_name) as employees_name, salary from employees where salary = (select min(salary) from employees) ;
-- 14.)  Display the names of all employees except the lowest paid.--
select concat(first_name,'',last_name) as employees_name from employees where salary > (select min(salary) from employees) ;

										                  -- 4 --
-- 1.)  Write a query to display the last name, department number, department name for all employees.--
select e.last_name, e.department_id as department_number,d.department_name from employees e join departments d on e.department_id = d.department_id ;
-- 2.)  Create a unique list of all jobs that are in department 4. Include the location of the department in the output.--
select distinct j.job_title, l.street_address, l.city, l.state_province, l.postal_code from departments d
 join employees e on d.department_id = e.department_id
 join jobs j on e.job_id = j.job_id
 join locations l on d.location_id = l.location_id
 where d.department_id = 4 ;
 -- 3.)   Write a query to display the employee last name,department name,location id and city of all employees who earn commission.--
 select e.last_name, d.department_name, l.location_id, l.city from employees e
 join departments d on e.department_id = d.department_id
 join locations l on d.location_id = l.location_id 
 where commission_pct is not null ;
 -- 4.) Display the employee last name and department name of all employees who have an 'a' in their last name --
 select e.last_name, d.department_name from employees e join departments d on e.department_id = d.department_id where e.last_name like 'a%' ;
 -- 5.) Write a query to display the last name,job,department number and department name for all employees who work in ATLANTA.--
 select e.last_name, j.job_title, e.department_id, d.department_name from employees e
 join departments d on e.department_id = d.department_id 
 join locations l on d.location_id = l.location_id 
 join jobs j on e.job_id = j.job_id 
 where l.city = 'ATLANTA' ;
 -- 6.)  Display the employee last name and employee number along with their manager's last name and manager number.--
 SELECT e.last_name,e.employee_id, m.last_name ,m.employee_id from employees e left join employees m on e.manager_id = m.employee_id ;
 -- 7.) Display the employee last name and employee number along with their manager's last name and manager number
 -- (including the employees who have no manager).--
 select e.last_name, e.employee_id, concat(m.last_name,'no manager') as manger_last_name, concat(m.employee_id,'N/A') as manager_number from employees e
 left join employees m on e.manager_id = m.employee_id ;
 -- 8.) Create a query that displays employees last name,department number,and all the employees who work in the same department as a given employee. --
SELECT e1.last_name AS employee_last_name,
       e1.department_id,
       e2.last_name AS colleague_last_name
FROM employees e1
JOIN employees e2 ON e1.department_id = e2.department_id
WHERE e1.employee_id = 101 AND e1.employee_id <> e2.employee_id;
-- 9.) Create a query that displays the name,job,department name,salary,grade for all employees. 
-- Derive grade based on salary(>=50000=A, >=30000=B,<30000=C) --
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    j.job_title,
    d.department_name,
    e.salary,
    CASE 
        WHEN e.salary >= 50000 THEN 'A'
        WHEN e.salary >= 30000 THEN 'B'
        ELSE 'C'
    END AS grade
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
JOIN departments d ON e.department_id = d.department_id;
-- 10.) Display the names and hire date for all employees who were hired before their managers along withe their manager names and hire date.
-- Label the columns as Employee name, emp_hire_date,manager name,
select e1.last_name as employee_name,
	   e1.hire_date as emp_hire_date,
       e2.last_name as manager_name,
       e2.hire_date as man_hire_date
	from employees e1
    join employees e2 on e1.manager_id = e2.employee_id
    where e1.hire_date < e2.hire_date;

                                                       -- 6 --
-- 1.) Write a query to display the last name and hire date of any employee in the same department as SALES.--
select e.last_name,e.hire_date from employees e 
join departments d on e.department_id = d.department_id 
where d.department_name = 'sales' ;
-- 2.)  Create a query to display the employee numbers and last names of all employees who earn more than the average salary.
-- Sort the results in ascending order of salary.--
select employee_id,last_name from employees 
where salary > (select avg(salary) from employees) 
order by salary asc ;
-- 3.)  Write a query that displays the employee numbers and last names of all employees
-- who work in a department with any employee whose last name contains a' u--
select e.employee_id,e.last_name from employees e 
where e.department_id in (select distinct e1.department_id
 from employees e1 where e1.last_name like 'u%') ;
-- 4.) Display the last name, department number, and job ID of all employees whose department location is ATLANTA.--
select e.last_name, d.department_id,e.job_id from employees e 
join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id 
where l.city = 'ATLANTA' ;
-- 5.)  Display the last name and salary of every employee who reports to FILLMORE.--
select last_name,salary from employees where last_name = 'fillmore' ;
-- 6.)  Display the department number, last name, and job ID for every employee in the OPERATIONS department.--
select e.department_id as department_number, e.last_name, e.job_id from employees e
 join departments d on e.department_id = d.department_id where d.department_name = 'operations' ;
-- 7.) Modify the above query to display the employee numbers, last names, and salaries of all employees 
-- who earn more than the average salary and who work in a department with any employee with a 'u'in their name.--
SELECT e.employee_id,e.last_name,e.salary FROM employees e
WHERE e.salary > (SELECT AVG(salary) FROM employees) AND e.department_id IN (SELECT DISTINCT d.department_id
FROM employees d WHERE d.first_name LIKE '%u%' OR d.last_name LIKE '%u%');

-- 8.) Display the names of all employees whose job title is the same as anyone in the sales dept.--
select e.first_name,e.last_name from employees e where e.job_id in(select distinct e1.job_id from employees e1
 join departments d on e1.department_id = d.department_id where d.department_name = 'sales');
-- 9.) Write a compound query to produce a list of employees showing raise percentages, employee IDs, and salaries. 
-- Employees in department 1 and 3 are given a 5% raise, employees in department 2 are given a 10% raise, 
-- employees in departments 4 and 5 are given a 15% raise, and employees in department 6 are not given a raise.--
select employee_id, salary, case when department_id in (1,3) then 0.05
when department_id = 2 then 0.10 when department_id in (4,5) then 0.15
else 0.00
end as raise_percentage from employees ;

-- 10.) Write a query to display the top three earners in the EMPLOYEES table. Display their last names and salaries.--
select last_name,salary from employees order by salary desc limit 3 ;
-- 11.)  Display the names of all employees with their salary and commission earned. 
-- Employees with a null commission should have O in the commission column--
select concat(first_name,'',last_name) as employee_name, salary, coalesce(commission_pct,0) as commission from employees ;

-- 12.) Display the Managers (name) with top three salaries along with their salaries and department information.--
select concat(e.first_name,'',e.last_name) as manager_name ,e.salary,d.department_name from employees e 
join departments d on e.department_id = d.department_id where e.employee_id in (select distinct manager_id from employees where manager_id is not null)
order by e.salary desc limit 3 ;

                                      -- -- -- -- DATE FUNCTION -- -- -- --
CREATE TABLE employeesdatefunction(
    employee_id INT PRIMARY KEY,
    hire_date DATE NOT NULL,
    resignation_date DATE
);
INSERT INTO employeesdatefunction (employee_id, hire_date, resignation_date) VALUES
(1, '2000-01-01', '2013-07-10'),
(2, '2003-04-12', '2017-03-08'),
(3, '2012-09-22', '2015-06-21'),
(4, '2015-04-13', NULL),
(5, '2016-06-03', NULL),
(6, '2017-08-08', NULL),
(7, '2016-11-13', NULL);
-- 1.)  Find the date difference between the hire date and resignation_date for all the 
-- employees. Display in no. of days, months and year(1 year 3 months 5 days). Emp_ID Hire Date Resignation_Date 
-- 1   1/1/2000 7/10/2013 
-- 2  4/12/2003 3/8/2017 
-- 3  22/9/2012 21/6/2015 
-- 4  13/4/2015 NULL 
-- 5  03/06/2016 NULL 
-- 6  08/08/2017 NULL 
-- 7  13/11/2016 NULL  
select employee_id, hire_date, resignation_date, case when resignation_date is not null then  CONCAT(
                TIMESTAMPDIFF(YEAR, hire_date, resignation_date), ' years, ',
                TIMESTAMPDIFF(MONTH, hire_date, resignation_date) % 12, ' months, ',
                DATEDIFF(resignation_date, DATE_ADD(hire_date, INTERVAL TIMESTAMPDIFF(MONTH, hire_date, resignation_date) MONTH)) , ' days')
		else 'still employed '
        end as duration from employeesdatefunction ;
-- 2.)  Format the hire date as mm/dd/yyyy(09/22/2003) and resignation_date as mon dd, yyyy(Aug 12th, 2004). Display the null as (DEC, 01th 1900) --
select employee_id, date_format(hire_date, '%m/%d/%y') as formatted_hire_date, if (resignation_date is null, 'dec 01th, 1990', 
date_format(resignation_date,'%b %dth,%y')) as formatted_resignation_date from employeesdatefunction ;

-- 3.)  Calcuate experience of the employee till date in Years and months(example 1 year and 3 months) --
SELECT employee_id, hire_date,
    COALESCE(resignation_date, CURRENT_DATE) AS effective_resignation_date,
    FLOOR(DATEDIFF(COALESCE(resignation_date, CURRENT_DATE), hire_date) / 365) AS years,
    FLOOR((DATEDIFF(COALESCE(resignation_date, CURRENT_DATE), hire_date) % 365) / 30) AS months
FROM employeesdatefunction;

-- 4.) Display the count of days in the previous quarter --
SELECT DATEDIFF(
    last_day(DATE_SUB(CURDATE(), INTERVAL QUARTER(CURDATE()) QUARTER)),
    DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL (QUARTER(CURDATE()) + 1) QUARTER)), INTERVAL 1 DAY)
) + 1 AS days_in_previous_quarter;

-- 5.)  Fetch the previous Quarter's second week's first day's date --
SELECT DATE_ADD(
    DATE_SUB(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL QUARTER(CURDATE()) QUARTER)), INTERVAL 1 MONTH), 
    INTERVAL 7 DAY
) AS first_day_second_week_previous_quarter;

-- 6.)  Fetch the financial year's 15th week's dates (Format: Mon DD YYYY) --
SELECT 
    DATE_FORMAT(DATE_ADD(financial_year_start, INTERVAL (15 - 1) * 7 DAY), '%a %d %Y') AS start_of_15th_week,
    DATE_FORMAT(DATE_ADD(financial_year_start, INTERVAL 15 * 7 - 1 DAY), '%a %d %Y') AS end_of_15th_week
FROM (
    SELECT IF(MONTH(CURDATE()) >= 4, 
               MAKEDATE(YEAR(CURDATE()), 91),  -- April 1st of the current year
               MAKEDATE(YEAR(CURDATE()) - 1, 91)) AS financial_year_start  -- April 1st of the previous year
) AS financial_year;

-- 7.) Find out the date that corresponds to the last Saturday of January, 2015 using with clause.--
WITH january_2015 AS (
    SELECT '2015-01-31' AS last_day_january  -- Last day of January 2015
)
SELECT 
    DATE_SUB(last_day_january, INTERVAL WEEKDAY(last_day_january) + 1 DAY) AS last_saturday
from january_2015 ;


 
		





  

 
 
	


/* *************************************************************** 
***************************INSERTING DATA*************************
**************************************************************** */
INSERT INTO regions
VALUES (
	1,
	'Europe'
	);

INSERT INTO regions
VALUES (
	2,
	'Americas'
	);

INSERT INTO regions
VALUES (
	3,
	'Asia'
	);

INSERT INTO regions
VALUES (
	4,
	'Middle East and Africa'
	);

COMMIT;

INSERT INTO countries
VALUES (
	'IT',
	'Italy',
	1
	);

INSERT INTO countries
VALUES (
	'JP',
	'Japan',
	3
	);

INSERT INTO countries
VALUES (
	'US',
	'United States of America',
	2
	);

INSERT INTO countries
VALUES (
	'CA',
	'Canada',
	2
	);

INSERT INTO countries
VALUES (
	'CN',
	'China',
	3
	);

INSERT INTO countries
VALUES (
	'IN',
	'India',
	3
	);

INSERT INTO countries
VALUES (
	'AU',
	'Australia',
	3
	);

INSERT INTO countries
VALUES (
	'ZW',
	'Zimbabwe',
	4
	);

INSERT INTO countries
VALUES (
	'SG',
	'Singapore',
	3
	);

INSERT INTO countries
VALUES (
	'UK',
	'United Kingdom',
	1
	);

INSERT INTO countries
VALUES (
	'FR',
	'France',
	1
	);

INSERT INTO countries
VALUES (
	'DE',
	'Germany',
	1
	);

INSERT INTO countries
VALUES (
	'ZM',
	'Zambia',
	4
	);

INSERT INTO countries
VALUES (
	'EG',
	'Egypt',
	4
	);

INSERT INTO countries
VALUES (
	'BR',
	'Brazil',
	2
	);

INSERT INTO countries
VALUES (
	'CH',
	'Switzerland',
	1
	);

INSERT INTO countries
VALUES (
	'NL',
	'Netherlands',
	1
	);

INSERT INTO countries
VALUES (
	'MX',
	'Mexico',
	2
	);

INSERT INTO countries
VALUES (
	'KW',
	'Kuwait',
	4
	);

INSERT INTO countries
VALUES (
	'IL',
	'Israel',
	4
	);

INSERT INTO countries
VALUES (
	'DK',
	'Denmark',
	1
	);

INSERT INTO countries
VALUES (
	'HK',
	'HongKong',
	3
	);

INSERT INTO countries
VALUES (
	'NG',
	'Nigeria',
	4
	);

INSERT INTO countries
VALUES (
	'AR',
	'Argentina',
	2
	);

INSERT INTO countries
VALUES (
	'BE',
	'Belgium',
	1
	);

COMMIT;

INSERT INTO locations
VALUES (
	1000,
	'1297 Via Cola di Rie',
	'00989',
	'Roma',
	NULL,
	'IT'
	);

INSERT INTO locations
VALUES (
	1100,
	'93091 Calle della Testa',
	'10934',
	'Venice',
	NULL,
	'IT'
	);

INSERT INTO locations
VALUES (
	1200,
	'2017 Shinjuku-ku',
	'1689',
	'Tokyo',
	'Tokyo Prefecture',
	'JP'
	);

INSERT INTO locations
VALUES (
	1300,
	'9450 Kamiya-cho',
	'6823',
	'Hiroshima',
	NULL,
	'JP'
	);

INSERT INTO locations
VALUES (
	1400,
	'2014 Jabberwocky Rd',
	'26192',
	'Southlake',
	'Texas',
	'US'
	);

INSERT INTO locations
VALUES (
	1500,
	'2011 Interiors Blvd',
	'99236',
	'South San Francisco',
	'California',
	'US'
	);

INSERT INTO locations
VALUES (
	1600,
	'2007 Zagora St',
	'50090',
	'South Brunswick',
	'New Jersey',
	'US'
	);

INSERT INTO locations
VALUES (
	1700,
	'2004 Charade Rd',
	'98199',
	'Seattle',
	'Washington',
	'US'
	);

INSERT INTO locations
VALUES (
	1800,
	'147 Spadina Ave',
	'M5V 2L7',
	'Toronto',
	'Ontario',
	'CA'
	);

INSERT INTO locations
VALUES (
	1900,
	'6092 Boxwood St',
	'YSW 9T2',
	'Whitehorse',
	'Yukon',
	'CA'
	);

INSERT INTO locations
VALUES (
	2000,
	'40-5-12 Laogianggen',
	'190518',
	'Beijing',
	NULL,
	'CN'
	);

INSERT INTO locations
VALUES (
	2100,
	'1298 Vileparle (E)',
	'490231',
	'Bombay',
	'Maharashtra',
	'IN'
	);

INSERT INTO locations
VALUES (
	2200,
	'12-98 Victoria Street',
	'2901',
	'Sydney',
	'New South Wales',
	'AU'
	);

INSERT INTO locations
VALUES (
	2300,
	'198 Clementi North',
	'540198',
	'Singapore',
	NULL,
	'SG'
	);

INSERT INTO locations
VALUES (
	2400,
	'8204 Arthur St',
	NULL,
	'London',
	NULL,
	'UK'
	);

INSERT INTO locations
VALUES (
	2500,
	'Magdalen Centre, The Oxford Science Park',
	'OX9 9ZB',
	'Oxford',
	'Oxford',
	'UK'
	);

INSERT INTO locations
VALUES (
	2600,
	'9702 Chester Road',
	'09629850293',
	'Stretford',
	'Manchester',
	'UK'
	);

INSERT INTO locations
VALUES (
	2700,
	'Schwanthalerstr. 7031',
	'80925',
	'Munich',
	'Bavaria',
	'DE'
	);

INSERT INTO locations
VALUES (
	2800,
	'Rua Frei Caneca 1360 ',
	'01307-002',
	'Sao Paulo',
	'Sao Paulo',
	'BR'
	);

INSERT INTO locations
VALUES (
	2900,
	'20 Rue des Corps-Saints',
	'1730',
	'Geneva',
	'Geneve',
	'CH'
	);

INSERT INTO locations
VALUES (
	3000,
	'Murtenstrasse 921',
	'3095',
	'Bern',
	'BE',
	'CH'
	);

INSERT INTO locations
VALUES (
	3100,
	'Pieter Breughelstraat 837',
	'3029SK',
	'Utrecht',
	'Utrecht',
	'NL'
	);

INSERT INTO locations
VALUES (
	3200,
	'Mariano Escobedo 9991',
	'11932',
	'Mexico City',
	'Distrito Federal,',
	'MX'
	);

COMMIT;

SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO departments
VALUES (
	10,
	'Administration',
	200,
	1700
	);

INSERT INTO departments
VALUES (
	20,
	'Marketing',
	201,
	1800
	);

INSERT INTO departments
VALUES (
	30,
	'Purchasing',
	114,
	1700
	);

INSERT INTO departments
VALUES (
	40,
	'Human Resources',
	203,
	2400
	);

INSERT INTO departments
VALUES (
	50,
	'Shipping',
	121,
	1500
	);

INSERT INTO departments
VALUES (
	60,
	'IT',
	103,
	1400
	);

INSERT INTO departments
VALUES (
	70,
	'Public Relations',
	204,
	2700
	);

INSERT INTO departments
VALUES (
	80,
	'Sales',
	145,
	2500
	);

INSERT INTO departments
VALUES (
	90,
	'Executive',
	100,
	1700
	);

INSERT INTO departments
VALUES (
	100,
	'Finance',
	108,
	1700
	);

INSERT INTO departments
VALUES (
	110,
	'Accounting',
	205,
	1700
	);

INSERT INTO departments
VALUES (
	120,
	'Treasury',
	NULL,
	1700
	);

INSERT INTO departments
VALUES (
	130,
	'Corporate Tax',
	NULL,
	1700
	);

INSERT INTO departments
VALUES (
	140,
	'Control And Credit',
	NULL,
	1700
	);

INSERT INTO departments
VALUES (
	150,
	'Shareholder Services',
	NULL,
	1700
	);

INSERT INTO departments
VALUES (
	160,
	'Benefits',
	NULL,
	1700
	);

INSERT INTO departments
VALUES (
	170,
	'Manufacturing',
	NULL,
	1700
	);

INSERT INTO departments
VALUES (
	180,
	'Construction',
	NULL,
	1700
	);

INSERT INTO departments
VALUES (
	190,
	'Contracting',
	NULL,
	1700
	);

INSERT INTO departments
VALUES (
	200,
	'Operations',
	NULL,
	1700
	);

INSERT INTO departments
VALUES (
	210,
	'IT Support',
	NULL,
	1700
	);

INSERT INTO departments
VALUES (
	220,
	'NOC',
	NULL,
	1700
	);

INSERT INTO departments
VALUES (
	230,
	'IT Helpdesk',
	NULL,
	1700
	);

INSERT INTO departments
VALUES (
	240,
	'Government Sales',
	NULL,
	1700
	);

INSERT INTO departments
VALUES (
	250,
	'Retail Sales',
	NULL,
	1700
	);

INSERT INTO departments
VALUES (
	260,
	'Recruiting',
	NULL,
	1700
	);

INSERT INTO departments
VALUES (
	270,
	'Payroll',
	NULL,
	1700
	);

SET FOREIGN_KEY_CHECKS = 1;

COMMIT;

INSERT INTO jobs
VALUES (
	'AD_PRES',
	'President',
	20000,
	40000
	);

INSERT INTO jobs
VALUES (
	'AD_VP',
	'Administration Vice President',
	15000,
	30000
	);

INSERT INTO jobs
VALUES (
	'AD_ASST',
	'Administration Assistant',
	3000,
	6000
	);

INSERT INTO jobs
VALUES (
	'FI_MGR',
	'Finance Manager',
	8200,
	16000
	);

INSERT INTO jobs
VALUES (
	'FI_ACCOUNT',
	'Accountant',
	4200,
	9000
	);

INSERT INTO jobs
VALUES (
	'AC_MGR',
	'Accounting Manager',
	8200,
	16000
	);

INSERT INTO jobs
VALUES (
	'AC_ACCOUNT',
	'Public Accountant',
	4200,
	9000
	);

INSERT INTO jobs
VALUES (
	'SA_MAN',
	'Sales Manager',
	10000,
	20000
	);

INSERT INTO jobs
VALUES (
	'SA_REP',
	'Sales Representative',
	6000,
	12000
	);

INSERT INTO jobs
VALUES (
	'PU_MAN',
	'Purchasing Manager',
	8000,
	15000
	);

INSERT INTO jobs
VALUES (
	'PU_CLERK',
	'Purchasing Clerk',
	2500,
	5500
	);

INSERT INTO jobs
VALUES (
	'ST_MAN',
	'Stock Manager',
	5500,
	8500
	);

INSERT INTO jobs
VALUES (
	'ST_CLERK',
	'Stock Clerk',
	2000,
	5000
	);

INSERT INTO jobs
VALUES (
	'SH_CLERK',
	'Shipping Clerk',
	2500,
	5500
	);

INSERT INTO jobs
VALUES (
	'IT_PROG',
	'Programmer',
	4000,
	10000
	);

INSERT INTO jobs
VALUES (
	'MK_MAN',
	'Marketing Manager',
	9000,
	15000
	);

INSERT INTO jobs
VALUES (
	'MK_REP',
	'Marketing Representative',
	4000,
	9000
	);

INSERT INTO jobs
VALUES (
	'HR_REP',
	'Human Resources Representative',
	4000,
	9000
	);

INSERT INTO jobs
VALUES (
	'PR_REP',
	'Public Relations Representative',
	4500,
	10500
	);

COMMIT;

INSERT INTO employees
VALUES (
	100,
	'Steven',
	'King',
	'SKING',
	'515.123.4567',
	STR_TO_DATE('17-JUN-1987', '%d-%M-%Y'),
	'AD_PRES',
	24000,
	NULL,
	NULL,
	90
	);

INSERT INTO employees
VALUES (
	101,
	'Neena',
	'Kochhar',
	'NKOCHHAR',
	'515.123.4568',
	STR_TO_DATE('21-SEP-1989', '%d-%M-%Y'),
	'AD_VP',
	17000,
	NULL,
	100,
	90
	);

INSERT INTO employees
VALUES (
	102,
	'Lex',
	'De Haan',
	'LDEHAAN',
	'515.123.4569',
	STR_TO_DATE('13-JAN-1993', '%d-%M-%Y'),
	'AD_VP',
	17000,
	NULL,
	100,
	90
	);

INSERT INTO employees
VALUES (
	103,
	'Alexander',
	'Hunold',
	'AHUNOLD',
	'590.423.4567',
	STR_TO_DATE('03-JAN-1990', '%d-%M-%Y'),
	'IT_PROG',
	9000,
	NULL,
	102,
	60
	);

INSERT INTO employees
VALUES (
	104,
	'Bruce',
	'Ernst',
	'BERNST',
	'590.423.4568',
	STR_TO_DATE('21-MAY-1991', '%d-%M-%Y'),
	'IT_PROG',
	6000,
	NULL,
	103,
	60
	);

INSERT INTO employees
VALUES (
	105,
	'David',
	'Austin',
	'DAUSTIN',
	'590.423.4569',
	STR_TO_DATE('25-JUN-1997', '%d-%M-%Y'),
	'IT_PROG',
	4800,
	NULL,
	103,
	60
	);

INSERT INTO employees
VALUES (
	106,
	'Valli',
	'Pataballa',
	'VPATABAL',
	'590.423.4560',
	STR_TO_DATE('05-FEB-1998', '%d-%M-%Y'),
	'IT_PROG',
	4800,
	NULL,
	103,
	60
	);

INSERT INTO employees
VALUES (
	107,
	'Diana',
	'Lorentz',
	'DLORENTZ',
	'590.423.5567',
	STR_TO_DATE('07-FEB-1999', '%d-%M-%Y'),
	'IT_PROG',
	4200,
	NULL,
	103,
	60
	);

INSERT INTO employees
VALUES (
	108,
	'Nancy',
	'Greenberg',
	'NGREENBE',
	'515.124.4569',
	STR_TO_DATE('17-AUG-1994', '%d-%M-%Y'),
	'FI_MGR',
	12000,
	NULL,
	101,
	100
	);

INSERT INTO employees
VALUES (
	109,
	'Daniel',
	'Faviet',
	'DFAVIET',
	'515.124.4169',
	STR_TO_DATE('16-AUG-1994', '%d-%M-%Y'),
	'FI_ACCOUNT',
	9000,
	NULL,
	108,
	100
	);

INSERT INTO employees
VALUES (
	110,
	'John',
	'Chen',
	'JCHEN',
	'515.124.4269',
	STR_TO_DATE('28-SEP-1997', '%d-%M-%Y'),
	'FI_ACCOUNT',
	8200,
	NULL,
	108,
	100
	);

INSERT INTO employees
VALUES (
	111,
	'Ismael',
	'Sciarra',
	'ISCIARRA',
	'515.124.4369',
	STR_TO_DATE('30-SEP-1997', '%d-%M-%Y'),
	'FI_ACCOUNT',
	7700,
	NULL,
	108,
	100
	);

INSERT INTO employees
VALUES (
	112,
	'Jose Manuel',
	'Urman',
	'JMURMAN',
	'515.124.4469',
	STR_TO_DATE('07-MAR-1998', '%d-%M-%Y'),
	'FI_ACCOUNT',
	7800,
	NULL,
	108,
	100
	);

INSERT INTO employees
VALUES (
	113,
	'Luis',
	'Popp',
	'LPOPP',
	'515.124.4567',
	STR_TO_DATE('07-DEC-1999', '%d-%M-%Y'),
	'FI_ACCOUNT',
	6900,
	NULL,
	108,
	100
	);

INSERT INTO employees
VALUES (
	114,
	'Den',
	'Raphaely',
	'DRAPHEAL',
	'515.127.4561',
	STR_TO_DATE('07-DEC-1994', '%d-%M-%Y'),
	'PU_MAN',
	11000,
	NULL,
	100,
	30
	);

INSERT INTO employees
VALUES (
	115,
	'Alexander',
	'Khoo',
	'AKHOO',
	'515.127.4562',
	STR_TO_DATE('18-MAY-1995', '%d-%M-%Y'),
	'PU_CLERK',
	3100,
	NULL,
	114,
	30
	);

INSERT INTO employees
VALUES (
	116,
	'Shelli',
	'Baida',
	'SBAIDA',
	'515.127.4563',
	STR_TO_DATE('24-DEC-1997', '%d-%M-%Y'),
	'PU_CLERK',
	2900,
	NULL,
	114,
	30
	);

INSERT INTO employees
VALUES (
	117,
	'Sigal',
	'Tobias',
	'STOBIAS',
	'515.127.4564',
	STR_TO_DATE('24-JUL-1997', '%d-%M-%Y'),
	'PU_CLERK',
	2800,
	NULL,
	114,
	30
	);

INSERT INTO employees
VALUES (
	118,
	'Guy',
	'Himuro',
	'GHIMURO',
	'515.127.4565',
	STR_TO_DATE('15-NOV-1998', '%d-%M-%Y'),
	'PU_CLERK',
	2600,
	NULL,
	114,
	30
	);

INSERT INTO employees
VALUES (
	119,
	'Karen',
	'Colmenares',
	'KCOLMENA',
	'515.127.4566',
	STR_TO_DATE('10-AUG-1999', '%d-%M-%Y'),
	'PU_CLERK',
	2500,
	NULL,
	114,
	30
	);

INSERT INTO employees
VALUES (
	120,
	'Matthew',
	'Weiss',
	'MWEISS',
	'650.123.1234',
	STR_TO_DATE('18-JUL-1996', '%d-%M-%Y'),
	'ST_MAN',
	8000,
	NULL,
	100,
	50
	);

INSERT INTO employees
VALUES (
	121,
	'Adam',
	'Fripp',
	'AFRIPP',
	'650.123.2234',
	STR_TO_DATE('10-APR-1997', '%d-%M-%Y'),
	'ST_MAN',
	8200,
	NULL,
	100,
	50
	);

INSERT INTO employees
VALUES (
	122,
	'Payam',
	'Kaufling',
	'PKAUFLIN',
	'650.123.3234',
	STR_TO_DATE('01-MAY-1995', '%d-%M-%Y'),
	'ST_MAN',
	7900,
	NULL,
	100,
	50
	);

INSERT INTO employees
VALUES (
	123,
	'Shanta',
	'Vollman',
	'SVOLLMAN',
	'650.123.4234',
	STR_TO_DATE('10-OCT-1997', '%d-%M-%Y'),
	'ST_MAN',
	6500,
	NULL,
	100,
	50
	);

INSERT INTO employees
VALUES (
	124,
	'Kevin',
	'Mourgos',
	'KMOURGOS',
	'650.123.5234',
	STR_TO_DATE('16-NOV-1999', '%d-%M-%Y'),
	'ST_MAN',
	5800,
	NULL,
	100,
	50
	);

INSERT INTO employees
VALUES (
	125,
	'Julia',
	'Nayer',
	'JNAYER',
	'650.124.1214',
	STR_TO_DATE('16-JUL-1997', '%d-%M-%Y'),
	'ST_CLERK',
	3200,
	NULL,
	120,
	50
	);

INSERT INTO employees
VALUES (
	126,
	'Irene',
	'Mikkilineni',
	'IMIKKILI',
	'650.124.1224',
	STR_TO_DATE('28-SEP-1998', '%d-%M-%Y'),
	'ST_CLERK',
	2700,
	NULL,
	120,
	50
	);

INSERT INTO employees
VALUES (
	127,
	'James',
	'Landry',
	'JLANDRY',
	'650.124.1334',
	STR_TO_DATE('14-JAN-1999', '%d-%M-%Y'),
	'ST_CLERK',
	2400,
	NULL,
	120,
	50
	);

INSERT INTO employees
VALUES (
	128,
	'Steven',
	'Markle',
	'SMARKLE',
	'650.124.1434',
	STR_TO_DATE('08-MAR-2000', '%d-%M-%Y'),
	'ST_CLERK',
	2200,
	NULL,
	120,
	50
	);

INSERT INTO employees
VALUES (
	129,
	'Laura',
	'Bissot',
	'LBISSOT',
	'650.124.5234',
	STR_TO_DATE('20-AUG-1997', '%d-%M-%Y'),
	'ST_CLERK',
	3300,
	NULL,
	121,
	50
	);

INSERT INTO employees
VALUES (
	130,
	'Mozhe',
	'Atkinson',
	'MATKINSO',
	'650.124.6234',
	STR_TO_DATE('30-OCT-1997', '%d-%M-%Y'),
	'ST_CLERK',
	2800,
	NULL,
	121,
	50
	);

INSERT INTO employees
VALUES (
	131,
	'James',
	'Marlow',
	'JAMRLOW',
	'650.124.7234',
	STR_TO_DATE('16-FEB-1997', '%d-%M-%Y'),
	'ST_CLERK',
	2500,
	NULL,
	121,
	50
	);

INSERT INTO employees
VALUES (
	132,
	'TJ',
	'Olson',
	'TJOLSON',
	'650.124.8234',
	STR_TO_DATE('10-APR-1999', '%d-%M-%Y'),
	'ST_CLERK',
	2100,
	NULL,
	121,
	50
	);

INSERT INTO employees
VALUES (
	133,
	'Jason',
	'Mallin',
	'JMALLIN',
	'650.127.1934',
	STR_TO_DATE('14-JUN-1996', '%d-%M-%Y'),
	'ST_CLERK',
	3300,
	NULL,
	122,
	50
	);

INSERT INTO employees
VALUES (
	134,
	'Michael',
	'Rogers',
	'MROGERS',
	'650.127.1834',
	STR_TO_DATE('26-AUG-1998', '%d-%M-%Y'),
	'ST_CLERK',
	2900,
	NULL,
	122,
	50
	);

INSERT INTO employees
VALUES (
	135,
	'Ki',
	'Gee',
	'KGEE',
	'650.127.1734',
	STR_TO_DATE('12-DEC-1999', '%d-%M-%Y'),
	'ST_CLERK',
	2400,
	NULL,
	122,
	50
	);

INSERT INTO employees
VALUES (
	136,
	'Hazel',
	'Philtanker',
	'HPHILTAN',
	'650.127.1634',
	STR_TO_DATE('06-FEB-2000', '%d-%M-%Y'),
	'ST_CLERK',
	2200,
	NULL,
	122,
	50
	);

INSERT INTO employees
VALUES (
	137,
	'Renske',
	'Ladwig',
	'RLADWIG',
	'650.121.1234',
	STR_TO_DATE('14-JUL-1995', '%d-%M-%Y'),
	'ST_CLERK',
	3600,
	NULL,
	123,
	50
	);

INSERT INTO employees
VALUES (
	138,
	'Stephen',
	'Stiles',
	'SSTILES',
	'650.121.2034',
	STR_TO_DATE('26-OCT-1997', '%d-%M-%Y'),
	'ST_CLERK',
	3200,
	NULL,
	123,
	50
	);

INSERT INTO employees
VALUES (
	139,
	'John',
	'Seo',
	'JSEO',
	'650.121.2019',
	STR_TO_DATE('12-FEB-1998', '%d-%M-%Y'),
	'ST_CLERK',
	2700,
	NULL,
	123,
	50
	);

INSERT INTO employees
VALUES (
	140,
	'Joshua',
	'Patel',
	'JPATEL',
	'650.121.1834',
	STR_TO_DATE('06-APR-1998', '%d-%M-%Y'),
	'ST_CLERK',
	2500,
	NULL,
	123,
	50
	);

INSERT INTO employees
VALUES (
	141,
	'Trenna',
	'Rajs',
	'TRAJS',
	'650.121.8009',
	STR_TO_DATE('17-OCT-1995', '%d-%M-%Y'),
	'ST_CLERK',
	3500,
	NULL,
	124,
	50
	);

INSERT INTO employees
VALUES (
	142,
	'Curtis',
	'Davies',
	'CDAVIES',
	'650.121.2994',
	STR_TO_DATE('29-JAN-1997', '%d-%M-%Y'),
	'ST_CLERK',
	3100,
	NULL,
	124,
	50
	);

INSERT INTO employees
VALUES (
	143,
	'Randall',
	'Matos',
	'RMATOS',
	'650.121.2874',
	STR_TO_DATE('15-MAR-1998', '%d-%M-%Y'),
	'ST_CLERK',
	2600,
	NULL,
	124,
	50
	);

INSERT INTO employees
VALUES (
	144,
	'Peter',
	'Vargas',
	'PVARGAS',
	'650.121.2004',
	STR_TO_DATE('09-JUL-1998', '%d-%M-%Y'),
	'ST_CLERK',
	2500,
	NULL,
	124,
	50
	);

INSERT INTO employees
VALUES (
	145,
	'John',
	'Russell',
	'JRUSSEL',
	'011.44.1344.429268',
	STR_TO_DATE('01-OCT-1996', '%d-%M-%Y'),
	'SA_MAN',
	14000,
	.4,
	100,
	80
	);

INSERT INTO employees
VALUES (
	146,
	'Karen',
	'Partners',
	'KPARTNER',
	'011.44.1344.467268',
	STR_TO_DATE('05-JAN-1997', '%d-%M-%Y'),
	'SA_MAN',
	13500,
	.3,
	100,
	80
	);

INSERT INTO employees
VALUES (
	147,
	'Alberto',
	'Errazuriz',
	'AERRAZUR',
	'011.44.1344.429278',
	STR_TO_DATE('10-MAR-1997', '%d-%M-%Y'),
	'SA_MAN',
	12000,
	.3,
	100,
	80
	);

INSERT INTO employees
VALUES (
	148,
	'Gerald',
	'Cambrault',
	'GCAMBRAU',
	'011.44.1344.619268',
	STR_TO_DATE('15-OCT-1999', '%d-%M-%Y'),
	'SA_MAN',
	11000,
	.3,
	100,
	80
	);

INSERT INTO employees
VALUES (
	149,
	'Eleni',
	'Zlotkey',
	'EZLOTKEY',
	'011.44.1344.429018',
	STR_TO_DATE('29-JAN-2000', '%d-%M-%Y'),
	'SA_MAN',
	10500,
	.2,
	100,
	80
	);

INSERT INTO employees
VALUES (
	150,
	'Peter',
	'Tucker',
	'PTUCKER',
	'011.44.1344.129268',
	STR_TO_DATE('30-JAN-1997', '%d-%M-%Y'),
	'SA_REP',
	10000,
	.3,
	145,
	80
	);

INSERT INTO employees
VALUES (
	151,
	'David',
	'Bernstein',
	'DBERNSTE',
	'011.44.1344.345268',
	STR_TO_DATE('24-MAR-1997', '%d-%M-%Y'),
	'SA_REP',
	9500,
	.25,
	145,
	80
	);

INSERT INTO employees
VALUES (
	152,
	'Peter',
	'Hall',
	'PHALL',
	'011.44.1344.478968',
	STR_TO_DATE('20-AUG-1997', '%d-%M-%Y'),
	'SA_REP',
	9000,
	.25,
	145,
	80
	);

INSERT INTO employees
VALUES (
	153,
	'Christopher',
	'Olsen',
	'COLSEN',
	'011.44.1344.498718',
	STR_TO_DATE('30-MAR-1998', '%d-%M-%Y'),
	'SA_REP',
	8000,
	.2,
	145,
	80
	);

INSERT INTO employees
VALUES (
	154,
	'Nanette',
	'Cambrault',
	'NCAMBRAU',
	'011.44.1344.987668',
	STR_TO_DATE('09-DEC-1998', '%d-%M-%Y'),
	'SA_REP',
	7500,
	.2,
	145,
	80
	);

INSERT INTO employees
VALUES (
	155,
	'Oliver',
	'Tuvault',
	'OTUVAULT',
	'011.44.1344.486508',
	STR_TO_DATE('23-NOV-1999', '%d-%M-%Y'),
	'SA_REP',
	7000,
	.15,
	145,
	80
	);

INSERT INTO employees
VALUES (
	156,
	'Janette',
	'King',
	'JKING',
	'011.44.1345.429268',
	STR_TO_DATE('30-JAN-1996', '%d-%M-%Y'),
	'SA_REP',
	10000,
	.35,
	146,
	80
	);

INSERT INTO employees
VALUES (
	157,
	'Patrick',
	'Sully',
	'PSULLY',
	'011.44.1345.929268',
	STR_TO_DATE('04-MAR-1996', '%d-%M-%Y'),
	'SA_REP',
	9500,
	.35,
	146,
	80
	);

INSERT INTO employees
VALUES (
	158,
	'Allan',
	'McEwen',
	'AMCEWEN',
	'011.44.1345.829268',
	STR_TO_DATE('01-AUG-1996', '%d-%M-%Y'),
	'SA_REP',
	9000,
	.35,
	146,
	80
	);

INSERT INTO employees
VALUES (
	159,
	'Lindsey',
	'Smith',
	'LSMITH',
	'011.44.1345.729268',
	STR_TO_DATE('10-MAR-1997', '%d-%M-%Y'),
	'SA_REP',
	8000,
	.3,
	146,
	80
	);

INSERT INTO employees
VALUES (
	160,
	'Louise',
	'Doran',
	'LDORAN',
	'011.44.1345.629268',
	STR_TO_DATE('15-DEC-1997', '%d-%M-%Y'),
	'SA_REP',
	7500,
	.3,
	146,
	80
	);

INSERT INTO employees
VALUES (
	161,
	'Sarath',
	'Sewall',
	'SSEWALL',
	'011.44.1345.529268',
	STR_TO_DATE('03-NOV-1998', '%d-%M-%Y'),
	'SA_REP',
	7000,
	.25,
	146,
	80
	);

INSERT INTO employees
VALUES (
	162,
	'Clara',
	'Vishney',
	'CVISHNEY',
	'011.44.1346.129268',
	STR_TO_DATE('11-NOV-1997', '%d-%M-%Y'),
	'SA_REP',
	10500,
	.25,
	147,
	80
	);

INSERT INTO employees
VALUES (
	163,
	'Danielle',
	'Greene',
	'DGREENE',
	'011.44.1346.229268',
	STR_TO_DATE('19-MAR-1999', '%d-%M-%Y'),
	'SA_REP',
	9500,
	.15,
	147,
	80
	);

INSERT INTO employees
VALUES (
	164,
	'Mattea',
	'Marvins',
	'MMARVINS',
	'011.44.1346.329268',
	STR_TO_DATE('24-JAN-2000', '%d-%M-%Y'),
	'SA_REP',
	7200,
	.10,
	147,
	80
	);

INSERT INTO employees
VALUES (
	165,
	'David',
	'Lee',
	'DLEE',
	'011.44.1346.529268',
	STR_TO_DATE('23-FEB-2000', '%d-%M-%Y'),
	'SA_REP',
	6800,
	.1,
	147,
	80
	);

INSERT INTO employees
VALUES (
	166,
	'Sundar',
	'Ande',
	'SANDE',
	'011.44.1346.629268',
	STR_TO_DATE('24-MAR-2000', '%d-%M-%Y'),
	'SA_REP',
	6400,
	.10,
	147,
	80
	);

INSERT INTO employees
VALUES (
	167,
	'Amit',
	'Banda',
	'ABANDA',
	'011.44.1346.729268',
	STR_TO_DATE('21-APR-2000', '%d-%M-%Y'),
	'SA_REP',
	6200,
	.10,
	147,
	80
	);

INSERT INTO employees
VALUES (
	168,
	'Lisa',
	'Ozer',
	'LOZER',
	'011.44.1343.929268',
	STR_TO_DATE('11-MAR-1997', '%d-%M-%Y'),
	'SA_REP',
	11500,
	.25,
	148,
	80
	);

INSERT INTO employees
VALUES (
	169,
	'Harrison',
	'Bloom',
	'HBLOOM',
	'011.44.1343.829268',
	STR_TO_DATE('23-MAR-1998', '%d-%M-%Y'),
	'SA_REP',
	10000,
	.20,
	148,
	80
	);

INSERT INTO employees
VALUES (
	170,
	'Tayler',
	'Fox',
	'TFOX',
	'011.44.1343.729268',
	STR_TO_DATE('24-JAN-1998', '%d-%M-%Y'),
	'SA_REP',
	9600,
	.20,
	148,
	80
	);

INSERT INTO employees
VALUES (
	171,
	'William',
	'Smith',
	'WSMITH',
	'011.44.1343.629268',
	STR_TO_DATE('23-FEB-1999', '%d-%M-%Y'),
	'SA_REP',
	7400,
	.15,
	148,
	80
	);

INSERT INTO employees
VALUES (
	172,
	'Elizabeth',
	'Bates',
	'EBATES',
	'011.44.1343.529268',
	STR_TO_DATE('24-MAR-1999', '%d-%M-%Y'),
	'SA_REP',
	7300,
	.15,
	148,
	80
	);

INSERT INTO employees
VALUES (
	173,
	'Sundita',
	'Kumar',
	'SKUMAR',
	'011.44.1343.329268',
	STR_TO_DATE('21-APR-2000', '%d-%M-%Y'),
	'SA_REP',
	6100,
	.10,
	148,
	80
	);

INSERT INTO employees
VALUES (
	174,
	'Ellen',
	'Abel',
	'EABEL',
	'011.44.1644.429267',
	STR_TO_DATE('11-MAY-1996', '%d-%M-%Y'),
	'SA_REP',
	11000,
	.30,
	149,
	80
	);

INSERT INTO employees
VALUES (
	175,
	'Alyssa',
	'Hutton',
	'AHUTTON',
	'011.44.1644.429266',
	STR_TO_DATE('19-MAR-1997', '%d-%M-%Y'),
	'SA_REP',
	8800,
	.25,
	149,
	80
	);

INSERT INTO employees
VALUES (
	176,
	'Jonathon',
	'Taylor',
	'JTAYLOR',
	'011.44.1644.429265',
	STR_TO_DATE('24-MAR-1998', '%d-%M-%Y'),
	'SA_REP',
	8600,
	.20,
	149,
	80
	);

INSERT INTO employees
VALUES (
	177,
	'Jack',
	'Livingston',
	'JLIVINGS',
	'011.44.1644.429264',
	STR_TO_DATE('23-APR-1998', '%d-%M-%Y'),
	'SA_REP',
	8400,
	.20,
	149,
	80
	);

INSERT INTO employees
VALUES (
	178,
	'Kimberely',
	'Grant',
	'KGRANT',
	'011.44.1644.429263',
	STR_TO_DATE('24-MAY-1999', '%d-%M-%Y'),
	'SA_REP',
	7000,
	.15,
	149,
	NULL
	);

INSERT INTO employees
VALUES (
	179,
	'Charles',
	'Johnson',
	'CJOHNSON',
	'011.44.1644.429262',
	STR_TO_DATE('04-JAN-2000', '%d-%M-%Y'),
	'SA_REP',
	6200,
	.10,
	149,
	80
	);

INSERT INTO employees
VALUES (
	180,
	'Winston',
	'Taylor',
	'WTAYLOR',
	'650.507.9876',
	STR_TO_DATE('24-JAN-1998', '%d-%M-%Y'),
	'SH_CLERK',
	3200,
	NULL,
	120,
	50
	);

INSERT INTO employees
VALUES (
	181,
	'Jean',
	'Fleaur',
	'JFLEAUR',
	'650.507.9877',
	STR_TO_DATE('23-FEB-1998', '%d-%M-%Y'),
	'SH_CLERK',
	3100,
	NULL,
	120,
	50
	);

INSERT INTO employees
VALUES (
	182,
	'Martha',
	'Sullivan',
	'MSULLIVA',
	'650.507.9878',
	STR_TO_DATE('21-JUN-1999', '%d-%M-%Y'),
	'SH_CLERK',
	2500,
	NULL,
	120,
	50
	);

INSERT INTO employees
VALUES (
	183,
	'Girard',
	'Geoni',
	'GGEONI',
	'650.507.9879',
	STR_TO_DATE('03-FEB-2000', '%d-%M-%Y'),
	'SH_CLERK',
	2800,
	NULL,
	120,
	50
	);

INSERT INTO employees
VALUES (
	184,
	'Nandita',
	'Sarchand',
	'NSARCHAN',
	'650.509.1876',
	STR_TO_DATE('27-JAN-1996', '%d-%M-%Y'),
	'SH_CLERK',
	4200,
	NULL,
	121,
	50
	);

INSERT INTO employees
VALUES (
	185,
	'Alexis',
	'Bull',
	'ABULL',
	'650.509.2876',
	STR_TO_DATE('20-FEB-1997', '%d-%M-%Y'),
	'SH_CLERK',
	4100,
	NULL,
	121,
	50
	);

INSERT INTO employees
VALUES (
	186,
	'Julia',
	'Dellinger',
	'JDELLING',
	'650.509.3876',
	STR_TO_DATE('24-JUN-1998', '%d-%M-%Y'),
	'SH_CLERK',
	3400,
	NULL,
	121,
	50
	);

INSERT INTO employees
VALUES (
	187,
	'Anthony',
	'Cabrio',
	'ACABRIO',
	'650.509.4876',
	STR_TO_DATE('07-FEB-1999', '%d-%M-%Y'),
	'SH_CLERK',
	3000,
	NULL,
	121,
	50
	);

INSERT INTO employees
VALUES (
	188,
	'Kelly',
	'Chung',
	'KCHUNG',
	'650.505.1876',
	STR_TO_DATE('14-JUN-1997', '%d-%M-%Y'),
	'SH_CLERK',
	3800,
	NULL,
	122,
	50
	);

INSERT INTO employees
VALUES (
	189,
	'Jennifer',
	'Dilly',
	'JDILLY',
	'650.505.2876',
	STR_TO_DATE('13-AUG-1997', '%d-%M-%Y'),
	'SH_CLERK',
	3600,
	NULL,
	122,
	50
	);

INSERT INTO employees
VALUES (
	190,
	'Timothy',
	'Gates',
	'TGATES',
	'650.505.3876',
	STR_TO_DATE('11-JUL-1998', '%d-%M-%Y'),
	'SH_CLERK',
	2900,
	NULL,
	122,
	50
	);

INSERT INTO employees
VALUES (
	191,
	'Randall',
	'Perkins',
	'RPERKINS',
	'650.505.4876',
	STR_TO_DATE('19-DEC-1999', '%d-%M-%Y'),
	'SH_CLERK',
	2500,
	NULL,
	122,
	50
	);

INSERT INTO employees
VALUES (
	192,
	'Sarah',
	'Bell',
	'SBELL',
	'650.501.1876',
	STR_TO_DATE('04-FEB-1996', '%d-%M-%Y'),
	'SH_CLERK',
	4000,
	NULL,
	123,
	50
	);

INSERT INTO employees
VALUES (
	193,
	'Britney',
	'Everett',
	'BEVERETT',
	'650.501.2876',
	STR_TO_DATE('03-MAR-1997', '%d-%M-%Y'),
	'SH_CLERK',
	3900,
	NULL,
	123,
	50
	);

INSERT INTO employees
VALUES (
	194,
	'Samuel',
	'McCain',
	'SMCCAIN',
	'650.501.3876',
	STR_TO_DATE('01-JUL-1998', '%d-%M-%Y'),
	'SH_CLERK',
	3200,
	NULL,
	123,
	50
	);

INSERT INTO employees
VALUES (
	195,
	'Vance',
	'Jones',
	'VJONES',
	'650.501.4876',
	STR_TO_DATE('17-MAR-1999', '%d-%M-%Y'),
	'SH_CLERK',
	2800,
	NULL,
	123,
	50
	);

INSERT INTO employees
VALUES (
	196,
	'Alana',
	'Walsh',
	'AWALSH',
	'650.507.9811',
	STR_TO_DATE('24-APR-1998', '%d-%M-%Y'),
	'SH_CLERK',
	3100,
	NULL,
	124,
	50
	);

INSERT INTO employees
VALUES (
	197,
	'Kevin',
	'Feeney',
	'KFEENEY',
	'650.507.9822',
	STR_TO_DATE('23-MAY-1998', '%d-%M-%Y'),
	'SH_CLERK',
	3000,
	NULL,
	124,
	50
	);

INSERT INTO employees
VALUES (
	198,
	'Donald',
	'OConnell',
	'DOCONNEL',
	'650.507.9833',
	STR_TO_DATE('21-JUN-1999', '%d-%M-%Y'),
	'SH_CLERK',
	2600,
	NULL,
	124,
	50
	);

INSERT INTO employees
VALUES (
	199,
	'Douglas',
	'Grant',
	'DGRANT',
	'650.507.9844',
	STR_TO_DATE('13-JAN-2000', '%d-%M-%Y'),
	'SH_CLERK',
	2600,
	NULL,
	124,
	50
	);

INSERT INTO employees
VALUES (
	200,
	'Jennifer',
	'Whalen',
	'JWHALEN',
	'515.123.4444',
	STR_TO_DATE('17-SEP-1987', '%d-%M-%Y'),
	'AD_ASST',
	4400,
	NULL,
	101,
	10
	);

INSERT INTO employees
VALUES (
	201,
	'Michael',
	'Hartstein',
	'MHARTSTE',
	'515.123.5555',
	STR_TO_DATE('17-FEB-1996', '%d-%M-%Y'),
	'MK_MAN',
	13000,
	NULL,
	100,
	20
	);

INSERT INTO employees
VALUES (
	202,
	'Pat',
	'Fay',
	'PFAY',
	'603.123.6666',
	STR_TO_DATE('17-AUG-1997', '%d-%M-%Y'),
	'MK_REP',
	6000,
	NULL,
	201,
	20
	);

INSERT INTO employees
VALUES (
	203,
	'Susan',
	'Mavris',
	'SMAVRIS',
	'515.123.7777',
	STR_TO_DATE('07-JUN-1994', '%d-%M-%Y'),
	'HR_REP',
	6500,
	NULL,
	101,
	40
	);

INSERT INTO employees
VALUES (
	204,
	'Hermann',
	'Baer',
	'HBAER',
	'515.123.8888',
	STR_TO_DATE('07-JUN-1994', '%d-%M-%Y'),
	'PR_REP',
	10000,
	NULL,
	101,
	70
	);

INSERT INTO employees
VALUES (
	205,
	'Shelley',
	'Higgins',
	'SHIGGINS',
	'515.123.8080',
	STR_TO_DATE('07-JUN-1994', '%d-%M-%Y'),
	'AC_MGR',
	12000,
	NULL,
	101,
	110
	);

INSERT INTO employees
VALUES (
	206,
	'William',
	'Gietz',
	'WGIETZ',
	'51hr5.123.8181',
	STR_TO_DATE('07-JUN-1994', '%d-%M-%Y'),
	'AC_ACCOUNT',
	8300,
	NULL,
	205,
	110
	);

COMMIT;

INSERT INTO job_history
VALUES (
	102,
	STR_TO_DATE('13-Jan-1993', '%d-%M-%Y'),
	STR_TO_DATE('24-Jul-1998', '%d-%M-%Y'),
	'IT_PROG',
	60
	);

INSERT INTO job_history
VALUES (
	101,
	STR_TO_DATE('21-Sep-1989', '%d-%M-%Y'),
	STR_TO_DATE('27-Oct-1993', '%d-%M-%Y'),
	'AC_ACCOUNT',
	110
	);

INSERT INTO job_history
VALUES (
	101,
	STR_TO_DATE('28-Oct-1993','%d-%M-%Y'),
	STR_TO_DATE('15-Mar-1997','%d-%M-%Y'),
	'AC_MGR',
	110
	);

INSERT INTO job_history
VALUES (
	201,
	STR_TO_DATE('27-Feb-1996','%d-%M-%Y'),
	STR_TO_DATE('19-Dec-1999','%d-%M-%Y'),
	'MK_REP',
	20
	);

INSERT INTO job_history
VALUES (
	114,
	STR_TO_DATE('24-Mar-1998','%d-%M-%Y'),
	STR_TO_DATE('31-Dec-1999','%d-%M-%Y'),
	'ST_CLERK',
	50
	);

INSERT INTO job_history
VALUES (
	122,
	STR_TO_DATE('01-Jan-1999','%d-%M-%Y'),
	STR_TO_DATE('31-Dec-1999','%d-%M-%Y'),
	'ST_CLERK',
	50
	);

INSERT INTO job_history
VALUES (
	200,
	STR_TO_DATE('17-Sep-1987','%d-%M-%Y'),
	STR_TO_DATE('17-Jun-1993','%d-%M-%Y'),
	'AD_ASST',
	90
	);

INSERT INTO job_history
VALUES (
	176,
	STR_TO_DATE('24-Mar-1998','%d-%M-%Y'),
	STR_TO_DATE('31-Dec-1998','%d-%M-%Y'),
	'SA_REP',
	80
	);

INSERT INTO job_history
VALUES (
	176,
	STR_TO_DATE('01-Jan-1999','%d-%M-%Y'),
	STR_TO_DATE('31-Dec-1999','%d-%M-%Y'),
	'SA_MAN',
	80
	);

INSERT INTO job_history
VALUES (
	200,
	STR_TO_DATE('01-Jul-1994','%d-%M-%Y'),
	STR_TO_DATE('31-Dec-1998','%d-%M-%Y'),
	'AC_ACCOUNT',
	90
	);
    
COMMIT;

/* *************************************************************** 
***************************FOREIGN KEYS***************************
**************************************************************** */

ALTER TABLE countries ADD FOREIGN KEY (region_id) REFERENCES regions(region_id);    
ALTER TABLE locations ADD FOREIGN KEY (country_id) REFERENCES countries(country_id);
ALTER TABLE departments ADD FOREIGN KEY (location_id) REFERENCES locations(location_id);
ALTER TABLE employees ADD FOREIGN KEY (job_id) REFERENCES jobs(job_id);
ALTER TABLE employees ADD FOREIGN KEY (department_id) REFERENCES departments(department_id);
ALTER TABLE employees ADD FOREIGN KEY (manager_id) REFERENCES employees(employee_id);
ALTER TABLE departments ADD FOREIGN KEY (manager_id) REFERENCES employees (employee_id);
ALTER TABLE job_history ADD FOREIGN KEY (employee_id) REFERENCES employees(employee_id);
ALTER TABLE job_history ADD FOREIGN KEY (job_id) REFERENCES jobs(job_id);
ALTER TABLE job_history ADD FOREIGN KEY (department_id) REFERENCES departments(department_id);
