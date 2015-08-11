SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_TableTurnAll]
	@BeginDate datetime,
	@EndDate datetime,
	@StoreID nvarchar(200),
	@TurnTime int,
	@DayPart nvarchar(50),
	@RevenueCenter nvarchar(50)
AS
BEGIN
	declare @sql nvarchar(max)
	declare @table1 nvarchar(max)
	declare @table2 nvarchar(max)
	SET NOCOUNT ON;
	
set @table1='select oi.OrderID, oi.BusinessDate, 
				oi.StoreID,
				sum(oi.Price*oi.Qty)-sum(oi.AdjustedPrice*oi.Qty) as sales,
				sum(oi.AdjustedPrice*oi.Qty) as adjuct,
				sum(case when oi.RecordType=''DISCNT'' then oi.Price*oi.Qty-oi.AdjustedPrice*oi.Qty else 0 end) as Discount
			from  #tempOrderLineItem  as oi
			where oi.SI<>''N/A''
			group by oi.OrderID,oi.StoreID, oi.BusinessDate'
set @table2='select c.OrderID,
				c.StoreID , 
				sum(case when p.MethodID =''CASH'' then p.Gratuity else 0 end)  as SrvCharage
			from #tempPayment as p inner join #tempCheck as c on p.CheckID =c.ID
			group by  c.OrderID,c.StoreID'
set @sql='if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')
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

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#order'') and type=''U'')
drop table #order
select *,dbo.[f_GetOrderMealPeriodRpt](OpenTime,StoreID) as daypart into #order from #tempOrder 

select * from (select o.daypart,  o.ID as orderID,
			o.StoreID, 
			s.StoreName as StoreName,
			o.EmpIDOpen,
			e.FirstName+'' ' + '''+e.LastName EmpNameOpen, 
			o.OpenTime,
			o.CloseTime,
			DATEDIFF(mi,o.OpenTime,o.CloseTime) as Duration, 
			o.GuestCount,
			salesTbl.sales,
			salesTbl.adjuct,
			salesTbl.Discount,
			CharageTbl.SrvCharage ,
			o.MealPeriod as MealPeriod,
			o.RevenueCenter as RevenueCenter,
			ltrim(rtrim(o.tablename)) as tablename
		from ('+@table1 +') as salesTbl left outer join (' +@table2+') as CharageTbl
			on salesTbl.OrderID =CharageTbl.OrderID and salesTbl.StoreID=CharageTbl.StoreID
		inner join #order as o on salesTbl.OrderID=o.ID and CharageTbl.StoreID=o.StoreID
		and salesTbl.BusinessDate=o.BusinessDate
		left join Employee as e on e.ID=o.EmpIDOpen and o.StoreID=e.StoreID
		inner join store  as s on s.id=o.storeID where 1=1'
if @TurnTime>0
begin
	set @sql +=' AND DATEDIFF(mi,o.OpenTime,o.CloseTime) >='+Convert(nvarchar,@TurnTime)
end
else
begin
	set @sql +=' AND DATEDIFF(mi,o.OpenTime,o.CloseTime) <=5'
end

if isnull(@RevenueCenter,'')<>''
begin
	set @sql +=' AND o.RevenueCenter='''+ @RevenueCenter+'''' 
end

set @sql=@sql+' ) tableAll'

if (@DayPart<>'')
begin
	set @sql +=' where daypart='''+ @DayPart+''''
end
set @sql +=' order by orderID'
exec sp_executesql @sql
--select @sql
END

GO
