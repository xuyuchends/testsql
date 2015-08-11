SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[Rpt_D_LaborPercent]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200)
AS  
BEGIN
SET NOCOUNT ON;
if (select COUNT(*) from GoogleChartPositionSetting where StoreID=@storeID and ReportName='LaborPercent By Position'
and IsShow=1 and IntervalType=0)>0
begin
		
		select PositionName,CONVERT(decimal(18,2),CONVERT(decimal(18,4), case when ISNULL(SUM(sales),0)=0 then 0 else SUM(TotalPay)/SUM(sales) end)*100)
		from (
		SELECT 
		p.Name PositionName,
		convert(decimal(18,2), SUM(ts.PayRate * case when ts.HoursWorked =0 then DATEDIFF( mi ,ts.TimeIn,GETDATE())/60.0 else ts.HoursWorked end)+SUM(ts.OT1HoursWorked * ts.OT1Payrate+ts.OT2HoursWorked  * ts.OT2Payrate))as TotalPay,0 sales
		From EmployeeTimeSheet as ts
LEFT OUTER JOIN EmployeeJob as ej ON ts.PositionID = ej.PositionID AND ts.EmployeeID = ej.EmployeeID and ts.StoreID=ej.StoreID
LEFT OUTER JOIN Position as p ON ts.PositionID =p.ID and p.StoreID=ts.StoreID
LEFT OUTER JOIN Employee as e ON ts.EmployeeID = e.ID and ts.StoreID=e.StoreID
inner join Store s on s.ID=ts.StoreID 
		where ts.BusinessDate between @BeginDate and @EndDate and ts.StoreID=@storeID
		and p.ID in (select positionID from GoogleChartPositionSetting where IntervalType=0
and ReportName='LaborPercent By Position' and isShow=1)
		GROUP BY p.Name,ts.StoreID
		
		union
		select p.Name PositionName,0,SUM((Price-AdjustedPrice)*Qty) sales  from OrderLineItem oli inner join [Order] o 
		on o.BusinessDate=oli.BusinessDate and o.ID=oli.OrderID and o.StoreID=oli.storeid 
		inner join EmployeeTimeSheet et on et.EmployeeID=o.EmpIDClose and o.CloseTime between  timein and case when TimeOut='1900-01-01 00:00:00.000' or TimeOut IS null then DATEADD(DAY,1,timein) else TimeOut end 
		and et.StoreID=o.StoreID and et.BusinessDate=o.BusinessDate
		inner join position p on p.ID=et.PositionID and p.StoreID=et.StoreID
		where oli.BusinessDate  between @BeginDate and @EndDate  and oli.StoreID=@storeID
		and oli.status='CLOSE'
		and p.ID in (select positionID from GoogleChartPositionSetting where IntervalType=0
and ReportName='LaborPercent By Position' and isShow=1)
		GROUP BY p.Name,et.StoreID) b group by PositionName
end
else
begin
	select PositionName,CONVERT(decimal(18,2),CONVERT(decimal(18,4), case when ISNULL(SUM(sales),0)=0 then 0 else SUM(TotalPay)/SUM(sales) end)*100)
		from (
		SELECT 
		p.Name PositionName,
		convert(decimal(18,2), SUM(ts.PayRate * case when ts.HoursWorked =0 then DATEDIFF( mi ,ts.TimeIn,GETDATE())/60.0 else ts.HoursWorked end)+SUM(ts.OT1HoursWorked * ts.OT1Payrate+ts.OT2HoursWorked  * ts.OT2Payrate))as TotalPay,0 sales
		From EmployeeTimeSheet as ts
LEFT OUTER JOIN EmployeeJob as ej ON ts.PositionID = ej.PositionID AND ts.EmployeeID = ej.EmployeeID and ts.StoreID=ej.StoreID
LEFT OUTER JOIN Position as p ON ts.PositionID =p.ID and p.StoreID=ts.StoreID
LEFT OUTER JOIN Employee as e ON ts.EmployeeID = e.ID and ts.StoreID=e.StoreID
inner join Store s on s.ID=ts.StoreID 
		where ts.BusinessDate between @BeginDate and @EndDate and ts.StoreID=@storeID
		GROUP BY p.Name,ts.StoreID
		
		union
		select p.Name PositionName,0,SUM((Price-AdjustedPrice)*Qty) sales  from OrderLineItem oli inner join [Order] o 
		on o.BusinessDate=oli.BusinessDate and o.ID=oli.OrderID and o.StoreID=oli.storeid 
		inner join EmployeeTimeSheet et on et.EmployeeID=o.EmpIDClose and o.CloseTime between  timein and case when TimeOut='1900-01-01 00:00:00.000' or TimeOut IS null then DATEADD(DAY,1,timein) else TimeOut end 
		and et.StoreID=o.StoreID and et.BusinessDate=o.BusinessDate
		inner join position p on p.ID=et.PositionID and p.StoreID=et.StoreID
		where oli.BusinessDate  between @BeginDate and @EndDate  and oli.StoreID=@storeID
		and oli.status='CLOSE'
		GROUP BY p.Name,et.StoreID) b group by PositionName
end
end


GO
