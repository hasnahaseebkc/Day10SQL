--Database - Collection of tables
--syntax for database
create database IBM
use IBM

--create table
--Set of rules ->Constraints
--Primary key,Foreign key,Check,default,unique,not null
create table IBMTrainees
(
Tid int Primary key,TName varchar(25) Unique not null,Designation varchar(25) default 'Trainee',Age int check(Age<24)
)
--DML and DDL statements
--Statements->DML(data manipulation language)--insert,update,delete
--DDL(data definition language)-create,alter,drop
--DQL- data query language-select
--DCL-Data control language-grant,revoke
--TCL-transaction control lang-commit,rollback,savepoint

--INSERT
insert into IBMTrainees values(1,'John','HR',22)
insert into IBMTrainees values(2,'Peter','HR',23)
insert into IBMTrainees values(3,'Sam','Developer',22)
insert into IBMTrainees(Tid,TName,Age) values(4,'Jancy',22) --Default desg

--SELECT
select * from IBMTrainees
select Tid,TName from IBMTrainees
select * from IBMTrainees where Designation='HR'
select * from IBMTrainees where Age<23
select * from IBMTrainees where Age<23 and Designation='Developer'
select * from IBMTrainees where TName like 'S%'
select * from IBMTrainees where TName like '_a%'
select * from IBMTrainees where TName like '[A-J]%'	--range,not case sensitive
select * from IBMTrainees where TName not like '[A-J]%'
select * from IBMTrainees where Age between 20 and 22

--Foreign Key****************
--Department(Primary)

create table dept
(
Dno int Primary key,
Dname varchar(25)
)

insert into dept values(1,'HR')
insert into dept values(2,'Trainer')
insert into dept values(3,'Developer')
insert into dept values(4,'Designer')

select * from dept

--employee(child- foreign key)
create table emp
(
Eid int Primary key,
Ename varchar(25),
Did int foreign key references dept(Dno)
)

insert into emp values(100,'John',1)
insert into emp values(101,'Peter',1)

--delete

delete from dept where Dno=1 --delete child details first
delete from emp where Did=1
select * from dept

--update
update dept set Dname='Testing' where Dno=2
select * from dept

--create demo table
create table demo
(
id int primary key,
name varchar(25),
dept varchar(25)
)

select * from demo

--add a column to demo
alter table demo add salary int

--drop a column
alter table demo drop column dept

insert into demo values(1,'John',25000)
insert into demo values(2,'John1',25000)
insert into demo values(3,'John2',25000)
insert into demo values(4,'John3',25000)

delete from demo --can give where clause

truncate table demo

--delete n truncate table remains, records cleared. Delete can give where clause

drop table demo --delete entire table 

update demo set name='John5' where id=4


--****************Joins
--combining records from one or more table based on a common column
--inner join, right outter join,left outer join,full outer join,cross join

create table one
(
id int primary key,
name varchar(25),
designation varchar(25),
salary int
)

create table two
(
did int primary key,
dname varchar(25),
eid int foreign key references one(id)
)

insert into one values(1,'John','HR',29456)
insert into one values(2,'John1','dev',23456)
insert into one values(3,'John2','des',23456)
insert into one values(4,'John3','test',28456)
insert into one values(5,'John4','HR',22456)

insert into two values(100,'Developer',1)
insert into two values(101,'Desgner',4)
insert into two values(102,'Testing',5)

select * from one
select * from two

--inner join
select o.id,o.name,t.did,t.dname from one o inner join two t on o.id=t.eid
--inner join n join same, alliases for one n two is o n t

select o.id,o.name,t.did,t.dname from one o left join two t on o.id=t.eid
select o.id,o.name,t.did,t.dname from one o right join two t on o.id=t.eid
select o.id,o.name,t.did,t.dname from one o full join two t on o.id=t.eid

--full or full uter same , specify condition

create table one1
(
id int,
name varchar(25),
designation varchar(25),
salary int
)

create table two1
(
did int,
dname varchar(25),
eid int
)

insert into one1 values(1,'John','HR',29456)
insert into one1 values(2,'John1','dev',23456)
insert into one1 values(3,'John2','des',23456)
insert into one1 values(4,'John3','test',28456)
insert into one1 values(5,'John4','HR',22456)

insert into two1 values(100,'Developer',1)
insert into two1 values(101,'Desgner',4)
insert into two1 values(102,'Testing',5)
insert into two1 values(102,'Testing',7)

select o.id,o.name,t.did,t.dname from one1 o left join two1 t on o.id=t.eid
select o.id,o.name,t.did,t.dname from one1 o right join two1 t on o.id=t.eid
select o.id,o.name,t.did,t.dname from one1 o full join two1 t on o.id=t.eid

--*************Aggregate function
--min,ma,avg,sum,count

select * from one1

select max(salary) as 'Maximum Salary' from one1
select max(salary) as MaximumSalary from one1
select max(salary),min(salary),count(salary),avg(salary) from one1

insert into one1 values(6,'John','HR',29456)
insert into one1 values(7,'John1','dev',23456)
insert into one1 values(8,'John2','des',23456)
insert into one1 values(9,'John3','test',28456)
insert into one1 values(10,'John4','HR',22456)

--group by clause -->only with aggregate function
select count(salary),designation from one1 group by designation--only select the aggrgt or group by columns others cause error
select count(salary),designation,name from one1 group by designation,name
select * from one1

--order by clause

select * from one1 order by salary
select * from one1 order by salary desc
select * from one1 order by designation
select * from one1 order by designation,salary

--******************************************************************************

--Function-subprogram->perform an action
--1.pre-defined functions
--2.user defined
	-->scalar - return a single value
	-->inline table value - return table - single statement
	-->multistatement table value - multiple statements - returns table

--SCALAR FUNCTIONS:
use ibm

create function cal_cube(@a int) --decimal(3,2)
returns int
as
	begin
		return @a*@a*@a
	end

select dbo.cal_cube(2) as Result

create function cal_age(@dob date)
returns int
as
	begin
		declare @age int
		set @age=DATEDIFF(year,@dob,GETDATE())
		return @age
	end

select dbo.cal_age('01/01/2000') as Age

select * from IBMTrainees


--INLINE TABLE VALUED FUNCTIONS:(no need of begin and end)
create function Fun_des(@desig varchar(25))
returns table
as
	return(select * from IBMTrainees where Designation=@desig)

select * from Fun_des('HR')
select * from Fun_des('Developer')



--MULTI-STATEMENT TABLE VALUED FUNCTIONS
create function Fun_IBMT()
returns @tbl table(TraineeID int, TraineeName varchar(25))
as
	begin
		insert into @tbl	--insert into table values
		select Tid,TName from IBMTrainees
		return
	end

select * from Fun_IBMT()

--*******************************************8

--Stored Procedure-group of one or more pre-compiled queries(improve performance)

--Pre and User-defined

create procedure sp_IBMDES
as
	begin
		select Designation from IBMTrainees
	end

exec sp_IBMDES
