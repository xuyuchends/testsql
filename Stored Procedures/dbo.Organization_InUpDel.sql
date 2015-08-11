SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Organization_InUpDel]
@SQLOperationType nvarchar(50),
@ID int,
@parentID int,
@storeID int,
@Name nvarchar(50),
@Error nvarchar(200) output 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
if @SQLOperationType='SQLDelete'
	begin try
		BEGIN TRAN
			delete from OrganizationToUser where OrganizationID in (select ID from f_SelOrganization(@ID,1))
			delete from Organization where ID  in (select ID from f_SelOrganization(@ID,1))
		commit tran
	end try
	begin catch
		rollback tran
	end catch
else if @SQLOperationType='SQLUpdate'
	begin try
		BEGIN TRAN
			if exists (select * from f_SelOrganization(@ID,1) where id=@parentID)
				begin
					set @Error='don''t move current node to child node '
				end
			else
				begin
					update Organization set ParentID=@parentID , Name=@Name where ID=@ID
				end
		commit tran
	end try
	begin catch
		rollback tran
	end catch
else if @SQLOperationType='SQLInsert'
	begin
		insert into Organization (StoreID,ParentID,Name) values (@storeID,@parentID,@Name)
	end
END

GO
