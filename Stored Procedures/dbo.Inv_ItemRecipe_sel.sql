SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_ItemRecipe_sel] 
	-- Add the parameters for the stored procedure here
	@id int,
	@ItemID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if ISNULL(@id,0)=0
	begin
		if ISNULL(@ItemID,0)<>0
		begin
			select ir.RecipeItemID,ri.Description RecipeItemName,InvItemID ItemID,i.Description ItemName, Qty ,ufm.Name Unit,ir.LastUpdate from Inv_ItemRecipe ir
			inner join Inv_Item i on i.ID=ir.InvItemID 
			inner join Inv_UnitOfMeasures AS ufm ON i.RecipeUnitID = ufm.ID
			inner join Inv_Item ri on ri.ID=ir.RecipeItemID
			where InvItemID=@ItemID
		end
	end
	else
	begin
		select RecipeItemID,InvItemID,Qty,LastUpdate from Inv_ItemRecipe where RecipeItemID=@id
	end
END
GO
