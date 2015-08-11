SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Rpt_AdjustItemByDateAll]
(
	@BeginDate datetime,
	@EndDate datetime,
	@StoreID int,
	@RevenueCenter nvarchar(200),
	@AdjustType nvarchar(200),
	@AdjustName nvarchar(20)
)
as
begin
declare @sql nvarchar(max)
SET NOCOUNT ON;
set @sql='

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')
drop table #tempOrder

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrderLineItem'') and type=''U'')
drop table #tempOrderLineItem 

select * into #tempOrderLineItem from [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(2000),@storeID)+''')
select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(2000),@storeID)+''')
declare @TotalSales decimal(10,2) SELECT    @TotalSales=SUM(OI.Qty * OI.Price) 
FROM #tempOrderLineItem  AS OI INNER JOIN #tempOrder AS O    ON OI.OrderID = O.ID AND O.StoreID = OI.StoreID
and OI.BusinessDate=O.BusinessDate   
INNER JOIN MenuItem AS MI    ON OI.ItemID = MI.ID AND MI.ReportDepartment <> ''MODIFIER'' and OI.SI<>''N/A'' AND MI.StoreID = O.StoreID  WHERE MI.MIType NOT IN (''GC'', ''IHPYMNT'')  
select v.name as Adjustname,'''+@AdjustType+''' as AdjustType,
CONVERT(varchar(12),o.BusinessDate,101) as BusinessDate,
 abs(isnull(SUM(case when oli.SI=''N/A'' then 1 else oli.Qty end),0)) as Quantity,    
 abs(isnull(SUM(oli.Qty*(oli.AdjustedPrice)),0)) as Amount, 
@TotalSales as TotalSales
from #tempOrderLineItem oli inner join '+@AdjustType+' as  v on oli.AdjustID=v.ID and oli.StoreID=v.StoreID
inner join Store as s on s.ID=oli.StoreID
inner join #tempOrder as o on o.StoreID=s.ID and o.ID=oli.OrderID and oli.BusinessDate=O.BusinessDate 
where   v.name ='''+@AdjustName+''' and oli.recordType='''+@AdjustType+''''
if  ISNULL(@RevenueCenter,'')<>''
begin
	set @sql+=' and o.RevenueCenter='''+@RevenueCenter+''''
end
set @sql+=' group by v.Name,o.BusinessDate,o.StoreID'
--select @sql
exec sp_executesql @sql
end
GO
