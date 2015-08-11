SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_D_SalesByPosition]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200)
AS  
BEGIN
declare @sql nvarchar(max)
SET NOCOUNT ON;
if (select COUNT(*) from GoogleChartPositionSetting where StoreID=@storeID and ReportName='Sales By Position'
and IsShow=1 and IntervalType=0)>0
begin
set @sql='select p.Name,convert(decimal(18,2), SUM(oli.Qty*oli.Price)) Sales from [order] o inner join OrderLineItem oli on o.StoreID=oli.StoreID and o.BusinessDate=oli.BusinessDate
and o.ID=oli.OrderID
inner join EmployeeTimeSheet et on et.EmployeeID=o.EmpIDClose and o.CloseTime between  timein and TimeOut
		and et.StoreID=o.StoreID and et.BusinessDate=o.BusinessDate
inner join Position p on p.StoreID=et.StoreID and p.ID=et.PositionID
		where 
		o.BusinessDate between '''+CONVERT(nvarchar(20),@BeginDate)+''' and '''+CONVERT(nvarchar(20),@EndDate)+''' 
		and o.Status=''CLOSE''
		and o.StoreID in ('+@storeID+') and p.ID in (select positionID from GoogleChartPositionSetting where IntervalType=0
and ReportName=''Sales By Position'' and isShow=1)
		GROUP BY p.Name'
end
else
begin
	set @sql='select p.Name,convert(decimal(18,2), SUM(oli.Qty*oli.Price)) Sales from [order] o inner join OrderLineItem oli on o.StoreID=oli.StoreID and o.BusinessDate=oli.BusinessDate
and o.ID=oli.OrderID
inner join EmployeeTimeSheet et on et.EmployeeID=o.EmpIDClose and o.CloseTime between  timein and TimeOut
		and et.StoreID=o.StoreID and et.BusinessDate=o.BusinessDate
inner join Position p on p.StoreID=et.StoreID and p.ID=et.PositionID
		where 
		o.BusinessDate between '''+CONVERT(nvarchar(20),@BeginDate)+''' and '''+CONVERT(nvarchar(20),@EndDate)+''' 
		and o.StoreID in ('+@storeID+') and o.Status=''CLOSE''
		GROUP BY p.Name'
end
--select @sql
exec sp_executesql @sql
end

GO
