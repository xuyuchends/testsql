SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Labor_InsScheduleInfo]
@ID int,
@ScheduleID int,
@Weekly nvarchar(50),
@Comments nvarchar(500),
@IsPublic int,
@StoreID int,
@Type int 
as
if(@Type = 0) 
	begin try  
		insert into LaborScheduleInfo(ScheduleID,Comments,Weekly,IsPublic,StoreId) values(@ScheduleID,@Comments,@Weekly,@IsPublic,@StoreID)
		select @@identity
	END TRY
	BEGIN CATCH
		if @@ERROR <>0
			update LaborScheduleInfo set Comments=@Comments,IsPublic=@IsPublic where Weekly = @Weekly and ScheduleID =@ScheduleID and StoreId = @StoreID
	end  CATCH 
else if(@Type=1)
	begin
		update LaborScheduleInfo set Comments=@Comments,IsPublic=@IsPublic where id = @ID
	end
GO
