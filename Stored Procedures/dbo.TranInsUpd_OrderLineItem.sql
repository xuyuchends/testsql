SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[TranInsUpd_OrderLineItem]
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
begin try
INSERT INTO OrderLineItem(StoreID,ID,OrderID,RecordType,ItemID,
		Price,Qty,Seat,AdjustedPrice,AdjustID,
		EmployeeID,TimeOrdered,ParentSplitLineNum,NumSplits,SI,SIText,BusinessDate,LastUpdate,AsEntree,status,TaxCat)
	VALUES(@StoreID,@ID,@OrderID,@RecordType,@ItemID,
		@Price,@Qty,@Seat,@AdjustedPrice,@AdjustID,
		@EmployeeID,@TimeOrdered,@ParentSplitLineNum,@NumSplits,@SI,@SIText,@BusinessDate,getDate(),@AsEntree,@Status,@TaxCat)

	If (select COUNT(*) from StoreSetting2 where InventoryInstalled=1 and storeid = @StoreID)>0
	Begin
	--ADD action takes inventory units OUT of inventory stock
	Execute Inv_Item_Usage_In @OrderID,@ID,@StoreID,  @ItemID,@RecordType,'ADD', @Qty, @BusinessDate
	End
END TRY
BEGIN CATCH
	if @@ERROR <>0
	begin
		Declare @oldRecordType as nvarchar(50)
	--Save currnt RecordType Value
		Select  @oldRecordType = RecordType From OrderLineItem Where StoreID=@StoreID and ID=@id and OrderID=@OrderID 
	
		UPDATE  OrderLineItem SET RecordType=@RecordType,ItemID=@ItemID,Price=@Price,Qty=@Qty,
			Seat=@Seat,AdjustedPrice=@AdjustedPrice,AdjustID=@AdjustID,EmployeeID=@EmployeeID,
			TimeOrdered=@TimeOrdered,ParentSplitLineNum=@ParentSplitLineNum,NumSplits=@NumSplits,SI=@SI,
			SIText=@SIText,BusinessDate=@BusinessDate,LastUpdate=getDate(),AsEntree=@AsEntree,status=@Status,TaxCat=@TaxCat
		where StoreID=@StoreID and ID=@id and OrderID=@OrderID and BusinessDate=@BusinessDate
		
		If (select COUNT(*) from StoreSetting2 where InventoryInstalled=1 and storeid = @storeid)>0
		Begin
			--Only adjust usage if record typ is different
			If @oldRecordType <> @RecordType
			Begin
				--If new record is a void
				If @RecordType = 'VOID'
				Begin
					--SUB action puts inventory units Back to inventory stock
					Execute Inv_Item_Usage_In @OrderID,@ID,@StoreID,  @ItemID,@RecordType,'SUB', @Qty, @BusinessDate
				End
				--If new recordtype is NONE/COMP/DISCNT
				
				If (@oldRecordType='VOID' and @RecordType <> 'VOID')
				Begin
					--ADD action takes inventory units OUT of inventory stock
					Execute Inv_Item_Usage_In @OrderID,@ID,@StoreID,  @ItemID,@RecordType,'ADD', @Qty, @BusinessDate
				End
			End
		end
	end
	
end  CATCH
GO
