SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Labor_GetEmployeeJob]
@StoreID int,
@EmployeeID int,
@PostionID int,
@type int
as
begin
		if(@type = 0)
			begin
				select * from EmployeeJob 
				where PositionID =@PostionID
				and StoreID = @StoreID

				and EmployeeID = @EmployeeID

			end
		else if(@type = 1)
			begin
				select distinct job.ID 'JobID', emp.ID 'EmployeeID' ,emp.FirstName,emp.LastName from EmployeeJob job
				JOIN Employee emp on job.EmployeeID = emp.ID and job.StoreID = emp.StoreID
				where job.StoreID = @StoreID AND job.PositionID =@PostionID and job.WageType = 'HOURLY' 
			 end 
		else if(@type = 2)
			begin
				select distinct job.ID 'JobID', emp.ID 'EmployeeID' ,emp.FirstName,emp.LastName from EmployeeJob job
				JOIN Employee emp on job.EmployeeID = emp.ID and job.StoreID = emp.StoreID
				where job.ID = @EmployeeID
			end
end
GO
