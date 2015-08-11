SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 CREATE PROCEDURE [dbo].[Rpt_PMIXAll]
(
 @BeginDate datetime,
 @EndDate datetime,
 @storeID int,  --only one store
 @AsEntree char(1)
)
as

BEGIN
declare @sql as nvarchar(max) 
SET NOCOUNT ON;
if @AsEntree<>'N'
begin
 set @AsEntree='Y'
end
set @sql='if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')
drop table #tempOrder
select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrderLineItem'') and type=''U'')
drop table #tempOrderLineItem 
select * into #tempOrderLineItem from [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

SELECT oli.ItemID, 
SUM(CASE WHEN oli.parentsplitLineNum = oli.ID THEN qty WHEN parentsplitLineNum = 0 THEN qty END) AS NumSold,
SUM(oli.Qty * (oli.Price-oli.AdjustedPrice))  AS SalesTotal,
mi.ReportName as MenuItemName, 
UPPER(mi.ReportCategory) AS Category, 
UPPER(mi.Department) AS Department, 
SUM(CASE WHEN NumSplits = 0 THEN (mi.Cost * oli.Qty)  WHEN NumSplits > 0 THEN (mi.Cost * oli.Qty / NumSplits) END) AS FoodCost,
SUM(oli.Qty * (oli.Price-oli.AdjustedPrice))  - SUM(CASE WHEN NumSplits = 0 THEN (mi.Cost * oli.Qty) WHEN NumSplits > 0 THEN (mi.Cost * oli.Qty / NumSplits) END) AS Profit
FROM #tempOrder AS o INNER JOIN #tempOrderLineItem AS oli ON o.ID = oli.OrderID and o.StoreID=oli.StoreID
and o.BusinessDate=oli.BusinessDate
INNER JOIN MenuItem AS mi ON oli.ItemID = mi.ID and  o.StoreID=mi.StoreID
WHERE (oli.RecordType <> ''VOID'') AND (oli.SI <> ''N/A'') AND (oli.AsEntree = '''+@AsEntree+''')
GROUP BY oli.ItemID, mi.ReportName, mi.ReportCategory,mi.Department'
--select @sql
exec sp_executesql @sql
end

GO
