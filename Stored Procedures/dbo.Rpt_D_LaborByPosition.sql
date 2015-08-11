SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_D_LaborByPosition]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200)
AS  
BEGIN
declare @sql nvarchar(max)
SET NOCOUNT ON;
if (select COUNT(*) from GoogleChartPositionSetting where StoreID=@storeID and ReportName='Labor By Position'
and IsShow=1 and IntervalType=0)>0
begin
set @sql='SELECT 
		p.Name PositionName,
		convert(decimal(18,2), SUM(ts.PayRate * case when ts.HoursWorked =0 then DATEDIFF( mi ,ts.TimeIn,GETDATE())/60.0 else ts.HoursWorked end)+SUM(ts.OT1HoursWorked * ts.OT1Payrate+ts.OT2HoursWorked  * ts.OT2Payrate))as TotalPay
		From EmployeeTimeSheet as ts
LEFT OUTER JOIN EmployeeJob as ej ON ts.PositionID = ej.PositionID AND ts.EmployeeID = ej.EmployeeID and ts.StoreID=ej.StoreID
LEFT OUTER JOIN Position as p ON ts.PositionID =p.ID and p.StoreID=ts.StoreID
LEFT OUTER JOIN Employee as e ON ts.EmployeeID = e.ID and ts.StoreID=e.StoreID
inner join Store s on s.ID=ts.StoreID 
		where 
		ts.BusinessDate between '''+CONVERT(nvarchar(20),@BeginDate)+''' and '''+CONVERT(nvarchar(20),@EndDate)+''' 
		and ts.StoreID in ('+@storeID+') and p.ID in (select positionID from GoogleChartPositionSetting where IntervalType=0
and ReportName=''Labor By Position'' and isShow=1)
		GROUP BY p.Name,ts.BusinessDate,ts.StoreID'
end
else
begin
	set @sql='SELECT 
		p.Name PositionName,
		convert(decimal(18,2), SUM(ts.PayRate * case when ts.HoursWorked =0 then DATEDIFF( mi ,ts.TimeIn,GETDATE())/60.0 else ts.HoursWorked end)+SUM(ts.OT1HoursWorked * ts.OT1Payrate+ts.OT2HoursWorked  * ts.OT2Payrate))as TotalPay
		From EmployeeTimeSheet as ts
LEFT OUTER JOIN EmployeeJob as ej ON ts.PositionID = ej.PositionID AND ts.EmployeeID = ej.EmployeeID and ts.StoreID=ej.StoreID
LEFT OUTER JOIN Position as p ON ts.PositionID =p.ID and p.StoreID=ts.StoreID
LEFT OUTER JOIN Employee as e ON ts.EmployeeID = e.ID and ts.StoreID=e.StoreID
inner join Store s on s.ID=ts.StoreID 
		where 
		ts.BusinessDate between '''+CONVERT(nvarchar(20),@BeginDate)+''' and '''+CONVERT(nvarchar(20),@EndDate)+''' 
		and ts.StoreID in ('+@storeID+') 
		GROUP BY p.Name,ts.BusinessDate,ts.StoreID'
end
--select @sql
exec sp_executesql @sql
end
GO
