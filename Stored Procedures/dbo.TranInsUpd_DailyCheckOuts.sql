SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[TranInsUpd_DailyCheckOuts]
	@StoreID int,
	@CheckOutID int,
	@RunDate datetime,
	@RunTime datetime,
	@BusinessDate datetime,
	@ServerID nvarchar(50),
	@UserID nvarchar(50),
	@NumSaleRec int,
	@TotalSales money,
	@TotalTip money,
	@TotalPymnt money,
	@Status nvarchar(50),
	@CashSales money,
	@ChargeSales money,
	@NetSales money,
	@ActualBusinessDate datetime,
	@CashDue money,
	@CashReceived money,
	@ActualCashEntered  char(1),
	@Covers bigint,
	@Discounts money,
	@EntreeCount bigint,
	@GCSold money,
	@GCRedeemed money,
	@NumTables bigint,
	@TaxCollected money,
	@OtherSales money,
	@ChargeTips money,
	@CompleteStatus char(1),
	@TipWithheld money
as
begin
 begin try
 if(@@ROWCOUNT=0)
	begin
		INSERT INTO [DailyCheckOuts]
           ([StoreID]
           ,[CheckOutID]
           ,[RunDate]
           ,[RunTime]
           ,[BusinessDate]
           ,[ServerID]
           ,[UserID]
           ,[NumSaleRec]
           ,[TotalSales]
           ,[TotalTip]
           ,[TotalPymnt]
           ,[Status]
           ,[CashSales]
           ,[ChargeSales]
           ,[NetSales]
           ,[ActualBusinessDate]
           ,[CashDue]
           ,[CashReceived]
           ,[ActualCashEntered]
           ,[Covers]
           ,[Discounts]
           ,[EntreeCount]
           ,[GCSold]
           ,[GCRedeemed]
           ,[NumTables]
           ,[TaxCollected]
           ,[OtherSales]
           ,[ChargeTips]
           ,[CompleteStatus]
           ,[TipWithheld]
           ,LastUpdate)
     VALUES
           (@StoreID
           ,@CheckOutID
           ,@RunDate
			  ,@RunTime
			  ,@BusinessDate
			  ,@ServerID
			  ,@UserID
			  ,@NumSaleRec
			  ,@TotalSales
			  ,@TotalTip
			  ,@TotalPymnt
			  ,@Status
			  ,@CashSales
			  ,@ChargeSales
			  ,@NetSales
			  ,@ActualBusinessDate
			  ,@CashDue
			  ,@CashReceived
			  ,@ActualCashEntered
			  ,@Covers
			  ,@Discounts
			  ,@EntreeCount
			  ,@GCSold
			  ,@GCRedeemed
			  ,@NumTables
			  ,@TaxCollected
			  ,@OtherSales
			  ,@ChargeTips
			  ,@CompleteStatus
			  ,@TipWithheld
			  ,GETDATE())

	end
	end try
	begin Catch 
		if @@ERROR>0
		UPDATE [DailyCheckOuts]
   SET [RunDate] = @RunDate
      ,[RunTime] = @RunTime
      ,[BusinessDate] = @BusinessDate
      ,[ServerID] = @ServerID
      ,[UserID] = @UserID
      ,[NumSaleRec] = @NumSaleRec
      ,[TotalSales] = @TotalSales
      ,[TotalTip] = @TotalTip
      ,[TotalPymnt] = @TotalPymnt
      ,[Status] = @Status
      ,[CashSales] =@CashSales
      ,[ChargeSales] = @ChargeSales
      ,[NetSales] = @NetSales
      ,[ActualBusinessDate] = @ActualBusinessDate
      ,[CashDue] = @CashDue
      ,[CashReceived] = @CashReceived
      ,[ActualCashEntered] = @ActualCashEntered
      ,[Covers] = @Covers
      ,[Discounts] = @Discounts
      ,[EntreeCount] = @EntreeCount
      ,[GCSold] = @GCSold
      ,[GCRedeemed] = @GCRedeemed
      ,[NumTables] = @NumTables
      ,[TaxCollected] = @TaxCollected
      ,[OtherSales] = @OtherSales
      ,[ChargeTips] = @ChargeTips
      ,[CompleteStatus] = @CompleteStatus
      ,[TipWithheld] = @TipWithheld
      ,LastUpdate=GETDATE()
 WHERE [StoreID] = @StoreID and [CheckOutID]  = @CheckOutID
	end Catch
 end
GO
