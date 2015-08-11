SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_ItemRecipe_InUpDel] 
	-- Add the parameters for the stored procedure here
	@RecipeItemID int,
	@ItemID int,
	@Qty decimal(18,2),
	@SQLOperationType nvarchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if @SQLOperationType='SQLINSERT'
    begin
		INSERT INTO [Inv_ItemRecipe]
           (RecipeItemID,[InvItemID]
           ,[Qty]
           ,[LastUpdate])
     VALUES
           (@RecipeItemID,@ItemID,@Qty,GETDATE())
           select @@IDENTITY
	end
	else if @SQLOperationType='SQLDELETE'
    begin
		delete from [Inv_ItemRecipe] where InvItemID=@ItemID
	end
	
	End
GO
