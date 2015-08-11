SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE proc [dbo].[Rpt_KeyMetricsAll]
(
	@BeginDate datetime,
	@EndDate datetime,
	@StoreID nvarchar(20),
	@RevenueCenterID nvarchar(50),
	@MealPeriod nvarchar(10)
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

set @SqlVoid='select isnull(SUM(Qty*AdjustedPrice),0) from #tempOrderLineItem m inner join #order o on m.OrderID=o.ID 
and m.StoreID=o.StoreID and m.BusinessDate=o.BusinessDate  where RecordType=''VOID'' and m.BusinessDate=oli.BusinessDate and m.storeid=oli.StoreID'

set @SqlDiscount='select isnull(SUM(Qty*AdjustedPrice),0) from #tempOrderLineItem m inner join [#order] o on m.OrderID=o.ID 
and m.StoreID=o.StoreID and m.BusinessDate=o.BusinessDate where RecordType in (''DISCOUNT'',''COUPON'') and m.BusinessDate=oli.BusinessDate  and m.storeid=oli.StoreID'

set @SqlComp='select isnull(SUM(Qty*AdjustedPrice),0) from #tempOrderLineItem m inner join [#order] o on m.OrderID=o.ID 
and m.StoreID=o.StoreID and m.BusinessDate=o.BusinessDate where RecordType=''COMP'' and m.BusinessDate=oli.BusinessDate and m.storeid=oli.StoreID'

set @SqlGCSales='Select ISNULL(SUM(OI.qty * OI.price),0) as gcSales
From #tempOrderLineItem OI JOIN [#order] O ON OI.orderid = O.ID
		and o.StoreId=OI.StoreID and o.BusinessDate=OI.BusinessDate
		JOIN MenuItem MI ON OI.itemid = MI.ID 
		AND (MI.MIType = ''GC'' or MI.MIType = ''IHPYMNT'')
		and MI.StoreId=o.StoreId
Where OI.RecordType <> ''VOID'' and OI.BusinessDate=oli.BusinessDate and OI.storeid=oli.StoreID
		 '
		
set @SqlAdvancePayments='Select ISNULL(SUM(SD.amount),0) as advPayment
From #tempPayment SD JOIN #tempCheck SH ON SD.CheckID = SH.ID
		and SH.StoreId=SD.StoreID and SH.BusinessDate=SD.BusinessDate 
		inner join [#order] o on SH.OrderID =o.id and SH.StoreId =o.StoreId and SH.BusinessDate =o.BusinessDate 
Where  
SH.FutureOrderAdvPayment = ''Y'' 
and SD.BusinessDate =oli.BusinessDate and SD.storeid=oli.StoreID
'

set @SqlPaidIn = 'Select ISNULL(SUM(Amount),0) AS TotalPaidIn
From #tempPaidInTrx
Where BusinessDate =oli.BusinessDate AND Status = ''PAID_IN'' and storeid=oli.StoreID
'

set @SqlSurchargeTotals ='Select ISNULL(SUM(TaxAmt),0) as surchageamt    From #tempTax A JOIN TaxCategory B on a.TaxCategoryID = b.ID and B.Category=''SUR''
		 and  A.Category=B.Category    JOIN [#order] c ON a.OrderID = c.ID 
		 AND a.BusinessDate = c.BusinessDate and a.StoreID= c.StoreID where c.BusinessDate=oli.BusinessDate  and c.storeid=oli.StoreID'
	
set @SqlTaxTotal='Select ISNULL(SUM(TaxAmt),0) as surchageamt    From #tempTax A JOIN TaxCategory B on a.TaxCategoryID = b.ID and B.Category=''TAX''
		 and  A.Category=B.Category    JOIN [#order] c ON a.OrderID = c.ID 
		 AND a.BusinessDate = c.BusinessDate and a.StoreID= c.StoreID
		 where c.BusinessDate=oli.BusinessDate and c.storeid=oli.StoreID'	 
		 
set @SqlLaborTotal=' select isnull(SUM(ts.PayRate * ts.HoursWorked),0)+isnull(SUM(ts.OT1HoursWorked * 
ts.OT1Payrate+ts.OT2HoursWorked  * ts.OT2Payrate),0)as TotalPay from EmployeeTimeSheet as ts where 
ts.BusinessDate=oli.BusinessDate   and ts.storeid=oli.StoreID '

set @SqlChecksCount='select COUNT(*) from #tempCheck c inner join [#order] o on c.OrderID=o.ID and c.StoreID=o.StoreID 
and c.BusinessDate=o.BusinessDate 
where c.BusinessDate =oli.BusinessDate and c.storeid=oli.StoreID '

set @SqlGuestCount = 'select isnull(SUM(GuestCount),0) from [#order] o where o.BusinessDate =oli.BusinessDate  and o.storeid=oli.StoreID '
if ISNULL(@MealPeriod,'')<>''
begin
	set @SqlGCSales=@SqlGCSales+' and o.daypart='''+convert(varchar(20),@MealPeriod)+''''
	set @SqlAdvancePayments=@SqlAdvancePayments+' and o.daypart='''+convert(varchar(20),@MealPeriod)+''''
	set @SqlSurchargeTotals=@SqlSurchargeTotals+' and C.daypart='''+convert(varchar(20),@MealPeriod)+''''
	set @SqlTaxTotal=@SqlTaxTotal+' and C.daypart='''+convert(varchar(20),@MealPeriod)+''''
	
	set @SqlLaborTotal=' select SUM(ts.PayRate * (dbo.fn_GetLaborHours(StoreID,EmployeeID,'''+convert(varchar(20),@MealPeriod)+''',businessDate,TimeIn)))+SUM(ts.OT1HoursWorked * ts.OT1Payrate+ts.OT2HoursWorked  * ts.OT2Payrate)as TotalPay from EmployeeTimeSheet as ts where ts.BusinessDate=oli.BusinessDate'
	
	set @SqlChecksCount=@SqlChecksCount+' and o.daypart='''+convert(varchar(20),@MealPeriod)+''''
	set @SqlGuestCount=@SqlGuestCount+' and o.daypart='''+convert(varchar(20),@MealPeriod)+''''
	set @WhereSql=@WhereSql+' and OD.daypart='''+convert(varchar(20),@MealPeriod)+''''
	set @SqlDiscount=@SqlDiscount+' and o.daypart='''+convert(varchar(20),@MealPeriod)+''''
	set @SqlVoid=@SqlVoid+' and o.daypart='''+convert(varchar(20),@MealPeriod)+''''
	set @SqlComp=@SqlComp+' and o.daypart='''+convert(varchar(20),@MealPeriod)+''''
end

--if ISNULL(@StoreID,'')<>''
--begin
--	set @SqlGCSales=@SqlGCSales+' and OI.StoreID in ('+@StoreID+')'
--	set @SqlAdvancePayments=@SqlAdvancePayments+' and SH.StoreId in ('+@StoreID+')'
--	set @SqlPaidIn=@SqlPaidIn+'and StoreId in ('+@StoreID+')'
--	set @SqlSurchargeTotals=@SqlSurchargeTotals+' and A.StoreID in ('+@StoreID+')'
--	set @SqlTaxTotal=@SqlTaxTotal+' and A.StoreID in ('+@StoreID+')'
--	set @SqlLaborTotal=@SqlLaborTotal+' and ts.StoreID in ('+@StoreID+')'
--	set @SqlChecksCount=@SqlChecksCount+' and c.StoreID in ('+@StoreID+')'
--	set @SqlGuestCount=@SqlGuestCount+' and o.StoreID in ('+@StoreID+')'
--	set @WhereSql = @WhereSql+' and oli.StoreID in ('+@StoreID+')'
--	set @SqlDiscount=@SqlDiscount+' and m.StoreID in ('+@StoreID+')'
--	set @SqlVoid=@SqlVoid+' and m.StoreID in ('+@StoreID+')'
--	set @SqlComp=@SqlComp+' and m.StoreID in ('+@StoreID+')'
--end

if ISNULL(@RevenueCenterID,'')<>''
begin
	set @SqlGCSales=@SqlGCSales+' and o.RevenueCenter= '''+@RevenueCenterID+''''
	set @SqlAdvancePayments=@SqlAdvancePayments+'  and o.RevenueCenter= '''+@RevenueCenterID+''''
	set @SqlSurchargeTotals=@SqlSurchargeTotals+' and c.RevenueCenter= '''+@RevenueCenterID+''''
	set @SqlTaxTotal=@SqlTaxTotal+' and c.RevenueCenter= '''+@RevenueCenterID+''''
	set @SqlChecksCount=@SqlChecksCount+' and o.RevenueCenter= '''+@RevenueCenterID+''''
	set @SqlGuestCount=@SqlGuestCount+' and o.RevenueCenter= '''+@RevenueCenterID+''''
	set @WhereSql= @WhereSql+' and OD.RevenueCenter= '''+@RevenueCenterID+''''
	set @SqlDiscount=@SqlDiscount+' and o.RevenueCenter= '''+@RevenueCenterID+''''
	set @SqlVoid=@SqlVoid+' and o.RevenueCenter= '''+@RevenueCenterID+''''
	set @SqlComp=@SqlComp+' and o.RevenueCenter= '''+@RevenueCenterID+''''
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

select isnull(sum(oli.Qty*oli.Price),0) as Sales, oli.BusinessDate,
			oli.storeID,
			s.StoreName,
		 ('+@SqlDiscount+') as Discount,
		 ('+@SqlComp+') as Comp,
		 ('+@SqlVoid+') as Void,
		 (('+@SqlGCSales+')+('+@SqlAdvancePayments+')+('+@SqlPaidIn+')+('+@SqlSurchargeTotals+')) as OtherIncome,
		 ('+@SqlTaxTotal+') as Taxs,
		('+@SqlLaborTotal+') as LaborTotal,
		('+@SqlChecksCount+') as  ChecksCount,
		('+@SqlGuestCount+') as GuestCount
		
  from #tempOrderLineItem oli inner join [#order] OD on OD.ID=oli.OrderID and OD.StoreID=oli.StoreID
  and OD.BusinessDate=oli.BusinessDate
  inner join store s on OD.StoreID =s.ID  
  group by 
  oli.BusinessDate,oli.StoreID,s.StoreName 
    '
  
--select @SqlAll
    exec sp_sqlexec @SqlAll
   
   
GO
