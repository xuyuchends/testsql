SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[GetMealPeriod]
(
	-- Add the parameters for the function here
	@OrderTime datetime,
	@StoreID int
)
RETURNS nvarchar(20)
AS
BEGIN
	declare @MealPeriodBegin datetime
	declare @MealPeriodEnd datetime
	declare @Name nvarchar(20)
	declare @retValue nvarchar(20)
	declare @dayofweek nvarchar(20)
	select @dayofweek=case when DATEPART(WEEKDAY,@OrderTime)=1 then 'SUNDAY'
							when DATEPART(WEEKDAY,@OrderTime)=2 then 'MONDAY'
							when DATEPART(WEEKDAY,@OrderTime)=3 then 'TUESDAY'
							when DATEPART(WEEKDAY,@OrderTime)=4 then 'WEDNESDAY'
							when DATEPART(WEEKDAY,@OrderTime)=5 then 'THURSDAY'
							when DATEPART(WEEKDAY,@OrderTime)=6 then 'FRIDAY'
							when DATEPART(WEEKDAY,@OrderTime)=7 then 'SATURDAY' end
	declare curMealPriod cursor for 
	 select beginTime,EndTime,Name from MealPeriod
where StoreID=@StoreID and [DayOfWeek]=@dayofweek
	open curMealPriod
	fetch next from curMealPriod into @MealPeriodBegin,@MealPeriodEnd,@Name
	while @@fetch_status=0
	begin
		
		set @MealPeriodBegin=convert(datetime,convert(varchar(10),@OrderTime,120)+' '+convert(VARCHAR(8),@MealPeriodBegin,108))
	set @retValue = convert(nvarchar(20),@MealPeriodBegin,120)+'/'+convert(nvarchar(20),@MealPeriodEnd,120)	
		if datepart(hh,@MealPeriodBegin)>datepart(hh,@MealPeriodEnd)
		begin
			set @MealPeriodEnd=convert(datetime,convert(varchar(10),dateadd(day,1,@OrderTime),120)+' '+convert(VARCHAR(8),@MealPeriodEnd,108))
		end
		else
		begin
			set @MealPeriodEnd=convert(datetime,convert(varchar(10),@OrderTime,120)+' '+convert(VARCHAR(8),@MealPeriodEnd,108))
		end
		if @OrderTime between @MealPeriodBegin and @MealPeriodEnd
		begin
			set @retValue = @Name
		end
	fetch next from curMealPriod into @MealPeriodBegin,@MealPeriodEnd,@Name
	end
	close curMealPriod
deallocate curMealPriod
return @retValue
END
GO
