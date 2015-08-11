SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_TenderType_InUpDel]
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
	if (@SQLOperationType='SQLINSERT')
		begin
			INSERT INTO [Inv_TenderType]([Name],[IsActive],[LastUpdate],[Creator],[Editor])
			VALUES(@Name,@IsActive,GETDATE(),@Creator,@Creator)
			select @@IDENTITY
		end
	else if (@SQLOperationType='SQLUPDATE')
		UPDATE [Inv_TenderType] SET [Name] = @Name,[IsActive] = @IsActive,[LastUpdate] = GETDATE(),[Editor] = @Editor
		where ID=@ID
END
GO
