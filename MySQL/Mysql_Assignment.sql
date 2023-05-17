---------------------------------------------------- Set 1 --------------------------------------------------------
        -- Question 1 --
create database Assignment;

		-- Question 2 --
use Assignment;

		-- Question 3 a--
create table countries(
name varchar(100),
population int,
capital varchar(100)
);
		-- Question 3 b--
insert into countries 
values("China",1382,"Beijing"),("India",1326,"Delhi"),
("United States",324,"Washington D.C."),("Indonesia",260,"Jakarta"),
("Brazil",209,"Brasilia"),("Pakistan",193,"Islamabad"),
("Nigeria",187,"Abuja"),('Bangladesh',163,"Dhaka"),
("Russia",143,"Moscow"),("Mexico",128,"Mexico City"),
("Japan",126,"Tokyo"),("Philippines",102,"Manila"),
("Ethiopia",101,"Addis Ababa"),("Vietnam",94,"Hanoi"),
("Egypt",93,"Cairo"),("Germany",81,"Berlin"),
("Iran",80,"Tehran"),("Turkey",79,"Ankara"),
("Congo",79,"Kinshasa"),("France",64,"Paris"),
("United Kingdom",65,"London"),("Italy",60,"Rome"),
("South Africa",55,"Pretoria"),("Myanmar",54,"Naypyidaw"),
("South Korea",92,"Seoul"),("Canada",101,"Ottawa");

		-- Question 3 c--
set sql_safe_updates=0;
update countries 
set capital="New Delhi"
where capital="Delhi";

select * from countries;

		-- Question 4--
rename table countries to big_countries;

		-- Question 5--
create table suppliers(
supplier_id int primary key,
supplier_name varchar(100),
location varchar(255)
);

create table product(
product_id int auto_increment ,
product_name varchar(100) not null unique ,
supplier_id int,
primary key(product_id),
Foreign Key(supplier_id) references Suppliers(supplier_id ) 
);

create table Stock(
id int auto_increment primary key,
product_id int,
foreign key(product_id) references product(product_id),
balance_stock int)
;

		-- Question 6--
insert into suppliers 
values 
(1,"Aditya Sharma","Mumbai"),
(2,"Raghini Mitra","Hyadrabad"),
(3,"Jeet Roy","Pune"),
(4,"Snehal Deshamukh","Delhi");

insert into product (product_name,supplier_id) 
values 
("Laptop" , 4),
("Mobile",2),
("Ipad",1),
("Speakers",3)
;

insert into stock (product_id,balance_stock) 
values (1,25000),(2,5000),(3,75000),(4,45000);
select * from stock;

		-- Question 7--
alter table suppliers modify column supplier_name varchar(100) not null unique;
desc suppliers;

		-- Question 8 a--

select*from emp;
alter table emp add column deptno int;

		-- Question 8 b--

update emp
set deptno = case
				when mod(emp_no,2)=0 then 20
                when mod(emp_no,3)=0 then 30
                when mod(emp_no,4)=0 then 40
                when mod(emp_no,5)=0 then 50
                else 10
                end;

		-- Question 9--
create unique index emp_id on employee(empid);
desc employee;

		-- Question 10--
create view emp_sal as
select emp_no, first_name, last_name, salary
from emp
order by salary desc;

select* from emp_sal;

--------------------------------------------------- Set 2 --------------------------------------------------------

		-- Question 1--
select * from employee where deptno=10 and salary>3000;

		-- Question 2--

		-- Question 2 a--
select count(id) from 
(select *,
case 
when marks > 80 then "Distinctions"
when marks > 60 then  "First Class"
when marks > 50 then "First Class"
when marks > 40 then "Second Class"
end status
from students) abc 
where status="First Class";

		-- Question 2 b--
select count(id) from
(select *,
case 
when marks > 80 then "Distinctions"
when marks > 60 then  "First Class"
when marks > 50 then "First Class"
when marks > 40 then "Second Class"
end status
from students)abc
where status="Distinctions";

		-- Question 3--
select distinct(city) from station where mod(id,2)=0;

		-- Question 4--
select N,N1, N-N1 as difference from
(select count(city) as N, count(distinct(city)) as N1 from station) as abc;

		-- Question 5 a--
select distinct(city) from station where left(city,1) in ("a","e","o","i","u");

		-- Question 5 b--
select distinct(city) from station where left(city,1) in ("a","e","o","i","u") and right(city,1) in ("a","e","o","i","u");

		-- Question 5 c--
select distinct(city) from station where left(city,1) not in ("a","e","o","i","u");
		-- Question 5 d--
select distinct(city) from station where left(city,1) 
not in ("a","e","o","i","u") or  right(city,1) not in ("a","e","o","i","u");

		-- Question 6--
select emp_no,first_name,last_name,hire_date,salary from emp
where timestampdiff(month,now(),hire_date)<36 and salary>2000
order by salary desc;

		-- Question 7-- 
select deptno, sum(salary) as total_salary 
from employee
group by deptno;

		-- Question 8--
select count(id) from city
where population > 100000;

		-- Question 9--
select sum(population) from city where district="California";

		-- Question 10--
select district,countrycode,avg(population) from city 
group by district,countrycode;

		-- Question 11--
select o.orderNumber,o.status,c.customernumber, c.customername, o.comments 
from orders o inner join customers c
using(customerNumber)
where status="Disputed";

--------------------------------------------------- set 3 -----------------------------------------------------
            		-- Question 1--
delimiter //
create procedure order_status(in param_year int, in param_month int)
begin
select ordernumber, orderdate, status from orders 
where month(orderDate)=param_month and year(orderDate)=param_year;
end //

call order_status(2005,11);
call order_status(2005,3);

		-- Question 2--
create table cancellation(
id int primary key,
customernumber int,
foreign key (customernumber) reference customers(customernumber)
);

CREATE TABLE cancellations (
    id int auto_increment,
    customernumber int not null,
    OrderNumber int NOT NULL,
    comments varchar(255),
    PRIMARY KEY (id),
    FOREIGN KEY (customernumber) REFERENCES customers(customernumber),
    FOREIGN KEY (OrderNumber) REFERENCES orders(OrderNumber)
);

delimiter // 
create procedure order_cancel()
begin
declare lcl_customernumber int;
declare lcl_ordernumber int;
declare lcl_comments varchar(255);
declare finish int default 0;
declare mycur cursor for select customernumber,ordernumber,comments from orders where status="cancelled";
declare continue handler for not found set finish=1;
open mycur;
myloop:loop
 fetch mycur into lcl_customernumber,lcl_ordernumber,lcl_comments;
 if finish=1 then
		leave myloop;
    end if;
insert into cancellations(customerNumber,orderNumber,comments)
 values(lcl_customernumber,lcl_ordernumber,lcl_comments);
end loop myloop;
close mycur;
end //

call order_cancel();

		-- Question 3 a--
Delimiter //
create function purchase_status (in_customernumber int)
returns varchar(20)
reads sql data
deterministic
begin
    declare statu varchar(20);
    declare total float default 0;
    
    set total=(select sum(amount) from payments where in_customernumber = customernumber);
	if total < 25000 then set statu= 'Silver';
    elseif total>25000 and amount <50000 then set statu = 'Gold';
    elseif total>50000 then set statu='Platinum';
    end if;
	return statu;
end//
    

		-- Question 3 b--
delimiter //
create procedure cust_detail()
begin
    select customernumber, customername, if (creditlimit>50000,"Platinum",if(50000>creditlimit>25000,"Gold","Silver"))
    from customers;
end//

		-- Question 4--
delimiter //
create trigger on_update_cascade
after update
on movies for each row
begin 
update rentals
set movieid=new.id
where movieid=old.id;
end //

update movies set id=2 where id=1;

delimiter //
create trigger on_delete_cascade
after delete
on movies for each row
begin 
delete from rentals
where movieid=old.id;
end //

delete from movies where id=2;

		-- Question 5--
select fname from employee
order by salary desc 
limit 2,1;
		-- Question 6--
select *, 
rank() over (order by salary desc) as Rank_by_amount
from employee; 
