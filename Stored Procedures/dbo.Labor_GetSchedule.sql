SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Labor_GetSchedule]
	@StoreID int,
	@ScheduleID int
as
begin
	if ISNULL(@StoreID,0)>0
	begin
		if(@ScheduleID!=0)
		begin
			SELECT ID,ScheduleName,Status,dbo.[fn_GetPositionID](LaborSchedule.Postions,@StoreID) as Postions,ispublic  FROM  LaborSchedule  where  ID = @ScheduleID
		end
		else
		begin
			SELECT ID,ScheduleName,Status,dbo.[fn_GetPositionID](LaborSchedule.Postions,@StoreID) as Postions,ispublic  FROM  LaborSchedule 
		end
	end
	else
	begin
		if(@ScheduleID!=0)
		begin
			SELECT *  FROM  LaborSchedule where  ID = @ScheduleID
		end
		else
		begin
			SELECT *  FROM  LaborSchedule 
		end
	end
end



GO
