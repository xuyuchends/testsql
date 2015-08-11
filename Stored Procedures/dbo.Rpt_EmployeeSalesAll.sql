SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Rpt_EmployeeSalesAll]
	@BeginDate datetime,
	@EndDate datetime,
	@StoreID nvarchar(50),
	@RevenueCenter nvarchar(50)
as
BEGIN
	declare @sql nvarchar(max)
	declare @table1 nvarchar(max)
	declare @table2 nvarchar(max)
	SET NOCOUNT ON;

set @table1='SELECT sales.EmployeeID as EmployeeID,
			o.GuestCount as GuestCount, 
			sales.StoreID as StoreID,
			sales.amount as amount,
			sales.ID as checkID,
			sales.OrderID as OrderID,
			sales.Gratuity as Gratuity,
			o.RevenueCenter as RevenueCenterName,
			 cast(DATEDIFF(MINUTE,OpenTime,CloseTime) as bigint) Duration
			FROM #tempOrder AS o INNER JOIN
			(
				SELECT  EmployeeID,  OrderID, StoreID,c.ID,c.BusinessDate,
				(SELECT ISNULL(SUM(Amount), 0) AS amount FROM #tempPayment AS p WHERE (CheckID = c.ID) AND (StoreID = c.StoreID) GROUP BY CheckID, StoreID)-(SELECT ISNULL(SUM(TaxAmt), 0) AS taxAmount FROM	#tempTax  AS t WHERE (CheckID = c.ID) AND (StoreID = c.StoreID) GROUP BY CheckID, StoreID) AS amount,
				(SELECT ISNULL(SUM(Gratuity), 0) AS Gratuity FROM #tempPayment AS p WHERE (CheckID = c.ID) AND (StoreID = c.StoreID) GROUP BY CheckID, StoreID) AS Gratuity
				FROM #tempCheck AS c
			)AS sales ON o.ID = sales.OrderID AND o.StoreID = sales.StoreID AND o.BusinessDate = sales.BusinessDate  '
if isnull(@RevenueCenter,'')<>''
begin
	set @Table1 +=' and o.RevenueCenter='''+@RevenueCenter+''''
end
set @table2='SELECT EmployeeID, OrderID, CASE WHEN oli.RecordType = ''VOID'' THEN oli.AdjustedPrice * Qty ELSE 0 END AS voids, 
			CASE WHEN oli.RecordType = ''COMP'' THEN oli.AdjustedPrice * Qty ELSE 0 END AS comps, 
			CASE WHEN oli.RecordType in ( ''DISCOUNT'',''COUPON'') THEN oli.AdjustedPrice * Qty ELSE 0 END AS discounts, StoreID
			FROM #tempOrderLineItem  AS oli
			WHERE ((CASE WHEN oli.RecordType = ''VOID'' THEN oli.AdjustedPrice * Qty ELSE 0 END > 0) OR
                  (CASE WHEN oli.RecordType = ''COMP'' THEN oli.AdjustedPrice * Qty ELSE 0 END > 0) OR
                  (CASE WHEN oli.RecordType = ''DISCOUNT'' THEN oli.AdjustedPrice * Qty ELSE 0 END > 0))'
set @sql ='
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

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempTax'') and type=''U'')
drop table #tempTax
select * into #tempTax from [dbo].[fnTaxTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

select t1.storeid as storeID,
		s.StoreName as storeName,
		SUM(t1.Gratuity) as Gratuity,
		t1.EmployeeID as EmployeeID,  
		e.FirstName+'' ''+e.LastName as EmployeeName , 
		(select isnull(SUM(case when HoursWorked<>0.00 then HoursWorked else 8 end),0) from EmployeeTimeSheet ets where ets.EmployeeID=t1.EmployeeID and ets.StoreID=t1.StoreID) as [Hours], 
		MAX(t1.GuestCount) as GuestCount,
		isnull(SUM(t1.amount),0) as Amount,
		isnull(SUM(t2.voids),0) as voids,
		isnull(SUM(t2.comps),0) as comps,
		isnull(SUM(t2.discounts),0) as discounts,
		COUNT(t1.checkID) as checks,
		isnull(sum(Duration),0) Duration
		from ( '+@table1 +' ) as t1 left outer join (' +@table2+ ') as t2 on t1.StoreID=t2.StoreID and t1.OrderID =t2.OrderID and t1.EmployeeID=t2.EmployeeID
		inner join store as s on s.id=t1.storeid
		inner join Employee e on e.StoreID=t1.StoreID   and e.ID=t1.EmployeeID
		group by t1.storeid,s.StoreName,t1.EmployeeID,e.FirstName+'' ''+e.LastName'
--select @sql
exec sp_executesql @sql
END


GO
