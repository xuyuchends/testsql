SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[MovePaymentToArchive]
AS
BEGIN
SET NOCOUNT ON;
declare @StoreID int
declare @CheckID bigint
declare	@LineNum int
declare	@MethodID nvarchar(50)
declare	@Amount money
declare	@AmountReceived money
declare	@Tip money
declare	@Gratuity money
declare	@BusinessDate datetime
declare	@LastUpdate datetime
declare	@Status nvarchar(50)

declare cur cursor
	for SELECT StoreID,CheckID,LineNum,MethodID,Amount,AmountReceived,Tip,Gratuity,BusinessDate,LastUpdate,Status FROM Payment
			   where CONVERT(varchar(10), BusinessDate, 120 )<DATEADD(YEAR,-2,CONVERT(varchar(10), GETDATE(), 120 ))
	open cur
	fetch next from cur into @StoreID,@CheckID,@LineNum,@MethodID,@Amount,@AmountReceived,@Tip,@Gratuity,@BusinessDate,@LastUpdate,@Status
	while(@@fetch_status=0)
	begin
		begin try
			update PaymentArchive set MethodID = @methodID,Amount = @Amount, AmountReceived = @AmountReceived, Tip = @Tip,Gratuity = @Gratuity,BusinessDate = @BusinessDate,LastUpdate = @LastUpdate,Status= @Status
			where StoreID=@StoreID and CheckID=@CheckID and LineNum=@LineNum
			if @@ROWCOUNT=0
			INSERT INTO PaymentArchive([StoreID],[CheckID],[LineNum],[MethodID],[Amount],[AmountReceived],[Tip],[Gratuity],[BusinessDate],[LastUpdate],[Status])
			VALUES (@StoreID,@CheckID, @LineNum,@MethodID,@Amount,@AmountReceived,@Tip,@Gratuity, @BusinessDate, @LastUpdate, @Status)
		END TRY
		BEGIN CATCH
		end  CATCH
		fetch next from cur into   @StoreID,@CheckID,@LineNum,@MethodID,@Amount,@AmountReceived,@Tip,@Gratuity,@BusinessDate,@LastUpdate,@Status
	end
close cur
deallocate cur
END

GO
