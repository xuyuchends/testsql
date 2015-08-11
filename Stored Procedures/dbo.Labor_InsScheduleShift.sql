SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Labor_InsScheduleShift]
@ScheduleID int,
@JobID int,
@Weekly datetime,
@StoreID int
as 
 insert into LaborScheduleShift values(@ScheduleID,@JobID,@Weekly,@StoreID)
return @@IDENTITY
GO
