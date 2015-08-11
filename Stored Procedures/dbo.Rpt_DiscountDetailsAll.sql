SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Rpt_DiscountDetailsAll]
(
	@BeginDate datetime,
	@EndDate datetime,
	@StoreID nvarchar(200),
	@RevenueCenter nvarchar(200)
)
as
begin
declare @sql nvarchar(max)
SET NOCOUNT ON;

set @sql=' 

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')
drop table #tempOrder
select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrderLineItem'') and type=''U'')
drop table #tempOrderLineItem 
select * into #tempOrderLineItem from [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')
select s.ID as storeid,
 o.RevenueCenter as RevenueCenter,
 o.ID as orderID, 
abs(isnull(SUM(oli.Qty),0)) as Quantity, 
abs(isnull(SUM(oli.Qty*(oli.Price-oli.AdjustedPrice)),0)) as Amount, 
abs(isnull(sum(Qty*Price),0)) as TotalSales
from #tempOrderLineItem oli
inner join Discount as  dis on oli.AdjustID=dis.ID and oli.StoreID=dis.StoreID 
inner join #tempOrder as o on o.id=oli.orderid and o.storeid=oli.storeid  AND O.BusinessDate = oli.BusinessDate 
inner join Store as s on s.ID=oli.StoreID 
where  oli.SI<>''N/A'' '
if  ISNULL(@RevenueCenter,'')<>''
begin
	set @sql+=' and o.RevenueCenter='''+@RevenueCenter+''''
end
set @sql+=' group by  s.ID,o.RevenueCenter,o.id '

--select @sql
exec sp_executesql @sql
end
GO
