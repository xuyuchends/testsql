SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_Rpt_CostOfSalesSummary] 
	-- Add the parameters for the stored procedure here
	@StoreID nvarchar(2000),
	@BeginTime datetime,
	@EndTime datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	select StoreID,StoreName,Category,CategoryID,isnull(SUM(BeginCost),0) BeginCost,isnull(SUM(ReceivedCost),0) ReceivedCost,
	isnull(SUM(EndCost),0) EndCost,isnull(SUM(Sales),0) Sales from (
	--BeginCost
	Select asitem.StoreID,sto.StoreName,itemG.Name+'/'+ dbo.fn_GetParentCategory(item.CategoryID) Category,item.CategoryID,
	Sum( UnitOnHand * LastUnitPrice ) as BeginCost,null as ReceivedCost,null as EndCost,
	null as Sales
	From Inv_ItemToStoreArchive asitem 
	join  Inv_Item item on asitem.ItemID = item.ID
	join Inv_ItemCategory itemCat on itemCat.ID = item.CategoryID
	join Inv_ItemGroup itemG on itemCat.GroupID = itemG.ID
	join Store sto on sto.ID = asitem.StoreID
	Where asitem.BusinessDate= @BeginTime and StoreID in (select * from dbo.f_split(@StoreID,','))
	Group by asitem.StoreID,sto.StoreName, StoreName,itemG.Name+'/'+ dbo.fn_GetParentCategory(item.CategoryID),item.CategoryID
	
	union 
	
	--EndCost
	Select asitem.StoreID,sto.StoreName,itemG.Name+'/'+ dbo.fn_GetParentCategory(item.CategoryID) Category,item.CategoryID,
	null as BeginCost,null as ReceivedCost,Sum( UnitOnHand * LastUnitPrice ) as EndCost,
	null as Sales
	From Inv_ItemToStoreArchive asitem 
	join  Inv_Item item on asitem.ItemID = item.ID
	join Inv_ItemCategory itemCat on itemCat.ID = item.CategoryID
	join Inv_ItemGroup itemG on itemCat.GroupID = itemG.ID
	join Store sto on sto.ID = asitem.StoreID
	Where asitem.BusinessDate= @EndTime and StoreID in (select * from dbo.f_split(@StoreID,','))
	Group by asitem.StoreID,sto.StoreName, StoreName,itemG.Name+'/'+ dbo.fn_GetParentCategory(item.CategoryID),item.CategoryID
	
	union
	
	--Received Cost
	Select 
	invH.StoreID,sto.StoreName,itemG.Name+'/'+ dbo.fn_GetParentCategory(item.CategoryID) Category,item.CategoryID,
	null as BeginCost,
	 Sum((invD.Qty*invD.UnitPrice)+ invD.ShoppingAmt+invD.TaxAmt- invD.DiscountAmt) as ReceivedCost
	 ,null as EndCost,null as Sales
	From Inv_InvoiceDetail invD
	 join Inv_Invoice invH on invD.InvoiceID = invH.ID
	join Inv_Item item on item.ID = invD. InvItemID
	join Inv_ItemCategory itemCat on itemCat.ID = item.CategoryID
	join Inv_ItemGroup itemG on itemCat.GroupID = itemG.ID
	join Store sto on sto.ID = invH.StoreID

	Where invH.InvoiceDate between @BeginTime and @EndTime and StoreID in (select * from dbo.f_split(@StoreID,','))
	Group by invH.StoreID,sto.StoreName, StoreName,
	itemG.Name+'/'+ dbo.fn_GetParentCategory(item.CategoryID),item.CategoryID

	union
	
	--Sales
	Select oli.StoreID,sto.StoreName,itemG.Name+'/'+ dbo.fn_GetParentCategory(iMItem.CategoryID) Category,
	iMItem.CategoryID,null as BeginCost,null as ReceivedCost ,null as EndCost,
	Sum(oli.price * oli.qty) as Sales 
	From OrderLineItem oli 
	Join Inv_StoreOrderItemCost cost on oli.OrderID = cost.OrderID and oli.ID = cost.LineItemID and oli.StoreID = cost.StoreID 
	Join Store sto on sto.id = oli.storeid 
	Join Inv_MenuItemMap map on oli.StoreID = map.StoreID and oli.ItemID = map.stMID 
	Join Inv_MenuItem iMItem on iMItem.id = map.InvMID and iMItem.IsActive = 1
	Join Inv_ItemCategory itemCat on itemCat.id = iMItem.CategoryID 
	join Inv_ItemGroup itemG on itemCat.GroupID = itemG.ID
	where oli.BusinessDate between @BeginTime and @EndTime and oli.RecordType <> 'VOID'
	and oli.StoreID in (select * from dbo.f_split(@StoreID,','))
	group by  oli.StoreID,sto.StoreName,itemG.Name+'/'+ dbo.fn_GetParentCategory(iMItem.CategoryID),
	iMItem.CategoryID
		) b group by StoreID,StoreName,Category,CategoryID

END
GO
