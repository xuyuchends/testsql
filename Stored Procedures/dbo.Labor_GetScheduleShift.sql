SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Labor_GetScheduleShift]
@ScheduleID int,
@Weekly datetime,
@JobID int,
@StoreID int
as
begin
if(@JobID = 0)
begin
	if(@ScheduleID = 0)
	begin
		select * FROM  LaborScheduleShift where weekly = @Weekly and StoreID = @StoreID
    end
    else
    begin
		select * FROM  LaborScheduleShift where ScheduleID = @ScheduleID and weekly in (DATEADD(DAY,-7,@Weekly),@Weekly,DATEADD(DAY,7,@Weekly)) and StoreID = @StoreID
    end
end
else 
begin
select * FROM  LaborScheduleShift where ScheduleID = @ScheduleID and weekly = @Weekly and JobID = @JobID and StoreID = @StoreID
end
end

 
 
 
 
GO
