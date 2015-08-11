SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_D_GorssSalesByPeriodByDay]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200)
AS  
BEGIN
declare @sql nvarchar(max)
SET NOCOUNT ON;

set @sql='
SELECT o1.dayPart as MealPriod, 
		SUM(OI.Qty * OI.Price) AS GrossSales
		FROM OrderLineItem AS OI INNER JOIN (select *,isnull((select Name from MealPeriod where StoreID=o.StoreID  
			and (case when		
				(EndTime>beginTime and (o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+'' ''+ CONVERT(nvarchar(20), beginTime,8) 
				and CONVERT(nvarchar(20), o.OpenTime,102) +'' ''+ CONVERT(nvarchar(20), EndTime,8)) ) 

			or (EndTime< beginTime and o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+'' ''+ CONVERT(nvarchar(20), BeginTime,8) 
			and CONVERT(nvarchar(20), o.OpenTime,102)+'' 23:59:59'') 
			or 
			(EndTime< beginTime and o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+'' 00:00:00'' 
			and CONVERT(nvarchar(20), o.OpenTime,102)+'' ''+CONVERT(nvarchar(20), EndTime,8)) 

			then 1 end )=1 
			 and DATEPART(WEEKDAY,o.OpenTime)=
			(case when [DayOfWeek]=''SUNDAY'' then 1
			when [DayOfWeek]=''MONDAY'' then 2
			when [DayOfWeek]=''TUESDAY'' then 3
			when [DayOfWeek]=''WEDNESDAY'' then 4
			when [DayOfWeek]=''THURSDAY'' then 5
			when [DayOfWeek]=''FRIDAY'' then 6
			when [DayOfWeek]=''SATURDAY'' then 7 end)),MealPeriod) as dayPart  from [Order] o) AS O1 
		ON OI.OrderID = O1.ID AND O1.StoreID = OI.StoreID AND O1.BusinessDate = OI.BusinessDate 
		INNER JOIN MenuItem AS MI 
		ON OI.ItemID = MI.ID AND MI.ReportCategory <> '''' AND 
	MI.ReportCategory IS NOT NULL and OI.SI<>''N/A'' AND MI.StoreID = O1.StoreID
WHERE MI.MIType NOT IN (''GC'', ''IHPYMNT'') and oi.BusinessDate between '''+CONVERT(nvarchar(20),@BeginDate)+''' and '''+CONVERT(nvarchar(20),@EndDate)+''' 
and oi.StoreID in ('+@storeID+') and oi.status=''CLOSE'' and OI.RecordType<>''VOID'''
set @sql +=' GROUP BY o1.dayPart'

--select @sql
exec sp_executesql @sql
end



GO
