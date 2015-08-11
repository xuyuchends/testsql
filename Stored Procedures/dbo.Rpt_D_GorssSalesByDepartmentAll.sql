SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_D_GorssSalesByDepartmentAll]
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

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrderLineItem'') and type=''U'')
drop table #tempOrderLineItem 

select * into #tempOrderLineItem from [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')
select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')

SELECT MI.ReportDepartment as Department, 
		SUM(OI.Qty * OI.Price) AS GrossSales
		FROM #tempOrderLineItem AS OI INNER JOIN #tempOrder AS O 
		ON OI.OrderID = O.ID AND O.StoreID = OI.StoreID and   O.BusinessDate = OI.BusinessDate
		INNER JOIN MenuItem AS MI 
		ON OI.ItemID = MI.ID AND MI.ReportDepartment <> ''MODIFIER'' and OI.SI<>''N/A'' AND MI.StoreID = O.StoreID
WHERE MI.MIType NOT IN (''GC'', ''IHPYMNT'') '
set @sql +=' GROUP BY MI.ReportDepartment'

--select @sql
exec sp_executesql @sql
end
GO
