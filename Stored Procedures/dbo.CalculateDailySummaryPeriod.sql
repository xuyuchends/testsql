SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[CalculateDailySummaryPeriod]
(
	@BeginTime datetime,
	@endTime datetime,
	@storeID int
)
as
begin
set nocount on
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#tempOrderLineItem') and type='U')
drop table #tempOrderLineItem
create table #tempOrderLineItem 
(
StoreID int null,
RecordType nvarchar(50) COLLATE DATABASE_DEFAULT,
[Qty] decimal(10,4),
[AdjustedPrice] money,
[Price] money,
[OrderID] bigint,
[ItemID] int,
[SI] nvarchar(3) COLLATE DATABASE_DEFAULT,
[ParentSplitLineNum] int,
[AdjustID] int,
[NumSplits] smallint,
[BusinessDate] datetime,
[TaxCat] nvarchar(1) null
)
CREATE CLUSTERED INDEX index1 ON #tempOrderLineItem
(
	[BusinessDate] DESC,
	[StoreID] ASC
)

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#tempOrder') and type='U')
drop table #tempOrder
create table #tempOrder 
(
[StoreID] int,
SaleGroup nvarchar(50) COLLATE DATABASE_DEFAULT,
[ID] bigint,
[RevenueCenter] nvarchar(50) COLLATE DATABASE_DEFAULT,
[Status] nvarchar(50) COLLATE DATABASE_DEFAULT,
[OpenTime] datetime,
[GuestCount] int,
[FutureOrder] char(1) COLLATE DATABASE_DEFAULT,
[BusinessDate] datetime
)
CREATE CLUSTERED INDEX index2 ON #tempOrder
(
	[BusinessDate] DESC,
	[StoreID] ASC
)

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#tempPaidOutTrx') and type='U')
drop table #tempPaidOutTrx
create table #tempPaidOutTrx
(
[StoreID] int,
[Amount] money,
[Status] nvarchar(50) COLLATE DATABASE_DEFAULT,
[BusinessDate] datetime
)
CREATE CLUSTERED INDEX index3 ON #tempPaidOutTrx
(
	[BusinessDate] DESC,
	[StoreID] ASC
)

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#tempPaidInTrx') and type='U')
drop table #tempPaidInTrx
create table #tempPaidInTrx 
(
[StoreID] int,
[Amount] money,
[Status] nvarchar(50) COLLATE DATABASE_DEFAULT,
[BusinessDate] datetime
)
CREATE CLUSTERED INDEX index4 ON #tempPaidInTrx
(
	[BusinessDate] DESC,
	[StoreID] ASC
)

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#tempPayment') and type='U')
drop table #tempPayment
create table #tempPayment
(
	[StoreID] int,
	[CheckID] bigint,
	[Amount] money,
	[Tip] money,
	[Gratuity] money,
	[AmountReceived] money,
	[MethodID] nvarchar(50) COLLATE DATABASE_DEFAULT,
	[Status] nvarchar(50) COLLATE DATABASE_DEFAULT,
	[BusinessDate] datetime
)
CREATE CLUSTERED INDEX index5 ON #tempPayment
(
	[BusinessDate] DESC,
	[StoreID] ASC
)
create nonclustered index tempPayment_index on #tempPayment
(
MethodID ASC
)

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#tempCheck') and type='U')
drop table #tempCheck
create table #tempCheck
(
	[StoreID] int,
	[OrderID] bigint,
	[ID] bigint,
	[FutureOrderAdvPayment] char(1) COLLATE DATABASE_DEFAULT,
	[BusinessDate] datetime
)
CREATE CLUSTERED INDEX index6 ON #tempCheck
(
	[BusinessDate] DESC,
	[StoreID] ASC
)


if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#tempTax') and type='U')
drop table #tempTax
create table #tempTax
(
	[StoreID] int,
	[Category] nvarchar(50) COLLATE DATABASE_DEFAULT,
	[TaxAmt] decimal(19,10),
	[TaxCategoryID] int,
	[OrderID] bigint,
	[TaxOrderAmt] decimal(19,10),
	[BusinessDate] datetime
)
CREATE CLUSTERED INDEX index7 ON #tempTax
(
	[BusinessDate] DESC,
	[StoreID] ASC
)

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#temptemp') and type='U')
drop table #temptemp
create table #temptemp
(
	StoreID int,
	SaleGroup nvarchar(20),
	RecordType nvarchar(50) ,
	value decimal(18,4),
	[BusinessDate] datetime
)
CREATE CLUSTERED INDEX index8 ON #temptemp
(
	[BusinessDate] DESC,
	[StoreID] ASC
)

insert into #tempOrderLineItem 
	SELECT StoreID,RecordType,Qty,AdjustedPrice,Price,OrderID,ItemID,SI,ParentSplitLineNum,AdjustID,NumSplits,BusinessDate,TaxCat 
	FROM [orderlineitem] where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID and status='CLOSE'
	union all
	SELECT StoreID,RecordType,Qty,AdjustedPrice,Price,OrderID,ItemID,SI,ParentSplitLineNum,AdjustID,NumSplits,BusinessDate ,TaxCat 
	FROM OrderLineItemArchive where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID and status='CLOSE'	

insert into #tempOrder
	SELECT StoreID,isnull((select  Name from MealPeriod where StoreID=o.StoreID  
			and (case when		
				(EndTime>beginTime and (OpenTime between CONVERT(nvarchar(20), OpenTime,102)+' '+ CONVERT(nvarchar(20), beginTime,8) 
				and CONVERT(nvarchar(20), OpenTime,102) +' '+ CONVERT(nvarchar(20), EndTime,8)) ) 

			or (EndTime< beginTime and OpenTime between CONVERT(nvarchar(20), OpenTime,102)+' '+ CONVERT(nvarchar(20), BeginTime,8) 
			and CONVERT(nvarchar(20), OpenTime,102)+' 23:59:59') 
			or 
			(EndTime< beginTime and OpenTime between CONVERT(nvarchar(20), OpenTime,102)+' 00:00:00' 
			and CONVERT(nvarchar(20), OpenTime,102)+' '+CONVERT(nvarchar(20), EndTime,8)) 

			then 1 end )=1 
			 and DATEPART(WEEKDAY,OpenTime)=
			(case when [DayOfWeek]='SUNDAY' then 1
			when [DayOfWeek]='MONDAY' then 2
			when [DayOfWeek]='TUESDAY' then 3
			when [DayOfWeek]='WEDNESDAY' then 4
			when [DayOfWeek]='THURSDAY' then 5
			when [DayOfWeek]='FRIDAY' then 6
			when [DayOfWeek]='SATURDAY' then 7 end)),o.MealPeriod)  as SaleGroup,ID,RevenueCenter,Status,OpenTime,GuestCount,FutureOrder,BusinessDate
	FROM [Order] o where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID and status='CLOSE'
	union all
	SELECT StoreID,isnull((select  Name from MealPeriod where StoreID=o.StoreID  
			and (case when		
				(EndTime>beginTime and (OpenTime between CONVERT(nvarchar(20), OpenTime,102)+' '+ CONVERT(nvarchar(20), beginTime,8) 
				and CONVERT(nvarchar(20), OpenTime,102) +' '+ CONVERT(nvarchar(20), EndTime,8)) ) 

			or (EndTime< beginTime and OpenTime between CONVERT(nvarchar(20), OpenTime,102)+' '+ CONVERT(nvarchar(20), BeginTime,8) 
			and CONVERT(nvarchar(20), OpenTime,102)+' 23:59:59') 
			or 
			(EndTime< beginTime and OpenTime between CONVERT(nvarchar(20), OpenTime,102)+' 00:00:00' 
			and CONVERT(nvarchar(20), OpenTime,102)+' '+CONVERT(nvarchar(20), EndTime,8)) 

			then 1 end )=1 
			 and DATEPART(WEEKDAY,OpenTime)=
			(case when [DayOfWeek]='SUNDAY' then 1
			when [DayOfWeek]='MONDAY' then 2
			when [DayOfWeek]='TUESDAY' then 3
			when [DayOfWeek]='WEDNESDAY' then 4
			when [DayOfWeek]='THURSDAY' then 5
			when [DayOfWeek]='FRIDAY' then 6
			when [DayOfWeek]='SATURDAY' then 7 end)),o.MealPeriod)  as SaleGroup,ID,RevenueCenter,Status,OpenTime,GuestCount,FutureOrder,BusinessDate
	FROM OrderArchive o where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID and status='CLOSE'	


insert into #tempPaidOutTrx
	SELECT StoreID,Amount,Status, BusinessDate
	FROM [PaidOutTrx]  where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID 
	union all
	SELECT StoreID,Amount,Status, BusinessDate
	FROM PaidOutTrxArchive where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID 


insert into #tempPaidInTrx
	SELECT StoreID,Amount,Status, BusinessDate
	FROM [PaidInTrx]  where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID 
	union all
	SELECT StoreID,Amount,Status, BusinessDate
	FROM PaidInTrxArchive where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID 	

insert into #tempPayment
	SELECT StoreID,CheckID,Amount,Tip,Gratuity,AmountReceived,MethodID,Status,BusinessDate
	FROM [Payment]  where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID and status='CLOSED'
	union all
	SELECT StoreID,CheckID,Amount,Tip,Gratuity,AmountReceived,MethodID,Status,BusinessDate
	FROM PaymentArchive where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID and status='CLOSED'	
	

insert into #tempCheck
	SELECT StoreID,OrderID,ID,FutureOrderAdvPayment,BusinessDate
	FROM [Check]  where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID  and status='CLOSED'
	union all
	SELECT StoreID,OrderID,ID,FutureOrderAdvPayment,BusinessDate
	FROM CheckArchive where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID and status='CLOSED'	



insert into #tempTax
	SELECT StoreID,Category,TaxAmt,TaxCategoryID,OrderID,TaxOrderAmt,BusinessDate
	FROM Tax  where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID and Status='VALID'
	union all
	SELECT StoreID,Category,TaxAmt,TaxCategoryID,OrderID,TaxOrderAmt,BusinessDate
	FROM TaxArchive where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID and Status='VALID'


	insert into #temptemp select StoreID, SaleGroup,RecordType,ISNULL(sum(ISNULL(value,0)),0) as value,BusinessDate   from
	(
	Select StoreID, SaleGroup,'Number Tables Served' as RecordType,count(o.ID) as value  ,o.BusinessDate
	 from #tempOrder as o 
	where o.status<>'TRANSFERRED' Group by o.openTime,o.StoreID,o.BusinessDate,o.SaleGroup
	union all 
	Select StoreID,SaleGroup,'Number Guest Served' as RecordType,ISNULL(sum(ISNULL(o.GuestCount,0)),0) as value
	,o.BusinessDate
	From  #tempOrder  as o  where o.status<>'TRANSFERRED' 
	Group by o.openTime,o.StoreID,o.BusinessDate,o.SaleGroup
	union all
	Select o.StoreID,SaleGroup, 'Number Checks' as RecordType, COUNT(p.CheckID) AS value,O.BusinessDate  
	From  #tempOrder  as O 
	inner JOIN  #tempCheck  as c ON O.id = c.orderid and o.StoreID=c.StoreID and O.BusinessDate=c.BusinessDate
	inner JOIN  #tempPayment  as p ON p.CheckID = c.ID and o.StoreID=p.StoreID and c.BusinessDate=p.BusinessDate
	where o.status<>'TRANSFERRED' 
	Group by o.openTime,o.StoreID ,o.BusinessDate,o.SaleGroup
	union all 
	Select o.StoreID,SaleGroup, 'ProfitTotal' as RecordType, sum (oi.Qty* (case when oi.RecordType<>'RETURN' then oi.Price-oi.AdjustedPrice else oi.Price end ) ) as value   ,o.BusinessDate
	From  #tempOrder  as O 
	inner JOIN  #tempOrderLineItem  OI ON O.ID = OI.orderid and o.StoreID= OI.StoreID and O.BusinessDate=OI.BusinessDate where o.status<>'TRANSFERRED' 
	Group by o.openTime,o.StoreID,o.BusinessDate,o.SaleGroup
	)  as tabel1 group by SaleGroup,RecordType,BusinessDate ,StoreID

declare @BusinessDate datetime
declare cur cursor 
for select distinct businessDate from #tempOrder order by businessDate desc
open cur
fetch next from cur into @BusinessDate
while (@@FETCH_STATUS=0)
begin

	--Rpt_DepartmentSalesAll
	delete from DailyDepartmentSales where BusinessDate=@BusinessDate and StoreID=@StoreID
	insert into DailyDepartmentSales
	select @storeid,Department,'','',
	isnull(SUM(isnull(GrossSales,0)),0) as  GrossSales,
	isnull(SUM(isnull(Voids,0)),0) Voids,
	isnull(SUM(isnull(Comps,0)),0) Comps,
	isnull(SUM(isnull(Discount,0)),0) Discount ,
	@BusinessDate,GETDATE(),
	isnull(SUM(isnull(returns,0)),0) returns 
	from(SELECT MI.ReportDepartment as Department, 
	isnull(SUM(OI.Qty * OI.Price),0) AS GrossSales, 
	isnull(SUM(isnull(CASE WHEN OI.RecordType='VOID' THEN OI.qty * OI.AdjustedPrice END,0)),0) AS Voids, 
	isnull(SUM(isnull(CASE WHEN OI.RecordType='COMP' THEN OI.qty * OI.AdjustedPrice END,0)),0) AS Comps, 
	isnull(SUM(isnull(CASE WHEN OI.RecordType in ('DISCOUNT','COUPON')  THEN OI.qty * OI.AdjustedPrice END,0)),0) AS Discount,
	isnull(SUM(isnull(CASE WHEN OI.RecordType='RETURN'  THEN OI.qty * OI.AdjustedPrice END,0)),0) AS returns
	FROM (select RecordType,Qty,AdjustedPrice,Price,OrderID,StoreID,ItemID,SI,BusinessDate from #tempOrderLineItem where BusinessDate=@BusinessDate) AS OI 
	INNER JOIN (select StoreID,SaleGroup,ID,BusinessDate  from #tempOrder where BusinessDate=@BusinessDate) AS O 
		ON OI.OrderID = O.ID AND O.StoreID = OI.StoreID and OI.BusinessDate=O.BusinessDate
	INNER JOIN MenuItem AS MI 
		ON OI.ItemID = MI.ID AND MI.ReportDepartment <> 'MODIFIER'  AND MI.StoreID = O.StoreID
	WHERE MI.MIType NOT IN ('GC', 'IHPYMNT')
	GROUP BY O.SaleGroup, MI.ReportDepartment, OI.RecordType with rollup
	having GROUPING(O.SaleGroup)=0
	and GROUPING( MI.ReportDepartment)=0
	and GROUPING(OI.RecordType) =1) as tab group by Department
	
	
	--tax
	delete from DailyTaxSummary where BusinessDate=@BusinessDate and StoreID=@StoreID
	insert into DailyTaxSummary
	Select @storeID,tc.Name as TaxName, isnull(SUM(ISNULL(t.TaxAmt,0)),0) as TaxAmt, SUM(ISNULL(t.TaxOrderAmt,0)) as OrderAmt,@BusinessDate,GETDATE()
			From (select TaxCategoryID,Category,StoreID,TaxOrderAmt,TaxAmt  from #tempTax where businessDate= @BusinessDate) as t inner JOIN TaxCategory tc 
				ON t.TaxCategoryID = tc.ID and t.Category COLLATE SQL_Latin1_General_CP1_CI_AS=tc.Category and tc.StoreID= t.StoreID
	Where  t.Category = 'TAX' 
	Group By tc.Name
	--paymentSummary
	delete from DailyPaymentSummary where BusinessDate=@BusinessDate  and StoreID=@StoreID
	insert into DailyPaymentSummary
	SELECT @storeid,pm.Name as PaymentName, 
	isnull(COUNT(isnull(p.CheckID,0)),0) AS numPayments, 
	isnull(SUM(isnull(p.Amount,0)),0) AS sales, 
	isnull(SUM(isnull(p.Tip,0)),0) AS TipTotal, 
	isnull(SUM(isnull(p.Gratuity,0)),0) AS TtlSrvCharge, 
	isnull(SUM(isnull(p.AmountReceived,0)),0) AS TtlReceived,@BusinessDate,GETDATE()
	FROM (select ID,StoreID from #tempOrder where businessDate= @BusinessDate) AS O
	INNER JOIN (select OrderID,ID,StoreID from #tempCheck where businessDate= @BusinessDate) AS c ON O.ID = c.OrderID AND O.StoreID = c.StoreID 
	INNER JOIN (select CheckID,Amount,Tip,Gratuity,AmountReceived,StoreID,MethodID from #tempPayment where businessDate= @BusinessDate and Status='CLOSED') AS p ON p.CheckID = c.ID AND O.StoreID = p.StoreID 
	INNER JOIN PaymentMethod AS pm ON p.MethodID = pm.Name AND pm.StoreID = O.StoreID
	GROUP BY pm.Name
	
	--CategorySummaryByPeriod
	delete from DailyCategorySummaryByPeriod where BusinessDate=@BusinessDate  and StoreID=@StoreID
	insert into DailyCategorySummaryByPeriod
	Select o.storeid as storeID, MI.ReportCategory as Category, 
	isnull(sum(isnull(CASE WHEN OI.parentsplitLineNum = 0 THEN OI.qty ELSE (convert(real,OI.qty)/convert(real,OI.numsplits)) END,0)),0)  as TtlQty, 
	isnull(sum(case when oi.RecordType<>'RETURN' then isnull(OI.qty * (OI.price-OI.adjustedPrice),0) else isnull(oi.Qty* OI.AdjustedPrice,0) end),0) as AdjustTotal,
	SaleGroup,
	@BusinessDate,GETDATE()
	From (select qty,price,AdjustedPrice,parentsplitLineNum,itemid,recordType,SI,orderid,numsplits,StoreID,TaxCat from #tempOrderLineItem where BusinessDate=@BusinessDate) as OI 
	inner JOIN (select storeid,SaleGroup,ID from #tempOrder where BusinessDate=@BusinessDate) as O ON OI.orderid = O.ID and OI.StoreID=O.StoreID
	LEFT JOIN MenuItem MI ON OI.itemid = MI.ID and o.StoreID=MI.StoreID
	Where si <> 'N/A' AND MI.ReportCategory <> '' AND MI.ReportCategory IS NOT NULL and oi.recordType<>'VOID' and oi.TaxCat<>'C'
	group by o.storeid,MI.ReportCategory,O.SaleGroup

	--CategorySummaryByPC
	delete from DailyCategorySummaryByPC where BusinessDate=@BusinessDate  and StoreID=@StoreID
	insert into DailyCategorySummaryByPC
	Select @StoreID,o.RevenueCenter, 
	MI.ReportCategory,
	isnull(sum(case when oi.RecordType<>'RETURN' then isnull(OI.qty * (OI.price-OI.adjustedPrice),0) else isnull(oi.Qty* OI.AdjustedPrice,0) end),0) as CatTotal
	,@BusinessDate,GETDATE()
	From (select orderid,StoreID,qty,price,AdjustedPrice,itemid,SI,RecordType,TaxCat from #tempOrderLineItem
	where BusinessDate=@BusinessDate) as OI 
	inner JOIN (select RevenueCenter,StoreID,ID from #tempOrder where BusinessDate=@BusinessDate)as O ON OI.orderid = O.ID
	and OI.StoreID=O.StoreID
	LEFT JOIN MenuItem MI ON OI.itemid = MI.ID AND MI.ReportCategory <> '' AND MI.ReportCategory IS NOT NULL
	and O.StoreID=MI.StoreID
	Where si <> 'N/A' and OI.RecordType<>'VOID' and oi.TaxCat<>'C'
	Group By o.RevenueCenter, MI.ReportCategory
		--AdjustedSummary
	delete from DailyAdjustmentSummary where BusinessDate=@BusinessDate  and StoreID=@StoreID
	insert into DailyAdjustmentSummary
	select StoreID,RecordType,AdjustedName,Total,count,BusinessDate,GETDATE()  from
	(select @StoreID StoreID,'VOID' RecordType, v.Name as AdjustedName,sum(oli.qty * oli.AdjustedPrice) as Total,COUNT(*) as  count,@BusinessDate BusinessDate
	from (select qty,AdjustedPrice,AdjustID,storeid,RecordType,itemid from #tempOrderLineItem
	where BusinessDate=@BusinessDate) as oli inner join Void as v on oli.AdjustID=v.ID and oli.StoreID=v.StoreID			
	LEFT outer JOIN menuItem MI ON MI.ID = oli.itemid and mi.StoreID=oli.StoreID
	where oli.RecordType = 'VOID' AND MI.MIType <>'IHPYMNT'
	group by v.Name
	union all
	select @StoreID,'COMP', v.Name as AdjustedName,sum(oli.qty * oli.AdjustedPrice) as Total,COUNT(*) as  count,@BusinessDate
	from (select qty,AdjustedPrice,AdjustID,storeid,RecordType,itemid from #tempOrderLineItem
	where BusinessDate=@BusinessDate) as oli inner join Comp as v on oli.AdjustID=v.ID and oli.StoreID=v.StoreID			
	LEFT outer JOIN menuItem MI ON MI.ID = oli.itemid and mi.StoreID=oli.StoreID
	where oli.RecordType = 'COMP' AND MI.MIType <>'IHPYMNT'
	group by v.Name
	union all 
	select @StoreID,'DISCOUNT', v.Name as AdjustedName,sum(oli.qty * oli.AdjustedPrice) as Total,COUNT(*) as  count,@BusinessDate
	from (select qty,AdjustedPrice,AdjustID,storeid,RecordType,itemid from #tempOrderLineItem
	where BusinessDate=@BusinessDate) as oli inner join Discount as v on oli.AdjustID=v.ID and oli.StoreID=v.StoreID			
	LEFT outer JOIN menuItem MI ON MI.ID = oli.itemid and mi.StoreID=oli.StoreID
	where oli.RecordType ='DISCOUNT' AND MI.MIType <>'IHPYMNT'
	group by v.Name
	union all 
	select @StoreID,'DISCOUNT', v.Name as AdjustedName,sum(oli.qty * oli.AdjustedPrice) as Total,COUNT(*) as  count,@BusinessDate
	from (select qty,AdjustedPrice,AdjustID,storeid,RecordType,itemid from #tempOrderLineItem
	where BusinessDate=@BusinessDate) as oli inner join Coupon as v on oli.AdjustID=v.ID and oli.StoreID=v.StoreID			
	LEFT outer JOIN menuItem MI ON MI.ID = oli.itemid and mi.StoreID=oli.StoreID
	where oli.RecordType ='COUPON' AND MI.MIType <>'IHPYMNT'
	group by v.Name
	union all
	select @StoreID,'RETURN', v.Name as AdjustedName,abs(sum(oli.qty * oli.Price)) as Total,sum(abs(oli.qty)) as  count,@BusinessDate
	from (select qty,Price,AdjustID,storeid,RecordType,itemid from #tempOrderLineItem
	where BusinessDate=@BusinessDate) as oli inner join [return] as v on oli.AdjustID=v.ID and oli.StoreID=v.StoreID			
	LEFT outer JOIN menuItem MI ON MI.ID = oli.itemid and mi.StoreID=oli.StoreID
	where oli.RecordType ='RETURN' AND MI.MIType <>'IHPYMNT' and Qty<0
	group by v.Name
	) b
	--GuestTableSummaryByPC
	delete from DailyGuestTableSummaryByPC where BusinessDate=@BusinessDate  and StoreID=@StoreID
	insert into DailyGuestTableSummaryByPC
	Select @StoreID, RevenueCenterName, isnull(SUM(isnull(NumTables,0)),0) as NumTables, 
	isnull(SUM(isnull(NumGuest,0)),0) as NumGuest, isnull(SUM(isnull(NumChecks,0)),0) as NumChecks, 
	isnull(SUM(isnull(ProfitTotal,0)),0) as ProfitTotal,@BusinessDate,GETDATE() from 
	(
	 select RevenueCenter as RevenueCenterName,count(ID) as NumTables ,isnull(SUM(isnull(GuestCount,0)),0)  as NumGuest,NULL AS NumChecks, NULL AS ProfitTotal from #tempOrder WHERE businessDate=@BusinessDate
	 and status<>'TRANSFERRED' Group by RevenueCenter
	UNION 
	Select o.RevenueCenter as RevenueCenterName,NULL AS NumTables, NULL AS NumGuest,
	COUNT(p.CheckID) AS NumChecks, NULL as ProfitTotal
	From (select RevenueCenter,StoreID,ID,status from #tempOrder WHERE businessDate=@BusinessDate) as  O
	inner JOIN (select ID,StoreID,orderid  from #tempCheck WHERE businessDate=@BusinessDate) as c ON O.ID = c.orderid and O.StoreID=c.StoreID
	inner JOIN (select CheckID,StoreID  from #tempPayment WHERE businessDate=@BusinessDate) as p ON p.CheckID = c.ID and c.StoreID=p.StoreID 
	where status<>'TRANSFERRED'
	Group by o.RevenueCenter
	UNION
	Select o.RevenueCenter as RevenueCenterName, NULL AS NumTables, NULL AS NumGuest,
	NULL AS NumChecks,  SUM (Qty* (case when RecordType<>'RETURN' then Price-AdjustedPrice else Price end ) ) as ProfitTotal 
	From (select RevenueCenter,ID,StoreID,status  from #tempOrder WHERE businessDate=@BusinessDate) as O
	inner JOIN (select orderid,StoreID,qty,price,AdjustedPrice,RecordType  from #tempOrderLineItem WHERE businessDate=@BusinessDate
	) as OI ON O.ID = OI.orderid  and O.StoreID=OI.StoreID where o.status<>'TRANSFERRED'
	 Group by o.RevenueCenter

	) as table1
	Group by RevenueCenterName
	--GuestTableSummaryByPeriod
	
	declare @saleGroup nvarchar(20)  
	declare @RecordType nvarchar(20)  
	declare @value decimal(10,2)   
	declare @GuestValue decimal(10,2)  
	declare @CheckValue decimal(10,2)  
	declare @PPA decimal (10,2)  
	declare @PCA decimal (10,2)    

	insert into #temptemp select t.StoreID, t.salegroup,'PPA',
	case when isnull(value,0)=0 then 0 else 
	(select value from #temptemp where recordType='ProfitTotal'  and salegroup=t.salegroup and BusinessDate=t.BusinessDate)/value end as PPA,
	t.BusinessDate from #temptemp t where RecordType='Number Guest Served' and t.BusinessDate=@BusinessDate and t.StoreID=@storeID
	insert into #temptemp select t.StoreID, t.salegroup,'PCA',
	case when isnull(value,0)=0 then 0 else
	(select value from #temptemp where recordType='ProfitTotal'  and salegroup=t.salegroup and BusinessDate=t.BusinessDate)/value end as PCA,
	t.BusinessDate from #temptemp t where RecordType='Number Checks' and t.BusinessDate=@BusinessDate and t.StoreID=@storeID
	
	declare @NumberGuestServedTotal decimal(10,2)   
	declare @numCheckTotal decimal(10,2)   
	declare @ProfitTotal decimal(10,2) 
	declare @NumberTablesServed decimal(10,2)  
	if (select COUNT(*) from #temptemp)>0
	begin
		select @NumberGuestServedTotal=isnull(SUM(isnull(value,0)),0) from #temptemp where RecordType='Number Guest Served'  and businessDate=@BusinessDate and StoreID=@storeID
		select @numCheckTotal=isnull(SUM(isnull(value,0)),0) from #temptemp where RecordType='Number Checks'  and businessDate=@BusinessDate  and StoreID=@storeID
		select @NumberTablesServed=isnull(SUM(isnull(value,0)),0) from #temptemp where RecordType='Number Tables Served'  and businessDate=@BusinessDate  and StoreID=@storeID
		select @ProfitTotal=isnull(SUM(isnull(value,0)),0) from #temptemp where RecordType='ProfitTotal' and businessDate=@BusinessDate and StoreID=@storeID
		insert into #temptemp values(@storeID,'Total','Number Checks',@numCheckTotal,@BusinessDate) 
		insert into #temptemp values(@storeID,'Total','Number Guest Served',@NumberGuestServedTotal,@BusinessDate)  
		insert into #temptemp values(@storeID,'Total','Number Tables Served',@NumberTablesServed,@BusinessDate)  
		insert into #temptemp values(@storeID,'Total','PPA',case when ISNULL(@NumberGuestServedTotal,0)=0 then 0 else @ProfitTotal/@NumberGuestServedTotal end,@BusinessDate)  
		insert into #temptemp values(@storeID,'Total','PCA',case when ISNULL(@numCheckTotal,0)=0 then 0 else @ProfitTotal/@numCheckTotal end,@BusinessDate) 
	end
	delete from DailyGuestTableSummaryByPeriod where BusinessDate=@BusinessDate  and StoreID=@StoreID
	insert into DailyGuestTableSummaryByPeriod
	select StoreID,SaleGroup,RecordType,value,
	case salegroup when 'Lunch' then 1 when 'DINNER' then 2 when 'Total' then 999 else 3 end OrderCol ,BusinessDate,GETDATE() from #temptemp 
	where RecordType<>'ProfitTotal' and BusinessDate=@BusinessDate and StoreID=@storeID
	

	--DailySaleDetails


	--gcSales
declare @gcSales  decimal(18,2)
 Select @gcSales=isnull(SUM(ISNULL(oli.qty * (oli.price-AdjustedPrice),0)),0)
From (select qty,price,OrderID,StoreID,itemid,BusinessDate,RecordType,AdjustedPrice  from #tempOrderLineItem WHERE businessDate=@BusinessDate) as oli 
inner JOIN (select StoreId,BusinessDate,ID from #tempOrder WHERE businessDate=@BusinessDate) as  O ON oli.orderid = O.ID
		and o.StoreId=oli.StoreID
		AND O.BusinessDate=oli.BusinessDate
		JOIN MenuItem MI ON oli.itemid = MI.ID AND MI.MIType = 'GC'
		and MI.StoreId=o.StoreId
Where oli.RecordType <> 'VOID' and oli.RecordType <>'comp'  

--Paid Ins
declare @paidIn decimal(18,2)
Select @paidIn=isnull(SUM(ISNULL(Amount,0)),0) From (select Amount,Status  from #tempPaidInTrx WHERE businessDate=@BusinessDate) as PaidInTrx Where [status] = 'PAID_IN'

--In House Payment Sales
declare @InHousePaymentSales decimal(18,2)
Select @InHousePaymentSales =isnull(SUM(ISNULL(OI.qty * OI.price,0)),0)
From (select qty,price,RecordType,itemid,orderid,StoreID,BusinessDate  from #tempOrderLineItem WHERE businessDate=@BusinessDate) as OI
inner  JOIN (select StoreID,ID,BusinessDate  from #tempOrder WHERE businessDate=@BusinessDate) as O ON OI.orderid = O.ID and o.StoreId=OI.StoreID and o.BusinessDate=oi.BusinessDate
inner JOIN MenuItem MI ON OI.itemid = MI.ID AND MI.MIType = 'IHPYMNT' and MI.StoreId=o.StoreID
Where OI.RecordType <> 'VOID'

--Advance Payments
declare @advPayment decimal(18,2)
Select @advPayment=isnull(SUM(ISNULL(p.amount,0)),0) From (select Amount,CheckID,StoreID,BusinessDate from #tempPayment WHERE businessDate=@BusinessDate) as p 
inner JOIN (select ID,StoreId,FutureOrderAdvPayment,BusinessDate  from #tempCheck WHERE businessDate=@BusinessDate) as c ON p.CheckID = c.ID and c.StoreId=p.StoreID and p.BusinessDate=c.BusinessDate
Where c.FutureOrderAdvPayment = 'Y'

--Surcharge collected
declare @surchageamt decimal(18,2)
Select @surchageamt=isnull(Sum(ISNULL((case when ss.SurchargeGuestPays='Y' then TaxAmt else 0 end),0)),0)
From (select StoreID,Category,BusinessDate,TaxAmt,TaxCategoryID,OrderID from #tempTax WHERE businessDate=@BusinessDate) as  A JOIN TaxCategory B on a.TaxCategoryID = b.ID and B.Category='SUR' and  A.Category=B.Category 
	 inner JOIN (select  BusinessDate,ID,StoreID  from #tempOrder WHERE businessDate=@BusinessDate) as o ON a.OrderID = o.ID 
	AND a.BusinessDate = o.BusinessDate and a.StoreID= o.StoreID
	left outer join StoreSetting as ss on o.StoreID =ss.StoreID
--TotalPaidOut
declare @TotalPaidOut decimal(18,2)
Select @TotalPaidOut=isnull(SUM(ISNULL(pot.Amount,0)),0)  From 
 (select Amount  from #tempPaidOutTrx WHERE businessDate=@BusinessDate)  as pot

--Previous payments from future orders
declare @PaidAdv decimal(18,2)
 select @PaidAdv =isnull(SUM(ISNULL(p.amount,0) ),0)
 From (select Amount,CheckID,StoreID from #tempPayment WHERE businessDate=@BusinessDate) as p
  inner JOIN (select ID,StoreID,orderid from #tempCheck WHERE businessDate=@BusinessDate) as c ON p.CheckID = c.ID and p.StoreID=c.StoreID  
 inner JOIN (select FutureOrder,ID,StoreID from #tempOrder WHERE businessDate=@BusinessDate) as O ON c.orderid = O.ID  and O.StoreID=c.StoreID
 where O.FutureOrder = 'Y'	
--GetDriverReimbursement
declare @ReimbursementTtl decimal(18,2)
SELECT @ReimbursementTtl=isnull(SUM(isnull(ReimbursementTtl,0)),0)
FROM	DeliveryReimbursements
WHERE  status = 'CLOSED' and   BusinessDate =@BusinessDate
AND StoreID=@StoreID	
	
--GetTipWithheld
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

	SELECT	@ttlServiceCharge = isnull(sum(isnull(p.Gratuity,0)),0)
	FROM	(select  ID,StoreID  from #tempCheck WHERE businessDate=@BusinessDate) as c INNER JOIN 
			(select Status,CheckID,StoreID,Gratuity,MethodID from #tempPayment WHERE businessDate=@BusinessDate)  as p ON c.id = p.CheckID  and c.StoreID=p.StoreID
	WHERE   p.Status = 'CLOSED' and MethodID<>'CASH'
	SELECT	@totalCashSrvCharge = isnull(sum(isnull(p.Gratuity,0)),0)
	FROM    (select ID,StoreID from #tempCheck WHERE businessDate=@BusinessDate) as c INNER JOIN 
			(select Status,CheckID,StoreID,MethodID,Gratuity from #tempPayment WHERE businessDate=@BusinessDate)  as p ON c.ID =p.CheckID and c.StoreID=p.StoreID INNER JOIN 
			PaymentMethod  as pm ON p.MethodID = pm.Name and p.StoreID=pm.StoreID
	WHERE	 p.Status = 'CLOSED' AND pm.DisplayName = 'cash' 
	set @creditCardSrvCharge = @ttlServiceCharge - @totalCashSrvCharge
	if @creditCardSrvCharge < 0 
		BEGIN
			set @creditCardSrvCharge = 0
		END
	select @SrvChargeWithHeld = isnull(sum(isnull(@creditCardSrvCharge *ss.PercentWithheldTips,0)),0)
		From StoreSetting   as ss where ss.StoreID in (select * from dbo.f_split(@StoreID,','))
	SELECT @CCWithHeld = isnull(sum(isnull(dc.totalTip * ss.PercentWithheldTips,0)),0)
		From DailyCheckOuts as dc inner join  StoreSetting as ss on dc.StoreID=ss.StoreID
		WHERE(BusinessDate =@BusinessDate ) AND (Status = 'closed') and dc.StoreID in (select * from dbo.f_split(@StoreID,','))
	set @Tip_withheld = @CCWithHeld + @SrvChargeWithHeld 

	--GetCashDepositTotals
	declare @CashDeposit decimal(18,2)
	SELECT @CashDeposit=isnull(sum(isnull(CashDeposit,0) ),0)
	FROM     CashDepsits    
	where BusinessDate =@BusinessDate
	AND StoreID =@StoreID

	declare @GrossCash decimal(18,2)
	--------GrossCash
	select @GrossCash=isnull(SUM(isnull(p.Amount,0)),0)
	FROM (select ID,StoreID from #tempOrder) AS O
	INNER JOIN (select OrderID,ID,StoreID from #tempCheck where BusinessDate=@BusinessDate) AS c ON O.ID = c.OrderID AND O.StoreID = c.StoreID 
	INNER JOIN (select CheckID,Amount,StoreID,MethodID from #tempPayment where BusinessDate=@BusinessDate and MethodID='Cash' and Status='CLOSED') AS p ON p.CheckID = c.ID AND O.StoreID = p.StoreID
	
	declare @CCTipTtl decimal(18,2)
	declare @TtlSrvCharge decimal(18,2)
	------------CCTipTtl,
	------------TtlSrvCharge
	select @CCTipTtl= isnull(SUM(isnull(p.Tip,0)),0),@TtlSrvCharge=isnull(SUM(isnull(p.Gratuity,0)),0)
	FROM (select ID,StoreID from #tempOrder) AS O
	INNER JOIN (select OrderID,ID,StoreID from #tempCheck where BusinessDate=@BusinessDate) AS c ON O.ID = c.OrderID AND O.StoreID = c.StoreID 
	INNER JOIN (select CheckID,Tip,Gratuity,StoreID,MethodID from #tempPayment where BusinessDate=@BusinessDate) AS p ON p.CheckID = c.ID AND O.StoreID = p.StoreID
	where  p.MethodID not in('Cash')

	declare @GCChangeTTL decimal(18,2)
	---GCChangeTTL= TtlReceived-sales-TtlSrvCharge
	select @GCChangeTTL=isnull(SUM(isnull(p.AmountReceived,0)),0) -isnull(SUM(isnull(p.Amount,0)),0)-isnull(SUM(isnull(p.Gratuity,0)),0)
	FROM (select ID,StoreID from #tempOrder where BusinessDate=@BusinessDate) AS O
	INNER JOIN (select OrderID,ID,StoreID from #tempCheck where BusinessDate=@BusinessDate) AS c ON O.ID = c.OrderID AND O.StoreID = c.StoreID 
	INNER JOIN (select CheckID,Amount,Tip,Gratuity,AmountReceived,StoreID,MethodID from #tempPayment) AS p ON p.CheckID = c.ID AND O.StoreID = p.StoreID
	where  p.MethodID='GC'
	---OtherPayments
	declare @OtherPayments decimal(18,2)
	set @OtherPayments=@CCTipTtl+@TtlSrvCharge
	select @OtherPayments=@OtherPayments+ISNULL(sum(Sales),0) from DailyPaymentSummary where BusinessDate=@BusinessDate and StoreID=@storeID and PaymentName<>'CASH' 
	----NetCash
	declare @NetCash decimal(18,2)
	set @NetCash=@GrossCash-@CCTipTtl-@TtlSrvCharge-@GCChangeTTL+@PaidIn-@TotalPaidOut+@Tip_withheld-@ReimbursementTtl
	----CashOverShort
	declare @CashOverShort decimal(18,2)
	set @CashOverShort=@CashDeposit-@NetCash

	--NetSaleTotal
	declare @NetSaleTotal decimal(18,2)
	SELECT @NetSaleTotal=isnull(SUM(ISNULL(OI.Qty * (OI.Price-AdjustedPrice),0)) ,0)
FROM (select RecordType,Qty,AdjustedPrice,Price,OrderID,StoreID,ItemID,SI from #tempOrderLineItem where BusinessDate=@BusinessDate) AS OI 
INNER JOIN (select StoreID,SaleGroup,ID  from #tempOrder where BusinessDate=@BusinessDate) AS O 
	ON OI.OrderID = O.ID AND O.StoreID = OI.StoreID 
INNER JOIN MenuItem AS MI 
	ON OI.ItemID = MI.ID AND MI.ReportDepartment <> 'MODIFIER' AND MI.StoreID = O.StoreID
WHERE MI.MIType NOT IN ('GC', 'IHPYMNT') 

	--TaxTotal
	declare @TaxTotal decimal(18,2)
	Select @TaxTotal=isnull(SUM(ISNULL(t.TaxAmt,0)) ,0)
		From (select TaxAmt,TaxCategoryID,Category,StoreID  from #tempTax where businessDate= @BusinessDate) as t inner JOIN TaxCategory tc 
			ON t.TaxCategoryID = tc.ID and t.Category=tc.Category and tc.StoreID= t.StoreID
		Where  t.Category  = 'TAX'

	--CashSrvChargeTTL
	declare @CashSrvChargeTTL decimal(18,2)
	SELECT @CashSrvChargeTTL=isnull(SUM(ISNULL(p.Gratuity,0)),0) 
	FROM (select Gratuity,MethodID from #tempPayment where businessDate= @BusinessDate) AS p 
	where p.MethodID='CASH'
	--ReturnTotal
	declare @ReturnTotal decimal(18,2)
	SELECT @ReturnTotal=isnull(SUM(ISNULL(Total,0)),0) 
	FROM DailyAdjustmentSummary where BusinessDate = @BusinessDate   and StoreID=@storeID and AdjustType='RETURN'


delete from DailySaleDetails where BusinessDate=@BusinessDate and  StoreID=@StoreID
insert into DailySaleDetails values(@StoreID,@gcSales,@paidIn,@InHousePaymentSales,@advPayment,
@surchageamt,@TotalPaidOut,@PaidAdv,@ReimbursementTtl,@Tip_withheld,@CashDeposit,@GrossCash,
@CCTipTtl,@ttlServiceCharge,@GCChangeTTL,@NetCash,@OtherPayments,@CashOverShort, 
@BusinessDate,@NetSaleTotal,@TaxTotal,@CashSrvChargeTTL,GETDATE(),@ReturnTotal)

fetch next from cur into @BusinessDate
end
CLOSE cur
DEALLOCATE cur
end


GO
