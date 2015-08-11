SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Labor_GiveUpSel]

@userID int,
@StoreID int,
@BeginTime datetime,
@Type nvarchar(20)
as
begin
if(@Type = 'USER')
begin
	select detail.ID as ID, 
	detail.IsGiveUp as IsGiveUp,
	detail.GiveUpFrom as GiveUpFrom,
	detail.GiveUpStatus as GiveUpStatus,
	detail.BeginTime as BeginTime,
	detail.EndTime as EndTime,
	detail.Description as Description,
	pos.Name as PositionName,
	pos.ID as PositionID,
	schedule.ID as ScheduleID,
	schedule.ScheduleName as ScheduleName,
	users.ID as UserID, 
	users.FirstName,
	users.LastName 
	from LaborScheduleShiftDetail as detail
	join LaborScheduleShift as shift  on detail.ShiftID = shift.ID
	join LaborScheduleInfo as info on shift.ScheduleID = info.ScheduleID and shift.Weekly = info.Weekly and info.IsPublic =1 and info.StoreId = shift.StoreID
	join LaborSchedule as schedule on schedule.ID = shift.ScheduleID
	join EmployeeJob as job on job.ID = shift.JobID and job.StoreID = shift.StoreID
	join Employee as users on users.ID=job.EmployeeID and users.StoreID = job.StoreID
	join Position as pos on job.PositionID = pos.ID and pos.StoreID = job.StoreID
	where (users.ID =@userID or (detail.GiveUpFrom in (select Jobgiveup.ID from EmployeeJob Jobgiveup where Jobgiveup.EmployeeID = @userID and Jobgiveup.StoreID = @StoreID )or GiveUpFrom=0 and detail.IsGiveUp = 1) )
	and detail.EndTime>=GETDATE() and pos.StoreID = @StoreID
end
else if(@Type ='MANAGER')
begin
	select detail.ID as ID, 
	detail.IsGiveUp as IsGiveUp,
	detail.GiveUpFrom as GiveUpFrom,
	detail.GiveUpStatus as GiveUpStatus,
	detail.BeginTime as BeginTime,
	detail.EndTime as EndTime,
	detail.Description as Description,
	pos.Name as PositionName,
	pos.ID as PositionID,
	schedule.ID as ScheduleID,
	schedule.ScheduleName as ScheduleName,
	users.ID as UserID, 
	users.FirstName,
	users.LastName 
	from LaborScheduleShiftDetail as detail
	join LaborScheduleShift as shift  on detail.ShiftID = shift.ID
	join LaborScheduleInfo as info on shift.ScheduleID = info.ScheduleID and info.StoreId = shift.StoreID and shift.Weekly = info.Weekly
	join LaborSchedule as schedule on schedule.ID = shift.ScheduleID
	join EmployeeJob as job on job.ID = shift.JobID  and job.StoreID = shift.StoreID
	join Employee as users on users.ID=job.EmployeeID and users.StoreID = job.StoreID
	join Position as pos on job.PositionID = pos.ID and pos.StoreID = job.StoreID
	where  detail.EndTime>=GETDATE() and pos.StoreID =@StoreID and ((IsGiveUp = 1 and GiveUpFrom = 0) or(IsGiveUp = 1 and GiveUpStatus =1))

 end
 end
GO
