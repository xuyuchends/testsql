SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Labor_InsSchedule]
@ID int,
@ScheduleName nvarchar(50),
@Status int,
@Postions nvarchar(50),
@IsPublic int,
@Operate nvarchar(20)
as 
if(@Operate = 'INSERT')
BEGIN
 insert into LaborSchedule values(@ScheduleName,@Status,@Postions,@IsPublic)
END
ELSE IF(@Operate = 'DELETE')
BEGIN
delete from LaborSchedule where ID=@ID
END
else if(@Operate= 'UPDATE')
BEGIN
update LaborSchedule set ScheduleName = @ScheduleName ,[Status]=@Status,Postions=@Postions,IsPublic = @IsPublic where ID=@ID
END
GO
