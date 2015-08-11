SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GoogleChart_SalesByStoreALLSel]
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
	delete from GoogleChartSalesByStoreALL where storeID=@storeID
	insert into GoogleChartSalesByStoreALL
		SELECT @storeID,   
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
		SUM(isnull(OI.Qty * OI.Price,0)) AS Sales , 
		'MONTH',
		'GROSSSALES' from
		OrderLineItem as OI    
		INNER JOIN MenuItem AS MI ON OI.ItemID = MI.ID  AND MI.StoreID = OI.StoreID   
		Where oi.BusinessDate between @monthBeginDate and @endDate and oi.StoreID=@storeID and  MI.MIType NOT IN ('GC', 'IHPYMNT') AND MI.ReportDepartment <> 'MODIFIER' and OI.SI<>'N/A'
		and oi.Status='Close'
		GROUP BY convert(char(7),OI.BusinessDate,120),
		datepart(m, OI.BusinessDate),DATEPART(YEAR,OI.BusinessDate)
	
	insert into GoogleChartSalesByStoreALL
		SELECT @storeID,  
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
		SUM(isnull(OI.Qty * (OI.Price-OI.AdjustedPrice),0)) AS Sales ,  
		'MONTH',
		'NETSALES' from
		OrderLineItem as OI    
		INNER JOIN MenuItem AS MI ON OI.ItemID = MI.ID  AND MI.StoreID = OI.StoreID  
		Where oi.BusinessDate between @monthBeginDate and @endDate and oi.StoreID=@storeID and MI.MIType NOT IN ('GC', 'IHPYMNT')  AND MI.ReportDepartment <> 'MODIFIER' and OI.SI<>'N/A'
		and oi.Status='Close'
		GROUP BY convert(char(7),OI.BusinessDate,120) ,
		datepart(m, OI.BusinessDate) ,DATEPART(YEAR,OI.BusinessDate)
	
	insert into GoogleChartSalesByStoreALL
		SELECT @storeID, 
		case when DATEPART(WEEKDAY,OI.BusinessDate)=1 then 'SUNDAY'         
		when DATEPART(WEEKDAY,OI.BusinessDate)=2 then 'MONDAY'         
		when DATEPART(WEEKDAY,OI.BusinessDate)=3 then 'TUESDAY'         
		when DATEPART(WEEKDAY,OI.BusinessDate)=4 then 'WEDNESDAY'         
		when DATEPART(WEEKDAY,OI.BusinessDate)=5 then 'THURSDAY'         
		when DATEPART(WEEKDAY,OI.BusinessDate)=6 then 'FRIDAY'         
		when DATEPART(WEEKDAY,OI.BusinessDate)=7 then 'SATURDAY' end period,
		convert(char(10),OI.BusinessDate,120) as BusinessDate,
		SUM(isnull(OI.Qty * OI.Price,0)) AS Sales ,
		'DAY', 
		'GROSSSALES' FROM 
		OrderLineItem as OI      
		INNER JOIN MenuItem AS MI ON OI.ItemID = MI.ID AND MI.StoreID = OI.StoreID   
		Where oi.BusinessDate between @dayBeginDate and @dayEndDate and oi.StoreID=@storeID and MI.MIType NOT IN ('GC', 'IHPYMNT') AND MI.ReportDepartment <> 'MODIFIER' and OI.SI<>'N/A'   
		and oi.Status='Close'
		GROUP BY convert(char(10),OI.BusinessDate,120),datepart(WEEKDAY,OI.BusinessDate) 
   
    insert into GoogleChartSalesByStoreALL
		SELECT @storeID,
		case when DATEPART(WEEKDAY,OI.BusinessDate)=1 then 'SUNDAY'         
		when DATEPART(WEEKDAY,OI.BusinessDate)=2 then 'MONDAY'         
		when DATEPART(WEEKDAY,OI.BusinessDate)=3 then 'TUESDAY'         
		when DATEPART(WEEKDAY,OI.BusinessDate)=4 then 'WEDNESDAY'         
		when DATEPART(WEEKDAY,OI.BusinessDate)=5 then 'THURSDAY'         
		when DATEPART(WEEKDAY,OI.BusinessDate)=6 then 'FRIDAY'         
		when DATEPART(WEEKDAY,OI.BusinessDate)=7 then 'SATURDAY' end period,
		convert(char(10),OI.BusinessDate,120) as BusinessDate,
		SUM(isnull(OI.Qty * (OI.Price-OI.AdjustedPrice),0)) AS Sales ,
		'DAY',
		'NETSALES'  FROM OrderLineItem as OI
		INNER JOIN MenuItem AS MI ON OI.ItemID = MI.ID AND MI.StoreID = OI.StoreID   
		Where oi.BusinessDate between @dayBeginDate and @dayEndDate and oi.StoreID=@storeID and MI.MIType NOT IN ('GC', 'IHPYMNT')  AND MI.ReportDepartment <> 'MODIFIER' and OI.SI<>'N/A' 
		and oi.Status='Close'
		GROUP BY convert(char(10),OI.BusinessDate,120) ,datepart(WEEKDAY,OI.BusinessDate) 

END
GO
