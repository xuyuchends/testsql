SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GoogleChart_GrossSalesByProfitCenterSel]
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
	delete from GoogleChartGrossSalesByProfitCenter where storeID=@storeID
	insert into GoogleChartGrossSalesByProfitCenter
		Select @storeID,o.RevenueCenter as RevenueCenter,    
		case when datepart(m, OI.BusinessDate)=1 then 'Jan'       
		when datepart(m, OI.BusinessDate)=2 then 'Feb'      
		when datepart(m, OI.BusinessDate)=3 then 'March'      
		when datepart(m, OI.BusinessDate)=4 then 'April'      
		when datepart(m, OI.BusinessDate)=5 then 'May'      
		when datepart(m, OI.BusinessDate)=6 then 'June'      
		when datepart(m, OI.BusinessDate)=7 then 'July'      
		when datepart(m, OI.BusinessDate)=8 then 'Aug'      
		when datepart(m, OI.BusinessDate)=9 then 'Sep'      
		when datepart(m, OI.BusinessDate)=10 then 'Oct'    
		when datepart(m, OI.BusinessDate)=11 and 
		DATEPART(YEAR,OI.BusinessDate)=DATEPART(YEAR,GETDATE()) then 'Nov'      
		when datepart(m, OI.BusinessDate)=12 and 
		DATEPART(YEAR,OI.BusinessDate)=DATEPART(YEAR,GETDATE())then 'Dec'      
		when datepart(m, OI.BusinessDate)=11 and 
		DATEPART(YEAR,OI.BusinessDate)=DATEPART(YEAR,DATEADD(year,-1, GETDATE())) then 'Nov'      
		when datepart(m, OI.BusinessDate)=12 and 
		DATEPART(YEAR,OI.BusinessDate)=DATEPART(YEAR,DATEADD(year,-1, GETDATE())) then 'Dec' end period ,
		convert(char(7),OI.BusinessDate,120) as BusinessDate ,
		isnull(SUM(OI.qty * OI.price),0) as GrossSales,'MONTH'  From 
		OrderLineItem as oi inner join [Order] as o
		ON OI.orderid = O.ID and OI.StoreID=O.StoreID and oi.BusinessDate=O.BusinessDate    
		LEFT JOIN MenuItem MI ON OI.itemid = MI.ID and o.StoreID=MI.StoreID    
		Where oi.BusinessDate between @monthBeginDate and @endDate and oi.StoreID=@storeID 
		and o.BusinessDate between @monthBeginDate and @endDate 
		and si <> 'N/A'  AND MI.Category <> ''    AND MI.Category IS NOT NULL  and MI.MIType NOT IN ('GC', 'IHPYMNT')  
		and OI.Status='Close' and O.Status='Close'  and oi.RecordType<>'VOID'
		Group By o.RevenueCenter ,convert(char(7),OI.BusinessDate,120),datepart(m, OI.BusinessDate) 
	,DATEPART(YEAR,OI.BusinessDate)
	
	insert into GoogleChartGrossSalesByProfitCenter
	    Select @storeID,o.RevenueCenter as RevenueCenter,
		case when DATEPART(WEEKDAY,OI.BusinessDate)=1 then 'SUNDAY'        
		when DATEPART(WEEKDAY,OI.BusinessDate)=2 then 'MONDAY'         
		when DATEPART(WEEKDAY,OI.BusinessDate)=3 then 'TUESDAY'         
		when DATEPART(WEEKDAY,OI.BusinessDate)=4 then 'WEDNESDAY'         
		when DATEPART(WEEKDAY,OI.BusinessDate)=5 then 'THURSDAY'         
	    when DATEPART(WEEKDAY,OI.BusinessDate)=6 then 'FRIDAY'         
		when DATEPART(WEEKDAY,OI.BusinessDate)=7 then 'SATURDAY' end period,
		convert(char(10),OI.BusinessDate,120) as BusinessDate,  
		isnull(SUM(OI.qty * OI.price),0) as GrossSales,'DAY'  From 
		OrderLineItem as oi inner join [Order] as o
		ON OI.orderid = O.ID and OI.StoreID=O.StoreID   and oi.BusinessDate=o.BusinessDate
	    LEFT JOIN MenuItem MI ON OI.itemid = MI.ID and o.StoreID=MI.StoreID    
		Where oi.BusinessDate between @dayBeginDate and @dayEndDate and oi.StoreID=@storeID 
		and o.BusinessDate between @dayBeginDate and @dayEndDate 
		and si <> 'N/A'  AND MI.Category <> ''    AND MI.Category IS NOT NULL  and MI.MIType NOT IN ('GC', 'IHPYMNT') 
		and OI.Status='Close' and O.Status='Close'   and oi.RecordType<>'VOID'
		Group By o.RevenueCenter , convert(char(10),OI.BusinessDate,120),datepart(WEEKDAY,OI.BusinessDate) 
END


GO
