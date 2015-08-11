SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Task_InUpDel]
@ID int,
@Subject nvarchar(200),
@DueDate datetime,
@Description nvarchar(max),
@Priority int,
@Status int, -- 0:closed,1:not completed,2:completed
@AssignedTo nvarchar(20),
@UpdateUserID int,
@StoreID int,
@SQLType nvarchar(50)
AS
Declare @OldSubject nvarchar(200)
Declare @OldDueDate datetime
Declare @OldDescription nvarchar(max)
Declare @OldPriority int
Declare @OldStatus int
Declare @OldUpdateUserID int
declare @OldAssignedTo nvarchar(20)
declare @OldStoreID int
declare @error int

BEGIN
if @SQLType='SQLINSERT'
begin
	
	INSERT INTO [Task]
           ([Subject]
           ,[DueDate]
           ,[Description]
           ,[Priority]
           ,[Status]
           ,AssignedTo
           ,[UpdateUserID]
           ,StoreID
           ,[UpdateTime])
     VALUES
           (@Subject
           ,@DueDate
           ,@Description
           ,@Priority
           ,@Status
           ,@AssignedTo
           ,@UpdateUserID
           ,@StoreID
           ,GETDATE())   
      select @@IDENTITY
end
else if @SQLType='SQLUPDATE'
begin

	begin tran updateTask
	
	select @OldSubject=[Subject],
	@OldDueDate=DueDate,
	@OldDescription=[Description] ,
	@OldPriority =Priority,
	@OldStatus=[Status],
	@OldUpdateUserID=UpdateUserID,
	@OldAssignedTo=AssignedTo,
	@OldStoreID=StoreID
	from [Task] where ID=@ID
	
	set @error=@error+@@ERROR
	
	--if (@OldStatus=1 and @Status=2) or (@OldStatus=1 and @Status=3) 
	--begin
	--	update TaskDetail set Status=2 where TaskID=@ID
	--end
	if @error>0
	begin
		rollback tran updateTask
		select @error
	end
	else
	begin
	if @Subject is null
		begin
			set @Subject=@OldSubject
		end
		if @DueDate is null
		begin
			set @DueDate=@OldDueDate
		end
		if @Description is null
		begin
			set @Description=@OldDescription
		end
		if @Priority is null
		begin
			set @Priority=@OldPriority
		end
		if @Status is null
		begin
			set @Status=@OldStatus
		end
		if @UpdateUserID is null
		begin
			set @UpdateUserID=@OldUpdateUserID
		end
		if @AssignedTo is null
		begin
			set @AssignedTo=@OldAssignedTo
		end
		if @StoreID is null
		begin
			set @StoreID=@OldStoreID
		end
		if @UpdateUserID =@OldUpdateUserID
		begin
			UPDATE [Task]
		   SET [Subject] = @Subject
			  ,[DueDate] = @DueDate 
			  ,[Description] = @Description
			  ,[Priority] = @Priority
			  ,[Status] = @Status
			  ,AssignedTo=@AssignedTo
			  ,[UpdateUserID] = @UpdateUserID
			  ,StoreID=@StoreID
			  ,[UpdateTime] = GETDATE()
			  where ID=@ID
			 set @error=@error+@@ERROR
			 UPDATE [TaskDetail]
				SET 
				  [Status] = @Status,
				  ResolveUserID=@UpdateUserID
				WHERE [TaskID] = @ID and AssignedStoreID = @StoreID
			--  declare @SelStoreID int
			--  select @SelStoreID=StoreID from EnterpriseUser where ID=@UpdateUserID
			--  set @error=@error+@@ERROR
			--  declare @Count int
			--  select @Count=COUNT(*) from TaskDetail where TaskID=@ID and AssignedStoreID=@SelStoreID
			--  if @Count>0
			--  begin
			--update TaskDetail set Status= @Status,Description=@Description,ResolveUserID=@UpdateUserID,ResolveTime=GETDATE(),[enable]=1
		 --WHERE TaskID=@ID and AssignedStoreID=@SelStoreID
			-- end
			-- else
			-- begin
			--	INSERT INTO [TaskDetail]([TaskID],[Status],[Description],AssignedStoreID,ResolveUserID,[ResolveTime],[Enable])
			--		VALUES(@ID,@Status,@Description,@SelStoreID,'',GETDATE(),1)
			-- end
		 set @error=@error+@@ERROR
		 end
		 else
		 begin
			declare @userType nvarchar(20)
			declare @oldUserType nvarchar(20)
			select @userType =(case when StoreID=0 then '1' when StoreID>0 and IsManager=1 then '4' else '8' end) from EnterpriseUser where ID=@UpdateUserID
	set @error=@error+@@ERROR		
			select @oldUserType =(case when StoreID=0 then '1' when StoreID>0 and IsManager=1 then '4' else '8' end) from EnterpriseUser where ID=@OldUpdateUserID	
	set @error=@error+@@ERROR		
			if @userType=@oldUserType
			begin
				UPDATE [Task]
			   SET [Subject] = @Subject
				  ,[DueDate] = @DueDate 
				  ,[Description] = @Description
				  ,[Priority] = @Priority
				  ,[Status] = @Status
				  ,AssignedTo=@AssignedTo
				  ,[UpdateUserID] = @UpdateUserID
				  ,Storeid=@StoreID
				  ,[UpdateTime] = GETDATE()
				WHERE ID=@ID 
				set @error=@error+@@ERROR
			end
		 end
	 end
	 if @@ERROR >0
	 begin
		rollback tran updateTask
	 end
	 else
	 begin
		commit tran updateTask
	 end
	 select @@ERROR
	
	
end
else if @SQLType ='SQLDELETE'
begin
	begin tran DelTask
	update TaskDetail set [Enable]=0 where TaskID=@ID
	if @@ERROR=0
	begin
		delete from Task where ID=@ID
		if @@ERROR=0
		begin
			  commit tran DelTask
		end
		else
		begin
			  rollback tran DelTask
		end
	end
	else
	begin
		rollback tran DelTask
	end
	
	select @@error
end


END
GO
