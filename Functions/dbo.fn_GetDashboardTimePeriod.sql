SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fn_GetDashboardTimePeriod]
 
 (
	@StoreID nvarchar(20)
 )  
 
 RETURNS datetime
 
 AS  
 
 BEGIN 
declare @beginTime datetime
declare @endTime datetime
declare @retValue datetime
declare cur cursor
read_only
for select distinct BeginTime,EndTime from MealPeriod where StoreID in (select * from dbo.f_split(@StoreID,','))

open cur
fetch next from cur into @beginTime,@endTime
while(@@fetch_status=0)

begin
	if @beginTime>@endTime
	begin
		if @retValue is not null 
		begin
			if @endTime<@retValue
			begin
				set @retValue=dateadd(mi,1, @endTime)
			end
		end
		else
		begin
			set @retValue=dateadd(mi,1, @endTime)
		end
	end
	
fetch next from cur into @beginTime,@endTime
end
close cur
deallocate cur
 
 	RETURN @retValue
 
 END
 
 
GO
