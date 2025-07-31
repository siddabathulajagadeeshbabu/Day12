create database Emp;
use Emp;
CREATE TABLE Department(
DeptID int primary KEY,
DeptName varchar(50)
);
--- Creating Employee Table ----
create table Employe(
EmpID int primary key,
EmpName varchar(100),
Salary decimal(10,2),
DeptID int,
ManagerID int,
DateOfJoining date);

---- Inserting values in Department Table ----
insert into Department values(1,'HR'),(2,'FINANCE'),(3,'IT');

---- Inserting values in Employee Table ----
insert into Employe values 
(101,'Raj',70000.45,3,null,'2024-01-15'),
(102,'Rajiv',35000,2,101,'2025-01-15'),
(103,'Rajesh',40000,3,101,'2021-01-15'),
(104,'Rajini',50000,3,102,'2022-01-15'),
(105,'Rani',70000,1,null,'2020-01-15');
insert into Employe values(106,'Kishor',80000,5,null,'2018-01-15');

Select * from Department;
Select * from Employe;

select Round(Avg(Salary),-2) from Employe;

select e1.EmpName as Employe , e1.EmpName as Manager
from Employe e1 Left Join Employe e2 on e1.ManagerID=e2.EmpID;


select * from Employe as e
Inner Join Department as d ON e.DeptID=d.DeptID; -- combines he column from multiple tables based on matching criteria
--returns a combined result of matching rows(Column level match)
--It keeps Duplicates unless DISTINCT is used explicitly
select * from Employe as e
Left Join Department as d ON e.DeptID=d.DeptID;

select * from Employe as e
Right Join Department as d ON e.DeptID=d.DeptID;

select * from Employe 
Cross Join Department ;

select * from Employe as e
Full Outer Join Department as d ON e.DeptID=d.DeptID;

select * from Employe as e
Left Join Department as d ON e.DeptID=d.DeptID
Except
select * from Employe as e
Right Join Department as d ON e.DeptID=d.DeptID;

select * from Employe as e
Left Join Department as d ON e.DeptID=d.DeptID
Intersect  
select * from Employe as e
Right Join Department as d ON e.DeptID=d.DeptID;

select * from Employe as e
Left Join Department as d ON e.DeptID=d.DeptID
Union
select * from Employe as e
Right Join Department as d ON e.DeptID=d.DeptID;

select count(salary) 
from Employe;

select EmpName from Employe
union 
select DeptName from Department;

select DeptID from Employe
Intersect --it shows you matching value only 
select DeptID from Department;
-- returing common rows between two independent select queries
-- duplicates removed 

select DeptID from Department
MINUS -- it is returning the result between two sets(not supported here,supports in ORACLE etc)
select DeptID from Employe;

select DeptID from Department
Except 
select DeptID from Employe;

create procedure DisplayDepartment
AS
BEGIN
SELECT * From Department;
END;

execute DisplayDepartment;


create procedure GetEmployeDetails 
@EmpID INT,@EmpName varchar(100) OUTPUT
AS
BEGIN
SELECT @EmpName = EmpName from Employe 
where EmpID = @EmpID;
END

declare @Name varchar(100);
execute GetEmployeDetails 103, @EmpName = @Name output;
print @Name;

--updatee employe details
Alter procedure UpdateEmployeDetails
@EmpID int,@NewSalary decimal(10,2) output
as
begin
update Employe
set salary = @NewSalary 
where EmpId = @EmpID;
select * from Employe
end;

execute UpdateEmployeDetails @EmpID = 102,@NewSalary = 90000;

Create procedure CheckSalary
@EmpID int
as
begin
declare @Salary decimal(10,2)
select @Salary = Salary from Employe where EmpID = @EmpID;
if @Salary>66000
print 'High Earner'
else
print'Low Earner';
end;

execute CheckSalary @EmpID=102;


BEGIN TRY
BEGIN Transaction ;
UPDATE Employe SET Salary = Salary + 5000 WHERE DeptID = 1;
commit 
END TRY

BEGIN CATCH
rollback;
Print 'Error_MESSAGE';
END CATCH

select * from Employe
Where DeptID = 1;

--scalar function
CREATE Function GetYearOfJoining(@EmpID INT)
returns  INT
AS
BEGIN
  Declare @Year INT;
  SELECT @Year = Year(DateOfJoining) FROM Employe Where EmpID = @EmpID;
  return @Year;
 END;

-- calling function
SELECT EmpName,dbo.GetYearOfJoining(102) As JoiningYear FROM Employe;


--Inline table valued function
create function GetEmployebyDept(@DeptID INT)
returns table
as
return 
(
select EmpID,EmpName,Salary from Employe Where DeptID = @DeptID
)
select * from dbo.GetEmployebyDept(1);


create procedure PrintEmployeJoiningYear
@EmpID int
as
begin
declare @Year int;
set @Year = dbo.GetYearOfJoining(@EmpID);
print 'Joined' + cast(@Year as varchar);
end;
execute PrintEmployeJoiningYear 101;