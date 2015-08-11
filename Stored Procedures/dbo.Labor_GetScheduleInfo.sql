SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Labor_GetScheduleInfo]
@ScheduleID int,
@Weekly datetime,
@StoreID int
as
 
begin
select * from LaborScheduleInfo where ScheduleID=@ScheduleID and Weekly=@Weekly and StoreId = @StoreID
end
GO
