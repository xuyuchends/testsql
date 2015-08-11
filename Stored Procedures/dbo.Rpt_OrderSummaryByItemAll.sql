SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Rpt_OrderSummaryByItemAll]
(
	@BeginDate datetime,
	@EndDate datetime,
	@StoreID int,
	@MenuItem varchar(20),
	@MenuItemID int,
	@RevenueCenter nvarchar(20) ,
	@MealPeriod nvarchar(20)
)
as
declare @SqlWhere nvarchar(200)
declare @SqlAll nvarchar(max)
declare @selsql nvarchar(max)
set @SqlWhere=''
set @selsql=''
if ISNULL(@RevenueCenter,0)<>0
begin
	set  @SqlWhere=@SqlWhere+' and o.RevenueCenter='+convert(varchar(20),@RevenueCenter)
end
if ISNULL(@MealPeriod,'')<>''
begin
	set @SqlWhere=@SqlWhere+' and o.daypart='''+@MealPeriod+''''
end
if ISNULL(@MenuItem,'')<>''
begin
	set @selsql=@selsql+' and mi.ReportCategory='''+@MenuItem+''''
end
if ISNULL(@MenuItemID,0)<>0
begin
	set @selsql=@selsql+' and mi.ID='''+convert(nvarchar(20),@MenuItemID)+''''
end
 
set @SqlAll='
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')
drop table #tempOrder
select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrderLineItem'') and type=''U'')
drop table #tempOrderLineItem 
select * into #tempOrderLineItem from [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

if exists (select * from sysobjects where id = object_id(N''tempdb..#order'') and type=''U'')
drop table #order
select *,dbo.[f_GetOrderMealPeriodRpt](OpenTime,StoreID) as daypart into #order from #tempOrder 

 select (select Name from MenuItem mi where StoreID=o.storeID '+@selsql+') MenuItem ,
 '+convert(nvarchar(20),@MenuItemID)+' as ItemID,
(select mi.ReportCategory from MenuItem mi where StoreID=o.storeID '+@selsql+') as Category,
(select mi.ReportDepartment from MenuItem mi where  StoreID=o.storeID '+@selsql+') as Department,o.ID OrderID,o.StoreID, 
 CONVERT(varchar(12),o.businessDate,101) BusinessDate, 
 convert(varchar(2),DATEPART(HOUR,OpenTime))+'':''+convert(varchar(2),DATEPART(minute,OpenTime) )StartTime  ,DATEDIFF(MINUTE,OpenTime,CloseTime) Duration,  
 
 (select isnull(SUM(Qty),0) from #tempOrderLineItem oi1 inner join MenuItem mi on oi1.ItemID=mi.ID and oi1.StoreID=mi.StoreID where oi1.OrderID=o.ID and oi1.StoreID=o.StoreID '+@selsql+') Quantity,
 
 (select isnull(SUM(Qty*AdjustedPrice),0) from #tempOrderLineItem oi1 inner join MenuItem mi on oi1.ItemID=mi.ID and oi1.StoreID=mi.StoreID where oi1.OrderID=o.ID and oi1.StoreID=o.StoreID '+@selsql+') Amount ,
 (select isnull(SUM(Qty*Price),0) from #tempOrderLineItem oi where oi.OrderID=o.ID and oi.StoreID=o.StoreID) as OrderTotal 
 from #order o  where 1=1 '+@SqlWhere+' and o.ID in (select distinct orderID from #tempOrderLineItem oli inner join MenuItem mi on oli.ItemID=mi.ID where 1=1 '+@selsql+')'
 
-- select @SqlAll
 exec sp_executesql @SqlAll
 
GO
