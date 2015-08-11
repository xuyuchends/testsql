SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Rpt_AdjustmentDetailAll]
(
	@BeginDate datetime,
	@EndDate datetime,
	@StoreID nvarchar(2000),
	@RevenueCenter nvarchar(200),
	@AdjustType nvarchar(20)
	
)
as
begin
declare @sql nvarchar(max)
declare @sqlWhere nvarchar(200)
SET NOCOUNT ON;

set @sqlWhere=''

if  ISNULL(@RevenueCenter,'')<>''
begin
	set @sqlWhere=' and o.RevenueCenter='''+@RevenueCenter+''''
end
set @sql='
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')  
drop table #tempOrder
select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrderLineItem'') and type=''U'')  
drop table #tempOrderLineItem 
select * into #tempOrderLineItem from [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')


declare @TotalSales decimal(10,2) 
SELECT    @TotalSales=SUM(OI.Qty * OI.Price) 
FROM #tempOrderLineItem AS OI 
INNER JOIN #tempOrder AS O    ON OI.OrderID = O.ID AND O.StoreID = OI.StoreID   
INNER JOIN MenuItem AS MI    ON OI.ItemID = MI.ID AND MI.ReportDepartment <> ''MODIFIER'' and OI.SI<>''N/A'' AND MI.StoreID = O.StoreID  WHERE MI.MIType NOT IN (''GC'', ''IHPYMNT'') '+@sqlWhere+'

select s.StoreName as Storename,oli.StoreID,
 v.name as Adjustname,
  abs(isnull(SUM(case when oli.SI=''N/A'' then 1 else oli.Qty end),0)) as Quantity,   
 abs(isnull(SUM(oli.Qty*oli.AdjustedPrice),0)) Amount, 
@TotalSales as TotalSales
from #tempOrderLineItem oli inner join '+@AdjustType+' as  v on oli.AdjustID=v.ID and oli.StoreID=v.StoreID
inner join Store as s on s.ID=oli.StoreID
inner join #tempOrder as o on o.StoreID=s.ID and o.ID=oli.OrderID and oli.BusinessDate=O.BusinessDate where oli.RecordType='''+@AdjustType+''''

set @sql+=@sqlwhere+' group by s.StoreName ,oli.StoreID,v.Name'
--select @sql
exec sp_executesql @sql
end

GO
