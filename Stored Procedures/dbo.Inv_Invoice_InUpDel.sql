SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_Invoice_InUpDel]
(
	@ID int,
	@InvOrderID int,
	@StoreID int,
	@VendorID int,
	@Num nvarchar(50) ,
	@Status int,
	@DueDate datetime ,
	@DeliveryDate datetime ,
	@InvoiceDate datetime ,
	@WeekEnding datetime ,
	@ReceivedByID int,
	@InvoiceTotal money,
	@DiscountTotal money ,
	@TaxTotal money ,
	@ShippingTotal money ,
	@PaidTotal money ,
	@TenderTypeID int,
	@CheckNum nvarchar(50) ,
	@Comment nvarchar(max) ,
	@LastUpdate datetime ,
	@CreatedID int,
	@CreatedName nvarchar(200),
	@EditorID int ,
	@EditorName nvarchar(200) ,
	@subTotal Decimal(18,2),
	@SQLOperationType nvarchar(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@SQLOperationType='SQLINSERT')
	begin
		INSERT INTO Inv_Invoice
			   (InvOrderID,StoreID,VendorID,Num,Status,DueDate,DeliveryDate,InvoiceDate,WeekEnding,ReceivedByID,InvoiceTotal
			   ,DiscountTotal,TaxTotal,ShippingTotal,PaidTotal,TenderTypeID,CheckNum,Comment,LastUpdate
			   ,CreatedID,CreatedName,EditorID,EditorName,SubTotal,CreationDate)
		 VALUES
			   (@InvOrderID,@StoreID,@VendorID,@Num,@Status,@DueDate,@DeliveryDate,@InvoiceDate,@WeekEnding,@ReceivedByID
			   ,@InvoiceTotal,@DiscountTotal,@TaxTotal,@ShippingTotal,@PaidTotal,@TenderTypeID
			   ,@CheckNum,@Comment,getdate(),@CreatedID,@CreatedName,@CreatedID,@CreatedName,@subTotal,GETDATE())
			select  scope_identity()
	end							
	else if (@SQLOperationType='SQLUPDATE')
	begin
		if ISNULL(@InvOrderID,0)<>0
		begin
			UPDATE Inv_Invoice
			SET InvOrderID = @InvOrderID,Num = @Num,Status = @Status,DueDate = @DueDate,DeliveryDate = @DeliveryDate
			,InvoiceDate = @InvoiceDate,WeekEnding = @WeekEnding,ReceivedByID = @ReceivedByID,InvoiceTotal = @InvoiceTotal
			,DiscountTotal = @DiscountTotal,TaxTotal = @TaxTotal,ShippingTotal = @ShippingTotal,PaidTotal = @PaidTotal
			,TenderTypeID = @TenderTypeID,CheckNum = @CheckNum,Comment = @Comment,LastUpdate = getdate()
			,EditorID = @EditorID,EditorName = @EditorName,StoreID=@StoreID,VendorID=@VendorID,SubTotal=@subTotal
			WHERE ID=@ID
		end
		else
		begin
			UPDATE Inv_Invoice
			SET Num = @Num,Status = @Status,DueDate = @DueDate,DeliveryDate = @DeliveryDate
			,InvoiceDate = @InvoiceDate,WeekEnding = @WeekEnding,ReceivedByID = @ReceivedByID,InvoiceTotal = @InvoiceTotal
			,DiscountTotal = @DiscountTotal,TaxTotal = @TaxTotal,ShippingTotal = @ShippingTotal,PaidTotal = @PaidTotal
			,TenderTypeID = @TenderTypeID,CheckNum = @CheckNum,Comment = @Comment,LastUpdate = getdate()
			,EditorID = @EditorID,EditorName = @EditorName,StoreID=@StoreID,VendorID=@VendorID,SubTotal=@subTotal
			WHERE ID=@ID
		end
	end
	else if (@SQLOperationType='SQLDELETE')
	begin
		delete from Inv_Invoice WHERE ID=@ID
	end
END
GO
