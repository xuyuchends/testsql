SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DocumentCateogry_InUpDel]
@SQLOperationType nvarchar(50),
@ID int,
@Name nvarchar(50),
@error nvarchar(200) output
AS
BEGIN
	SET NOCOUNT ON;
	if @SQLOperationType='SQLInsert'
	begin
		if exists (select * from DocumentCateogry where Name=@Name)
		begin
			set @error='name is existed'
			return
		end
		insert into [DocumentCateogry](Name) values(@Name)
		return @@IDENTITY
	end
	else if @SQLOperationType='SQLUpdate'
	begin
		if exists (select * from DocumentCateogry where Name=@Name and ID<>@ID)
		begin
			set @error='name is existed'
			return
		end
		update [DocumentCateogry] 
		set [Name]=@Name
		where ID=@ID
	end
	else if @SQLOperationType='SQLDelete'
	begin
		delete from [DocumentManager] where [CategoryID]=@ID
		delete from [DocumentCateogry] where ID=@ID
	end


END
GO
