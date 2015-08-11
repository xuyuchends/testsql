SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[f_GetMealPeriodNameRpt] 
(
@storeID int,
@dayOfWeek nvarchar(50)
)
returns @t table(name nvarchar(50),beginTime datetime,endtime datetime)
as
begin
insert @t select distinct Name, BeginTime,EndTime  from MealPeriod where DayOfWeek=@dayOfWeek and StoreID =@storeID

	declare @MealPeriodName nvarchar(50)
    declare @MealPeriodBegin datetime
    declare @MealPeriodEnd datetime
    
    declare curMealPriod cursor for select name, beginTime,EndTime  from @t
	open curMealPriod
	fetch next from curMealPriod into @MealPeriodName,@MealPeriodBegin,@MealPeriodEnd
	while @@fetch_status=0
	begin 
		if @MealPeriodEnd<@MealPeriodBegin
		begin
			delete from @t where beginTime=@MealPeriodBegin and endtime=@MealPeriodEnd
			insert into @t (name,beginTime,endtime) values (@MealPeriodName,@MealPeriodBegin, '1900-01-01 23:59:59')
			insert into @t (name,beginTime,endtime) values (@MealPeriodName,'1900-01-01 00:00:00', @MealPeriodEnd)
		end
		fetch next from curMealPriod into @MealPeriodName,@MealPeriodBegin,@MealPeriodEnd
	end
	close curMealPriod
deallocate curMealPriod

   return
end
GO
