SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Rpt_OrderSummaryByAdjustmentAll]
(
	@AdjustType nvarchar(10),
	@AdjustName varchar(20),
	@StoreID int,
	@RevenueCenter nvarchar(20),
	@BeginDate datetime,
	@EndDate datetime
)
as

declare @sql nvarchar(max)
declare @where nvarchar(max)
if ISNULL(@AdjustName,'')<>''
begin
	set @where=' and o.ID in (select distinct #tempOrder.ID from #tempOrder 
  inner join #tempOrderLineItem on #tempOrderLineItem.OrderID= #tempOrder.ID
   and #tempOrderLineItem.StoreID= #tempOrder.StoreID
    and #tempOrderLineItem.BusinessDate= #tempOrder.BusinessDate
  inner join '+@AdjustType+' on #tempOrderLineItem.AdjustID='+@AdjustType+'.ID and #tempOrderLineItem.StoreID= '+@AdjustType+'.StoreID
  where 
  '+@AdjustType+'.Name='''+@AdjustName+''' 
  and #tempOrderLineItem.RecordType='''+@AdjustType+''')'
end
if ISNULL(@StoreID,0)<>0
begin
		set @where=@where +' and o.StoreId ='+convert(nvarchar(10),@StoreID)+''
end
if ISNULL(@RevenueCenter,'')<>''
begin
	set @where=@where+'and o.RevenueCenter ='''+@RevenueCenter+''''
end
set @sql='
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')
drop table #tempOrder
select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrderLineItem'') and type=''U'')
drop table #tempOrderLineItem 
select * into #tempOrderLineItem from [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

select '''+@AdjustName+''' as AdjustName,o.StoreID,CONVERT(varchar(10),o.businessDate,23) BusinessDate,RevenueCenter,
convert(varchar(2),DATEPART(HOUR,OpenTime))+'':''+convert(varchar(2),DATEPART(minute,OpenTime) )StartTime
,DATEDIFF(MINUTE,OpenTime,CloseTime) Duration,
o.ID OrderID,(select isnull(SUM(Qty*Price),0) from #tempOrderLineItem oi where oi.OrderID=o.ID and oi.StoreID=o.StoreID) as CheckTotal ,
(select isnull(SUM(Qty*AdjustedPrice),0) from #tempOrderLineItem oi1 where RecordType='''+@AdjustType+''' and oi1.OrderID=o.ID and oi1.StoreID=o.StoreID) Amount,
(select isnull(SUM(case when oi1.SI=''N/A'' then 1 else oi1.Qty end),0) from #tempOrderLineItem oi1 where RecordType='''+@AdjustType+''' and oi1.OrderID=o.ID and  oi1.StoreID=o.StoreID) Quantity
from [Order] o  where 1=1'

if ISNULL(LTRIM(rtrim(@where)),'')<>''
begin
	set @sql=@sql+@where
end

--select @sql
execute sp_executesql @sql


GO
