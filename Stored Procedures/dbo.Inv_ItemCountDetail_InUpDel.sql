SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_ItemCountDetail_InUpDel]
	@CountID int,
	@ItemID int,
	@StockUnitQOH decimal(18,2),
	@UseUnitQOH decimal(18,2),
	@StockUnitTOH decimal(18,2),
	@UseUnitTOH decimal(18,2),
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @storeid as int 
	Declare @ReceiptPerStock as decimal(18,2)
	Declare @CountQOH as decimal(18,2)
	Declare @TOH as decimal(18,2)

    -- Insert statements for procedure here
    if @sqlType='SQLINSERT'
	Begin
		Select @storeid = storeid from Inv_ItemCount Where CountID = @CountID
		Select top 1 @ReceiptPerStock= ReceipePerStock from Inv_ItemToVendor Where ItemID = @ItemID 
		Select @TOH = UnitOnHand From Inv_ItemToStore Where storeid = @storeid and ItemID = @ItemID 

		Set @CountQOH = @StockUnitQOH + (@UseUnitQOH/@ReceiptPerStock)

		if (select COUNT(*) from Inv_ItemCountDetail where CountID=@CountID and ItemID=@ItemID)=0
		INSERT INTO Inv_ItemCountDetail(CountID,ItemID,StockUnitQOH,UseUnitQOH,CountQOH, TOH, StockUnitTOH, UseUnitTOH  )
		VALUES(@CountID,@ItemID,@StockUnitQOH,@UseUnitQOH,@CountQOH,@TOH, @StockUnitTOH,@UseUnitTOH)
		else
		update Inv_ItemCountDetail set StockUnitQOH=@StockUnitQOH,UseUnitQOH=@UseUnitQOH,CountQOH=@CountQOH,
		TOH=@TOH,StockUnitTOH=@StockUnitTOH,UseUnitTOH=@UseUnitTOH where CountID=@CountID and ItemID=@ItemID
		
		Update Inv_ItemToStore 
		Set UnitOnHand = @CountQOH, LastUpdate = getdate()
		Where StoreID = @storeid and itemid = @ItemID 
	End
END
GO
