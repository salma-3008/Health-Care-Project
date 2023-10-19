
use hr;
#1
select concat(first_name,last_name) as fullname, salary
from employees where salary >
(select salary from employees where last_name = 'Bull');
#2
select concat(first_name,' ',last_name) as fullname from 
employees join departments using(department_id) where
department_name = 'IT'; 
select * from departments;
select * from employees;
#3
select concat(first_name,' ',last_name) as fullname from 
employees where manager_id in (select manager_id from 
departments where location_id in (select location_id 
from locations where country_id = 'US'));
#4
select concat(first_name,' ',last_name) as fullname from 
employees where employee_id in 
(select manager_id  from departments);
#5
select concat(first_name,' ',last_name) as fullname,salary
from employees where salary > (select avg(salary) from
employees);
#6
select concat(first_name,' ',last_name) as fullname,salary
from employees e where salary = (select min_salary from
jobs j where e.job_id = j.job_id);
#7
select concat(first_name,' ',last_name) as fullname,salary
from employees join departments using(department_id)  
where salary > (select avg(salary) from
employees) and department_name like '%it%';
#8
select concat(first_name,' ',last_name) as fullname,salary
from employees where salary > (select salary from employees
 where last_name = 'Bell');
 #9
select concat(first_name,' ',last_name) as fullname,salary,department_id
from employees where salary = (select min(salary) from 
employees) group by department_id,salary,fullname;
#10
select concat(first_name,' ',last_name) as fullname,salary
from employees where salary > (select avg(salary) from
employees) group by department_id;
#11
select concat(first_name,' ',last_name) as fullname,salary
from employees where salary > (select max_salary from jobs
where job_id = 'SH_CLERK') order by salary;
#12
select concat(first_name,' ',last_name) as fullname
from employees where employee_id not in
(select manager_id from departments);
#13
select employee_id,first_name,last_name,department_name
from employees join departments using(department_id);
#14
select employee_id,first_name,last_name,salary from
employees e1 where salary > (select avg(salary) from employees
e2 where e1.department_id = e2.department_id group by 
department_id);
#15
select * from employees where employee_id % 2 = 0;
#16
select salary from employees order by salary desc limit 1
offset 4;
#17
#18
select * from employees order by employee_id desc limit 10;
#19
select department_id,department_name from departments
where department_id not in 
(select department_id from employees);
#20
select salary from employees order by salary desc limit 3;
#21
select salary from employees order by salary limit 3;
#22







