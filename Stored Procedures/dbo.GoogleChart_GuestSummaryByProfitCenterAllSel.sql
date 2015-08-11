SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GoogleChart_GuestSummaryByProfitCenterAllSel]
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
	delete from GoogleChartGuestSummaryByProfitCenterAll where storeID=@storeID
	insert into GoogleChartGuestSummaryByProfitCenterAll
		Select @storeID,
		o.RevenueCenter,    
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
		sum(o.GuestCount) as NumGuest,
		'MONTH'
		From 
		[Order] as o where o.BusinessDate between @monthBeginDate and @endDate and o.StoreID=@storeID
		and Status='Close'
		group by o.RevenueCenter ,convert(char(7),O.BusinessDate,120),
		datepart(m, o.BusinessDate),DATEPART(YEAR,o.BusinessDate)

insert into GoogleChartGuestSummaryByProfitCenterAll
		Select @storeID,
		o.RevenueCenter,        
		case when DATEPART(WEEKDAY,O.BusinessDate)=1 then 'SUNDAY'
		when DATEPART(WEEKDAY,O.BusinessDate)=2 then 'MONDAY'         
		when DATEPART(WEEKDAY,O.BusinessDate)=3 then 'TUESDAY'         
		when DATEPART(WEEKDAY,O.BusinessDate)=4 then 'WEDNESDAY'         
		when DATEPART(WEEKDAY,O.BusinessDate)=5 then 'THURSDAY'         
		when DATEPART(WEEKDAY,O.BusinessDate)=6 then 'FRIDAY'         
		when DATEPART(WEEKDAY,O.BusinessDate)=7 then 'SATURDAY' end period,
		convert(char(10),O.BusinessDate,120) as BusinessDate ,
		sum(o.GuestCount) as NumGuest,
		'DAY'
		from [Order] as o where o.BusinessDate between @dayBeginDate and @dayEndDate and o.StoreID=@storeID
		and Status='Close'
		group by o.RevenueCenter ,convert(char(10),O.BusinessDate,120),datepart(WEEKDAY, o.BusinessDate)
END
GO
