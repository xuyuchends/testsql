SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Labor_GetEmployeeByID]

@userID int,
@StoreID int,
@Type int
as
begin
if(@Type = 1)
begin
 select * from Employee as emp 
  where  emp.ID = (select EmployeeID from EnterpriseUser users where users.ID = @userID and users.StoreID =@StoreID)AND emp.StoreID = @StoreID
end
else if(@Type = 2)
begin
 select distinct job.ID'JobID',PositionID,job.EmployeeID'EmployeeID',pos.[View/PrintAllSchedules] 'View/PrintAllSchedules'from EmployeeJob as job 
 join Position pos on job.PositionID =pos.ID and  job.StoreID = pos.StoreID
  where job.EmployeeID= (select EmployeeID from EnterpriseUser users where users.ID = @userID and users.StoreID =@StoreID)AND pos.StoreID = @StoreID
end
 end

 
GO
