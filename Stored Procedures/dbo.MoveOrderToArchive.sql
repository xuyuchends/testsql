SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROCEDURE [dbo].[MoveOrderToArchive]
AS
BEGIN
SET NOCOUNT ON;
declare	@StoreID int 
declare	@ID bigint 
declare	@OpenTime datetime 
declare	@CloseTime datetime 
declare	@EmpIDOpen int 
declare	@EmpIDClose int 
declare	@TableName nvarchar(50) 
declare	@GuestCount int 
declare	@RevenueCenter nvarchar(50) 
declare	@MealPeriod nvarchar(50) 
declare	@LineItemCount int 
declare	@CheckCount int 
declare	@PaymentCount int 
declare	@TaxCount int 
declare	@FutureOrder char(1) 
declare	@BusinessDate datetime 
declare	@LastUpdate datetime 
declare @Status nvarchar(50)

declare cur cursor for SELECT StoreID,ID,OpenTime,CloseTime,EmpIDOpen,EmpIDClose,TableName,GuestCount,RevenueCenter,MealPeriod,LineItemCount,CheckCount,PaymentCount,TaxCount,FutureOrder,BusinessDate,LastUpdate,[status] FROM [Order] where CONVERT(varchar(10), BusinessDate, 120 )<DATEADD(YEAR,-2,CONVERT(varchar(10), GETDATE(), 120 ))
	open cur fetch next from cur into @StoreID,@ID,@OpenTime,@CloseTime,@EmpIDOpen,@EmpIDClose,@TableName,@GuestCount,@RevenueCenter,@MealPeriod,@LineItemCount,@CheckCount,@PaymentCount,@TaxCount,@FutureOrder,@BusinessDate,@LastUpdate,@Status
	while(@@fetch_status=0)
	begin
		begin try
			UPDATE OrderArchive SET StoreID = @StoreID,ID = @ID,OpenTime = @OpenTime,CloseTime = @CloseTime,			 EmpIDOpen = @EmpIDOpen,EmpIDClose	=	@EmpIDClose,TableName	=	@TableName,	GuestCount = @GuestCount,	RevenueCenter = @RevenueCenter, MealPeriod = @MealPeriod,LineItemCount	=	@LineItemCount,	CheckCount	=	@CheckCount, PaymentCount = @PaymentCount,	TaxCount = @TaxCount,FutureOrder = @FutureOrder, BusinessDate	=	@BusinessDate,
	LastUpdate	=	@LastUpdate,status=@Status
			WHERE  StoreID=@StoreID and ID=@ID
			if @@ROWCOUNT=0
			INSERT INTO OrderArchive 
(StoreID,ID,OpenTime,CloseTime,EmpIDOpen,EmpIDClose,TableName,GuestCount,RevenueCenter,MealPeriod,LineItemCount,CheckCount,PaymentCount,TaxCount,FutureOrder,BusinessDate,LastUpdate,status)
			 VALUES 
(@StoreID,@ID,@OpenTime,@CloseTime,@EmpIDOpen,@EmpIDClose,@TableName,@GuestCount,@RevenueCenter,@MealPeriod,@LineItemCount,@CheckCount,@PaymentCount,@TaxCount,@FutureOrder,@BusinessDate,@LastUpdate,@Status)
		END TRY
		BEGIN CATCH
		end  CATCH
		fetch next from cur into  
@StoreID,@ID,@OpenTime,@CloseTime,@EmpIDOpen,@EmpIDClose,@TableName,@GuestCount,@RevenueCenter,@MealPeriod,@LineItemCount,@CheckCount,@PaymentCount,@TaxCount,@FutureOrder,@BusinessDate,@LastUpdate,@Status
	end
close cur
deallocate cur
END
GO
