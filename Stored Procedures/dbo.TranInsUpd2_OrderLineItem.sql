SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[TranInsUpd2_OrderLineItem]
@StoreID int ,
@ID bigint ,
@OrderID bigint ,
@RecordType nvarchar(50) ,
@ItemID int ,
@Price money ,
@Qty decimal(10,4) ,
@Seat nvarchar(50) ,
@AdjustedPrice money ,
@AdjustID int ,
@EmployeeID int ,
@TimeOrdered datetime ,
@ParentSplitLineNum int,
@NumSplits smallint,
@SI nvarchar(3),
@SIText nvarchar(50),
@BusinessDate datetime ,
@AsEntree char(1),
@Status nvarchar(20),
@TaxCat nvarchar(1)
AS
	INSERT INTO OrderLineItem(StoreID,ID,OrderID,RecordType,ItemID,Price,Qty,Seat,AdjustedPrice,AdjustID,EmployeeID,TimeOrdered,ParentSplitLineNum,NumSplits,SI,SIText,BusinessDate,LastUpdate,AsEntree,status,TaxCat)
	VALUES(@StoreID,@ID,@OrderID,@RecordType,@ItemID,@Price,@Qty,@Seat,@AdjustedPrice,@AdjustID,@EmployeeID,@TimeOrdered,@ParentSplitLineNum,@NumSplits,@SI,@SIText,@BusinessDate,getDate(),@AsEntree,@Status,@TaxCat)

	If (select COUNT(*) from StoreSetting2 where InventoryInstalled=1 and storeid = @StoreID)>0
	Begin
	--ADD action takes inventory units OUT of inventory stock
	Execute Inv_Item_Usage_In @OrderID,@ID,@StoreID,  @ItemID,@RecordType,'ADD', @Qty, @BusinessDate
	End
GO
