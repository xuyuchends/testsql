SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[DCS_DailySummary_Compare]
(
	@BusinessDate datetime,
	@storeID int
)
as
begin
set nocount on

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#temptemp') and type='U')
drop table #temptemp
create table #temptemp
(
	SaleGroup nvarchar(20),
	RecordType nvarchar(50) ,
	value decimal(18,2),
	[BusinessDate] datetime
)
CREATE CLUSTERED INDEX index8 ON #temptemp
(
	[BusinessDate] DESC
)

--delete from DailyAdjustmentSummary where StoreID=@storeID and BusinessDate between @BeginTime and @endTime
--delete from DailyCategorySummaryByPC where StoreID=@storeID and BusinessDate between @BeginTime and @endTime
--delete from DailyCategorySummaryByPeriod where StoreID=@storeID and BusinessDate between @BeginTime and @endTime
--delete from DailyDepartmentSales where StoreID=@storeID and BusinessDate between @BeginTime and @endTime
--delete from DailyGuestTableSummaryByPC where StoreID=@storeID and BusinessDate between @BeginTime and @endTime
--delete from DailyGuestTableSummaryByPeriod where StoreID=@storeID and BusinessDate between @BeginTime and @endTime
--delete from DailyPaymentSummary where StoreID=@storeID and BusinessDate between @BeginTime and @endTime
--delete from DailySaleDetails where StoreID=@storeID and BusinessDate between @BeginTime and @endTime
--delete from DailyTaxSummary where StoreID=@storeID and BusinessDate between @BeginTime and @endTime

--insert into #tempOrderLineItem 
--	SELECT StoreID,RecordType,Qty,AdjustedPrice,Price,OrderID,ItemID,SI,ParentSplitLineNum,AdjustID,NumSplits,BusinessDate 
--	FROM [orderlineitem] where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID and status='CLOSE'
--	union all
--	SELECT StoreID,RecordType,Qty,AdjustedPrice,Price,OrderID,ItemID,SI,ParentSplitLineNum,AdjustID,NumSplits,BusinessDate 
--	FROM OrderLineItemArchive where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID and status='CLOSE'	

--insert into #tempOrder
--	SELECT StoreID,MealPeriod,ID,RevenueCenter,Status,OpenTime,GuestCount,FutureOrder,BusinessDate
--	FROM [Order]  where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID and status='CLOSE'
--	union all
--	SELECT StoreID,MealPeriod,ID,RevenueCenter,Status,OpenTime,GuestCount,FutureOrder,BusinessDate
--	FROM OrderArchive where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID and status='CLOSE'	


--insert into #tempPaidOutTrx
--	SELECT StoreID,Amount,Status, BusinessDate
--	FROM [PaidOutTrx]  where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID 
--	union all
--	SELECT StoreID,Amount,Status, BusinessDate
--	FROM PaidOutTrxArchive where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID 


--insert into #tempPaidInTrx
--	SELECT StoreID,Amount,Status, BusinessDate
--	FROM [PaidInTrx]  where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID 
--	union all
--	SELECT StoreID,Amount,Status, BusinessDate
--	FROM PaidInTrxArchive where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID 	

--insert into #tempPayment
--	SELECT StoreID,CheckID,Amount,Tip,Gratuity,AmountReceived,MethodID,Status,BusinessDate
--	FROM [Payment]  where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID and status='CLOSED'
--	union all
--	SELECT StoreID,CheckID,Amount,Tip,Gratuity,AmountReceived,MethodID,Status,BusinessDate
--	FROM PaymentArchive where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID and status='CLOSED'	
	

--insert into #tempCheck
--	SELECT StoreID,OrderID,ID,FutureOrderAdvPayment,BusinessDate
--	FROM [Check]  where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID and status='CLOSED'
--	union all
--	SELECT StoreID,OrderID,ID,FutureOrderAdvPayment,BusinessDate
--	FROM CheckArchive where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID and status='CLOSED'	



--insert into #tempTax
--	SELECT StoreID,Category,TaxAmt,TaxCategoryID,OrderID,TaxOrderAmt,BusinessDate
--	FROM Tax  where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID and Status='VALID'
--	union all
--	SELECT StoreID,Category,TaxAmt,TaxCategoryID,OrderID,TaxOrderAmt,BusinessDate
--	FROM TaxArchive where [BusinessDate] between @BeginTime and @endTime and storeID =@StoreID and Status='VALID'


	insert into #temptemp select SaleGroup,RecordType,ISNULL(sum(ISNULL(value,0)),0) as value,BusinessDate   from
	(
	Select (select Name from MealPeriod where StoreID=o.StoreID  
			and (case when		
				(EndTime>beginTime and (o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+' '+ CONVERT(nvarchar(20), beginTime,8) 
				and CONVERT(nvarchar(20), o.OpenTime,102) +' '+ CONVERT(nvarchar(20), EndTime,8)) ) 

			or (EndTime< beginTime and o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+' '+ CONVERT(nvarchar(20), BeginTime,8) 
			and CONVERT(nvarchar(20), o.OpenTime,102)+' 23:59:59') 
			or 
			(EndTime< beginTime and o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+' 00:00:00' 
			and CONVERT(nvarchar(20), o.OpenTime,102)+' '+CONVERT(nvarchar(20), EndTime,8)) 

			then 1 end )=1 
			 and DATEPART(WEEKDAY,o.OpenTime)=
			(case when [DayOfWeek]='SUNDAY' then 1
			when [DayOfWeek]='MONDAY' then 2
			when [DayOfWeek]='TUESDAY' then 3
			when [DayOfWeek]='WEDNESDAY' then 4
			when [DayOfWeek]='THURSDAY' then 5
			when [DayOfWeek]='FRIDAY' then 6
			when [DayOfWeek]='SATURDAY' then 7 end))  as SaleGroup,'Number Tables Served' as RecordType,count(o.ID) as value  ,o.BusinessDate
	 from [Order] as o 
	where o.status<>'TRANSFERRED' and o.Status='CLOSE' and BusinessDate =@BusinessDate
	and o.StoreID=@storeID
	 Group by o.openTime,o.StoreID,o.BusinessDate
	union all 
	Select (select Name from MealPeriod where StoreID=o.StoreID  
			and (case when		
				(EndTime>beginTime and (o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+' '+ CONVERT(nvarchar(20), beginTime,8) 
				and CONVERT(nvarchar(20), o.OpenTime,102) +' '+ CONVERT(nvarchar(20), EndTime,8)) ) 

			or (EndTime< beginTime and o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+' '+ CONVERT(nvarchar(20), BeginTime,8) 
			and CONVERT(nvarchar(20), o.OpenTime,102)+' 23:59:59') 
			or 
			(EndTime< beginTime and o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+' 00:00:00' 
			and CONVERT(nvarchar(20), o.OpenTime,102)+' '+CONVERT(nvarchar(20), EndTime,8)) 

			then 1 end )=1 
			 and DATEPART(WEEKDAY,o.OpenTime)=
			(case when [DayOfWeek]='SUNDAY' then 1
			when [DayOfWeek]='MONDAY' then 2
			when [DayOfWeek]='TUESDAY' then 3
			when [DayOfWeek]='WEDNESDAY' then 4
			when [DayOfWeek]='THURSDAY' then 5
			when [DayOfWeek]='FRIDAY' then 6
			when [DayOfWeek]='SATURDAY' then 7 end)) as SaleGroup,'Number Guest Served' as RecordType,ISNULL(sum(ISNULL(o.GuestCount,0)),0) as value
	,o.BusinessDate
	From  [Order]  as o  where o.status<>'TRANSFERRED' and o.Status='CLOSE' and BusinessDate =@BusinessDate
	and o.StoreID=@storeID
	Group by o.openTime,o.StoreID,o.BusinessDate
	union all
	Select (select Name from MealPeriod where StoreID=o.StoreID  
			and (case when		
				(EndTime>beginTime and (o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+' '+ CONVERT(nvarchar(20), beginTime,8) 
				and CONVERT(nvarchar(20), o.OpenTime,102) +' '+ CONVERT(nvarchar(20), EndTime,8)) ) 

			or (EndTime< beginTime and o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+' '+ CONVERT(nvarchar(20), BeginTime,8) 
			and CONVERT(nvarchar(20), o.OpenTime,102)+' 23:59:59') 
			or 
			(EndTime< beginTime and o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+' 00:00:00' 
			and CONVERT(nvarchar(20), o.OpenTime,102)+' '+CONVERT(nvarchar(20), EndTime,8)) 

			then 1 end )=1 
			 and DATEPART(WEEKDAY,o.OpenTime)=
			(case when [DayOfWeek]='SUNDAY' then 1
			when [DayOfWeek]='MONDAY' then 2
			when [DayOfWeek]='TUESDAY' then 3
			when [DayOfWeek]='WEDNESDAY' then 4
			when [DayOfWeek]='THURSDAY' then 5
			when [DayOfWeek]='FRIDAY' then 6
			when [DayOfWeek]='SATURDAY' then 7 end))  as SaleGroup, 'Number Checks' as RecordType, COUNT(p.CheckID) AS value,O.BusinessDate  
	From  [Order]  as O 
	inner JOIN  [Check]  as c ON O.id = c.orderid and o.StoreID=c.StoreID and O.BusinessDate=c.BusinessDate
	inner JOIN  Payment  as p ON p.CheckID = c.ID and o.StoreID=p.StoreID and c.BusinessDate=p.BusinessDate
	where o.status<>'TRANSFERRED' and O.Status='CLOSE' and c.Status='CLOSED' and p.Status='CLOSED'
	and o.BusinessDate =@BusinessDate and o.StoreID=@storeID
	Group by o.openTime,o.StoreID ,o.BusinessDate
	union all 
	Select (select Name from MealPeriod where StoreID=o.StoreID  
			and (case when		
				(EndTime>beginTime and (o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+' '+ CONVERT(nvarchar(20), beginTime,8) 
				and CONVERT(nvarchar(20), o.OpenTime,102) +' '+ CONVERT(nvarchar(20), EndTime,8)) ) 

			or (EndTime< beginTime and o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+' '+ CONVERT(nvarchar(20), BeginTime,8) 
			and CONVERT(nvarchar(20), o.OpenTime,102)+' 23:59:59') 
			or 
			(EndTime< beginTime and o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+' 00:00:00' 
			and CONVERT(nvarchar(20), o.OpenTime,102)+' '+CONVERT(nvarchar(20), EndTime,8)) 

			then 1 end )=1 
			 and DATEPART(WEEKDAY,o.OpenTime)=
			(case when [DayOfWeek]='SUNDAY' then 1
			when [DayOfWeek]='MONDAY' then 2
			when [DayOfWeek]='TUESDAY' then 3
			when [DayOfWeek]='WEDNESDAY' then 4
			when [DayOfWeek]='THURSDAY' then 5
			when [DayOfWeek]='FRIDAY' then 6
			when [DayOfWeek]='SATURDAY' then 7 end))  as SaleGroup, 'ProfitTotal' as RecordType, SUM(qty *(price -AdjustedPrice)) as ProfitTotal   ,o.BusinessDate
	From  [Order]  as O 
	inner JOIN  [OrderLineItem]  OI ON O.ID = OI.orderid and o.StoreID= OI.StoreID and o.BusinessDate=OI.BusinessDate
	where o.status<>'TRANSFERRED'  and o.BusinessDate =@BusinessDate and O.Status='CLOSE'
	and OI.Status='CLOSE' and o.StoreID=@storeID
	Group by o.openTime,o.StoreID,o.BusinessDate
	)  as tabel1 group by SaleGroup,RecordType,BusinessDate 


	--Rpt_DepartmentSalesAll

	select @storeid StoreID,Department,'','',
	isnull(SUM(isnull(GrossSales,0)),0) as  GrossSales,
	isnull(SUM(isnull(Voids,0)),0) Voids,
	isnull(SUM(isnull(Comps,0)),0) Comps,
	isnull(SUM(isnull(Discount,0)),0) Discount 
	from(SELECT MI.Department as Department, 
	isnull(SUM(OI.Qty * OI.Price),0) AS GrossSales, 
	isnull(SUM(isnull(CASE WHEN OI.RecordType='VOID' THEN OI.qty * OI.AdjustedPrice END,0)),0) AS Voids, 
	isnull(SUM(isnull(CASE WHEN OI.RecordType='COMP' THEN OI.qty * OI.AdjustedPrice END,0)),0) AS Comps, 
	isnull(SUM(isnull(CASE WHEN OI.RecordType in ('DISCOUNT','COUPON')  THEN OI.qty * OI.AdjustedPrice END,0)),0) AS Discount
	FROM OrderLineItem AS OI 
	INNER JOIN [Order] AS O 
		ON OI.OrderID = O.ID AND O.StoreID = OI.StoreID and OI.BusinessDate=O.BusinessDate
	INNER JOIN MenuItem AS MI 
		ON OI.ItemID = MI.ID AND MI.Department <> 'MODIFIER'  AND MI.StoreID = O.StoreID
		WHERE MI.MIType NOT IN ('GC', 'IHPYMNT') and O.Status='Close' and OI.Status='close' and 
		o.BusinessDate=@BusinessDate and o.StoreID=@storeID
	GROUP BY O.MealPeriod, MI.Department, OI.RecordType with rollup
	having GROUPING(O.MealPeriod)=0
	and GROUPING( MI.Department)=0
	and GROUPING(OI.RecordType) =1) as tab group by Department
	--Other InCome
		--gcSales
declare @gcSales  decimal(18,2)
 Select @gcSales=isnull(SUM(ISNULL(oli.qty * (oli.price-AdjustedPrice),0)),0)
From OrderLineItem as oli 
inner JOIN [Order] as  O ON oli.orderid = O.ID
		and o.StoreId=oli.StoreID
		AND O.BusinessDate=oli.BusinessDate
		JOIN MenuItem MI ON oli.itemid = MI.ID AND MI.MIType = 'GC'
		and MI.StoreId=o.StoreId
Where oli.RecordType <> 'VOID' and oli.RecordType <>'comp'  and oli.Status='CLOSE' and o.Status='CLOSE'
and o.StoreID=@storeID
and oli.BusinessDate=@BusinessDate

--Paid Ins
declare @paidIn decimal(18,2)
Select @paidIn=isnull(SUM(ISNULL(Amount,0)),0) From  PaidInTrx Where [status] = 'PAID_IN' 
and BusinessDate=@BusinessDate and StoreID=@storeID

--In House Payment Sales
declare @InHousePaymentSales decimal(18,2)
Select @InHousePaymentSales =isnull(SUM(ISNULL(OI.qty * OI.price,0)),0)
From OrderLineItem as OI
inner  JOIN [Order] as O ON OI.orderid = O.ID and o.StoreId=OI.StoreID and o.BusinessDate=oi.BusinessDate
inner JOIN MenuItem MI ON OI.itemid = MI.ID AND MI.MIType = 'IHPYMNT' and MI.StoreId=o.StoreID
Where OI.RecordType <> 'VOID' and o.BusinessDate=@BusinessDate and OI.Status='CLOSE'
and o.Status='CLOSE' and o.StoreID=@storeID

--Advance Payments
declare @advPayment decimal(18,2)
Select @advPayment=isnull(SUM(ISNULL(p.amount,0)),0) From Payment as p 
inner JOIN [Check] as c ON p.CheckID = c.ID and c.StoreId=p.StoreID and p.BusinessDate=c.BusinessDate
Where c.FutureOrderAdvPayment = 'Y' and p.Status='CLOSED' and c.Status='CLOSED' 
and p.BusinessDate=@BusinessDate and c.StoreID=@storeID

--Surcharge collected
declare @surchageamt decimal(18,2)
Select @surchageamt=isnull(Sum(ISNULL((case when ss.SurchargeGuestPays='Y' then TaxAmt else 0 end),0)),0)
From Tax as  A JOIN TaxCategory B on a.TaxCategoryID = b.ID and B.Category='SUR' and  A.Category=B.Category 
	 inner JOIN [Order] as o ON a.OrderID = o.ID 
	AND a.BusinessDate = o.BusinessDate and a.StoreID= o.StoreID
	left outer join StoreSetting as ss on o.StoreID =ss.StoreID
	where a.Status='VALID' and o.Status='CLOSE' and a.BusinessDate=@BusinessDate
	and o.StoreID=@storeID
--TotalPaidOut
declare @TotalPaidOut decimal(18,2)
Select @TotalPaidOut=isnull(SUM(ISNULL(pot.Amount,0)),0)  From 
 PaidOutTrx  as pot where BusinessDate=@BusinessDate and StoreID=@storeID

--Previous payments from future orders
declare @PaidAdv decimal(18,2)
 select @PaidAdv =isnull(SUM(ISNULL(p.amount,0) ),0)
 From Payment as p
  inner JOIN [Check] as c ON p.CheckID = c.ID and p.StoreID=c.StoreID  and c.BusinessDate=p.BusinessDate
 inner JOIN [Order] as O ON c.orderid = O.ID  and O.StoreID=c.StoreID and O.BusinessDate=c.BusinessDate
 where O.FutureOrder = 'Y'	and p.Status='CLOSED' and c.Status='CLOSED' and o.Status='CLOSE'
 and p.BusinessDate=@BusinessDate and o.StoreID=@storeID
 
 SELECT @gcSales gcSales,@paidIn TotalPaidIn
		,@InHousePaymentSales InHousePaymentSales,
		@advPayment advPayment,@surchageamt surchageamt
 SELECT @TotalPaidOut TotalPaidOut,@PaidAdv PaidAdv
	
	--tax
	
	Select @storeID StoreID,tc.Name as tax_name, isnull(SUM(ISNULL(t.TaxAmt,0)),0) as tax_amt, 
	SUM(ISNULL(t.TaxOrderAmt,0)) as [OrderAmt]
			From Tax as t inner JOIN TaxCategory tc 
				ON t.TaxCategoryID = tc.ID and t.Category COLLATE SQL_Latin1_General_CP1_CI_AS=tc.Category and tc.StoreID= t.StoreID
	Where  t.Category = 'TAX' and Status='VALID' and BusinessDate=@BusinessDate and t.StoreID=@storeID
	Group By tc.Name
	
	--paymentSummary
	SELECT @storeid [StoreID],pm.Name as display_name, 
	isnull(COUNT(isnull(p.CheckID,0)),0) AS numPayments, 
	isnull(SUM(isnull(p.Amount,0)),0) AS sales, 
	isnull(SUM(isnull(p.Tip,0)),0) AS Tip_Total, 
	isnull(SUM(isnull(p.Gratuity,0)),0) AS TtlSrvCharge, 
	isnull(SUM(isnull(p.AmountReceived,0)),0) AS [TtlReceived]
	FROM [Order] AS O
	INNER JOIN [Check] AS c ON O.ID = c.OrderID AND O.StoreID = c.StoreID and O.BusinessDate=c.BusinessDate
	INNER JOIN Payment AS p ON p.CheckID = c.ID AND O.StoreID = p.StoreID and c.BusinessDate=p.BusinessDate
	INNER JOIN PaymentMethod AS pm ON p.MethodID = pm.Name AND pm.StoreID = O.StoreID
	where o.Status='CLOSE' and c.Status='CLOSED' and p.Status='CLOSED' and o.BusinessDate=@BusinessDate
	and o.StoreID=@storeID
	GROUP BY pm.Name
	--CategorySummaryByPeriod

	
	SELECT CategoryName,sum(QtyTtl) QtyTtl,isnull(sum(Dinner),0) Dinner,isnull(sum(Lunch),0) Lunch
		FROM (Select  MI.Category as CategoryName, 
	isnull(sum(isnull(CASE WHEN OI.parentsplitLineNum = 0 THEN OI.qty ELSE (convert(real,OI.qty)/convert(real,OI.numsplits)) END,0)),0)  as QtyTtl, 
	isnull(sum(isnull(OI.qty * (OI.price-OI.adjustedPrice),0)),0) as AdjustTotal,MealPeriod
	From OrderLineItem as OI 
	inner JOIN [Order] as O ON OI.orderid = O.ID and OI.StoreID=O.StoreID and OI.BusinessDate=O.BusinessDate
	LEFT JOIN MenuItem MI ON OI.itemid = MI.ID and o.StoreID=MI.StoreID
	Where si <> 'N/A' AND MI.Category <> '' AND MI.Category IS NOT NULL 
	and oi.recordType<>'VOID' and O.MealPeriod in ('LUNCH','DINNER') and o.BusinessDate=@BusinessDate
	and o.Status='CLOSE' and OI.Status='CLOSE' and o.StoreID=@storeID
	group by o.storeid,MI.Category,O.MealPeriod
		) a pivot (sum(AdjustTotal) for [MealPeriod] in (Dinner,Lunch)) b group by CategoryName

	--CategorySummaryByPC
	Select @StoreID,o.RevenueCenter dining_room, 
	MI.Category MI_SALE_RPT_CATEGORY,
	isnull(SUM(isnull(OI.qty * (OI.price-OI.AdjustedPrice),0)),0) as CatTotal
	From OrderLineItem as OI 
	inner JOIN [order] as O ON OI.orderid = O.ID
	and OI.StoreID=O.StoreID and OI.BusinessDate=O.BusinessDate
	LEFT JOIN MenuItem MI ON OI.itemid = MI.ID AND MI.Category <> '' AND MI.Category IS NOT NULL
	and O.StoreID=MI.StoreID
	Where si <> 'N/A' and OI.RecordType<>'VOID' and OI.BusinessDate=@BusinessDate and OI.Status='CLOSE'
	and o.Status='CLOSE' and o.StoreID=@storeID
	Group By o.RevenueCenter, MI.Category
	order by o.RevenueCenter, MI.Category
		--AdjustedSummary

	--VOID
	select @StoreID StoreID,'VOID' [AdjustType], v.Name as Reason,sum(oli.qty * oli.AdjustedPrice) as Total,COUNT(*) as  Number
	from OrderLineItem as oli inner join Void as v on oli.AdjustID=v.ID and oli.StoreID=v.StoreID			
	LEFT outer JOIN menuItem MI ON MI.ID = oli.itemid and mi.StoreID=oli.StoreID
	where oli.RecordType = 'VOID' AND MI.MIType <>'IHPYMNT' and oli.Status='CLOSE' 
	and oli.BusinessDate=@BusinessDate and oli.StoreID=@storeID
	group by v.Name
	
	--COMP
	select @StoreID StoreID,'COMP' [AdjustType], v.Name as Reason,sum(oli.qty * oli.AdjustedPrice) as Total,COUNT(*) as  Number
	from OrderLineItem as oli inner join Comp as v on oli.AdjustID=v.ID and oli.StoreID=v.StoreID			
	LEFT outer JOIN menuItem MI ON MI.ID = oli.itemid and mi.StoreID=oli.StoreID
	where oli.RecordType = 'COMP' AND MI.MIType <>'IHPYMNT' and oli.Status='CLOSE' 
	and oli.BusinessDate=@BusinessDate and oli.StoreID=@storeID
	group by v.Name

	--DICOUNT
	select @StoreID StoreID,'DISCOUNT' [AdjustType], v.Name as Reason,sum(oli.qty * oli.AdjustedPrice) as Total,COUNT(*) as  Number
	from OrderLineItem as oli inner join Discount as v on oli.AdjustID=v.ID and oli.StoreID=v.StoreID			
	LEFT outer JOIN menuItem MI ON MI.ID = oli.itemid and mi.StoreID=oli.StoreID
	where oli.RecordType ='DISCOUNT' AND MI.MIType <>'IHPYMNT' and oli.Status='CLOSE' 
	and oli.BusinessDate=@BusinessDate and oli.StoreID=@storeID
	group by v.Name
	
	--COUPON
	select @StoreID StoreID,'DISCOUNT' [AdjustType], v.Name as Reason,sum(oli.qty * oli.AdjustedPrice) as Total,COUNT(*) as  Number
	from OrderLineItem as oli inner join Coupon as v on oli.AdjustID=v.ID and oli.StoreID=v.StoreID			
	LEFT outer JOIN menuItem MI ON MI.ID = oli.itemid and mi.StoreID=oli.StoreID
	where oli.RecordType ='COUPON' AND MI.MIType <>'IHPYMNT' and oli.Status='CLOSE' and 
	oli.BusinessDate=@BusinessDate and oli.StoreID=@storeID
	group by v.Name
	
	--RETURN
	select @StoreID StoreID,'Return' [AdjustType], v.Name as Reason,abs(sum(oli.qty * oli.Price)) as Total,COUNT(*) as  Number
	from OrderLineItem as oli inner join [return] as v on oli.AdjustID=v.ID and oli.StoreID=v.StoreID			
	LEFT outer JOIN menuItem MI ON MI.ID = oli.itemid and mi.StoreID=oli.StoreID
	where oli.RecordType ='NONE' AND MI.MIType <>'IHPYMNT' and Qty<0 and oli.Status='CLOSE' 
	and oli.BusinessDate=@BusinessDate and oli.StoreID=@storeID
	group by v.Name
	--GuestTableSummaryByPeriod
	
	declare @saleGroup nvarchar(20)  
	declare @RecordType nvarchar(20)  
	declare @value decimal(10,2)   
	declare @GuestValue decimal(10,2)  
	declare @CheckValue decimal(10,2)  
	declare @PPA decimal (10,2)  
	declare @PCA decimal (10,2)    

	insert into #temptemp select t.salegroup,'PPA',
	case when isnull(value,0)=0 then 0 else 
	(select value from #temptemp where recordType='ProfitTotal'  and salegroup=t.salegroup and BusinessDate=t.BusinessDate)/value end as PPA,
	t.BusinessDate from #temptemp t where RecordType='Number Guest Served' and t.BusinessDate=@BusinessDate
	insert into #temptemp select t.salegroup,'PCA',
	case when isnull(value,0)=0 then 0 else
	(select value from #temptemp where recordType='ProfitTotal'  and salegroup=t.salegroup and BusinessDate=t.BusinessDate)/value end as PCA,
	t.BusinessDate from #temptemp t where RecordType='Number Checks' and t.BusinessDate=@BusinessDate	
	
	declare @NumberGuestServedTotal decimal(10,2)   
	declare @numCheckTotal decimal(10,2)   
	declare @ProfitTotal decimal(10,2) 
	declare @NumberTablesServed decimal(10,2)  
	if (select COUNT(*) from #temptemp)>0
	begin
		select @NumberGuestServedTotal=isnull(SUM(isnull(value,0)),0) from #temptemp where RecordType='Number Guest Served'  and businessDate=@BusinessDate
		select @numCheckTotal=isnull(SUM(isnull(value,0)),0) from #temptemp where RecordType='Number Checks'  and businessDate=@BusinessDate
		select @NumberTablesServed=isnull(SUM(isnull(value,0)),0) from #temptemp where RecordType='Number Tables Served'  and businessDate=@BusinessDate
		select @ProfitTotal=isnull(SUM(isnull(value,0)),0) from #temptemp where RecordType='ProfitTotal' 
		and businessDate=@BusinessDate
		insert into #temptemp values('Total','Number Checks',@numCheckTotal,@BusinessDate) 
		insert into #temptemp values('Total','Number Guest Served',@NumberGuestServedTotal,@BusinessDate)  
		insert into #temptemp values('Total','Number Tables Served',@NumberTablesServed,@BusinessDate)  
		insert into #temptemp values('Total','PPA',case when ISNULL(@NumberGuestServedTotal,0)=0 then 0 else @ProfitTotal/@NumberGuestServedTotal end,@BusinessDate)  
		insert into #temptemp values('Total','PCA',case when ISNULL(@numCheckTotal,0)=0 then 0 else @ProfitTotal/@numCheckTotal end,@BusinessDate) 
	end
	
	select @StoreID [StoreID],SaleGroup Meal,RecordType,value,
	case salegroup when 'Lunch' then 1 when 'DINNER' then 2 when 'Total' then 999 else 3 end [OrderCol] ,
	BusinessDate from #temptemp 
	where RecordType<>'ProfitTotal'  and RecordType not in ('PPA','PCA') and [SaleGroup]<>'total'
	

	--GuestTableSummaryByPC

	Select @StoreID [StoreID], RevenueCenterName Salegroup, isnull(SUM(isnull(NumTables,0)),0) as NumTables, 
	isnull(SUM(isnull(NumGuest,0)),0) as [NumGuest], isnull(SUM(isnull(NumChecks,0)),0) as NumChecks, 
	isnull(SUM(isnull(ProfitTotal,0)),0) as Profit_total from 
	(
	 select RevenueCenter as RevenueCenterName,count(ID) as NumTables ,isnull(SUM(isnull(GuestCount,0)),0)  as NumGuest,NULL AS NumChecks, NULL AS ProfitTotal from [Order]
	  WHERE businessDate=@BusinessDate and Status='CLOSE' and StoreID=@storeID
	 and status<>'TRANSFERRED' Group by RevenueCenter
	UNION 
	Select o.RevenueCenter as RevenueCenterName,NULL AS NumTables, NULL AS NumGuest,
	COUNT(p.CheckID) AS NumChecks, NULL as ProfitTotal
	From [Order] as  O
	inner JOIN [Check] as c ON O.ID = c.orderid and O.StoreID=c.StoreID and O.BusinessDate=c.BusinessDate
	inner JOIN Payment as p ON p.CheckID = c.ID and c.StoreID=p.StoreID and c.BusinessDate=p.BusinessDate
	where o.status<>'TRANSFERRED' and o.Status='CLOSE' and c.Status='CLOSED' and p.Status='CLOSED' and o.BusinessDate=@BusinessDate
	 and o.StoreID=@storeID
	Group by o.RevenueCenter
	UNION
	Select o.RevenueCenter as RevenueCenterName, NULL AS NumTables, NULL AS NumGuest,
	NULL AS NumChecks, SUM(qty * (price-AdjustedPrice)) as ProfitTotal
	From [Order] as O
	inner JOIN OrderLineItem as OI ON O.ID = OI.orderid  and O.StoreID=OI.StoreID and O.BusinessDate=OI.BusinessDate
	where o.status<>'TRANSFERRED' and o.Status='CLOSE' and OI.Status='CLOSE' and o.BusinessDate=@BusinessDate
	 and o.StoreID=@storeID
	 Group by o.RevenueCenter

	) as table1
	Group by RevenueCenterName
	
	--DailySaleDetails



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
	FROM	[Check] as c INNER JOIN 
			Payment  as p ON c.id = p.CheckID  and c.StoreID=p.StoreID and c.BusinessDate=p.BusinessDate
	WHERE   p.Status = 'CLOSED' and MethodID<>'CASH' and c.Status='CLOSED' and c.BusinessDate=@BusinessDate
	 and p.StoreID=@storeID
	SELECT	@totalCashSrvCharge = isnull(sum(isnull(p.Gratuity,0)),0)
	FROM    [Check] as c INNER JOIN 
			Payment  as p ON c.ID =p.CheckID and c.StoreID=p.StoreID and c.BusinessDate=p.BusinessDate INNER JOIN 
			PaymentMethod  as pm ON p.MethodID = pm.Name and p.StoreID=pm.StoreID
	WHERE	 p.Status = 'CLOSED' AND pm.DisplayName = 'cash'  and c.Status='CLOSED' 
	and c.BusinessDate=@BusinessDate  and p.StoreID=@storeID
	
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

	declare @GCChangeTTL decimal(18,2)
	---GCChangeTTL= TtlReceived-sales-TtlSrvCharge
	select @GCChangeTTL=isnull(SUM(isnull(p.AmountReceived,0)),0) -isnull(SUM(isnull(p.Amount,0)),0)-isnull(SUM(isnull(p.Gratuity,0)),0)
	FROM [Order] AS O
	INNER JOIN [Check] AS c ON O.ID = c.OrderID AND O.StoreID = c.StoreID and O.BusinessDate=c.BusinessDate
	INNER JOIN Payment AS p ON p.CheckID = c.ID AND O.StoreID = p.StoreID and c.BusinessDate=p.BusinessDate
	where  p.MethodID='GC' and p.status='CLOSED' and c.status='CLOSED' and o.status='CLOSE' and 
	o.BusinessDate=@BusinessDate  and p.StoreID=@storeID


select @GCChangeTTL GCChangeTTl,@ReimbursementTtl ReimbursementTtl,@Tip_withheld TipWithheld
 ,@CashDeposit CashDeposit
end

GO
