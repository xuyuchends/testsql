SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SF_ForecastNetSaleDataSel]
@storeid int,-- =12
@weekDiff int,--=52
@daypart nvarchar(50),-- ='Lunch'
@ForecastDay datetime --='2013-07-26'
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
 
declare @InnerMealPeriodBeginTime datetime
declare @InnerMealPeriodEndTime datetime
declare @InnerStrDaypart nvarchar(50)
    set @InnerstrDaypart=case when DATEPART(WEEKDAY,@ForecastDay)=1 then 'SUNDAY'
when DATEPART(WEEKDAY,@ForecastDay)=2 then 'MONDAY'
when DATEPART(WEEKDAY,@ForecastDay)=3 then 'TUESDAY'
when DATEPART(WEEKDAY,@ForecastDay)=4 then 'WEDNESDAY'
when DATEPART(WEEKDAY,@ForecastDay)=5 then 'THURSDAY'
when DATEPART(WEEKDAY,@ForecastDay)=6 then 'FRIDAY'
else 'SATURDAY' end  
 
select @InnerMealPeriodBeginTime=BeginTime,@InnerMealPeriodEndTime=EndTime from MealPeriod where DayOfWeek=@InnerstrDaypart and StoreID=@storeid and Name=@daypart
-- 当天已有数据
if exists (select * from (select BusinessDate from OrderLineItem union  
select BusinessDate from OrderLineItemArchive ) as tabel1 where BusinessDate=@ForecastDay )
or convert(nvarchar(20),DATEADD(day,-1, GETDATE()),102)>=@ForecastDay
begin
	if (@InnerMealPeriodBeginTime<@InnerMealPeriodEndTime)
		select ISNULL( sum(netsales),0) netsales,@ForecastDay Businessdate from 
		( 
			select Qty*(price-AdjustedPrice) as netsales,BusinessDate,TimeOrdered from OrderLineItem where StoreID=@storeid
			union 
			select Qty*(price-AdjustedPrice) as netsales,BusinessDate,TimeOrdered from OrderLineItemArchive where StoreID=@storeid
		) as tabel1
		where TimeOrdered between  CONVERT(CHAR(10),TimeOrdered,120)+ ' '+ CONVERT(char(12),@InnerMealPeriodBeginTime,114) 
		and CONVERT(CHAR(10),TimeOrdered,120)+ ' '+ CONVERT(char(12),@InnerMealPeriodEndTime,114)
		and BusinessDate=@ForecastDay
		--group by BusinessDate
	else 
		select isnull(sum(netsales),0) netsales,@ForecastDay Businessdate from 
		( 
		select Qty*(price-AdjustedPrice) as netsales,BusinessDate,TimeOrdered from OrderLineItem where StoreID=@storeid
		union 
		select Qty*(price-AdjustedPrice) as netsales,BusinessDate,TimeOrdered from OrderLineItemArchive where StoreID=@storeid 
		) as tabel1
		where TimeOrdered between  CONVERT(CHAR(10),TimeOrdered,120)+ ' '+ CONVERT(char(12),@InnerMealPeriodBeginTime,114) 
		and CONVERT(CHAR(10),TimeOrdered,120)+ ' 23:59:59:999'
		and TimeOrdered between  CONVERT(CHAR(10),TimeOrdered,120)+ ' 00:00:00:000' and 
		CONVERT(CHAR(10),TimeOrdered,120)+ ' '+ CONVERT(char(12),@InnerMealPeriodEndTime,114)
		and BusinessDate=@ForecastDay
		--group by BusinessDate
	end
else
--当天还没有数据，返回所有的周
begin
	declare @forecastDataBegin datetime
	declare @forecaseDataEnd datetime
	declare @selDate datetime
	set @forecastDataBegin=DATEADD(week,-1*@weekDiff,convert(nvarchar(20),GETDATE(),101))
	if exists (select * from (select BusinessDate from OrderLineItem union  
select BusinessDate from OrderLineItemArchive ) as tabel1 where BusinessDate=convert(nvarchar(20),GETDATE(),101) )
	begin
	set @forecastDataBegin=DATEADD(day,1,@forecastDataBegin)
	set @forecaseDataEnd=GETDATE()
	end
	else
	begin
		set @forecaseDataEnd=DATEADD(day,-1,GETDATE())
	end
	if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#dayTable') 
and type='U')  
	drop table [dbo].#dayTable
	create table #dayTable (businessdate datetime)
	set @selDate=@forecastDataBegin
	while @selDate<@forecaseDataEnd
	begin
		if DATEPART(weekday,@selDate)=DATEPART(WEEKDAY, @ForecastDay)
			insert into #dayTable values(@selDate)
		set @selDate=DATEADD(day,1, @selDate)
	end
	--select * from #dayTable
	--select @forecastDataBegin
	--select @forecaseDataEnd
	--6:00~19:00
	if (@InnerMealPeriodBeginTime<@InnerMealPeriodEndTime)
		select ISNULL( sum(netsales),0) netsales,t.businessdate from 
		( 
		select Qty*(price-AdjustedPrice) as netsales,BusinessDate from OrderLineItem where 
		StoreID=@storeid and TimeOrdered between  CONVERT(CHAR(10),TimeOrdered,120)+ ' '+ CONVERT(char(12),@InnerMealPeriodBeginTime,114) and 
		CONVERT(CHAR(10),TimeOrdered,120)+ ' '+ CONVERT(char(12),@InnerMealPeriodEndTime,114)
		and BusinessDate between @forecastDataBegin and @forecaseDataEnd
		 and DATEPART(WEEKDAY, BusinessDate)=DATEPART(WEEKDAY, @ForecastDay)
		union 
		select Qty*(price-AdjustedPrice) as netsales,BusinessDate from OrderLineItemArchive
		 where StoreID=@storeid and TimeOrdered between  CONVERT(CHAR(10),TimeOrdered,120)+ ' '+ CONVERT(char(12),@InnerMealPeriodBeginTime,114) and 
		CONVERT(CHAR(10),TimeOrdered,120)+ ' '+ CONVERT(char(12),@InnerMealPeriodEndTime,114)
		and BusinessDate  between @forecastDataBegin and @forecaseDataEnd
		 and DATEPART(WEEKDAY, BusinessDate)=DATEPART(WEEKDAY, @ForecastDay)
		) as tabel1 right join #dayTable t on tabel1.BusinessDate=t.businessdate
		group by t.businessdate order by t.businessdate
	--19:00~06:00
	else 
		select  ISNULL( sum(netsales),0) netsales,t.businessdate from 
		( 
		select Qty*(price-AdjustedPrice) as netsales,BusinessDate,TimeOrdered from OrderLineItem where StoreID=@storeid
		and (TimeOrdered between  CONVERT(CHAR(10),TimeOrdered,120)+ ' '+ CONVERT(char(12),@InnerMealPeriodBeginTime,114) and CONVERT(CHAR(10),TimeOrdered,120)+ ' 23:59:59:999'
		or TimeOrdered between  CONVERT(CHAR(10),TimeOrdered,120)+ ' 00:00:00:000' and CONVERT(CHAR(10),TimeOrdered,120)+ ' '+ CONVERT(char(12),@InnerMealPeriodEndTime,114))
		 and BusinessDate  between @forecastDataBegin and @forecaseDataEnd
		 and DATEPART(WEEKDAY, BusinessDate)=DATEPART(WEEKDAY, @ForecastDay)
		union 
		
		select Qty*(price-AdjustedPrice) as netsales,BusinessDate,TimeOrdered from OrderLineItemArchive where StoreID=@storeid 
		and (TimeOrdered between  CONVERT(CHAR(10),TimeOrdered,120)+ ' '+ CONVERT(char(12),@InnerMealPeriodBeginTime,114) and CONVERT(CHAR(10),TimeOrdered,120)+ ' 23:59:59:999'
		or TimeOrdered between  CONVERT(CHAR(10),TimeOrdered,120)+ ' 00:00:00:000' and CONVERT(CHAR(10),TimeOrdered,120)+ ' '+ CONVERT(char(12),@InnerMealPeriodEndTime,114))
		 and BusinessDate  between @forecastDataBegin and @forecaseDataEnd
		 and DATEPART(WEEKDAY, BusinessDate)=DATEPART(WEEKDAY, @ForecastDay)
		) as tabel1 right join #dayTable t on tabel1.BusinessDate=t.businessdate
		group by t.businessdate
		order by t.businessdate
	end
END
GO
