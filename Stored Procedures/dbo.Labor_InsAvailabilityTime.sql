SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create proc [dbo].[Labor_InsAvailabilityTime]
	  @WeekDays nvarchar(50)
      ,@TimeScale nvarchar(50)
       ,@AvailabilityID int
AS
BEGIN
insert into LaborAvailabilityTime(WeekDays, TimeScale, AvailabilityID)
values(@WeekDays, @TimeScale, @AvailabilityID)
END
select @@IDENTITY
GO
