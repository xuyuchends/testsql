SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_ItemToVendorCopyProduct]
	-- Add the parameters for the stored procedure here
	@ItemID int,
	@FromVendorID int,
	@ToVendorID int,
	@UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    declare @Desciption nvarchar(50)
    declare @OrderUnit int
    declare @StockPerOrder decimal(18,2)
    declare @ReceipePerStock decimal(18,2)
    declare @UPC nvarchar(200)
    select @Desciption=Description,@OrderUnit=OrderUnit,@StockPerOrder=StockPerOrder,
    @ReceipePerStock=ReceipePerStock,@UPC=UPC from Inv_ItemToVendor 
    where ItemID=@ItemID and VendorID=@FromVendorID
    if (select COUNT(*) from Inv_ItemToVendor where ItemID=@ItemID and VendorID=@ToVendorID)=0
    begin
	INSERT INTO Inv_ItemToVendor
		(ItemID,[VendorID],[SupplierCode],[Description],[LastUnitPrice],[OrderUnit],[StockPerOrder]
           ,[ReceipePerStock],[UPC],[DisplaySeq],[LastUpdate],[Creator],[Editor])
     VALUES(@ItemID,@ToVendorID,'',@Desciption,0,@OrderUnit,
     @StockPerOrder,@ReceipePerStock,@UPC,
     (select isnull(MAX(DisplaySeq),0) from Inv_ItemToVendor)+1,GETDATE(),@UserID,null)
    end
	
END
GO
