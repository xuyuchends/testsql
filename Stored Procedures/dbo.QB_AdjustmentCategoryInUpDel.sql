SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[QB_AdjustmentCategoryInUpDel]
	@ID nvarchar(200),
	@Name nvarchar(200),
	@CategoryType nvarchar(200),
	@Type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@Type = 1)
		begin
			insert into QB_AdjustmentCategory (ID,Name,Type) values(@ID,@Name,@CategoryType)
			return @@identity
		end    -- Insert statements for procedure here
	else if(@Type = 2)
		begin
			delete from QB_AdjustmentCategory where ID = @ID and type=@CategoryType
		END
	else if(@Type = 3)
		begin
			update QB_AdjustmentCategory set Name =@Name,Type=@CategoryType where ID = @ID
		end
END
GO
