SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Document_InUpDel]
@SQLOperationType nvarchar(50),
@ID int,
@Name nvarchar(50),
@Description  nvarchar(max),
@FilePath nvarchar(200),
@FileSize nvarchar(50),
@FileAlias nvarchar(50),
@FileType nvarchar(50),
@CategoryID nvarchar(50),
@UpdateUserID int,
@WhoCanView int,
@WhoCanEdit int,
@CanViewStoreID nvarchar(2000),
@PubStoreID int,
@UpdateTime datetime
AS
BEGIN
	SET NOCOUNT ON;
	if @SQLOperationType='SQLInsert'
	begin
		insert  into  [DocumentManager]
			([Name],
			[Description],
			[FilePath],
			[FileSize],
			[FileAlias],
			[FileType],
			[CategoryID],
			[UserID],
			WhoCanView,
			WhoCanEdit,
			CanViewStoreID,
			UpdateUserID,
			PubStoreID,
			[UpdateTime])
		values (@Name,@Description,@FilePath,@FileSize,@FileType,@FileAlias,@CategoryID,
		@UpdateUserID,@WhoCanView,@WhoCanEdit,@CanViewStoreID,@UpdateUserID,@PubStoreID,@UpdateTime)
	return @@IDENTITY
	end
	else if @SQLOperationType='SQLUpdate'
	begin
		update [DocumentManager] 
		set  [Name]=@Name,[Description]=@Description,FilePath=@FilePath,[FileType]=@FileType,FileSize=@FileSize,[FileAlias]=@FileAlias,CategoryID=@CategoryID,
		UpdateTime=@UpdateTime,WhoCanView=@WhoCanView,WhoCanEdit=@WhoCanEdit,CanViewStoreID=@CanViewStoreID,UpdateUserID=@UpdateUserID
		where ID=@ID
	end
	else if @SQLOperationType='SQLDelete'
	begin
		delete from [DocumentManager] where ID=@ID
	end
END
GO
