SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[Inv_MenuItemRecipe_sel]
(
	@InvMID int,
	@InvItemID int,
	@Qty int,
	@SQLOperationType nvarchar(50)
)
as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@SQLOperationType='SQLSELECT')
		SELECT i.RecipeUnitID, ufm.Name AS RecipeUnitName, mir.InvMID, mir.InvItemID, mir.Qty, i.Description
		FROM dbo.Inv_MenuItemRecipe AS mir INNER JOIN
		dbo.Inv_Item AS i ON mir.InvItemID = i.ID INNER JOIN
		dbo.Inv_UnitOfMeasures AS ufm ON i.RecipeUnitID = ufm.ID
		where mir.InvMID=@InvMID
END
GO
