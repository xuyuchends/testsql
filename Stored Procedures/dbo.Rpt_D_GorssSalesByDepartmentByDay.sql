SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE Procedure [dbo].[Rpt_D_GorssSalesByDepartmentByDay]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200)
AS  
BEGIN
declare @sql nvarchar(max)
SET NOCOUNT ON;

set @sql='
SELECT MI.ReportDepartment as Department, 
		SUM(OI.Qty * OI.Price) AS GrossSales
		FROM OrderLineItem AS OI INNER JOIN [Order] AS O 
		ON OI.OrderID = O.ID AND O.StoreID = OI.StoreID AND O.BusinessDate = OI.BusinessDate 
		INNER JOIN MenuItem AS MI 
		ON OI.ItemID = MI.ID AND MI.ReportDepartment <> ''MODIFIER'' and OI.SI<>''N/A'' AND MI.StoreID = O.StoreID
WHERE MI.MIType NOT IN (''GC'', ''IHPYMNT'') and oi.BusinessDate between '''+CONVERT(nvarchar(20),@BeginDate)+''' 
and '''+CONVERT(nvarchar(20),@EndDate)+''' and  oi.recordType<>''VOID''
and oi.StoreID in ('+@storeID+')
and oi.Status=''CLOSE'''
set @sql +=' GROUP BY MI.ReportDepartment'

--select @sql
exec sp_executesql @sql
end

GO
