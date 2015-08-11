SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Group_InUpDel]
	@SQLOperationType nvarchar(50),
	@GroupName nvarchaR(50),
	@GroupID int,
	@UserID int,
	@RoleType int,
	@ErrorMsg nvarchar(200) output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if @SQLOperationType='SQLUpdate'
	begin
		if exists (select * from [Group] where Name=@GroupName and id<>@GroupID)
			begin
				set @ErrorMsg='Name is existed,Please Modify Name'
				return 
			end
		update [Group] set Name=@GroupName,userid=@UserID where ID=@GroupID
	end
	else if @SQLOperationType='SQLInsert'
	begin
		if exists (select * from [Group] where Name=@GroupName)
			begin
				set @ErrorMsg='Name is existed,Please Modify Name'
				return 
			end
		insert into [Group] (Name,CanDelete,userid,LastUpdate,RoleType) values (@GroupName,1,@UserID,GETDATE(),@RoleType)
	end
	else if @SQLOperationType='SQLDelete'
	begin
		declare @canDelete bit
		set @canDelete=1
		select @canDelete=CanDelete from [Group] where ID=@GroupID
		if @canDelete=1
			begin try
			begin tran
				delete from  GroupToUser where GroupID=@GroupID
				delete from GroupToFunction  where GroupID=@GroupID
				delete from [Group] where ID=@GroupID
			commit tran
			end try
			begin catch
				rollback tran
			end catch
		else
			begin
				set @ErrorMsg='Can not delete default group'
				return 
			end
	END
end
GO
