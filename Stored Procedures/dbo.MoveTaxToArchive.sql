SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[MoveTaxToArchive]
AS
BEGIN
SET NOCOUNT ON;
declare @StoreID int
declare @TaxCategoryID int
declare @CheckID int
declare @OrderID int
declare @Category nvarchar(50)
declare @TaxAmt decimal(19,10)
declare @TaxOrderAmt decimal(19,10)
declare @BusinessDate datetime
declare @LastUpdate datetime

declare cur cursor
	for select storeid,TaxCategoryID,CheckID,OrderID,Category,TaxAmt,TaxOrderAmt,BusinessDate,LastUpdate  from Tax
			   where CONVERT(varchar(10), BusinessDate, 120 )<DATEADD(YEAR,-2,CONVERT(varchar(10), GETDATE(), 120 ))
	open cur
	fetch next from cur into @StoreID,@TaxCategoryID,@CheckID,@OrderID,@Category,@TaxAmt,@TaxOrderAmt,@BusinessDate,@LastUpdate
	while(@@fetch_status=0)
	begin
		begin try
			UPDATE TaxArchive SET [TaxAmt] = @TaxAmt,[TaxOrderAmt] = @TaxOrderAmt,[BusinessDate] = @BusinessDate,[LastUpdate] = @LastUpdate
			WHERE StoreID=@StoreID and TaxCategoryID=@TaxCategoryID and CheckID=@CheckID and OrderID=@OrderID and Category=@Category
			if @@ROWCOUNT=0
			INSERT INTO TaxArchive ([StoreID],[TaxCategoryID],[CheckID],[OrderID],[Category],[TaxAmt],[TaxOrderAmt],[BusinessDate],[LastUpdate])
			VALUES (@StoreID,@TaxCategoryID, @CheckID, @OrderID, @Category, @TaxAmt, @TaxOrderAmt, @BusinessDate, @LastUpdate)
		END TRY
		BEGIN CATCH
		end  CATCH
		fetch next from cur into  @StoreID,@TaxCategoryID,@CheckID,@OrderID,@Category,@TaxAmt,@TaxOrderAmt,@BusinessDate,@LastUpdate
	end
close cur
deallocate cur
END

GO
