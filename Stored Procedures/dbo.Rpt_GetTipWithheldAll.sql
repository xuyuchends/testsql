SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_GetTipWithheldAll]
(
	@BeginDate datetime,
	@EndDate datetime,
	@StoreID nvarchar(2000),
@Tip_withheld MONEY OUTPUT
)
AS
begin
DECLARE @ttlServiceCharge MONEY
DECLARE @totalCashSrvCharge MONEY
DECLARE @creditCardSrvCharge MONEY
DECLARE @SrvChargeWithHeld MONEY
DECLARE @CCWithHeld MONEY
DECLARE @innerStoreID int

set @ttlServiceCharge =0
set @totalCashSrvCharge =0
set @creditCardSrvCharge=0
set @SrvChargeWithHeld =0
set @CCWithHeld =0
set @innerStoreID=0

	SELECT	@ttlServiceCharge = isnull(sum(p.Gratuity),0)
	FROM	(select  ID,StoreID  from [dbo].[fnCheckTable](@BeginDate,@EndDate,@StoreID)) as c INNER JOIN 
			(select Status,CheckID,StoreID,Gratuity from [dbo].[fnPaymentTable](@BeginDate,@EndDate,@StoreID))  as p ON c.id = p.CheckID  and c.StoreID=p.StoreID
	WHERE   p.Status = 'CLOSED' 
	SELECT	@totalCashSrvCharge = isnull(sum(p.Gratuity),0)
	FROM    (select ID,StoreID from [dbo].[fnCheckTable](@BeginDate,@EndDate,@StoreID)) as c INNER JOIN 
			(select Status,CheckID,StoreID,MethodID,Gratuity from [dbo].[fnPaymentTable](@BeginDate,@EndDate,@StoreID))  as p ON c.ID =p.CheckID and c.StoreID=p.StoreID INNER JOIN 
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
		WHERE(BusinessDate BETWEEN @BeginDate AND @EndDate ) AND (Status = 'closed') and dc.StoreID in (select * from dbo.f_split(@StoreID,','))
	set @Tip_withheld = @CCWithHeld + @SrvChargeWithHeld 

RETURN @Tip_withheld 
end
GO
