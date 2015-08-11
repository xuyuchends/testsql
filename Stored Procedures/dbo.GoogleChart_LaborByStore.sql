SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GoogleChart_LaborByStore]
	@storeID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @endDate as datetime
	declare @monthBeginDate as datetime
	declare @dayBeginDate as datetime
	
	declare @dayEndDate as datetime
	set @endDate=CONVERT(nvarchar(20), datepart(year,getdate()))+'-12-31'
	set @monthBeginDate=convert(nvarchar(10),datepart(year,DATEAdd(YEAR,-1, getdate()))) +'-11-01' 
	set @dayBeginDate=DATEADD(day,-6,DATEADD(day, DATEDIFF(day,0,GETDATE()),0))
	set @dayEndDate=CONVERT(nvarchar(20), GETDATE(),101)
	delete from GoogleChartLaborByStore where storeID=@storeID
	insert into GoogleChartLaborByStore
		SELECT storeid,
		case when datepart(m, BusinessDate)=1 then 'Jan'       
		when datepart(m, BusinessDate)=2 then 'Feb'       
		when datepart(m, BusinessDate)=3 then 'March'      
		when datepart(m, BusinessDate)=4 then 'April'      
		when datepart(m, BusinessDate)=5 then 'May'      
		when datepart(m, BusinessDate)=6 then 'June'      
		when datepart(m, BusinessDate)=7 then 'July'      
		when datepart(m, BusinessDate)=8 then 'Aug'      
		when datepart(m, BusinessDate)=9 then 'Sep'      
		when datepart(m, BusinessDate)=10 then 'Oct'     
		when datepart(m, BusinessDate)=11 and 
		DATEPART(YEAR,BusinessDate)=DATEPART(YEAR,GETDATE()) then 'Nov'      
		when datepart(m, BusinessDate)=12 and 
		DATEPART(YEAR,BusinessDate)=DATEPART(YEAR,GETDATE())then 'Dec'      
		when datepart(m, BusinessDate)=11 and 
		DATEPART(YEAR,BusinessDate)=DATEPART(YEAR,DATEADD(year,-1, GETDATE())) then 'Nov'      
		when datepart(m, BusinessDate)=12 and 
		DATEPART(YEAR,BusinessDate)=DATEPART(YEAR,DATEADD(year,-1, GETDATE())) then 'Dec' end period ,
		convert(char(7),BusinessDate,120) as BusinessDate ,CONVERT(decimal(18,2), SUM(TotalPay)) TotalPay,CONVERT(decimal(18,2), SUM(Sales)) Sales,SUM(LaborPercent) LaborPercent,Type
		from ( SELECT @storeID storeid,
	ts.BusinessDate,
		SUM(ts.PayRate * ts.HoursWorked)+SUM(ts.OT1HoursWorked * ts.OT1Payrate+ts.OT2HoursWorked  * ts.OT2Payrate)as TotalPay , 
		0 Sales,
		0 LaborPercent,'MONTH'   Type
		From EmployeeTimeSheet as ts
LEFT OUTER JOIN EmployeeJob as ej ON ts.PositionID = ej.PositionID AND ts.EmployeeID = ej.EmployeeID and ts.StoreID=ej.StoreID
LEFT OUTER JOIN Position as p ON ts.PositionID =p.ID and p.StoreID=ts.StoreID
LEFT OUTER JOIN Employee as e ON ts.EmployeeID = e.ID and ts.StoreID=e.StoreID
inner join Store s on s.ID=ts.StoreID 
		where ts.BusinessDate between @monthBeginDate and @endDate and ts.StoreID=@storeID
		GROUP BY BusinessDate,ts.StoreID
		
		union 
		 select @storeID storeid,BusinessDate, 0 TotalPay,SUM((Price-AdjustedPrice)*Qty) Sales ,0 LaborPercent,'MONTH' Type
		  from OrderLineItem where BusinessDate  between @monthBeginDate and @endDate and StoreID=@storeID
		  and Status='CLOSE'
		 group by BusinessDate ,StoreID
		 ) b  group by convert(char(7),BusinessDate,120),
		datepart(m, BusinessDate),DATEPART(YEAR,BusinessDate),StoreID,type
	
	insert into GoogleChartLaborByStore
		SELECT storeid,
		case when DATEPART(WEEKDAY,BusinessDate)=1 then 'SUNDAY'         
		when DATEPART(WEEKDAY,BusinessDate)=2 then 'MONDAY'         
		when DATEPART(WEEKDAY,BusinessDate)=3 then 'TUESDAY'         
		when DATEPART(WEEKDAY,BusinessDate)=4 then 'WEDNESDAY'         
		when DATEPART(WEEKDAY,BusinessDate)=5 then 'THURSDAY'         
		when DATEPART(WEEKDAY,BusinessDate)=6 then 'FRIDAY'         
		when DATEPART(WEEKDAY,BusinessDate)=7 then 'SATURDAY' end period,
		convert(char(10),BusinessDate,120) as BusinessDate ,CONVERT(decimal(18,2), SUM(TotalPay)) TotalPay,CONVERT(decimal(18,2), SUM(Sales)) Sales,SUM(LaborPercent) LaborPercent,Type
		from ( SELECT @storeID storeid,
	ts.BusinessDate,
		SUM(ts.PayRate * ts.HoursWorked)+SUM(ts.OT1HoursWorked * ts.OT1Payrate+ts.OT2HoursWorked  * ts.OT2Payrate)as TotalPay , 
		0 Sales,
		0 LaborPercent,'DAY'   Type
		From EmployeeTimeSheet as ts
LEFT OUTER JOIN EmployeeJob as ej ON ts.PositionID = ej.PositionID AND ts.EmployeeID = ej.EmployeeID and ts.StoreID=ej.StoreID
LEFT OUTER JOIN Position as p ON ts.PositionID =p.ID and p.StoreID=ts.StoreID
LEFT OUTER JOIN Employee as e ON ts.EmployeeID = e.ID and ts.StoreID=e.StoreID
inner join Store s on s.ID=ts.StoreID 
		where ts.BusinessDate between @dayBeginDate and @dayEndDate and ts.StoreID=@storeID
		GROUP BY BusinessDate,ts.StoreID
		
		union 
		 select @storeID storeid,BusinessDate, 0 TotalPay,SUM((Price-AdjustedPrice)*Qty) Sales ,0 LaborPercent,'DAY' Type
		  from OrderLineItem where BusinessDate  between @dayBeginDate and @dayEndDate and StoreID=@storeID
		  and Status='CLOSE'
		 group by BusinessDate ,StoreID
		 ) b  group by convert(char(10),BusinessDate,120),datepart(WEEKDAY,BusinessDate),StoreID,type
END
GO
