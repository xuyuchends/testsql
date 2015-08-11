SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Rpt_SaleSummaryAll]
(
	@BeginDate datetime,
	@EndDate Datetime,
	@StoreID nvarchar(200),
	@RevenueCenter nvarchar(20),
	@MealPeriod varchar(10)
)
as
declare @sqlAll nvarchar(max)
declare @SqlWhere nvarchar(200)
declare @sqlGroupby nvarchar(200)
declare @SelectSql nvarchar(200)
declare @TotalWhere nvarchar(200)
set @SqlWhere=''
set @SelectSql=''
if ISNULL(@RevenueCenter,0)<>0
begin
	set  @SqlWhere=@SqlWhere+' and o.RevenueCenter='+convert(varchar(20),@RevenueCenter)
end
if ISNULL(@MealPeriod,'')<>''
begin
	set @SqlWhere=@SqlWhere+' and o.daypart='''+@MealPeriod+''''
end

set @sqlAll=
'if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')
drop table #tempOrder
select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrderLineItem'') and type=''U'')
drop table #tempOrderLineItem 
select * into #tempOrderLineItem from [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#order'') and type=''U'')
drop table #order
select *,dbo.[f_GetOrderMealPeriodRpt](OpenTime,StoreID) as daypart into #order from #tempOrder  where BusinessDate  between '''+CONVERT(varchar(20),@BeginDate)+''' and '''+CONVERT(varchar(20),@EndDate)+'''

select mi.ReportDepartment as Department,mi.ReportCategory as Category,StoreName,o.StoreID,
		SUM(oli.Qty*oli.Price) as sales,
		SUM(oli.Qty) as QuantitySold,
		SUM(oli.Qty*oli.Price)/SUM(oli.Qty) Avg
		from #tempOrderLineItem  oli inner join #order o on oli.OrderID=o.ID and o.StoreID=oli.StoreID 
		and o.BusinessDate=oli.BusinessDate 
		inner join MenuItem mi on oli.ItemID=mi.ID and oli.StoreID=mi.StoreID 
		inner join Store on o.StoreID=Store.ID
		where 1=1'
		+@SqlWhere+' group by o.StoreID,StoreName,mi.ReportDepartment,mi.ReportCategory order by o.StoreID,StoreName,mi.ReportDepartment,mi.ReportCategory'
--select @sqlAll

exec sp_executesql @sqlAll


GO
