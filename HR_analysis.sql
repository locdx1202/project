-- Overall information of <employees> and <offices> table
SELECT * FROM employees;
SELECT * FROM offices;
-- Handle duplicate data
SET FOREIGN_KEY_CHECKS=0;

WITH ctd AS (
	SELECT
		*,
        ROW_NUMBER() OVER(PARTITION BY first_name) AS rn
	FROM employees
)
DELETE FROM employees  USING employees JOIN ctd ON employees.employee_id = ctd.employee_id
WHERE ctd.rn >1;

SET FOREIGN_KEY_CHECKS=1;

-- Calculate the avg salary of each office, return employees who have salary higer than average salary.
-- Using correlated subquery
SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE office_id = e.office_id);
-- Using windown function
WITH avg_office_salary AS (
	SELECT
		*,
		AVG(salary) OVER(PARTITION BY office_id) AS avg_salary
	FROM employees
)
SELECT *
FROM avg_office_salary aos
WHERE aos.salary > aos.avg_salary;


-- Calculate the average salary of the company and print the result of which department has the highest number of employee earning above average.
SELECT
	sub.office_id,
    COUNT(sub.office_id) AS count_office
FROM(
SELECT 
	*,
    AVG(salary) OVER() AS avg_salary
FROM employees) sub
WHERE sub.salary > sub.avg_salary
GROUP BY 1
ORDER BY 2 DESC
;
--

-- Average salary ranking by state, to determine if region has an impact on average salary.
WITH avg_office_salary AS (
	SELECT
		*,
		AVG(salary) OVER(PARTITION BY office_id) AS avg_salary
	FROM employees
)
SELECT 
	aos.avg_salary,
    o.city,
    o.state
FROM avg_office_salary aos
JOIN offices o USING(office_id)
GROUP BY state
ORDER BY 1 DESC;
