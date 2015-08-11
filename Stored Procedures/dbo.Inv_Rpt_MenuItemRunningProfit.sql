SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_Rpt_MenuItemRunningProfit]
	-- Add the parameters for the stored procedure here
	@StoreID nvarchar(2000),
	@CategoryID int,
	@BeginDate datetime,
	@EndDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if ISNULL(@CategoryID,0)=0
    begin
		Select oli.storeid, sto.StoreName,cat.Name as CategoryName, mi.ID as MenuItemID,mi.Name as MenuItemName, sum(oli.price) as Price, sum(TtlCost) as Cost, count(oli.qty) as Qty
		From Inv_StoreOrderItemCost cost 
			join OrderLineItem oli	on cost.OrderID = oli.OrderID and cost.LineItemID = oli.ID and cost.StoreID = oli.StoreID 
			join store sto on sto.ID = cost.StoreID 
			join Inv_MenuItemMap map on map.StoreID = oli.StoreID and map.stMID = oli.ItemID 
			join Inv_MenuItem mi on mi.ID = map.InvMID 
			join Inv_MenuItemCategory cat on cat.ID = mi.CategoryID
		Where cost.StoreID in (select * from dbo.f_split(@storeid,','))
		and oli.BusinessDate between @BeginDate and @EndDate
		and status = 'close' and mi.IsActive = 1 and cat.ShowInReport=1
		Group by oli.storeid, sto.StoreName,cat.Name,mi.ID,mi.Name
		Order By sto.StoreName, cat.Name, mi.ID

    end
    else
    begin
		Select oli.storeid, sto.StoreName,cat.Name as CategoryName, mi.ID as MenuItemID,mi.Name as MenuItemName, sum(oli.price) as Price, sum(TtlCost) as Cost, count(oli.qty) as Qty
		From Inv_StoreOrderItemCost cost 
			join OrderLineItem oli	on cost.OrderID = oli.OrderID and cost.LineItemID = oli.ID and cost.StoreID = oli.StoreID 
			join store sto on sto.ID = cost.StoreID 
			join Inv_MenuItemMap map on map.StoreID = oli.StoreID and map.stMID = oli.ItemID 
			join Inv_MenuItem mi on mi.ID = map.InvMID 
			join Inv_MenuItemCategory cat on cat.ID = mi.CategoryID
		Where cost.StoreID in (select * from dbo.f_split(@storeid,','))
		and oli.BusinessDate between @BeginDate and @EndDate
		and mi.CategoryID = @CategoryID and cat.ShowInReport=1
		and status = 'close' and mi.IsActive = 1
		Group by oli.storeid, sto.StoreName,cat.Name,mi.ID,mi.Name
		Order By sto.StoreName, cat.Name, mi.ID

    end
    
END
GO
