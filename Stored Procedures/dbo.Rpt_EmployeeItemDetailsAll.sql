SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_EmployeeItemDetailsAll]
@beginDate Datetime,
@EndDate Datetime,
@StoreID nvarchar(20),
@EmployeeID int,
@RevenueCenter nvarchar(20),
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
	set @sqlWhere=@sqlWhere+' and o.RevenueCenter ='''+@RevenueCenter+''''
end

if ISNULL(@EmployeeID,'0')<>'0'
begin
	set @sqlWhere=@sqlWhere+' and e.ID='+convert(varchar(10),@EmployeeID)
end

if ISNULL(@MenuItemID,'0')<>'0'
begin
	set @sqlWhere=@sqlWhere+' and mi.ID='+convert(varchar(10),@MenuItemID)
end
if ISNULL(@MenuItemCategory,'')<>''
begin
	set @sqlWhere=@sqlWhere+' and mi.ReportDepartment+''/''+mi.ReportCategory='''+@MenuItemCategory+''''
end

set @sqlAll='
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')
drop table #tempOrder
select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrderLineItem'') and type=''U'')
drop table #tempOrderLineItem 
select * into #tempOrderLineItem from [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')

	select (select FirstName+'' ''+LastName  from Employee where ID='+convert(varchar(20),@EmployeeID)+' and StoreId = o.StoreID) as EmployeeName ,mi.ReportName  MenuItem,sum((oli.Price-oli.AdjustedPrice)*Qty) as Sales,COUNT(oli.ID) as ItemCounts from OrderLineItem oli inner join [Order] o on oli.OrderID=o.ID and oli.StoreID=o.StoreID and oli.BusinessDate=o.BusinessDate
inner join MenuItem mi on oli.ItemID=mi.ID and oli.StoreID=mi.StoreID
inner join Employee e on e.ID=o.EmpIDClose and e.StoreID=o.StoreID where 1=1 
'+@sqlWhere+' 
 group by mi.ReportName , o.StoreID'

	--select @sqlAll
	execute sp_executesql @sqlAll
END

GO
