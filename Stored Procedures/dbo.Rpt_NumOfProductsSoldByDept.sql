SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create  Procedure [dbo].[Rpt_NumOfProductsSoldByDept]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID int,
	@Department nvarchar(50),
	@topOrBottom bit,
	@OrderBy int
AS  
BEGIN
SET NOCOUNT ON;
declare @topOrBottonCount int
declare @sql nvarchar(max)
set @sql=''
if ISNULL(@topOrBottom,0)=1
select @topOrBottonCount=Value from ConstTable where Category='NumberOfRPTCount' 
and ID=1
else
select @topOrBottonCount=Value from ConstTable where Category='NumberOfRPTCount' 
and ID=2
set @sql=@sql+'
select top '+CONVERT(nvarchar(20),isnull(@topOrBottonCount,0))+' StoreName,StoreID,Department,Category,Name,UpcNumber,ItemID,
isnull(SUM(Qty),0) as  Qty,
	isnull(SUM(GrossSales),0) as  GrossSales,
	isnull(SUM(Voids),0) Voids,
	isnull(SUM(Comps),0) Comps,
	isnull(SUM(Discount),0) Discount 
	from(SELECT s.StoreName,oi.StoreID,MI.ReportDepartment as Department, 
	mi.ReportCategory as Category,
	mi.ReportName as Name,
	case when isnull( ltrim(rtrim(mi.UpcNumber)),'''')='''' then CONVERT(nvarchar(20), oi.ItemID) else mi.UpcNumber end UpcNumber,
	oi.ItemID ItemID,
	sum(OI.Qty) Qty,
	SUM(OI.Qty * OI.Price) AS GrossSales, 
	SUM(isnull(CASE OI.RecordType WHEN ''VOID'' THEN OI.qty * OI.AdjustedPrice END,0)) AS Voids, 
	SUM(isnull(CASE OI.RecordType WHEN ''COMP'' THEN OI.qty * OI.AdjustedPrice END,0)) AS Comps, 
	SUM(isnull(CASE OI.RecordType WHEN ''DISCOUNT'' THEN OI.qty * OI.AdjustedPrice END,0)) AS Discount
FROM (select RecordType,Qty,AdjustedPrice,Price,OrderID,StoreID,ItemID,SI,BusinessDate from [dbo].[fnOrderLineItemTable]('''+CONVERT(nvarchar(20),@BeginDate)+''','''+CONVERT(nvarchar(20),@EndDate)+''','+CONVERT(nvarchar(20),@storeID)+')) AS OI 
INNER JOIN (select StoreID,MealPeriod,ID,BusinessDate  from [dbo].[fnOrderTable]('''+CONVERT(nvarchar(20),@BeginDate)+''','''+CONVERT(nvarchar(20),@EndDate)+''','+CONVERT(nvarchar(20),@storeID)+')) AS O 
	ON OI.OrderID = O.ID AND O.StoreID = OI.StoreID and O.BusinessDate=OI.BusinessDate
INNER JOIN MenuItem AS MI 
	ON OI.ItemID = MI.ID AND MI.ReportDepartment <> ''MODIFIER'' and OI.SI<>''N/A'' AND MI.StoreID = O.StoreID
	 inner join Store s on s.ID=oi.StoreID
WHERE MI.MIType NOT IN (''GC'', ''IHPYMNT'') and ReportDepartment='''+@department+'''
GROUP BY s.StoreName,oi.StoreID,O.MealPeriod, MI.ReportDepartment,MI.ReportCategory,mi.ReportName, OI.RecordType,mi.UpcNumber,oi.ItemID ) as tab group by StoreName,StoreID,Department,Category,Name,UpcNumber ,ItemID  
'
if(isnull(@topOrBottom,0)=1)
begin
	if(isnull(@OrderBy,0)=1)
		set @sql=@sql+' order by  Qty desc,Name'
	else
		set @sql=@sql+' order by  GrossSales desc,Name'
end
else
begin
	if(isnull(@OrderBy,0)=1)
		set @sql=@sql+' order by  Qty ,Name'
	else
		set @sql=@sql+' order by  GrossSales ,Name'
end
--select @sql
exec sp_executesql @sql

end
GO
