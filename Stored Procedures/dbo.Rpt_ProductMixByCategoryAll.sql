SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Rpt_ProductMixByCategoryAll]
(
	@StoreId int,
	@BeginDate datetime,
	@EndDate datetime,
	@Department nvarchar(20),
	@Category nvarchar(20),
	@MenuItem nvarchar(20),
	@RevenueCenter nvarchar(20),
	@MealPeriod nvarchar(20)
	
)
as
declare @sqlAll nvarchar(max)
declare @sqlwhere nvarchar(max)

set @sqlwhere=''
if ISNULL(@Department,'')<>''
begin
	set @sqlwhere=' and mi.ReportDepartment='''+@Department+''''
end

if ISNULL(@Category,'')<>''
begin
	set @sqlwhere=' and mi.ReportCategory='''+@Category+''''
end

if ISNULL(@MenuItem,'')<>''
begin
	set @sqlwhere=' and mi.ReportName='''+@MenuItem+''''
end

if ISNULL(@RevenueCenter,'')<>''
begin
	set @sqlwhere=' and o.RevenueCenter='''+@RevenueCenter+''''
end

if ISNULL(@MealPeriod,'')<>''
begin
	set @sqlwhere=' and o.daypart='''+@MealPeriod+''''
end


set @sqlAll=' if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')
drop table #tempOrder
select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrderLineItem'') and type=''U'')
drop table #tempOrderLineItem 
select * into #tempOrderLineItem from [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

if exists (select * from sysobjects where id = object_id(N''tempdb..#order'') and type=''U'')
drop table #order
select *,dbo.[f_GetOrderMealPeriodRpt](OpenTime,StoreID) as daypart into #order from #tempOrder  where BusinessDate  between '''+CONVERT(varchar(20),@BeginDate)+''' and '''+CONVERT(varchar(20),@EndDate)+'''

select mi.ReportCategory Category,oli.ItemID,mi.ReportDepartment Department,mi.ReportName MenuItem,SUM(Qty*oli.Price) as sales ,sum(Qty) as QuantitySold ,sum(Qty*oli.Price)/sum(Qty) as Avg from #tempOrderLineItem oli inner join [#order] o
on oli.OrderID=o.ID and oli.StoreID=o.StoreID and oli.BusinessDate=o.BusinessDate
inner join MenuItem mi on mi.ID=oli.ItemID and mi.StoreID=oli.StoreID
where 1=1 '+@sqlwhere+'
group by mi.ReportDepartment,mi.ReportCategory ,mi.ReportName,oli.ItemID'

exec sp_executesql @sqlAll

--select @sqlAll

GO
