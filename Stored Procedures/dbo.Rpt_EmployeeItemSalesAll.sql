SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_EmployeeItemSalesAll]
@beginDate Datetime,
@EndDate Datetime,
@StoreID nvarchar(200),
@RevenueCenter nvarchar(50),
@MenuItemID int,
@MenuItemCategory nvarchar(20)
AS
BEGIN
declare @sqlWhere nvarchar(max)
declare @sqlGroupBy nvarchar(max)
declare @sqlSelect nvarchar(max)
declare @sqlAll nvarchar(max)
set @sqlWhere=''
set @sqlGroupBy=''
set @sqlSelect=''
if ISNULL(@RevenueCenter,'')<>''
begin
	set @sqlWhere=@sqlWhere+' and o.RevenueCenter='''+@RevenueCenter+''''
end
if ISNULL(@MenuItemID,'0')<>'0'
begin
	set @sqlWhere=@sqlWhere+' and mi.ID='+convert(varchar(10),@MenuItemID)
--set @sqlGroupBy=@sqlGroupBy+',mi.Name'
--set @sqlSelect=@sqlSelect+',mi.Name MenuItem'
end

if ISNULL(@MenuItemCategory,'')<>''
begin
	
	set @sqlWhere=@sqlWhere+' and mi.ReportDepartment+''/''+mi.ReportCategory='''+@MenuItemCategory+''''
	--set @sqlGroupBy=@sqlGroupBy+',mi.Name'
	--set @sqlSelect=@sqlSelect+',mi.Name MenuItem'
	
end

set @sqlAll='

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')
drop table #tempOrder
select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrderLineItem'') and type=''U'')
drop table #tempOrderLineItem 
select * into #tempOrderLineItem from [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')
	select e.FirstName+'' '' +e.LastName as EmployeeName,
	e.ID EmployeeID,
	o.StoreID as StoreID,
	s.StoreName,
	sum((oli.Price-oli.AdjustedPrice)*Qty) as Sales,
	COUNT(oli.ID) as ItemCounts'+@sqlSelect+'
	from #tempOrder as o inner join #tempOrderLineItem as oli
	on o.StoreID=oli.StoreID and o.ID=oli.OrderID and o.BusinessDate=oli.BusinessDate 
	inner join Employee as e on  e.StoreID=o.StoreID and e.ID=o.EmpIDClose 
	inner join MenuItem mi on mi.ID=oli.ItemID and mi.StoreID=o.StoreID
	inner join Store s on s.ID=o.StoreID
	where oli.SI<>''N/A'' '+
	@sqlWhere +'
	group by e.FirstName+'' '' +e.LastName,e.ID,o.StoreID,s.StoreName'+@sqlGroupBy
	
	--select @sqlAll
	execute sp_executesql @sqlAll
END
GO
