SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Rpt_DailySummary]
(
	@BeginTime datetime,
	@endTime datetime,
	@StoreID int
)
as
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#tempOrderLineItem') and type='U')  
drop table #tempOrderLineItem 
select * into #tempOrderLineItem from [dbo].[fnOrderLineItemTable](@BeginTime,@endTime,@StoreID)
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#tempOrder') and type='U')  
drop table #tempOrder
select * into #tempOrder from [dbo].[fnOrderTable](@BeginTime,@endTime,@StoreID)
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#tempPaidOutTrx') and type='U')  
drop table #tempPaidOutTrx
select * into #tempPaidOutTrx from [dbo].[fnPaidOutTrxTable](@BeginTime,@endTime,@StoreID)
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#tempPaidInTrx') and type='U')  
drop table #tempPaidInTrx
select * into #tempPaidInTrx from [dbo].[fnPaidInTrxTable](@BeginTime,@endTime,@StoreID)
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#tempPayment') and type='U')  
drop table #tempPayment
select * into #tempPayment from [dbo].[fnPaymentTable](@BeginTime,@endTime,@StoreID)
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#tempCheck') and type='U')  
drop table #tempCheck
select * into #tempCheck from [dbo].[fnCheckTable](@BeginTime,@endTime,@StoreID)
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#tempTax') and type='U')  
drop table #tempTax
select * into #tempTax from [dbo].[fnTaxTable](@BeginTime,@endTime,@StoreID)

-----------------------------------------------Rpt_DepartmentSalesAll
select Department,'','',
	isnull(SUM(GrossSales),0) as  GrossSales,
	isnull(SUM(Voids),0) Voids,
	isnull(SUM(Comps),0) Comps,
	isnull(SUM(Discount),0) Discount 
	from(SELECT MI.ReportDepartment as Department, 
	SUM(OI.Qty * OI.Price) AS GrossSales, 
	SUM(isnull(CASE OI.RecordType WHEN 'VOID' THEN OI.qty * OI.AdjustedPrice END,0)) AS Voids, 
	SUM(isnull(CASE OI.RecordType WHEN 'COMP' THEN OI.qty * OI.AdjustedPrice END,0)) AS Comps, 
	SUM(isnull(CASE OI.RecordType WHEN 'DISCOUNT' THEN OI.qty * OI.AdjustedPrice END,0)) AS Discount
FROM (select RecordType,Qty,AdjustedPrice,Price,OrderID,StoreID,ItemID,SI from #tempOrderLineItem) AS OI 
INNER JOIN (select StoreID,MealPeriod,ID  from #tempOrder) AS O 
	ON OI.OrderID = O.ID AND O.StoreID = OI.StoreID 
INNER JOIN MenuItem AS MI 
	ON OI.ItemID = MI.ID AND MI.ReportDepartment <> 'MODIFIER' and OI.SI<>'N/A' AND MI.StoreID = O.StoreID
WHERE MI.MIType NOT IN ('GC', 'IHPYMNT') 
GROUP BY O.MealPeriod, MI.ReportDepartment, OI.RecordType with rollup
having GROUPING(O.MealPeriod)=0
and GROUPING( MI.ReportDepartment)=0
and GROUPING(OI.RecordType) =1) as tab group by Department
-----------------------------------------------Rpt_DepartmentSalesAll
-----------------------------------------------Rpt_DSROtherIncomeAll
 Select ISNULL(SUM(oli.qty * oli.price),0) as gcSales
From (select qty,price,OrderID,StoreID,itemid,BusinessDate,RecordType  from #tempOrderLineItem) as oli 
inner JOIN (select StoreId,BusinessDate,ID from #tempOrder) as  O ON oli.orderid = O.ID
		and o.StoreId=oli.StoreID
		AND O.BusinessDate=oli.BusinessDate
		JOIN MenuItem MI ON oli.itemid = MI.ID AND MI.MIType = 'GC'
		and MI.StoreId=o.StoreId
Where oli.RecordType <> 'VOID' and oli.RecordType <>'comp'  

--Paid Ins
Select ISNULL(SUM(Amount),0) AS TotalPaidIn From (select *  from #tempPaidInTrx) as PaidInTrx Where [status] = 'PAID_IN'

--In House Payment Sales
Select ISNULL(SUM(OI.qty * OI.price),0) as InHousePaymentSales
From (select qty,price,RecordType,itemid,orderid,StoreID,BusinessDate  from #tempOrderLineItem) as OI
inner  JOIN (select StoreID,ID,BusinessDate  from #tempOrder) as O ON OI.orderid = O.ID and o.StoreId=OI.StoreID and o.BusinessDate=oi.BusinessDate
inner JOIN MenuItem MI ON OI.itemid = MI.ID AND MI.MIType = 'IHPYMNT' and MI.StoreId=o.StoreID
Where OI.RecordType <> 'VOID'

--Advance Payments
Select ISNULL(SUM(p.amount),0) as advPayment From (select Amount,CheckID,StoreID,BusinessDate from #tempPayment) as p 
inner JOIN (select ID,StoreId,FutureOrderAdvPayment,BusinessDate  from #tempCheck) as c ON p.CheckID = c.ID and c.StoreId=p.StoreID and p.BusinessDate=c.BusinessDate
Where c.FutureOrderAdvPayment = 'Y'

--Surcharge collected
Select ISNULL(Sum(case when ss.SurchargeGuestPays='Y' then TaxAmt else 0 end),0) as surchageamt 
From (select StoreID,Category,BusinessDate,TaxAmt,TaxCategoryID,OrderID from #tempTax) as  A JOIN TaxCategory B on a.TaxCategoryID = b.ID and B.Category='SUR' and  A.Category=B.Category 
	 inner JOIN (select  BusinessDate,ID,StoreID  from #tempOrder) as o ON a.OrderID = o.ID 
	AND a.BusinessDate = o.BusinessDate and a.StoreID= o.StoreID
	left outer join StoreSetting as ss on o.StoreID =ss.StoreID
	
-----------------------------------------------Rpt_DSROtherIncomeAll
-----------------------------------------------Rpt_DSRExpendituresAll
 Select ISNULL(SUM(pot.Amount),0) AS TotalPaidOut From 
 (select Amount  from #tempPaidOutTrx)  as pot

--Previous payments from future orders
 select ISNULL(SUM(p.amount),0) as PaidAdv  
 From (select Amount,CheckID,StoreID from #tempPayment) as p
  inner JOIN (select ID,StoreID,orderid from #tempCheck) as c ON p.CheckID = c.ID and p.StoreID=c.StoreID  
 inner JOIN (select FutureOrder,ID,StoreID from #tempOrder) as O ON c.orderid = O.ID  and O.StoreID=c.StoreID
 where O.FutureOrder = 'Y'
-----------------------------------------------Rpt_DSRExpendituresAll
-----------------------------------------------Rpt_TaxSummaryAll
Select tc.Name as TaxName, ISNULL(SUM(t.TaxAmt),0) as TaxAmt, ISNULL(SUM(t.TaxOrderAmt),0) as OrderAmt
		From #tempTax as t inner JOIN TaxCategory tc 
			ON t.TaxCategoryID = tc.ID and t.Category=tc.Category and tc.StoreID= t.StoreID
		Where  t.Category = 'TAX'
Group By tc.Name
-----------------------------------------------Rpt_TaxSummaryAll
-----------------------------------------------Rpt_PaymentSummaryAll
SELECT pm.Name as PaymentName, 
isnull(COUNT(p.CheckID),0) AS numPayments, 
isnull(SUM(p.Amount),0) AS sales, 
isnull(SUM(p.Tip),0) AS TipTotal, 
isnull(SUM(p.Gratuity),0) AS TtlSrvCharge, 
isnull(SUM(p.AmountReceived),0) AS TtlReceived
FROM (select ID,StoreID from #tempOrder) AS O
INNER JOIN (select OrderID,ID,StoreID from #tempCheck) AS c ON O.ID = c.OrderID AND O.StoreID = c.StoreID 
INNER JOIN (select CheckID,Amount,Tip,Gratuity,AmountReceived,StoreID,MethodID from [#tempPayment]) AS p ON p.CheckID = c.ID AND O.StoreID = p.StoreID
INNER JOIN PaymentMethod AS pm ON p.MethodID = pm.Name AND pm.StoreID = O.StoreID
GROUP BY pm.Name
-----------------------------------------------Rpt_PaymentSummaryAll
-----------------------------------------------Rpt_CategorySummaryByPeriodAll
Select storeid, Category, CAST(isnull(sum(ttlqty),0)as int) as TtlQty, isnull(sum(lunch),0) as  Lunch, sum(dinner) as Dinner From 
(
Select o.storeid as storeID, MI.ReportCategory as Category, 
CASE WHEN OI.parentsplitLineNum = 0 THEN OI.qty ELSE (convert(real,OI.qty)/convert(real,OI.numsplits)) END  as TtlQty, 
case when O.MealPeriod = 'LUNCH' then isnull(OI.qty * (OI.price-OI.adjustedPrice),0) else 0 end as Lunch,
case when O.MealPeriod = 'DINNER' then isnull(OI.qty * (OI.price-OI.adjustedPrice),0) else 0 end as DINNER
From (select qty,price,AdjustedPrice,parentsplitLineNum,itemid,recordType,SI,orderid,numsplits,StoreID from #tempOrderLineItem) as OI 
inner JOIN (select storeid,MealPeriod,ID from #tempOrder) as O ON OI.orderid = O.ID and OI.StoreID=O.StoreID
LEFT JOIN MenuItem MI ON OI.itemid = MI.ID and o.StoreID=MI.StoreID
Where si <> 'N/A' AND MI.ReportCategory <> '' AND MI.ReportCategory IS NOT NULL and oi.recordType<>'VOID' and O.MealPeriod in ('LUNCH','DINNER') 
) as table1
Group by storeid, Category
-----------------------------------------------Rpt_CategorySummaryByPeriodAll
-----------------------------------------------Rpt_CategorySummaryByPCAll
Select o.RevenueCenter, 
MI.ReportCategory,
isnull(SUM(OI.qty * (OI.price-OI.AdjustedPrice)),0) as CatTotal
From (select orderid,StoreID,qty,price,AdjustedPrice,itemid,SI from #tempOrderLineItem) as OI 
inner JOIN (select RevenueCenter,StoreID,ID from #tempOrder)as O ON OI.orderid = O.ID
and OI.StoreID=O.StoreID
LEFT JOIN MenuItem MI ON OI.itemid = MI.ID AND MI.ReportCategory <> '' AND MI.ReportCategory IS NOT NULL
and O.StoreID=MI.StoreID
Where si <> 'N/A' 
Group By o.RevenueCenter, MI.ReportCategory
-----------------------------------------------Rpt_CategorySummaryByPCAll
-----------------------------------------------Rpt_LinecutsSummaryAll VOID
select v.Name as AdjustedName,sum(oli.qty * oli.AdjustedPrice) as Total,COUNT(*) as  count
from (select qty,AdjustedPrice,AdjustID,storeid,RecordType,itemid from #tempOrderLineItem) as oli inner join Void as v on oli.AdjustID=v.ID and oli.StoreID=v.StoreID			
LEFT outer JOIN menuItem MI ON MI.ID = oli.itemid and mi.StoreID=oli.StoreID
where oli.RecordType = 'VOID' AND MI.MIType <>'IHPYMNT'
group by v.Name
-----------------------------------------------Rpt_LinecutsSummaryAll VOID
-----------------------------------------------Rpt_LinecutsSummaryAll COMP
select v.Name as AdjustedName,sum(oli.qty * oli.AdjustedPrice) as Total,COUNT(*) as  count
from (select qty,AdjustedPrice,AdjustID,storeid,RecordType,itemid from #tempOrderLineItem) as oli inner join COMP as v on oli.AdjustID=v.ID and oli.StoreID=v.StoreID			
LEFT outer JOIN menuItem MI ON MI.ID = oli.itemid and mi.StoreID=oli.StoreID
where oli.RecordType = 'COMP' AND MI.MIType <>'IHPYMNT'
group by v.Name
-----------------------------------------------Rpt_LinecutsSummaryAll COMP
-----------------------------------------------Rpt_LinecutsSummaryAll DISCOUNT
select v.Name as AdjustedName,sum(oli.qty * oli.AdjustedPrice) as Total,COUNT(*) as  count
from (select qty,AdjustedPrice,AdjustID,storeid,RecordType,itemid from #tempOrderLineItem) as oli inner join DISCOUNT as v on oli.AdjustID=v.ID and oli.StoreID=v.StoreID			
LEFT outer JOIN menuItem MI ON MI.ID = oli.itemid and mi.StoreID=oli.StoreID
where oli.RecordType = 'DISCOUNT' AND MI.MIType <>'IHPYMNT'
group by v.Name
-----------------------------------------------Rpt_LinecutsSummaryAll DISCOUNT
-------------------------------------------------Rpt_GuestTableSummaryByPCAll
Select RevenueCenterName, SUM(NumTables) as NumTables, SUM(NumGuest)as NumGuest, SUM(NumChecks) as NumChecks, SUM(ProfitTotal) as ProfitTotal from 
(
 select RevenueCenter as RevenueCenterName,count(ID) as NumTables ,sum(GuestCount)  as NumGuest,NULL AS NumChecks, NULL AS ProfitTotal from #tempOrder
 where status<>'TRANSFERRED' Group by RevenueCenter
UNION 
Select o.RevenueCenter as RevenueCenterName,NULL AS NumTables, NULL AS NumGuest,
COUNT(p.CheckID) AS NumChecks, NULL as ProfitTotal
From (select RevenueCenter,StoreID,ID,status from #tempOrder) as  O
inner JOIN (select ID,StoreID,orderid  from #tempCheck) as c ON O.ID = c.orderid and O.StoreID=c.StoreID
inner JOIN (select CheckID,StoreID  from #tempPayment) as p ON p.CheckID = c.ID and c.StoreID=p.StoreID 
where status<>'TRANSFERRED'
Group by o.RevenueCenter
UNION
Select o.RevenueCenter as RevenueCenterName, NULL AS NumTables, NULL AS NumGuest,
NULL AS NumChecks, SUM(qty * (price-AdjustedPrice)) as ProfitTotal
From (select RevenueCenter,ID,StoreID,status  from #tempOrder) as O
inner JOIN (select orderid,StoreID,qty,price,AdjustedPrice  from #tempOrderLineItem
) as OI ON O.ID = OI.orderid  and O.StoreID=OI.StoreID where o.status<>'TRANSFERRED'
 Group by o.RevenueCenter

) as table1
Group by RevenueCenterName
-----------------------------------------------Rpt_GuestTableSummaryByPCAll
---------------------------------------------Rpt_GuestTableSummaryByPeriodAll
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#temp') and type='U')
   drop table #temp
select SaleGroup,RecordType,ISNULL(sum(value),0) as value into #temp  from
(
Select dbo.f_GetOrderMealPeriodRpt(o.openTime,o.StoreID) as SaleGroup,'Number Tables Served' as RecordType,count(o.ID) as value  
From (select openTime,StoreID,status,ID  from #tempOrder) as o 
where o.status<>'TRANSFERRED' Group by o.openTime,o.StoreID
union all 
Select dbo.f_GetOrderMealPeriodRpt(o.openTime,o.StoreID) as SaleGroup,'Number Guest Served' as RecordType,sum(o.GuestCount) as value 
From (select openTime,StoreID,status,GuestCount from #tempOrder) as o  where o.status<>'TRANSFERRED' 
Group by o.openTime,o.StoreID
union all
Select dbo.f_GetOrderMealPeriodRpt(o.openTime,o.StoreID) as SaleGroup, 'Number Checks' as RecordType, COUNT(p.CheckID) AS value   
From (select openTime,StoreID,status,id from #tempOrder) as O 
inner JOIN (select orderid,StoreID,ID from #tempCheck) as c ON O.id = c.orderid and o.StoreID=c.StoreID 
inner JOIN (select StoreID,CheckID from #tempPayment) as p ON p.CheckID = c.ID and o.StoreID=p.StoreID
where o.status<>'TRANSFERRED' 
Group by o.openTime,o.StoreID 
union all 
Select dbo.f_GetOrderMealPeriodRpt(o.openTime,o.StoreID) as SaleGroup, 'ProfitTotal' as RecordType, SUM(qty *(price -AdjustedPrice)) as ProfitTotal   
From (select openTime,StoreID,status,ID  from #tempOrder) as O 
inner JOIN (select qty,price,AdjustedPrice,orderid,StoreID from #tempOrderLineItem)  OI ON O.ID = OI.orderid and o.StoreID= OI.StoreID where o.status<>'TRANSFERRED' 
Group by o.openTime,o.StoreID
)  as tabel1 group by SaleGroup,RecordType


declare @saleGroup nvarchar(20)  
declare @RecordType nvarchar(20)  
declare @value decimal(10,2)   
declare @GuestValue decimal(10,2)  
declare @CheckValue decimal(10,2)  
declare @PPA decimal (10,2)  
declare @PCA decimal (10,2)    

DECLARE cur CURSOR FOR select * from #temp where recordType='ProfitTotal' 
  
OPEN cur FETCH NEXT FROM cur INTO @saleGroup, @RecordType,@value   
 WHILE @@FETCH_STATUS = 0 
 BEGIN 
	select @GuestValue=value from #temp where RecordType='Number Guest Served' and saleGroup = @saleGroup 
	select @CheckValue=value from #temp where RecordType='Number Checks' and saleGroup = @saleGroup 
	set @PPA=@value/@GuestValue*1.00 
	set @PCA=@value/@CheckValue*1.00 
	
	insert into #temp values(@saleGroup,'PPA',@PPA)     
	insert into #temp values(@saleGroup,'PCA',@PCA)
 FETCH NEXT FROM cur INTO @saleGroup, @RecordType,@value  
 END    
 CLOSE cur 
 DEALLOCATE cur   
 

declare @NumberGuestServedTotal decimal(10,2)   
declare @numCheckTotal decimal(10,2)   
declare @ProfitTotal decimal(10,2) 
declare @NumberTablesServed decimal(10,2)  
if (select COUNT(*) from #temp)>0
begin
select @NumberGuestServedTotal=SUM(isnull(value,0)) from #temp where RecordType='Number Guest Served'  
select @numCheckTotal=SUM(isnull(value,0)) from #temp where RecordType='Number Checks'  
select @NumberTablesServed=SUM(isnull(value,0)) from #temp where RecordType='Number Tables Served'  
select @ProfitTotal=SUM(isnull(value,0)) from #temp where RecordType='ProfitTotal' 
insert into #temp values('Total','Number Checks',@numCheckTotal) 
insert into #temp values('Total','Number Guest Served',@NumberGuestServedTotal)  
insert into #temp values('Total','Number Tables Served',@NumberTablesServed)  
insert into #temp values('Total','PPA',@ProfitTotal/@NumberGuestServedTotal)  
insert into #temp values('Total','PCA',@ProfitTotal/@numCheckTotal) 
delete from #temp where RecordType='ProfitTotal'  

end
select *,case salegroup when 'Lunch' then 1 when 'DINNER' then 2 when 'Total' then 999 else 3 end OrderCol from #temp  
drop table #temp 
-------------------------------------------------Rpt_GuestTableSummaryByPeriodAll
-----------------------------------------------Rpt_GetDriverReimbursement
SELECT isnull(SUM(ReimbursementTtl) ,0) ReimbursementTtl
FROM	DeliveryReimbursements
WHERE  status = 'CLOSED' and   BusinessDate BETWEEN @BeginTime  AND @endTime 
AND StoreID=@StoreID
-----------------------------------------------Rpt_GetDriverReimbursement
-----------------------------------------------Rpt_GetTipWithheldAll
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
	FROM	(select  ID,StoreID  from #tempCheck) as c INNER JOIN 
			(select Status,CheckID,StoreID,Gratuity from #tempPayment)  as p ON c.id = p.CheckID  and c.StoreID=p.StoreID
	WHERE   p.Status = 'CLOSED' 
	SELECT	@totalCashSrvCharge = isnull(sum(p.Gratuity),0)
	FROM    (select ID,StoreID from #tempCheck) as c INNER JOIN 
			(select Status,CheckID,StoreID,MethodID,Gratuity from #tempPayment)  as p ON c.ID =p.CheckID and c.StoreID=p.StoreID INNER JOIN 
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

select @Tip_withheld 

-----------------------------------------------Rpt_GetTipWithheldAll



-----------------------------------------------Rpt_GetCashDepositTotals
SELECT isnull(sum(CashDeposit),0) as CashDeposit
FROM     CashDepsits    
where BusinessDate BETWEEN @BeginTime   AND @endTime 
AND StoreID =@StoreID
-----------------------------------------------Rpt_GetCashDepositTotals

GO
