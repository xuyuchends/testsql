SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[MoveCheckToArchive]
AS
BEGIN
SET NOCOUNT ON;
declare @StoreID int 
declare @ID bigint 
declare @SaleTime datetime 
declare @OrderID bigint 
declare @EmployeeID int 
declare @Seat nvarchar(200) 
declare @FutureOrderAdvPayment char(1) 
declare @BusinessDate datetime 
declare @LastUpdate datetime 

declare cur cursor
	for SELECT StoreID,ID,SaleTime,OrderID,EmployeeID,Seat,FutureOrderAdvPayment,BusinessDate,LastUpdate FROM [Check]
	where CONVERT(varchar(10), BusinessDate, 120 )<DATEADD(YEAR,-2,CONVERT(varchar(10), GETDATE(), 120 ))
	open cur
	fetch next from cur into @StoreID,@ID,@SaleTime,@OrderID,@EmployeeID,@Seat,@FutureOrderAdvPayment,@BusinessDate,@LastUpdate
	while(@@fetch_status=0)
	begin
		begin try
			UPDATE CheckArchive SET StoreID = @StoreID,ID = @ID,SaleTime = @SaleTime,OrderID = @OrderID,EmployeeID = @EmployeeID,Seat = @Seat,FutureOrderAdvPayment = @FutureOrderAdvPayment,BusinessDate = @BusinessDate ,LastUpdate = @LastUpdate
			WHERE  StoreID=@StoreID and ID=@ID
			if @@ROWCOUNT=0
			begin
				INSERT INTO CheckArchive(StoreID,ID,SaleTime,OrderID,EmployeeID,Seat,FutureOrderAdvPayment,BusinessDate,LastUpdate)
				VALUES (@StoreID,@ID,@SaleTime,@OrderID,@EmployeeID,@Seat,@FutureOrderAdvPayment,@BusinessDate,@LastUpdate)
			end
			if exists (select * from CheckArchive where StoreID = @StoreID and ID = @ID)
			begin
				delete from [Check] where StoreID = @StoreID and ID = @ID
			end
		END TRY
		BEGIN CATCH
		end  CATCH
		
		fetch next from cur into  @StoreID,@ID,@SaleTime,@OrderID,@EmployeeID,@Seat,@FutureOrderAdvPayment,@BusinessDate,@LastUpdate
	end
close cur
deallocate cur
END

/****** Object:  StoredProcedure [dbo].[MoveOrderToArchive]    Script Date: 01/26/2013 12:41:24 ******/
SET ANSI_NULLS ON
GO
