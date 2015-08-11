SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_ItemToStore_InUpDel]
	-- Add the parameters for the stored procedure here
	@ItemID int,
	@StoreID int,
	@UnitOnHand decimal(18,2),
	@LastUnitPrice money,
	@Creator int,
	@Editor int,
	--@VendorID int,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if ISNULL(@sqlType,'')='SQLINSERT'
    begin
    begin try
	INSERT INTO [Inv_ItemToStore]
           ([ItemID]
           ,[StoreID]
           ,[UnitOnHand]
           ,[LastUnitPrice]
           ,[Creator]
           ,[Editor]
           ,[LastUpdate])
     VALUES (@ItemID,@StoreID,@UnitOnHand,@LastUnitPrice,@Creator,@Editor,GETDATE())
     end try
     begin catch
		update Inv_ItemToStore set Editor=@Editor ,LastUpdate=GETDATE()
     end catch
	end
	else if ISNULL(@sqlType,'')='SQLUPDATE'
	begin
		declare @StockPerOrder decimal
		--select @StockPerOrder = StockPerOrder from Inv_ItemToVendor where ItemID=@ItemID and VendorID=@VendorID
		--set @UnitOnHand=@UnitOnHand*@StockPerOrder
		if ISNULL(@LastUnitPrice,0)=0
		begin
			update Inv_ItemToStore set UnitOnHand=@UnitOnHand + UnitOnHand,
			Editor=@Editor ,LastUpdate=GETDATE() where ItemID=@ItemID and StoreID=@StoreID
		end
		else
		begin
			update Inv_ItemToStore set UnitOnHand=case when  @UnitOnHand + UnitOnHand>0 then @UnitOnHand + UnitOnHand else 0 end,
			LastUnitPrice=@LastUnitPrice,
			Editor=@Editor ,LastUpdate=GETDATE() where ItemID=@ItemID and StoreID=@StoreID
		end
	end
	
END
GO
