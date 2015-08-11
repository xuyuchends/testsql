SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 CREATE proc [dbo].[Labor_GetScheduleShiftDetails]
@DetailID int,
@ScheduleID int,
@Weekly datetime,
@StoreID int
as
begin
if(@DetailID =  0)
begin
  --select * FROM  LaborScheduleShiftDetail  
  --where ShiftID 
  --in
 --dateadd(day,1,DATEADD(MINUTE,-1,@Weekly))
  --(select Shift.ID from LaborScheduleShift as shift 
  -- where ScheduleID = 1 and weekly = '2012-09-10 00:00:00.000' and StoreID =1)
   if(@Weekly <> '1900-01-01')
	   begin 
	    if(@ScheduleID = 0)
			begin
				select distinct detail.*,sch.ScheduleName,info.IsPublic AS 'IsPublic', info.Comments, job.Wage,pos.Name'PositionName',emp.Phone, emp.FirstName 'FirstName',emp.LastName 'LastName',job.EmployeeID,shift.ScheduleID 'ScheduleID' FROM  LaborScheduleShiftDetail as detail
				join LaborScheduleShift as shift on detail.ShiftID = shift.ID
				join LaborSchedule as sch on shift.ScheduleID = sch.ID and sch.IsPublic = 1
				join EmployeeJob as job on shift.JobID = job.ID and job.StoreID =shift.StoreID
				join Position as pos on job.PositionID = pos.ID and pos.StoreID = job.StoreID
				JOIN Employee as emp on emp.ID = job.EmployeeID and emp.StoreID = job.StoreID  and emp.IsTerminated = 0
				join LaborScheduleInfo as info on info.ScheduleID = sch.ID and info.Weekly = shift.Weekly and info.storeId=shift.StoreID
				where shift.StoreID =@StoreID and shift.Weekly  = @Weekly
			end 
		else
			begin
				select distinct detail.*,job.Wage,emp.FirstName 'FirstName',emp.LastName 'LastName',info.IsPublic AS 'IsPublic',job.EmployeeID,job.ID'JobID' FROM  LaborScheduleShiftDetail as detail
				join LaborScheduleShift as shift on detail.ShiftID = shift.ID 
				join EmployeeJob as job on shift.JobID = job.ID and job.StoreID = shift.StoreID
				JOIN Employee as emp on emp.ID = job.EmployeeID and emp.StoreID = job.StoreID  and emp.IsTerminated = 0
				left join LaborScheduleInfo as info on info.ScheduleID = shift.ScheduleID and info.Weekly = shift.Weekly and info.storeId=shift.StoreID
				where Shift.ScheduleID =@ScheduleID and shift.Weekly  in (DATEADD(DAY,-7,@Weekly),@Weekly,DATEADD(DAY,7,@Weekly)) and shift.StoreID =@StoreID
				order by emp.FirstName
			end
		end
  else if(@ScheduleID = 0)
	begin
		select distinct detail.*,job.Wage,pos.Name'PositionName',emp.FirstName 'FirstName',emp.LastName 'LastName' FROM  LaborScheduleShiftDetail as detail
		join LaborScheduleShift as shift on detail.ShiftID = shift.ID
		join EmployeeJob as job on shift.JobID = job.ID and job.StoreID = shift.StoreID
		join Position as pos on job.PositionID = pos.ID and pos.StoreID = job.StoreID
		JOIN Employee as emp on emp.ID = job.EmployeeID and emp.StoreID = job.StoreID
		where  shift.StoreID =@StoreID
	end
	else
	begin
		select distinct detail.*,job.Wage FROM  LaborScheduleShiftDetail as detail
		join LaborScheduleShift as shift on detail.ShiftID = shift.ID
		join EmployeeJob as job on shift.JobID = job.ID and shift.StoreID = job.StoreID
		where Shift.ScheduleID =@ScheduleID and shift.StoreID =@StoreID
	end
end
else
		begin
			select distinct detail.*,shift.ScheduleID 'ScheduleID',shift.Weekly 'Weekly', shift.Weekly,job.Wage,job.ID 'JobID',job.PositionID,pos.Name 'PositionName'from  LaborScheduleShiftDetail as detail
			join LaborScheduleShift as shift on detail.ShiftID = shift.ID
			join EmployeeJob as job on shift.JobID = job.ID
			join Position pos on job.PositionID = pos.ID
			where detail.ID = @DetailID 
		end
 end
GO
