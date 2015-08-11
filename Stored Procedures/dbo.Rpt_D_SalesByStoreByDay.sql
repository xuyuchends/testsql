SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_D_SalesByStoreByDay]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200),
	@SalesType int --1:GrossSales 2:NetSales
AS  
BEGIN
declare @sql nvarchar(max)
declare @SalesTypeSql nvarchar(max)
declare @colName nvarchar(20)
SET NOCOUNT ON;
set @SalesTypeSql=''
set @colName=''

if ISNULL( @SalesType,0)=1
begin
	set @SalesTypeSql=',SUM(OI.Qty * OI.Price) AS GrossSales '
	set @colName='GrossSales'
end
else if ISNULL( @SalesType,0)=2
begin
	set @SalesTypeSql=',SUM(OI.Qty * (OI.Price-OI.AdjustedPrice)) AS NetSales '
	set @colName='NetSales'
end

set @sql='SELECT s.storeName as StoreName '+ @SalesTypeSql + '
	FROM OrderLineItem AS OI 
	INNER JOIN MenuItem AS MI ON OI.ItemID = MI.ID AND MI.ReportDepartment <> ''MODIFIER'' and OI.SI<>''N/A'' AND MI.StoreID = OI.StoreID
	inner join store as s on s.id=oi.storeID 
	WHERE MI.MIType NOT IN (''GC'', ''IHPYMNT'') and BusinessDate between '''+Convert(nvarchar,@BeginDate,120)+''' and '''+Convert(nvarchar,@EndDate,120)+''' and oi.StoreID in ('+@storeID+') 
	and oi.status=''CLOSE'''
set @sql +=' GROUP BY s.storeName '



--select @sql
exec sp_executesql @sql
end
GO
