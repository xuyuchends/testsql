SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fn_GetMealPeriod1]
 
 (
	@StoreId nvarchar(2000),
	@Type nvarchar(20)
 )  
 
 RETURNS nvarchar(100)
 
 AS  
 
 BEGIN 
 	declare @Name varchar(100)
    declare @retValue nvarchar(100)
    set @retValue=''
    declare @beginTime datetime
    declare @endTime datetime
    declare @TimePeriodEnd datetime
	select @TimePeriodEnd=dbo.[fn_GetDashboardTimePeriod](@storeID)
	if CONVERT(datetime, CONVERT(nvarchar(20), GETDATE(),102))<=GETDATE() and getdate()<=CONVERT(datetime, CONVERT(nvarchar(20), GETDATE(),102))+@TimePeriodEnd
	begin
		set @beginTime=CONVERT(datetime, CONVERT(nvarchar(20),DATEADD(day,-1,getdate()),102))
		set @endTime=CONVERT(datetime, CONVERT(nvarchar(20),DATEADD(day,-1,getdate()),102))
	end
	else
	begin
		set @beginTime=CONVERT(datetime, CONVERT(nvarchar(20),getdate(),102))
		set @endTime=CONVERT(datetime, CONVERT(nvarchar(20),getdate(),102))
	end
  if @Type='MONTH' 
  begin
	  set   @beginTime=CONVERT(datetime,(CONVERT(nvarchar(20), DATEPART(year,@beginTime)) +'-01-01')) 
	end       
  else if @Type='Quarter' 
  begin
	set @beginTime=CONVERT(datetime,CONVERT(nvarchar(20), DATEPART(year,'2014-8-1')) +'-'+convert(nvarchar(20), DATEPART(month,'2014-8-1')-2)+'-01') 
   end  
  else if @Type='Day'
  begin  
		set @beginTime=CONVERT(datetime,CONVERT(nvarchar(20), dateadd(day,-6,@beginTime))) 
  end
declare cur cursor read_only for 
select distinct name from (
select distinct dayPart name from (select *,
  isnull((select Name from MealPeriod where StoreID=o.StoreID       
  and (case when        
  (EndTime>beginTime and (o.OpenTime between 
  CONVERT(nvarchar(20), o.OpenTime,102)+' '+ 
  CONVERT(nvarchar(20), beginTime,8)       
  and CONVERT(nvarchar(20), o.OpenTime,102) +' '+ 
  CONVERT(nvarchar(20), EndTime,8)) )        
  or (EndTime< beginTime and o.OpenTime between 
  CONVERT(nvarchar(20), o.OpenTime,102)+' '+ 
  CONVERT(nvarchar(20), BeginTime,8)      and 
  CONVERT(nvarchar(20), o.OpenTime,102)+' 23:59:59')      or      
  (EndTime< beginTime and o.OpenTime between 
  CONVERT(nvarchar(20), o.OpenTime,102)+' 00:00:00'      
  and CONVERT(nvarchar(20), o.OpenTime,102)+' '+
  CONVERT(nvarchar(20), EndTime,8))        then 1 end )=1       
  and DATEPART(WEEKDAY,o.OpenTime)=     
  (case when [DayOfWeek]='SUNDAY' then 1     
  when [DayOfWeek]='MONDAY' then 2     when [DayOfWeek]='TUESDAY' then 3     
  when [DayOfWeek]='WEDNESDAY' then 4     when [DayOfWeek]='THURSDAY' then 5
  when [DayOfWeek]='FRIDAY' then 6     when [DayOfWeek]='SATURDAY' then 7 end))
  ,MealPeriod) as dayPart  from [Order] o where BusinessDate between @beginTime and @endTime) b where Storeid in (select * from dbo.f_split(@StoreID,','))
  union 
  select distinct Name from MealPeriod 
  )
  a
open cur
fetch next from cur into @Name
while(@@fetch_status=0)

begin
	if ISNULL(@retValue,'')=''
	begin
	set @retValue=@retValue+'['+@Name+']'
	end
	else
	begin
		set @retValue=@retValue+','+'['+@Name+']'
	end
fetch next from cur into @Name
end
close cur
deallocate cur
 
 	RETURN @retValue
 
 END
GO
