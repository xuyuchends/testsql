SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_GetAlterNetCashReceived]
(
	@BeginTime datetime,
	@endTime datetime,
	@StoreID int
)
RETURNS decimal(18,2)
AS
BEGIN
declare @GrossCash decimal(18,2)
declare @CCTipTtl_TtlSrvCharge decimal(18,2)
declare @GCChangeTTL decimal(18,2)
declare @PaidIn decimal(18,2)
declare @PaidOut decimal(18,2)
declare @TipWithheld decimal(18,2)
declare @ReimbursementTtl decimal(18,2)
set @GrossCash=0
set @CCTipTtl_TtlSrvCharge =0
set @GCChangeTTL =0
set @PaidIn=0
set @PaidOut=0
set @TipWithheld =0
set @ReimbursementTtl=0

	DECLARE @tempOrder  Table(id bigint null,StoreID int null)
	insert into @tempOrder	select ID,@StoreID from [dbo].[fnOrderTable](@BeginTime,@endTime,@StoreID) 
	DECLARE @tempPaidOutTrx  Table(Amount money null)
	insert into @tempPaidOutTrx	select Amount from [dbo].[fnPaidOutTrxTable](@BeginTime,@endTime,@StoreID)
	DECLARE @tempPaidInTrx  Table(Amount money null,[Status] nvarchar(50))
	insert into @tempPaidInTrx	select Amount,[status]  from [dbo].[fnPaidInTrxTable](@BeginTime,@endTime,@StoreID)
	DECLARE @tempPayment  Table([CheckID] bigint,[Amount] money,StoreID int,[MethodID] nvarchar(50),[Tip] money,[Gratuity] money,[AmountReceived] money,[Status] nvarchar(50))
	insert into @tempPayment select CheckID,Amount,@StoreID,MethodID,Tip,Gratuity,AmountReceived,Status from [dbo].[fnPaymentTable](@BeginTime,@endTime,@StoreID)
	DECLARE @tempCheck  Table(OrderID bigint null,id bigint null,StoreID int null)
	insert into @tempCheck	select OrderID,id,@StoreID from [dbo].[fnCheckTable](@BeginTime,@endTime,@StoreID)
	
	--------GrossCash
	select @GrossCash=isnull(SUM(p.Amount),0)
	FROM (select ID,StoreID from @tempOrder) AS O
	INNER JOIN (select OrderID,ID,StoreID from @tempCheck) AS c ON O.ID = c.OrderID AND O.StoreID = c.StoreID 
	INNER JOIN (select CheckID,Amount,StoreID,MethodID from @tempPayment) AS p ON p.CheckID = c.ID AND O.StoreID = p.StoreID
	INNER JOIN PaymentMethod AS pm ON p.MethodID = pm.Name AND pm.StoreID = O.StoreID
	where  pm.Name='Cash'

	------------CCTipTtl+TtlSrvCharge
	select @CCTipTtl_TtlSrvCharge= isnull(SUM(p.Tip),0)+isnull(SUM(p.Gratuity),0)
	FROM (select ID,StoreID from @tempOrder) AS O
	INNER JOIN (select OrderID,ID,StoreID from @tempCheck) AS c ON O.ID = c.OrderID AND O.StoreID = c.StoreID 
	INNER JOIN (select CheckID,Tip,Gratuity,StoreID,MethodID from @tempPayment) AS p ON p.CheckID = c.ID AND O.StoreID = p.StoreID
	INNER JOIN PaymentMethod AS pm ON p.MethodID = pm.Name AND pm.StoreID = O.StoreID
	where  pm.Name not in('Cash')

	---------------------------GCChangeTTL= TtlReceived-sales-TtlSrvCharge
	select @GCChangeTTL=isnull(SUM(p.AmountReceived),0) -isnull(SUM(p.Amount),0)-isnull(SUM(p.Gratuity),0)
	FROM (select ID,StoreID from @tempOrder) AS O
	INNER JOIN (select OrderID,ID,StoreID from @tempCheck) AS c ON O.ID = c.OrderID AND O.StoreID = c.StoreID 
	INNER JOIN (select CheckID,Amount,Tip,Gratuity,AmountReceived,StoreID,MethodID from @tempPayment) AS p ON p.CheckID = c.ID AND O.StoreID = p.StoreID
	INNER JOIN PaymentMethod AS pm ON p.MethodID = pm.Name AND pm.StoreID = O.StoreID
	where  pm.Name='GC'

	----Paid Ins
	Select @PaidIn= ISNULL(SUM(Amount),0) from @tempPaidInTrx Where status = 'PAID_IN'
	----Paid out
	 Select @PaidOut =ISNULL(SUM(Amount),0) from @tempPaidOutTrx
	-- --TipWithHeld
	 
	DECLARE @ttlServiceCharge MONEY
	DECLARE @totalCashSrvCharge MONEY
	DECLARE @creditCardSrvCharge MONEY
	DECLARE @SrvChargeWithHeld MONEY
	DECLARE @CCWithHeld MONEY
	DECLARE @innerStoreID int
	declare @Tip_withheld decimal(18,2)
	set @ttlServiceCharge =0
	set @totalCashSrvCharge =0
	set @creditCardSrvCharge=0
	set @SrvChargeWithHeld =0
	set @CCWithHeld =0
	set @innerStoreID=0

	SELECT	@ttlServiceCharge = isnull(sum(p.Gratuity),0)
	FROM	(select  ID,StoreID  from @tempCheck) as c INNER JOIN 
			(select Status,CheckID,StoreID,Gratuity from @tempPayment)  as p ON c.id = p.CheckID  and c.StoreID=p.StoreID
	WHERE   p.Status = 'CLOSED' 
	SELECT	@totalCashSrvCharge = isnull(sum(p.Gratuity),0)
	FROM    (select ID,StoreID from @tempCheck) as c INNER JOIN 
			(select Status,CheckID,StoreID,MethodID,Gratuity from @tempPayment)  as p ON c.ID =p.CheckID and c.StoreID=p.StoreID INNER JOIN 
			PaymentMethod  as pm ON p.MethodID = pm.Name and p.StoreID=pm.StoreID
	WHERE	 p.Status = 'CLOSED' AND pm.DisplayName = 'cash' 
	set @creditCardSrvCharge = @ttlServiceCharge - @totalCashSrvCharge
	if @creditCardSrvCharge < 0 
		BEGIN
			set @creditCardSrvCharge = 0
		END
	select @SrvChargeWithHeld = sum(@creditCardSrvCharge *ss.PercentWithheldTips)
		From StoreSetting   as ss where ss.StoreID in (select * from dbo.f_split(@StoreID,','))
	SELECT @CCWithHeld = isnull(SUM(dc.totalTip * ss.PercentWithheldTips),0) 
		From DailyCheckOuts as dc inner join  StoreSetting as ss on dc.StoreID=ss.StoreID
		WHERE(BusinessDate BETWEEN @BeginTime AND @endTime ) AND (Status = 'closed') and dc.StoreID in (select * from dbo.f_split(@StoreID,','))
	set @Tip_withheld = @CCWithHeld + @SrvChargeWithHeld 

	----ReimbursementTtl
	SELECT @ReimbursementTtl= isnull(SUM(ReimbursementTtl) ,0)
	FROM	DeliveryReimbursements
	WHERE  status = 'CLOSED' and   BusinessDate BETWEEN @BeginTime  AND @endTime AND StoreID=@StoreID
	------------------------------------------------------------
	return @GrossCash-@CCTipTtl_TtlSrvCharge-@GCChangeTTL+@PaidIn-@PaidOut+@TipWithheld-@ReimbursementTtl
END
GO
