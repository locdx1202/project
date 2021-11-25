-- for each employee
--  calculate the avg salary for employee.office
--  return the employee if salary > avg
SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE office_id = e.office_id);
    
    
select * from employees;

select
	employee_id,
    concat(first_name,' ', last_name) as full_name,
    salary,
    office_id,
    avg(salary) over(partition by office_id) as avg_office_salary
from employees;

with avg_office_salary as (
	select
		*,
		avg(salary) over(partition by office_id) as avg_salary
	from employees
)
select *
from avg_office_salary aos
where aos.salary > aos.avg_salary;

-- tính avg(salary) của cả công ty, xem phòng ban nào có số người thu nhập trên mức trung bình cao nhất
select
	*
from(
select 
	*,
    avg(salary) over() as avg_salary
from employees) sub
where sub.salary > sub.avg_salary;
--
select
	sub.office_id,
    count(sub.office_id) as count_office
from(
select 
	*,
    avg(salary) over() as avg_salary
from employees) sub
where sub.salary > sub.avg_salary
group by 1
order by 2 desc
;
--

-- xem thử thu nhập theo thứ tự các state, liệu ở state có phải là yếu tố tác động lên thu nhập.
with avg_office_salary as (
	select
		*,
		avg(salary) over(partition by office_id) as avg_salary
	from employees
)
select 
	aos.avg_salary,
    o.city,
    o.state
from avg_office_salary aos
join offices o using(office_id)
group by state
order by 1 desc;
--
with avg_office_salary as (
	select
		*,
		avg(salary) over(partition by office_id) as avg_salary
	from employees
)
select 
	*
from avg_office_salary aos
join offices o using(office_id);