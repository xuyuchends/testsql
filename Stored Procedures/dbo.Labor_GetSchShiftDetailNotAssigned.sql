SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Labor_GetSchShiftDetailNotAssigned]
@ScheduleID int,
@DetailID int,
@Weekly datetime,
@StoreID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@DetailID =  0)
	begin
	select distinct  shift.JobID,detail.*,sch.ScheduleName,info.IsPublic AS 'IsPublic', info.Comments, pos.Name'PositionName',shift.ScheduleID 'ScheduleID',shift.JobID ,shift.Weekly
				FROM  LaborScheduleShiftDetail as detail
				join LaborScheduleShift as shift on detail.ShiftID = shift.ID
				join LaborSchedule as sch on shift.ScheduleID = sch.ID and sch.IsPublic = 1
				join Position as pos on ABS(shift.JobID) = pos.ID and pos.StoreID = shift.StoreID
				left join LaborScheduleInfo as info on info.ScheduleID = sch.ID and info.Weekly = shift.Weekly
				where Shift.ScheduleID =@ScheduleID and shift.Weekly  in (DATEADD(DAY,-7,@Weekly),@Weekly,DATEADD(DAY,7,@Weekly)) and shift.StoreID =@StoreID
	end
	else
	begin
			select distinct detail.*,shift.JobID,shift.ScheduleID 'ScheduleID',shift.Weekly 'Weekly', shift.Weekly,pos.Name 'PositionName',pos.ID 'PositionID' from  LaborScheduleShiftDetail as detail
			join LaborScheduleShift as shift on detail.ShiftID = shift.ID
			join Position as pos on ABS(shift.JobID) = pos.ID and pos.StoreID = shift.StoreID
			where detail.ID = @DetailID 
	end
				
END
GO
