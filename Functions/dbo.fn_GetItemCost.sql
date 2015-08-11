SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
create FUNCTION [dbo].[fn_GetItemCost]
(
	-- Add the parameters for the function here
	@InvItemID int,
	@UnitOnHand decimal(18,2),
	@LastUnitPrice decimal(18,2),
	@StoreID int
)
RETURNS decimal(18,2)
AS
BEGIN
	-- Declare the return variable here
	Declare @LastInvoiceID as bigint
	Declare @LastInvoiceQty as decimal
	Declare @LastInvoiceUnitPrice as money
	Declare @LastInvoiceUnitPrice1 as money
	declare @LastInvoiceQty1 decimal
	Declare @LastInvoiceID1 as bigint
	declare @CurrCost decimal(18,2)
	
	Select top 1 @LastInvoiceID = invH.ID, @LastInvoiceQty=(invD.Qty * vitem.StockPerOrder)
	From Inv_InvoiceDetail invD join Inv_Invoice invH on invD.InvoiceID = invH.ID 
		join Inv_ItemToVendor vitem  on vitem.itemid = invD.InvItemID and invH.vendorid = vitem.VendorID 
	Where StoreID = @StoreID and invD.InvItemID = @InvItemID 
	Order by invH.ID desc
	

	--3. Compare 
	If (@UnitOnHand <= @LastInvoiceQty)
	Begin												--Use @LastUnitPrice price
		Set @CurrCost = @LastUnitPrice * @UnitOnHand

	End
	Else												--Use second most invoice price for this inventor item for this store
	Begin
		
		Select top 1 @LastInvoiceID1 = invH.ID,  @LastInvoiceQty1=(invD.Qty * vitem.StockPerOrder)
	From Inv_InvoiceDetail invD join Inv_Invoice invH on invD.InvoiceID = invH.ID 
		join Inv_ItemToVendor vitem  on vitem.itemid = invD.InvItemID and invH.vendorid = vitem.VendorID 
	Where StoreID = @StoreID and invD.InvItemID = @InvItemID and invH.ID < @LastInvoiceID
	Order by invH.ID desc
		
		if @UnitOnHand <= (@LastInvoiceQty+@LastInvoiceQty1)
		begin
			Select top 1 @LastInvoiceUnitPrice = (UnitPrice + ShippingTotal + TaxAmt - DiscountAmt)  --Unit price here is Order Unit
			From Inv_InvoiceDetail invD join Inv_Invoice invH on invD.InvoiceID = invH.ID 
			Where StoreID = @StoreID and invD.InvItemID = @InvItemID and invH.ID < @LastInvoiceID
			Order by invH.ID desc

			If @@ROWCOUNT = 0
			Begin
				Set @CurrCost = @LastUnitPrice * @UnitOnHand

			End
			Else
			Begin
				Set @CurrCost = @LastUnitPrice * @LastInvoiceQty+(@UnitOnHand-@LastInvoiceQty)*@LastInvoiceUnitPrice

			End
		end
		else
		begin
			Select top 1 @LastInvoiceUnitPrice1 = (UnitPrice + ShippingTotal + TaxAmt - DiscountAmt)  --Unit price here is Order Unit
			From Inv_InvoiceDetail invD join Inv_Invoice invH on invD.InvoiceID = invH.ID 
			Where StoreID = @StoreID and invD.InvItemID = @InvItemID and invH.ID < @LastInvoiceID1
			Order by invH.ID desc

			If @@ROWCOUNT = 0
			Begin
				Select top 1 @LastInvoiceUnitPrice = (UnitPrice + ShippingTotal + TaxAmt - DiscountAmt)  --Unit price here is Order Unit
				From Inv_InvoiceDetail invD join Inv_Invoice invH on invD.InvoiceID = invH.ID 
				Where StoreID = @StoreID and invD.InvItemID = @InvItemID and invH.ID < @LastInvoiceID
				Order by invH.ID desc
				Set @CurrCost = @LastUnitPrice * @LastInvoiceQty+(@UnitOnHand-@LastInvoiceQty)*@LastInvoiceUnitPrice

			End
			Else
			Begin
				Set @CurrCost = @LastUnitPrice * @LastInvoiceQty+@LastInvoiceQty1*@LastInvoiceUnitPrice
				+(@UnitOnHand-@LastInvoiceQty-@LastInvoiceQty1)*@LastInvoiceUnitPrice1

			End
		end

	End

	-- Return the result of the function
	RETURN @CurrCost

END
GO
