SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_D_NumGuestByPeriodByDay]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200)
AS  
BEGIN
declare @sql nvarchar(max)
SET NOCOUNT ON;

set @sql='Select o1.dayPart MealPriod,
	--count(o1.ID) as NumTables
	sum(o1.GuestCount) as NumGuest   
	From (select *,isnull((select Name from MealPeriod where StoreID=o.StoreID  
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
			when [DayOfWeek]=''SATURDAY'' then 7 end)),MealPeriod) as dayPart  from [Order] o) as o1 
	where o1.BusinessDate between '''+CONVERT(nvarchar(20),@BeginDate)+''' and 
	'''+CONVERT(nvarchar(20),@EndDate)+''' and o1.StoreID in ('+@storeID+')
	and o1.status=''CLOSE'''
set @sql+=' GROUP BY o1.dayPart '

--select @sql
exec sp_executesql @sql
end
GO
