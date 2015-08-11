SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Rpt_KeyMetricsComparisonByDateAll]
(
	@StoreID nvarchar(20),
	@RevenueCenter nvarchar(20),
	@BeginDate datetime,
	@EndDate datetime,
	@MealPeriod varchar(10)
)
as
declare @SqlGCSales nvarchar(max)
declare @SqlAdvancePayments nvarchar(max)
declare @SqlPaidIn nvarchar(max)
declare @SqlSurchargeTotals nvarchar(max)
declare @SqlTaxTotal nvarchar(max)
declare @SqlLaborTotal nvarchar(max)
declare @SqlChecksCount nvarchar(max)
declare @SqlGuestCount nvarchar(max)
declare @WhereSql nvarchar(max)
declare @SqlVoid nvarchar(max)
declare @SqlDiscount nvarchar(max)
declare @SqlComp nvarchar(max)
declare @SqlAll nvarchar(max)

set @WhereSql=''

set @SqlVoid='select SUM(Qty*AdjustedPrice) from #tempOrderLineItem m inner join [#order] o on m.OrderID=o.ID and m.StoreID=o.StoreID and m.BusinessDate=o.BusinessDate where RecordType=''VOID'' '

set @SqlDiscount='select SUM(Qty*AdjustedPrice) from #tempOrderLineItem m inner join [#order] o on m.OrderID=o.ID and m.StoreID=o.StoreID and m.BusinessDate=o.BusinessDate where RecordType in (''DISCOUNT'' ,''COUPON'' )'

set @SqlComp='select SUM(Qty*AdjustedPrice) from #tempOrderLineItem m inner join [#order] o on m.OrderID=o.ID and m.StoreID=o.StoreID and m.BusinessDate=o.BusinessDate where RecordType=''COMP''  '

set @SqlGCSales='Select ISNULL(SUM(OI.qty * OI.price),0) as gcSales
From #tempOrderLineItem OI JOIN [#order] O ON OI.orderid = O.ID
		and o.StoreId=OI.StoreID and o.BusinessDate=oi.BusinessDate
		JOIN MenuItem MI ON OI.itemid = MI.ID 
		AND (MI.MIType = ''GC'' or MI.MIType = ''IHPYMNT'')
		and MI.StoreId=o.StoreId
Where OI.RecordType <> ''VOID''  '
		
set @SqlAdvancePayments='Select ISNULL(SUM(SD.amount),0) as advPayment
From #tempPayment SD JOIN #tempCheck SH ON SD.CheckID = SH.ID
		and SH.StoreId=SD.StoreID
		inner join [#order] o on SH.OrderID =o.id and SH.StoreID =o.StoreID and  SH.BusinessDate =o.BusinessDate
Where  
SH.FutureOrderAdvPayment = ''Y''  '

set @SqlPaidIn = 'Select ISNULL(SUM(Amount),0) AS TotalPaidIn
From #tempPaidInTrx
Where  Status = ''PAID_IN''
'

set @SqlSurchargeTotals ='Select ISNULL(SUM(TaxAmt),0) as surchageamt    From #tempTax A JOIN TaxCategory B on a.TaxCategoryID = b.ID and B.Category=''SUR''
		 and  A.Category=B.Category    JOIN [#order] c ON a.OrderID = c.ID 
		 AND a.BusinessDate = c.BusinessDate and a.StoreID= c.StoreID where 1=1 '
	
set @SqlTaxTotal='Select ISNULL(SUM(TaxAmt),0) as surchageamt    From #tempTax A JOIN TaxCategory B on a.TaxCategoryID = b.ID and B.Category=''TAX''
		 and  A.Category=B.Category    JOIN [#order] c ON a.OrderID = c.ID 
		 AND a.BusinessDate = c.BusinessDate and a.StoreID= c.StoreID where 1=1 ' 
		 
set @SqlLaborTotal=' select SUM(ts.PayRate * ts.HoursWorked)+SUM(ts.OT1HoursWorked * ts.OT1Payrate+ts.OT2HoursWorked  * ts.OT2Payrate)as TotalPay from EmployeeTimeSheet as ts where ts.BusinessDate between '''+CONVERT(varchar(20),@BeginDate)+''' and '''+CONVERT(varchar(20),@EndDate)+'''  '

set @SqlChecksCount='select COUNT(*) from #tempCheck c inner join [#order] o on c.OrderID=o.ID and c.StoreID=o.StoreID and c.BusinessDate=o.BusinessDate where 1=1 '

set @SqlGuestCount = 'select SUM(GuestCount) from [#order] o where 1=1 '
if ISNULL(@MealPeriod,'')<>''
begin
	set @SqlGCSales=@SqlGCSales+' and o.daypart='''+convert(varchar(20),@MealPeriod)+''''
	set @SqlAdvancePayments=@SqlAdvancePayments+' and o.daypart='''+convert(varchar(20),@MealPeriod)+''''
	set @SqlSurchargeTotals=@SqlSurchargeTotals+' and C.daypart='''+convert(varchar(20),@MealPeriod)+''''
	set @SqlTaxTotal=@SqlTaxTotal+' and C.daypart='''+convert(varchar(20),@MealPeriod)+''''
	
	set @SqlLaborTotal=' select SUM(ts.PayRate * (dbo.fn_GetLaborHours(StoreID,EmployeeID,'''+convert(varchar(20),@MealPeriod)+''',businessDate,TimeIn)))+SUM(ts.OT1HoursWorked * ts.OT1Payrate+ts.OT2HoursWorked  * ts.OT2Payrate)as TotalPay from EmployeeTimeSheet as ts where ts.BusinessDate between '''+CONVERT(varchar(20),@BeginDate)+''' and '''+CONVERT(varchar(20),@EndDate)+'''  '
	
	set @SqlChecksCount=@SqlChecksCount+' and o.daypart='''+convert(varchar(20),@MealPeriod)+''''
	set @SqlGuestCount=@SqlGuestCount+' and o.daypart='''+convert(varchar(20),@MealPeriod)+''''
	set @WhereSql=@WhereSql+' and OD.daypart='''+convert(varchar(20),@MealPeriod)+''''
	set @SqlDiscount=@SqlDiscount+' and o.daypart='''+convert(varchar(20),@MealPeriod)+''''
	set @SqlVoid=@SqlVoid+' and o.daypart='''+convert(varchar(20),@MealPeriod)+''''
	set @SqlComp=@SqlComp+' and o.daypart='''+convert(varchar(20),@MealPeriod)+''''
end

--if ISNULL(@StoreID,'')<>''
--begin
--	set @SqlGCSales=@SqlGCSales+' and OI.StoreID in '+@StoreID
--	set @SqlAdvancePayments=@SqlAdvancePayments+' and SH.StoreId in '+@StoreID
--	set @SqlPaidIn=@SqlPaidIn+'and StoreId in '+@StoreID
--	set @SqlSurchargeTotals=@SqlSurchargeTotals+' and A.StoreID in '+@StoreID
--	set @SqlTaxTotal=@SqlTaxTotal+' and A.StoreID in '+@StoreID
--	set @SqlLaborTotal=@SqlLaborTotal+' and ts.StoreID in '+@StoreID
--	set @SqlChecksCount=@SqlChecksCount+' and c.StoreID in '+@StoreID
--	set @SqlGuestCount=@SqlGuestCount+' and o.StoreID in '+@StoreID
--	set @WhereSql = @WhereSql+' and oli.StoreID in '+@StoreID
--	set @SqlDiscount=@SqlDiscount+' and m.StoreID in '+@StoreID
--	set @SqlVoid=@SqlVoid+' and m.StoreID in '+@StoreID
--	set @SqlComp=@SqlComp+' and m.StoreID in '+@StoreID
--end

if ISNULL(@RevenueCenter,'')<>''
begin
	set @SqlGCSales=@SqlGCSales+' and o.RevenueCenter='''+@RevenueCenter+''''
	set @SqlAdvancePayments=@SqlAdvancePayments+'  and o.RevenueCenter='''+@RevenueCenter+''''
	set @SqlSurchargeTotals=@SqlSurchargeTotals+' and c.RevenueCenter='''+@RevenueCenter+''''
	set @SqlTaxTotal=@SqlTaxTotal+' and c.RevenueCenter='''+@RevenueCenter+''''
	set @SqlChecksCount=@SqlChecksCount+' and o.RevenueCenter ='''+@RevenueCenter+''''
	set @SqlGuestCount=@SqlGuestCount+' and o.RevenueCenter='''+@RevenueCenter+''''
	set @WhereSql= @WhereSql+' and OD.RevenueCenter='''+@RevenueCenter+''''
	set @SqlDiscount=@SqlDiscount+' and o.RevenueCenter='''+@RevenueCenter+''''
	set @SqlVoid=@SqlVoid+' and o.RevenueCenter='''+@RevenueCenter+''''
	set @SqlComp=@SqlComp+' and o.RevenueCenter='''+@RevenueCenter+''''
end


set @SqlAll='
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')
drop table #tempOrder
select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrderLineItem'') and type=''U'')
drop table #tempOrderLineItem 
select * into #tempOrderLineItem from [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempPayment'') and type=''U'')
drop table #tempPayment
select * into #tempPayment from [dbo].[fnPaymentTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempCheck'') and type=''U'')
drop table #tempCheck
select * into #tempCheck from [dbo].[fnCheckTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempPaidInTrx'') and type=''U'')
drop table #tempPaidInTrx
select * into #tempPaidInTrx from [dbo].[fnPaidInTrxTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempTax'') and type=''U'')
drop table #tempTax
select * into #tempTax from [dbo].[fnTaxTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

if exists (select * from sysobjects where id = object_id(N''tempdb..#order'') and type=''U'')
drop table #order
select *,dbo.[f_GetOrderMealPeriodRpt](OpenTime,StoreID) as daypart into #order from #tempOrder  
select isnull(sum(oli.Qty*oli.Price),0) as Sales, 
case when (select count(*) from store where id in ('+@StoreID+'))>1 then ''All Store''
else (select StoreName from Store where id in ('+@StoreID+')) end as StoreName,
case when (select count(*) from store where id in ('+@StoreID+'))>1 then ''''
else (select ID from Store where id in ('+@StoreID+')) end as StoreID,
			'''+convert(nvarchar(12),@BeginDate,101)+''' as BeginDate,
			'''+convert(nvarchar(12),@EndDate,101)+''' as EndDate,
		 isnull(('+@SqlDiscount+'),0) as Discount,
		 isnull(('+@SqlComp+'),0) as Comp,
		 isnull(('+@SqlVoid+'),0) as Void,
		 isnull((('+@SqlGCSales+')+('+@SqlAdvancePayments+')+('+@SqlPaidIn+')+('+@SqlSurchargeTotals+')),0) as OtherIncome,
		 isnull(('+@SqlTaxTotal+'),0) as Taxs,
		isnull(('+@SqlLaborTotal+'),0) as LaborTotal,
		isnull(('+@SqlChecksCount+'),0) as  ChecksCount,
		isnull(('+@SqlGuestCount+'),0) as GuestCount
  from #tempOrderLineItem oli inner join [#order] OD on OD.ID=oli.OrderID and OD.StoreID=oli.StoreID
  and OD.BusinessDate=oli.BusinessDate
  inner join store s on OD.StoreID =s.ID '+@WhereSql
  
  --  select @SqlAll
exec sp_sqlexec @SqlAll


GO
