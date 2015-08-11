SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_InvoiceDetail_InUpDel]
(
	@InvoiceID int,
	@InvItemID int,
	@ItemLineID int,
	@Qty decimal(18,2) ,
	@UnitPrice money ,
	@DiscountAmt money ,
	@ShoppingAmt money ,
	@TaxAmt money ,
	@LedgerID int ,
	@isReceived bit,
	@OrderUnitID int,
	@SQLOperationType nvarchar(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@SQLOperationType='SQLINSERT')
	begin
		INSERT INTO Inv_InvoiceDetail
           (InvoiceID,InvItemID,ItemLineID,Qty,UnitPrice,DiscountAmt,ShoppingAmt,TaxAmt,LedgerID,isReceived, orderunitid)
		VALUES(@InvoiceID,@InvItemID,@ItemLineID,@Qty,@UnitPrice,@DiscountAmt,@ShoppingAmt,@TaxAmt,@LedgerID,@isReceived, @OrderUnitID)
	end							
	else if @SQLOperationType='SQLDELETE'
	begin
		delete from Inv_InvoiceDetail WHERE InvoiceID=@InvoiceID
	end
END
GO
