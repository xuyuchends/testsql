SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_InvoiceDetail_Sel]
(
	@InvoiceID int,
	@InvItemID int,
	@ItemLineID int,
	@Qty int ,
	@UnitPrice money ,
	@DiscountAmt money ,
	@ShoppingAmt money ,
	@TaxAmt money ,
	@LedgerID int ,
	@isReceived bit,
	@SQLOperationType nvarchar(50)
)
as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 if (@SQLOperationType='SQLSELECT')
		SELECT InvoiceID,InvItemID,ItemLineID,Qty,UnitPrice,DiscountAmt,ShoppingAmt,TaxAmt,LedgerID,isReceived, ufm.Name 
		FROM Inv_InvoiceDetail vd 
		join Inv_Invoice vh on vh.ID = vd.InvoiceID 
		join Inv_ItemToVendor itv on itv.VendorID = vh.vendorid and vd.InvItemID = itv.ItemID 
		join Inv_ItemToStore its on its.StoreID = vh.storeid and its.ItemID = vd.InvItemID 
		join Inv_UnitOfMeasures as ufm on ufm.ID=itv.OrderUnit
		Where InvoiceID=@InvoiceID
	else if (@SQLOperationType='SQLSELECTDETAIL')
		SELECT InvoiceID,InvItemID,ItemLineID,Qty,UnitPrice,DiscountAmt,ShoppingAmt,TaxAmt,LedgerID,isReceived, ufm.Name 
		FROM Inv_InvoiceDetail vd 
		join Inv_Invoice vh on vh.ID = vd.InvoiceID 
		join Inv_ItemToVendor itv on itv.VendorID = vh.vendorid and vd.InvItemID = itv.ItemID 
		join Inv_ItemToStore its on its.StoreID = vh.storeid and its.ItemID = vd.InvItemID 
		join Inv_UnitOfMeasures as ufm on ufm.ID=itv.OrderUnit
		where InvoiceID=@InvoiceID and InvItemID=@InvItemID
END
GO
