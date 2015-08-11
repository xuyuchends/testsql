SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fn_GetTimeByShiftID]
 
 (
	@shiftID int
 )  
 
 RETURNS nvarchar(max)
 
 AS  
 
 BEGIN 
 	declare @TimePeriod varchar(max)
   declare @retValue nvarchar(max)
   set @retValue=''
declare cur cursor
read_only
for select distinct CONVERT(nvarchar(20), BeginTime)+'*'+CONVERT(nvarchar(20), EndTime) TimePeriod
 from LaborScheduleShiftDetail where shiftID =@shiftID

open cur
fetch next from cur into @TimePeriod
while(@@fetch_status=0)

begin
	if ISNULL(@retValue,'')=''
	begin
	set @retValue=@retValue+@TimePeriod
	end
	else
	begin
		set @retValue=@retValue+','+@TimePeriod
	end
fetch next from cur into @TimePeriod
end
close cur
deallocate cur
 
 	RETURN @retValue
 
 END
 
GO
