SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_DepartmentSalesAll]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(2000)
AS  
BEGIN
SET NOCOUNT ON;
select Department,Category,Name,
	isnull(SUM(GrossSales),0) as  GrossSales,
	isnull(SUM(Voids),0) Voids,
	isnull(SUM(Comps),0) Comps,
	isnull(SUM(Discount),0) Discount 
	from(SELECT MI.ReportDepartment as Department, 
	mi.ReportCategory as Category,
	mi.ReportName as Name,
	SUM(OI.Qty * OI.Price) AS GrossSales, 
	SUM(isnull(CASE OI.RecordType WHEN 'VOID' THEN OI.qty * OI.AdjustedPrice END,0)) AS Voids, 
	SUM(isnull(CASE OI.RecordType WHEN 'COMP' THEN OI.qty * OI.AdjustedPrice END,0)) AS Comps, 
	SUM(isnull(CASE OI.RecordType WHEN 'DISCOUNT' THEN OI.qty * OI.AdjustedPrice END,0)) AS Discount
FROM (select RecordType,Qty,AdjustedPrice,Price,OrderID,StoreID,ItemID,SI,BusinessDate from [dbo].[fnOrderLineItemTable](@BeginDate,@EndDate,@storeID)) AS OI 
INNER JOIN (select StoreID,MealPeriod,ID,BusinessDate  from [dbo].[fnOrderTable](@BeginDate,@EndDate,@storeID)) AS O 
	ON OI.OrderID = O.ID AND O.StoreID = OI.StoreID and O.BusinessDate=OI.BusinessDate
INNER JOIN MenuItem AS MI 
	ON OI.ItemID = MI.ID AND MI.ReportDepartment <> 'MODIFIER' and OI.SI<>'N/A' AND MI.StoreID = O.StoreID
WHERE MI.MIType NOT IN ('GC', 'IHPYMNT') 
GROUP BY O.MealPeriod, MI.ReportDepartment,MI.ReportCategory,mi.ReportName, OI.RecordType with rollup
having GROUPING(O.MealPeriod)=0
and GROUPING( MI.ReportDepartment)=0
and GROUPING(MI.ReportCategory)=0
and	GROUPING(mi.ReportName)=0
and GROUPING(OI.RecordType) =1) as tab group by Department,Category,Name
end
GO
