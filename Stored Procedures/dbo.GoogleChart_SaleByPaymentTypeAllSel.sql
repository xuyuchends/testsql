SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GoogleChart_SaleByPaymentTypeAllSel]
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

	delete from GoogleChartSaleByPaymentTypeAll where storeID=@storeID
	insert into GoogleChartSaleByPaymentTypeAll
		SELECT @storeID,
		pm.Name as Payment,    
		case when datepart(m, p.BusinessDate)=1 then 'Jan'       
		when datepart(m, p.BusinessDate)=2 then 'Feb'       
		when datepart(m, p.BusinessDate)=3 then 'March'      
		when datepart(m, p.BusinessDate)=4 then 'April'      
		when datepart(m, p.BusinessDate)=5 then 'May'      
		when datepart(m, p.BusinessDate)=6 then 'June'      
		when datepart(m, p.BusinessDate)=7 then 'July'      
		when datepart(m, p.BusinessDate)=8 then 'Aug'      
		when datepart(m, p.BusinessDate)=9 then 'Sep'      
		when datepart(m, p.BusinessDate)=10 then 'Oct'     
		when datepart(m, p.BusinessDate)=11 and 
		DATEPART(YEAR,p.BusinessDate)=DATEPART(YEAR,GETDATE()) then 'Nov'      
		when datepart(m, p.BusinessDate)=12 and 
		DATEPART(YEAR,p.BusinessDate)=DATEPART(YEAR,GETDATE())then 'Dec'      
		when datepart(m, p.BusinessDate)=11 and 
		DATEPART(YEAR,p.BusinessDate)=DATEPART(YEAR,DATEADD(year,-1, GETDATE())) then 'Nov'      
		when datepart(m, p.BusinessDate)=12 and 
		DATEPART(YEAR,p.BusinessDate)=DATEPART(YEAR,DATEADD(year,-1, GETDATE())) then 'Dec' end period ,
		convert(char(7),p.BusinessDate,120) as BusinessDate ,
		SUM(isnull(p.Amount,0)) AS Sales,
		'MONTH'  
		FROM  Payment as p 
		INNER JOIN PaymentMethod AS pm ON p.MethodID = pm.Name AND pm.StoreID = p.StoreID  
		where p.BusinessDate between @monthBeginDate and @endDate and p.StoreID=@storeID
		and p.Status='Closed'
		GROUP BY pm.Name ,convert(char(7),p.BusinessDate,120),
		datepart(m, p.BusinessDate),DATEPART(YEAR,p.BusinessDate)
	
	insert into GoogleChartSaleByPaymentTypeAll
		SELECT @storeID,
		pm.Name as PaymentName,
		case when DATEPART(WEEKDAY,p.BusinessDate)=1 then 'SUNDAY'         
		when DATEPART(WEEKDAY,p.BusinessDate)=2 then 'MONDAY'         
		when DATEPART(WEEKDAY,p.BusinessDate)=3 then 'TUESDAY'         
		when DATEPART(WEEKDAY,p.BusinessDate)=4 then 'WEDNESDAY'         
		when DATEPART(WEEKDAY,p.BusinessDate)=5 then 'THURSDAY'         
		when DATEPART(WEEKDAY,p.BusinessDate)=6 then 'FRIDAY'         
		when DATEPART(WEEKDAY,p.BusinessDate)=7 then 'SATURDAY' end period,
		convert(char(10),p.BusinessDate,120) as BusinessDate ,  
		SUM(isnull(p.Amount,0)) AS Sales,
		'DAY'
	    FROM  Payment as p    
		INNER JOIN PaymentMethod AS pm ON p.MethodID = pm.Name AND pm.StoreID = p.StoreID  
		where p.BusinessDate between @dayBeginDate and @dayEndDate and p.StoreID=@storeID
		and p.Status='Closed'
		GROUP BY pm.Name ,convert(char(10),p.BusinessDate,120),datepart(WEEKDAY,p.BusinessDate)
END
GO
