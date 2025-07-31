--Inline table valued function
Create Function GetEmployebyDept(@DeptID INT)
returns table
AS
return 
(
select EmpID,EmpName,Salary FROM Employe Where DeptID = @DeptID
)
select * FROM dbo.GetEmployebyDept(1);