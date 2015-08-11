SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_PaymentSummaryAll]
	@BeginDate datetime,	
	@EndDate datetime,
	@storeID nvarchar(2000)
AS
begin
SELECT pm.Name as PaymentName, 
isnull(COUNT(p.CheckID),0) AS numPayments, 
isnull(SUM(p.Amount),0) AS sales, 
isnull(SUM(p.Tip),0) AS TipTotal, 
isnull(SUM(p.Gratuity),0) AS TtlSrvCharge, 
isnull(SUM(p.AmountReceived),0) AS TtlReceived
FROM (select ID,StoreID,BusinessDate from [dbo].[fnOrderTable](@BeginDate,@EndDate,@storeID)) AS O
INNER JOIN (select OrderID,ID,StoreID,BusinessDate from [dbo].[fnCheckTable](@BeginDate,@EndDate,@storeID)) AS c ON O.ID = c.OrderID AND O.StoreID = c.StoreID 
and O.BusinessDate=c.BusinessDate
INNER JOIN (select CheckID,Amount,Tip,Gratuity,AmountReceived,StoreID,MethodID,BusinessDate from [dbo].[fnPaymentTable](@BeginDate,@EndDate,@storeID)) AS p ON p.CheckID = c.ID AND O.StoreID = p.StoreID 
and p.BusinessDate = c.BusinessDate
INNER JOIN PaymentMethod AS pm ON p.MethodID = pm.Name AND pm.StoreID = O.StoreID
GROUP BY pm.Name
end
GO
