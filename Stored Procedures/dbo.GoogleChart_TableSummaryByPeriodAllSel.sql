SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GoogleChart_TableSummaryByPeriodAllSel]
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
	delete from GoogleChartTableSummaryByPeriodAll where storeID=@storeID
	insert into GoogleChartTableSummaryByPeriodAll
		Select @storeID,
		o.SaleGroup as MealPriod,    
		case when datepart(m, o.BusinessDate)=1 then 'Jan'       
		when datepart(m, o.BusinessDate)=2 then 'Feb'       
		when datepart(m, o.BusinessDate)=3 then 'March'      
		when datepart(m, o.BusinessDate)=4 then 'April'      
		when datepart(m, o.BusinessDate)=5 then 'May'      
		when datepart(m, o.BusinessDate)=6 then 'June'      
		when datepart(m, o.BusinessDate)=7 then 'July'      
		when datepart(m, o.BusinessDate)=8 then 'Aug'      
		when datepart(m, o.BusinessDate)=9 then 'Sep'      
		when datepart(m, o.BusinessDate)=10 then 'Oct'      
		when datepart(m, o.BusinessDate)=11 and 
		DATEPART(YEAR,o.BusinessDate)=DATEPART(YEAR,GETDATE()) then 'Nov'      
		when datepart(m, o.BusinessDate)=12 and 
		DATEPART(YEAR,o.BusinessDate)=DATEPART(YEAR,GETDATE())then 'Dec'      
		when datepart(m, o.BusinessDate)=11 and 
		DATEPART(YEAR,o.BusinessDate)=DATEPART(YEAR,DATEADD(year,-1, GETDATE())) then 'Nov'      
		when datepart(m, o.BusinessDate)=12 and 
		DATEPART(YEAR,o.BusinessDate)=DATEPART(YEAR,DATEADD(year,-1, GETDATE())) then 'Dec' end period ,
		convert(char(7),o.BusinessDate,120) as BusinessDate ,
		count(o.ID) as NumTables , 
		'MONTH'
		From (select *,isnull((select Name from MealPeriod where StoreID=o.StoreID  
			and (case when		
				(EndTime>beginTime and (o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+' '+ CONVERT(nvarchar(20), beginTime,8) 
				and CONVERT(nvarchar(20), o.OpenTime,102) +' '+ CONVERT(nvarchar(20), EndTime,8)) ) 

			or (EndTime< beginTime and o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+' '+ CONVERT(nvarchar(20), BeginTime,8) 
			and CONVERT(nvarchar(20), o.OpenTime,102)+' 23:59:59') 
			or 
			(EndTime< beginTime and o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+' 00:00:00' 
			and CONVERT(nvarchar(20), o.OpenTime,102)+' '+CONVERT(nvarchar(20), EndTime,8)) 

			then 1 end )=1 
			 and DATEPART(WEEKDAY,o.OpenTime)=
			(case when [DayOfWeek]='SUNDAY' then 1
			when [DayOfWeek]='MONDAY' then 2
			when [DayOfWeek]='TUESDAY' then 3
			when [DayOfWeek]='WEDNESDAY' then 4
			when [DayOfWeek]='THURSDAY' then 5
			when [DayOfWeek]='FRIDAY' then 6
			when [DayOfWeek]='SATURDAY' then 7 end)),MealPeriod) SaleGroup  from [Order] o where BusinessDate between @monthBeginDate and @endDate and StoreID=@storeID and o.Status='Close') as o   
		group by SaleGroup ,convert(char(7),O.BusinessDate,120) ,
		datepart(m, o.BusinessDate),
		DATEPART(YEAR,o.BusinessDate)
		
	insert into GoogleChartTableSummaryByPeriodAll
		Select @storeID,
		o.SaleGroup as MealPriod,    
		case when DATEPART(WEEKDAY,O.BusinessDate)=1 then 'SUNDAY'         
		when DATEPART(WEEKDAY,O.BusinessDate)=2 then 'MONDAY'         
		when DATEPART(WEEKDAY,O.BusinessDate)=3 then 'TUESDAY'         
		when DATEPART(WEEKDAY,O.BusinessDate)=4 then 'WEDNESDAY'         
		when DATEPART(WEEKDAY,O.BusinessDate)=5 then 'THURSDAY'         
		when DATEPART(WEEKDAY,O.BusinessDate)=6 then 'FRIDAY'         
		when DATEPART(WEEKDAY,O.BusinessDate)=7 then 'SATURDAY' end period,
		convert(char(10),O.BusinessDate,120) as BusinessDate , 
		count(o.ID) as NumTables , 
		'DAY'
		From (select *,isnull((select Name from MealPeriod where StoreID=o.StoreID  
			and (case when		
				(EndTime>beginTime and (o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+' '+ CONVERT(nvarchar(20), beginTime,8) 
				and CONVERT(nvarchar(20), o.OpenTime,102) +' '+ CONVERT(nvarchar(20), EndTime,8)) ) 

			or (EndTime< beginTime and o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+' '+ CONVERT(nvarchar(20), BeginTime,8) 
			and CONVERT(nvarchar(20), o.OpenTime,102)+' 23:59:59') 
			or 
			(EndTime< beginTime and o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+' 00:00:00' 
			and CONVERT(nvarchar(20), o.OpenTime,102)+' '+CONVERT(nvarchar(20), EndTime,8)) 

			then 1 end )=1 
			 and DATEPART(WEEKDAY,o.OpenTime)=
			(case when [DayOfWeek]='SUNDAY' then 1
			when [DayOfWeek]='MONDAY' then 2
			when [DayOfWeek]='TUESDAY' then 3
			when [DayOfWeek]='WEDNESDAY' then 4
			when [DayOfWeek]='THURSDAY' then 5
			when [DayOfWeek]='FRIDAY' then 6
			when [DayOfWeek]='SATURDAY' then 7 end)),MealPeriod) SaleGroup   from [Order] o where BusinessDate between @dayBeginDate and @dayEndDate and StoreID=@storeID  and o.Status='Close') as o   
		group by SaleGroup ,convert(char(10),O.BusinessDate,120) ,datepart(WEEKDAY, o.BusinessDate)
END
GO
