SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[TaskDetail_InUpDel]
@ID int,
@TaskID int,
@Status int,
@Description nvarchar(max),
@AssignedStoreID int,
@ResolveUserID int,
@SQLOperationType nvarchar(50)
AS
declare @OldTaskID int
declare @OldStatus int
declare @OldDescription nvarchar(max)
declare @OldAssignedStoreID int
declare @OldResolveUserID int
declare @Count int
declare @Error int
BEGIN 
if @SQLOperationType='SQLINSERT'
begin
	INSERT INTO [TaskDetail]
           ([TaskID]
           ,[Status]
           ,[Description]
           ,AssignedStoreID
           ,ResolveUserID
           ,[ResolveTime]
           ,[Enable])
     VALUES
           (@TaskID
           ,@Status
           ,@Description
           ,@AssignedStoreID
           ,@ResolveUserID
           ,GETDATE()
           ,1)
           select @@ERROR
end
else if @SQLOperationType='SQLUPDATE'
begin
	select @OldTaskID=TaskID,
	@OldStatus=[Status],
	@OldDescription=[Description],
	@OldAssignedStoreID=AssignedStoreID,
	@OldResolveUserID =ResolveUserID
	from TaskDetail where [TaskID] = @TaskID and AssignedStoreID = @AssignedStoreID
	set @Error=@Error+@@ERROR
	if @TaskID is  null
	begin
		set @TaskID = @OldTaskID
	end
	if @Status is null
	begin
		set @Status=@OldStatus
	end
	if @Description is null
	begin
		set @Description=@OldDescription
	end
	if @AssignedStoreID is null
	begin
		set @AssignedStoreID=@OldAssignedStoreID
	end
	if @ResolveUserID is null
	begin
		set @ResolveUserID=@OldResolveUserID
	end
	select @Count=COUNT(*) from [TaskDetail] where [TaskID] = @TaskID and AssignedStoreID = @AssignedStoreID
	if (@Count>0)
	begin

		UPDATE [TaskDetail]
		SET 
		  [Status] = @Status
		  ,[Description] = @Description
		  ,ResolveUserID=@ResolveUserID
		  ,AssignedStoreID=@AssignedStoreID
		  ,[ResolveTime] = GETDATE()
		  ,[Enable]=1
		WHERE [TaskID] = @TaskID and AssignedStoreID = @AssignedStoreID
		set @Error=@Error+@@ERROR
	end
	else
	begin
		declare @TaskStatus int
		declare @TaskUpdateUserID int
		set @TaskUpdateUserID=null
		set @TaskStatus=1
		select @TaskStatus=[Status] from Task where ID=@TaskID and  StoreID=@AssignedStoreID
		if @TaskStatus=2
		    select @TaskUpdateUserID=UpdateUserID from task where ID=@TaskID and  StoreID=@AssignedStoreID
		
		INSERT INTO [TaskDetail]([TaskID],[Status],[Description],AssignedStoreID,ResolveUserID,[ResolveTime],[Enable])
     VALUES(@TaskID,@TaskStatus,@Description,@AssignedStoreID,@TaskUpdateUserID,GETDATE(),1)
     set @Error=@Error+@@ERROR
	end
	
	select @count=COUNT(*) from TaskDetail where TaskID=@taskID and Status=1 and Enable=1 and AssignedStoreID>0
	if @count=0
	begin
		update Task set Status=2 where ID=@taskID
		update TaskDetail set Status=2,ResolveUserID=@ResolveUserID where ID=@taskID and AssignedStoreID=0
	end
	 select @@ERROR
end
else if @SQLOperationType ='SQLDELETE'
begin
	update TaskDetail set [Enable]=0 where TaskID=@TaskID
	select @@ERROR
end
else if @SQLOperationType ='SQLDELETEDETAIL'
begin
	update TaskDetail set [Enable]=0 where ID=@ID
	select @@ERROR
end
else if @SQLOperationType ='SQLDELETECOMPLETELY'
begin
	delete from TaskDetail  where TaskID=@TaskID
	select @@ERROR
end
	
END
GO
