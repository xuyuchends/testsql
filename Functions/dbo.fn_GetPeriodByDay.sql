SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[fn_GetPeriodByDay]
 
 (
	@BeginDate datetime,
	@EndDate datetime
 )  
 
 RETURNS nvarchar(100)
 
 AS  
 
 BEGIN 
 	declare @Period varchar(100)
               declare @retValue nvarchar(100)
               set @retValue=''
declare cur cursor
read_only
for select distinct case when DATEPART(WEEKDAY,dateadd(day,number,@BeginDate))=1 then 'SUNDAY'
							when DATEPART(WEEKDAY,dateadd(day,number,@BeginDate))=2 then 'MONDAY'
							when DATEPART(WEEKDAY,dateadd(day,number,@BeginDate))=3 then 'TUESDAY'
							when DATEPART(WEEKDAY,dateadd(day,number,@BeginDate))=4 then 'WEDNESDAY'
							when DATEPART(WEEKDAY,dateadd(day,number,@BeginDate))=5 then 'THURSDAY'
							when DATEPART(WEEKDAY,dateadd(day,number,@BeginDate))=6 then 'FRIDAY'
							when DATEPART(WEEKDAY,dateadd(day,number,@BeginDate))=7 then 'SATURDAY' end Period  from master..spt_values  where type='P' and dateadd(day,number,@BeginDate)<=@EndDate

open cur
fetch next from cur into @Period
while(@@fetch_status=0)

begin
	if ISNULL(@retValue,'')=''
	begin
	set @retValue=@retValue+'['+@Period+']'
	end
	else
	begin
		set @retValue=@retValue+','+'['+@Period+']'
	end
fetch next from cur into @Period
end
close cur
deallocate cur
 
 	RETURN @retValue
 
 END
 
 


GO
