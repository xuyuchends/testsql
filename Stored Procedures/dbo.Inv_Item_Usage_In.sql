SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_Item_Usage_In]
	@OrderId [bigint],
	@LineItemID [int],
	@StoreID [int],
	@ItemID [int],
	@RecordType [nvarchar](20),
	@Action [nvarchar](20),
	@Qty decimal(10,4),
	@BusinessDate [datetime]
WITH EXECUTE AS CALLER
AS
Declare @InvItemID as int
Declare @Usage as decimal(18,2)
Declare @UnitCost as money
Declare @InvoiceID as bigint

Declare @FinalUnitCost as money
Set @FinalUnitCost = 0

--Get Menu Item Receipe
Declare Receipe Cursor For
	Select rec.InvItemID,rec.Qty
	From Inv_MenuItemMap map join Inv_MenuItemRecipe rec
		on map.InvMID = rec.InvMID 
	Where StoreID = @StoreID and stMID = @ItemID
Open Receipe

Fetch Next From Receipe Into @InvItemID, @Usage

While @@FETCH_STATUS = 0
Begin
	--Get Inventory Item Unit Price.
	--1. Get Store Current Units On Hand
	
	
	Declare @CurrentUOH as decimal(18,4)
	Declare @LastUnitPrice as money

	set @CurrentUOH = 0
	set @LastUnitPrice = 0
	
 
	Select @CurrentUOH = UnitOnHand, @LastUnitPrice = LastUnitPrice  --(LastUnitPrice Already includes (if configured) shipping/tax/-discount amount in Inv_ItemToStore [Stock Unit Price])
	From Inv_ItemToStore 
	Where StoreID = @StoreID and ItemID = @InvItemID

	
	--2. Get most recent invoice InvoiceQty
	Declare @LastInvoiceID as bigint
	Declare @LastInvoiceQty as decimal
	Declare @LastInvoiceUnitPrice as money
	Declare @StockPerOrder as decimal(18,2)
	Declare @UsePerStock as decimal(18,2)
	declare @LastInvoiceQty1 decimal
	Declare @LastInvoiceID1 as bigint

	Set @LastInvoiceID= 0
	Set @LastInvoiceQty= 0
	Set @LastInvoiceUnitPrice= 0
	Set @StockPerOrder = 0
	Set @UsePerStock = 0

	Select top 1 @LastInvoiceID = invH.ID, @LastInvoiceQty=(invD.Qty * vitem.StockPerOrder), @StockPerOrder = vitem.StockPerOrder, @UsePerStock = vitem.ReceipePerStock, @LastInvoiceUnitPrice = vitem.LastUnitPrice 
	 From Inv_InvoiceDetail invD join Inv_Invoice invH on invD.InvoiceID = invH.ID 
		join Inv_ItemToVendor vitem  on vitem.itemid = invD.InvItemID and invH.vendorid = vitem.VendorID and invd.OrderUnitID = vitem.OrderUnit 
	Where StoreID = @StoreID and invD.InvItemID = @InvItemID 
	Order by invH.ID desc
	
select @UsePerStock
	--3. Compare 
	If (@CurrentUOH <= @LastInvoiceQty)
	Begin												--Use @LastUnitPrice price
		set @InvoiceID=@LastInvoiceID
		Set @UnitCost = @LastUnitPrice
		print 'Use @LastUnitPrice price ' 
	End
	Else												--Use second most invoice price for this inventor item for this store
	Begin
		
		Select top 1 @LastInvoiceID1 = invH.ID,  @LastInvoiceQty1=(invD.Qty * vitem.StockPerOrder)
		
	From Inv_InvoiceDetail invD join Inv_Invoice invH on invD.InvoiceID = invH.ID 
		join Inv_ItemToVendor vitem  on vitem.itemid = invD.InvItemID and invH.vendorid = vitem.VendorID 
	Where StoreID = @StoreID and invD.InvItemID = @InvItemID and invH.ID < @LastInvoiceID
	Order by invH.ID desc
		
		if @CurrentUOH <= (@LastInvoiceQty+@LastInvoiceQty1)
		begin
			Select top 1 @LastInvoiceUnitPrice = (UnitPrice + ShippingTotal + TaxAmt - DiscountAmt)  --Unit price here is Order Unit
			From Inv_InvoiceDetail invD join Inv_Invoice invH on invD.InvoiceID = invH.ID 
			Where StoreID = @StoreID and invD.InvItemID = @InvItemID and invH.ID < @LastInvoiceID
			Order by invH.ID desc

			If @@ROWCOUNT = 0
			Begin
				
				Set @UnitCost = @LastUnitPrice
				print 'no second most invoice'
			End
			Else
			Begin
			    set @InvoiceID=@LastInvoiceID1
				Set @UnitCost = (@LastInvoiceUnitPrice/@StockPerOrder)
				print 'use second most recent invoice'
			End
		end
		else
		begin
			Select top 1 @LastInvoiceID1 = invH.ID, @LastInvoiceUnitPrice = (UnitPrice + ShippingTotal + TaxAmt - DiscountAmt)  --Unit price here is Order Unit
			From Inv_InvoiceDetail invD join Inv_Invoice invH on invD.InvoiceID = invH.ID 
			Where StoreID = @StoreID and invD.InvItemID = @InvItemID and invH.ID < @LastInvoiceID1
			Order by invH.ID desc

			If @@ROWCOUNT = 0
			Begin
				Set @UnitCost = (@LastInvoiceUnitPrice/@StockPerOrder)
				print 'no third most invoice'
			End
			Else
			Begin
			 set @InvoiceID=@LastInvoiceID1
				Set @UnitCost = (@LastInvoiceUnitPrice/@StockPerOrder)
				print 'use third most recent invoice'
			End
		end

	End


	print 'Use @UnitCost '  + cast(@UnitCost as varchar(10))

	--4. Insert into usage table
	--If @Action = 'ADD'
	--Begin
	-- End
	
	If @Action = 'SUB'
	Begin
		Set @Qty = @Qty * -1
	End
	insert into Inv_ItemUsages values( @StoreID, @InvItemID, @Usage*@Qty,@UnitCost, @ItemID,@LineItemID,@OrderID , @BusinessDate,getdate())
--select @UsePerStock
	update Inv_ItemToStore 
	set UnitOnHand= UnitOnHand - (@Qty * @Usage/@UsePerStock),LastUpdate=GETDATE()
	where StoreID = @StoreID and itemid = @InvItemID
	
	set @FinalUnitCost = @FinalUnitCost + (@Usage*@Qty*@UnitCost/@UsePerStock)

	Fetch Next From Receipe Into @InvItemID, @Usage
End

Close Receipe
Deallocate Receipe

If @Action = 'ADD'
Begin try
	Insert Into Inv_StoreOrderItemCost values (@StoreID, @OrderId, @LineItemID, @FinalUnitCost)
End try

Begin Catch
End Catch
GO
