SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Labor_GetAttendanceStatuses]
@ID int,
@type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

if(@type = 0)
begin
  select * from AttendanceStatuses
end
else if(@type = 1)
begin
select * from AttendanceStatuses where ID = @ID
end
END
GO
