SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_DepartmentSalesByStoreAll]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200)
AS  
BEGIN
declare @sql nvarchar(max)
SET NOCOUNT ON;

set @sql='
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')
drop table #tempOrder
select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrderLineItem'') and type=''U'')
drop table #tempOrderLineItem 
select * into #tempOrderLineItem from [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')
select store.StoreName StoreName,isnull(SUM(GrossSales),0) GrossSales,
isnull(SUM(Voids),0) Voids,isnull(SUM(Comps),0) Comps,isnull(SUM(Discount),0) Discount,
(isnull(SUM(GrossSales),0) -isnull(SUM(Voids),0)-isnull(SUM(Comps),0) -isnull(SUM(Discount),0)) NetSales from(SELECT o.StoreID,O.MealPeriod as MealPeriod,  
	MI.Department as Department, 
	mi.Category as Category,
	mi.Name,
	SUM(OI.Qty * OI.Price) AS GrossSales, 
	SUM(isnull(CASE OI.RecordType WHEN ''VOID'' THEN OI.qty * OI.AdjustedPrice END,0)) AS Voids, 
	SUM(isnull(CASE OI.RecordType WHEN ''COMP'' THEN OI.qty * OI.AdjustedPrice END,0)) AS Comps, 
	SUM(isnull(CASE OI.RecordType WHEN ''DISCOUNT'' THEN OI.qty * OI.AdjustedPrice END,0)) AS Discount
FROM #tempOrderLineItem  AS OI INNER JOIN #tempOrder AS O 
	ON OI.OrderID = O.ID AND O.StoreID = OI.StoreID AND O.BusinessDate = OI.BusinessDate 
INNER JOIN MenuItem AS MI 
	ON OI.ItemID = MI.ID AND MI.Department <> ''MODIFIER'' and OI.SI<>''N/A'' AND MI.StoreID = O.StoreID
WHERE MI.MIType NOT IN (''GC'', ''IHPYMNT'') '
set @sql +=' GROUP BY o.StoreID,O.MealPeriod, MI.Department,MI.Category,mi.Name, OI.RecordType with rollup
having GROUPING(O.MealPeriod)=0
and GROUPING( MI.Department)=0
and GROUPING(MI.Category)=0
and	GROUPING(mi.Name)=0
and GROUPING(OI.RecordType) =1) as tab inner join store on store.id=StoreID  group by Store.StoreName'

--select @sql
exec sp_executesql @sql
end
GO
