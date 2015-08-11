SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[Rpt_DepartmentSalesSub]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200)
AS  
BEGIN
declare @sql nvarchar(max)
declare @orderTableName nvarchar(50)
declare @orderLineItemTableName nvarchar(50)
SET NOCOUNT ON;
if exists (select * from [order] where BusinessDate = @BeginDate)
begin
	set @orderTableName='[Order]'
	set @orderLineItemTableName='[OrderLineItem]'
end
else
begin
	set @orderTableName='[OrderArchive]'
	set @orderLineItemTableName='[OrderLineItemArchive]'
end
set @sql='
if exists (select * from sysobjects where id = object_id(''#tempOrder''))
drop table #tempOrder
if exists (select * from sysobjects where id = object_id(''#tempOrderLineItem''))
	drop table #tempOrderLineItem 
select * into #tempOrder from '+@orderTableName+' where BusinessDate between '''+ Convert(nvarchar,@BeginDate,120)+ ''' and '''  + Convert(nvarchar,@EndDate,120) + ''' and StoreID ='''+@storeID+'''
	select * into #tempOrderLineItem from '+@orderLineItemTableName+' where BusinessDate between '''+ Convert(nvarchar,@BeginDate,120)+ ''' and '''+ Convert(nvarchar,@EndDate,120) + ''' and Storeid = '''+@storeID+'''

select Department,isnull(SUM(GrossSales),0) GrossSales,isnull(SUM(Voids),0) Voids,(ISNULL(SUM(GrossSales),0)-isnull(SUM(Voids),0)) as ActualSales,isnull(SUM(Comps),0) Comps,(ISNULL(SUM(GrossSales),0)-isnull(SUM(Voids),0)-isnull(SUM(Comps),0)) as AdjSales,isnull(SUM(Discount),0) Discount,(ISNULL(SUM(GrossSales),0)-isnull(SUM(Voids),0)-isnull(SUM(Comps),0)-isnull(SUM(Discount),0)) as NetSales from(SELECT 
	MI.ReportDepartment as Department, 
	mi.ReportCategory as Category,
	mi.ReportName as Name,
	SUM(OI.Qty * OI.Price) AS GrossSales, 
	SUM(isnull(CASE OI.RecordType WHEN ''VOID'' THEN OI.qty * OI.AdjustedPrice END,0)) AS Voids, 
	SUM(isnull(CASE OI.RecordType WHEN ''COMP'' THEN OI.qty * OI.AdjustedPrice END,0)) AS Comps, 
	SUM(isnull(CASE OI.RecordType WHEN ''DISCOUNT'' THEN OI.qty * OI.AdjustedPrice END,0)) AS Discount
FROM #tempOrderLineItem AS OI INNER JOIN #tempOrder AS O 
	ON OI.OrderID = O.ID AND O.StoreID = OI.StoreID  AND O.BusinessDate = OI.BusinessDate 
INNER JOIN MenuItem AS MI 
	ON OI.ItemID = MI.ID AND MI.ReportDepartment <> ''MODIFIER'' and OI.SI<>''N/A'' AND MI.StoreID = O.StoreID
WHERE MI.MIType NOT IN (''GC'', ''IHPYMNT'') GROUP BY O.MealPeriod, MI.ReportDepartment,MI.ReportCategory,mi.ReportName, OI.RecordType with rollup
having GROUPING(O.MealPeriod)=0
and GROUPING( MI.ReportDepartment)=0
and GROUPING(MI.ReportCategory)=0
and	GROUPING(mi.ReportName)=0
and GROUPING(OI.RecordType) =1) as tab group by Department


union 

select '''',sum(GrossSales),sum(Voids),sum(ActualSales),sum(Comps),sum(AdjSales),sum(Discount),sum(NetSales) from (select Department,isnull(SUM(GrossSales),0) GrossSales,isnull(SUM(Voids),0) Voids,(ISNULL(SUM(GrossSales),0)-isnull(SUM(Voids),0)) as ActualSales,isnull(SUM(Comps),0) Comps,(ISNULL(SUM(GrossSales),0)-isnull(SUM(Voids),0)-isnull(SUM(Comps),0)) as AdjSales,isnull(SUM(Discount),0) Discount,(ISNULL(SUM(GrossSales),0)-isnull(SUM(Voids),0)-isnull(SUM(Comps),0)-isnull(SUM(Discount),0)) as NetSales from(SELECT 
	MI.ReportDepartment as Department, 
	mi.ReportCategory as Category,
	mi.ReportName as Name,
	SUM(OI.Qty * OI.Price) AS GrossSales, 
	SUM(isnull(CASE OI.RecordType WHEN ''VOID'' THEN OI.qty * OI.AdjustedPrice END,0)) AS Voids, 
	SUM(isnull(CASE OI.RecordType WHEN ''COMP'' THEN OI.qty * OI.AdjustedPrice END,0)) AS Comps, 
	SUM(isnull(CASE OI.RecordType WHEN ''DISCOUNT'' THEN OI.qty * OI.AdjustedPrice END,0)) AS Discount
FROM #tempOrderLineItem AS OI INNER JOIN #tempOrder AS O 
	ON OI.OrderID = O.ID AND O.StoreID = OI.StoreID  AND O.BusinessDate = OI.BusinessDate 
INNER JOIN MenuItem AS MI 
	ON OI.ItemID = MI.ID AND MI.ReportDepartment <> ''MODIFIER'' and OI.SI<>''N/A'' AND MI.StoreID = O.StoreID
WHERE MI.MIType NOT IN (''GC'', ''IHPYMNT'') GROUP BY O.MealPeriod, MI.ReportDepartment,MI.ReportCategory,mi.ReportName, OI.RecordType with rollup
having GROUPING(O.MealPeriod)=0
and GROUPING( MI.ReportDepartment)=0
and GROUPING(MI.ReportCategory)=0
and	GROUPING(mi.ReportName)=0
and GROUPING(OI.RecordType) =1) as tab group by Department) table1 order by Department desc'

--select @sql
exec sp_executesql @sql
end
GO
