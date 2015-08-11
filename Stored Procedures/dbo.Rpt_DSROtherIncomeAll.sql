SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_DSROtherIncomeAll]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(2000)

AS
begin
--GC Sales--
 Select ISNULL(SUM(oli.qty * oli.price),0) as gcSales
From (select qty,price,OrderID,StoreID,itemid,BusinessDate,RecordType  from [dbo].[fnOrderLineItemTable](@BeginDate,@EndDate,@storeID)) as oli 
inner JOIN (select StoreId,BusinessDate,ID from [dbo].[fnOrderTable](@BeginDate,@EndDate,@storeID)) as  O ON oli.orderid = O.ID
		and o.StoreId=oli.StoreID
		AND O.BusinessDate=oli.BusinessDate
		JOIN MenuItem MI ON oli.itemid = MI.ID AND MI.MIType = 'GC'
		and MI.StoreId=o.StoreId
Where oli.RecordType <> 'VOID' and oli.RecordType <>'comp'  

--Paid Ins
Select ISNULL(SUM(Amount),0) AS TotalPaidIn From (select *  from [dbo].[fnPaidInTrxTable](@BeginDate,@EndDate,@storeID)) as PaidInTrx Where [status] = 'PAID_IN'

--In House Payment Sales
Select ISNULL(SUM(OI.qty * OI.price),0) as InHousePaymentSales
From (select qty,price,RecordType,itemid,orderid,StoreID,BusinessDate  from [dbo].[fnOrderLineItemTable](@BeginDate,@EndDate,@storeID)) as OI
inner  JOIN (select StoreID,ID,BusinessDate  from [dbo].[fnOrderTable](@BeginDate,@EndDate,@storeID)) as O ON OI.orderid = O.ID and o.StoreId=OI.StoreID and o.BusinessDate=oi.BusinessDate
inner JOIN MenuItem MI ON OI.itemid = MI.ID AND MI.MIType = 'IHPYMNT' and MI.StoreId=o.StoreID
Where OI.RecordType <> 'VOID'

--Advance Payments
Select ISNULL(SUM(p.amount),0) as advPayment From (select Amount,CheckID,StoreID,BusinessDate from [dbo].[fnPaymentTable](@BeginDate,@EndDate,@storeID)) as p 
inner JOIN (select ID,StoreId,FutureOrderAdvPayment,BusinessDate  from [dbo].[fnCheckTable](@BeginDate,@EndDate,@storeID)) as c ON p.CheckID = c.ID and c.StoreId=p.StoreID and p.BusinessDate=c.BusinessDate
Where c.FutureOrderAdvPayment = 'Y'

--Surcharge collected
Select ISNULL(Sum(case when ss.SurchargeGuestPays='Y' then TaxAmt else 0 end),0) as surchageamt 
From (select StoreID,Category,BusinessDate,TaxAmt,TaxCategoryID,OrderID from [dbo].[fnTaxTable](@BeginDate,@EndDate,@storeID)) as  A JOIN TaxCategory B on a.TaxCategoryID = b.ID and B.Category='SUR' and  A.Category=B.Category 
	 inner JOIN (select  BusinessDate,ID,StoreID  from [dbo].[fnOrderTable](@BeginDate,@EndDate,@storeID)) as o ON a.OrderID = o.ID 
	AND a.BusinessDate = o.BusinessDate and a.StoreID= o.StoreID
	left outer join StoreSetting as ss on o.StoreID =ss.StoreID
end
GO
