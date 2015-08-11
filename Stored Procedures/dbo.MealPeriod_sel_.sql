SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[MealPeriod_sel_]
@StoreID nvarchar(200),
@Name nvarchar(50),
@ID int ,
@type int
as
begin
	set nocount on
	declare @Separator char(1)
		declare @Input nvarchar(200)
		declare @sql1 nvarchar(max)
		declare @count int
		declare @Index int, @Entry nvarchar(max)
	declare @sql nvarchar(max)
	if @type=1
	begin
		if ISNULL(@StoreID,'')<>''
		begin
		

		set @Separator=','
		set @Input=@StoreID+','
		set @count=1
		set @sql1=''
		
		set @Index = charindex(@Separator,@Input)

		while (@Index>0)
		begin
			set @Entry=ltrim(rtrim(substring(@Input, 1, @Index-1)))
	        
			if @Entry<>''
			begin
				set @sql1=@sql1+' and name in(select name from MealPeriod where StoreID='+@Entry+'   and BeginTime=m.BeginTime and datepart(hh, EndTime)=datepart(hh,m.EndTime) and datepart(mi, EndTime)=datepart(mi,m.EndTime))'
			end

			set @Input = substring(@Input, @Index+datalength(@Separator)/2+1, len(@Input))
			set @Index = charindex(@Separator, @Input)
			set @count=@count+1
		end
		 set @sql=' 
		 select Name,max(SUNDAY) as Sun,max(MONDAY) as Mon,max(TUESDAY) as Tue,max(WEDNESDAY) as Wed,
 max(THURSDAY) as Thu,max(FRIDAY) as Fri,max(SATURDAY) as Sat 
 from  (select [StoreID]
			  ,[ID]
			  ,[Name]
			  ,[BeginTime]
			  ,[EndTime]
			   ,convert(nvarchar(20),[BeginTime],8) +''-''+convert(nvarchar(20),(case when DATEPART(SS,[EndTime])=59 then  dateadd(second,1,[EndTime]) when DATEPART(SS,[EndTime])=0 then dateadd(MI,1,[EndTime]) end),8) as [Time]
			  ,[DayOfWeek]
			  ,[LastUpdate]   from MealPeriod m where StoreID in ('+@StoreID+') '+@sql1+') a pivot (max([Time])
  for [DayOfWeek] in (SUNDAY,MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY)) b group by name'
		end
		else
		begin
			set @sql=' 
		 select Name,max(SUNDAY) as Sun,max(MONDAY) as Mon,max(TUESDAY) as Tue,max(WEDNESDAY) as Wed,
 max(THURSDAY) as Thu,max(FRIDAY) as Fri,max(SATURDAY) as Sat 
 from  (select [StoreID]
			  ,[ID]
			  ,[Name]
			  ,[BeginTime]
			  ,[EndTime]
			   ,convert(nvarchar(20),[BeginTime],8) +''-''+convert(nvarchar(20),(case when DATEPART(SS,[EndTime])=59 then  dateadd(second,1,[EndTime]) when DATEPART(SS,[EndTime])=0 then dateadd(MI,1,[EndTime]) end),8) as [Time]
			  ,[DayOfWeek]
			  ,[LastUpdate]   from MealPeriod where StoreID in ('+@StoreID+')) a pivot (max([Time])
  for [DayOfWeek] in (SUNDAY,MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY)) b group by name'
		end
	end
	if @type =2  --select by name 
	begin
		set @sql = 'SELECT [StoreID]
			  ,[ID]
			  ,[Name]
			  ,[BeginTime]
			  ,[EndTime]
			   ,convert(nvarchar(20),[BeginTime],8) +''-''+convert(nvarchar(20),(case when DATEPART(SS,[EndTime])=59 then  dateadd(second,1,[EndTime]) when DATEPART(SS,[EndTime])=0 then dateadd(MI,1,[EndTime]) end),8) as [Time]
			  ,[DayOfWeek]
			  ,[LastUpdate]
		FROM MealPeriod
		where [StoreID] in ('+@StoreID+') and [Name]='''+@Name+''''
	end
	if @type=3 --getID
	begin
		set @sql=' select MAX([ID]) from MealPeriod where [StoreID] in ('+@StoreID+')'
	end
	if @type=4 --vailda same name
	begin
		set @sql='select distinct Store.StoreName   from  MealPeriod 
		inner join Store on MealPeriod.StoreID=Store.ID 
		where [StoreID] in ('+@StoreID+') and Name='''+@Name+''''
	end
	if @type=5 --validate is Contain All Period
	begin
		if ISNULL(@StoreID,'')<>''
		begin

		set @Separator=','
		set @Input=@StoreID+','
		set @count=1
		set @sql1=''
		set @Index = charindex(@Separator,@Input)

		while (@Index>0)
		begin
			set @Entry=ltrim(rtrim(substring(@Input, 1, @Index-1)))
	        
			if @Entry<>''
			begin
				set @sql1=@sql1+' and name in(select name from MealPeriod where StoreID='+@Entry+'   and BeginTime=m.BeginTime and datepart(hh, EndTime)=datepart(hh,m.EndTime) and datepart(mi, EndTime)=datepart(mi,m.EndTime))'
			end

			set @Input = substring(@Input, @Index+datalength(@Separator)/2+1, len(@Input))
			set @Index = charindex(@Separator, @Input)
			set @count=@count+1
		end
		 set @sql=' 
		 select distinct 
			  [Name]
			  ,[BeginTime]
			  ,case when DATEPART(SS,[EndTime])=59 then  dateadd(second,1,[EndTime]) when DATEPART(SS,[EndTime])=0 then dateadd(MI,1,[EndTime]) end EndTime
			  ,[DayOfWeek]  from MealPeriod m where StoreID in ('+@StoreID+') '+@sql1
		end
	end
	--select @sql
	execute sp_executesql @sql
end
GO
