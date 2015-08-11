SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Labor_UpDelAttendanceStatuses]
@ID int,
@Name nvarchar(50),
@type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

if(@type = 0)
begin
insert into AttendanceStatuses values(@Name)
 
end
else if(@type = 1)
begin
 update AttendanceStatuses set name = @Name where ID = @ID

end
else if (@type = 2)
delete from AttendanceStatuses where ID = @ID
END
GO
