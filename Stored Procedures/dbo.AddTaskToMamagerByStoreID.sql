SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[AddTaskToMamagerByStoreID]
(
	@taskID int,
	@Description nvarchar(max),
	@UpdateUserID int
)
as
begin tran 
declare @Error int
declare @StoreID int
set @Error=0
select @StoreID=StoreID from EnterpriseUser where ID=@UpdateUserID
select ID from EnterpriseUser where IsManager=1 and Enable=1 and StoreID=@StoreID
set @Error=@Error+@@ERROR
declare @user int
declare cur cursor for select ID from EnterpriseUser where IsManager=1 and Enable=1 and StoreID=@StoreID
open cur
fetch next from cur into  @user
while @@FETCH_STATUS=0
begin
		execute [TaskDetail_InUpDel] 0,@taskID,1,@Description,@user,'SQLINSERT'
		set @Error=@Error+@@ERROR
	fetch next from cur into @user
end
close cur
deallocate cur
if @Error>0
begin
	rollback tran 
end
else
begin
	commit tran 
end

GO
