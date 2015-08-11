SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[f_GetMealPeriodRange] 
(
@begintime datetime,
@endtime datetime,
@storeID nvarchar(2000),
@dayOfWeek nvarchar(50),
@dayPartName nvarchar(50)
)
returns @t table(storeID int,StoreName nvarchar(50), beginTime datetime,endtime datetime)
as
begin
insert @t select distinct StoreID,s.StoreName as StoreName, BeginTime,EndTime  from MealPeriod inner join store as s on s.ID=StoreID
 where DayOfWeek=@dayOfWeek and StoreID in (select str from f_StrToTable(@storeID)) and BeginTime is not null and EndTime is not null and name <> @dayPartName
	
	declare @MealStoreID int
	declare @MealStoreName nvarchar(50)
    declare @MealPeriodBegin datetime
    declare @MealPeriodEnd datetime
    
    declare curMealPriod cursor for select StoreID,StoreName,beginTime,EndTime  from @t
	open curMealPriod
	fetch next from curMealPriod into @MealStoreID,@MealStoreName,@MealPeriodBegin,@MealPeriodEnd
	while @@fetch_status=0
	begin 
		if @MealPeriodEnd<@MealPeriodBegin
		begin
			delete from @t where beginTime=@MealPeriodBegin and endtime=@MealPeriodEnd and storeID=@MealStoreID
			insert into @t (StoreID,StoreName,beginTime,endtime) values (@MealStoreID,@MealStoreName,@MealPeriodBegin, '1900-01-01 23:59:59')
			insert into @t (StoreID,StoreName,beginTime,endtime) values (@MealStoreID,@MealStoreName,'1900-01-01 00:00:00', @MealPeriodEnd)
		end
		fetch next from curMealPriod into @MealStoreID,@MealStoreName,@MealPeriodBegin,@MealPeriodEnd
	end
	close curMealPriod
	deallocate curMealPriod
	delete from @t where (@begintime not between beginTime and endtime) and (@endtime not between beginTime and endtime )
   return
end
GO
