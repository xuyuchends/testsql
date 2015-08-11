SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_Rpt_ItemsOnHandValuation]
	-- Add the parameters for the stored procedure here
	@StoreID nvarchar(2000),
	@ItemID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    declare @sqlWhere nvarchar(max)
    declare @sql nvarchar(max)
    set @sqlWhere=''
    if ISNULL(@ItemID,0)<>0
    begin
		set @sqlWhere=@sqlWhere+' and items.ID='+Convert(nvarchar(20),@ItemID)
    end
    set @sql='
	Select StoreID,sto.StoreName, items.ID ItemID, items.Description ItemName, sitems.UnitOnHand, 
	uom.Name, case when isnull( sitems.LastUnitPrice,0)=0 
   then items.InitialCost*(select top 1 ReceipePerStock from Inv_ItemToVendor where ItemID=items.ID Order by LastUpdate desc)
   else sitems.LastUnitPrice end LastUnitPrice, sitems.LastUpdate,dbo.fn_GetParentCategory(cat.ID) CategoryName 
	,dbo.fn_GetCategoryDisplaySql(cat.ID) displaySql
		From Inv_item items 
		--join Inv_ItemToVendor vitems on items.ID = vitems.ItemID
			join Inv_ItemToStore sitems on sitems.ItemID = items.ID
			join Inv_ItemCategory cat on items.categoryid = cat.ID
			join Inv_UnitOfMeasures uom on uom.id = items.CountUnitID
			join Store sto on sto.id = sitems.StoreID

		Where items.IsActive=1 and sitems.StoreID in (select * from dbo.f_split( '''+Convert(nvarchar(20),@StoreID)+''','',''))'+@sqlWhere+' 
 
		Order by sitems.StoreID, displaySql, items.description'
		--select @sql
		execute sp_executesql @sql

END
GO
