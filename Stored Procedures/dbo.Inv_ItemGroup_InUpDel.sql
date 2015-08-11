SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_ItemGroup_InUpDel]
(
	@ID int,
	@Name nvarchar(200),
	@IsActive bit,
	@LastUpdate datetime,
	@Creator int,
	@Editor int,
	@SQLOperationType nvarchar(50)
)
as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @GroupID int
	if (@SQLOperationType='SQLINSERT')
		begin
			if( select COUNT(*) from Inv_ItemGroup where Name=@Name)=0
			begin
			INSERT INTO [Inv_ItemGroup]([Name],[IsActive],[LastUpdate],[Creator],[Editor])
			VALUES(@Name,@IsActive,GETDATE(),@Creator,@Creator)
			 set @GroupID= @@IDENTITY
			end
			else
			begin
				UPDATE [Inv_ItemGroup] SET [IsActive] = @IsActive,[LastUpdate] = GETDATE(),[Editor] = @Creator
		where [Name] = @Name
				select @GroupID= id  from Inv_ItemGroup where [Name] = @Name
			end
			select @GroupID
		end
	else if (@SQLOperationType='SQLUPDATE')
		UPDATE [Inv_ItemGroup] SET [Name] = @Name,[IsActive] = @IsActive,[LastUpdate] = GETDATE(),[Editor] = @Editor
		where ID=@ID
	else if (@SQLOperationType='SQLDELETE')
		UPDATE [Inv_ItemGroup] SET [IsActive] = 0,[LastUpdate] = GETDATE(),[Editor] = @Editor
		where ID=@ID
END
GO
