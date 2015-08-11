SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[fn_GetPeriodByMonth] 
 
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
for select distinct case when datepart(m, dateadd(month,number,@BeginDate))=1 then 'Jan' 
				when datepart(m, dateadd(month,number,@BeginDate))=2 then 'Feb' 
				when datepart(m,dateadd(month,number,@BeginDate))=3 then 'March'
				when datepart(m, dateadd(month,number,@BeginDate))=4 then 'April'
				when datepart(m, dateadd(month,number,@BeginDate))=5 then 'May'
				when datepart(m, dateadd(month,number,@BeginDate))=6 then 'Jnue'
				when datepart(m, dateadd(month,number,@BeginDate))=7 then 'July'
				when datepart(m, dateadd(month,number,@BeginDate))=8 then 'Aug'
				when datepart(m, dateadd(month,number,@BeginDate))=9 then 'Sep'
				when datepart(m, dateadd(month,number,@BeginDate))=10 then 'Oct'
				when datepart(m, dateadd(month,number,@BeginDate))=11 then 'Nov'
				when datepart(m, dateadd(month,number,@BeginDate))=12 then 'Dec' end period
				  from master..spt_values  where type='P' and dateadd(month,number,@BeginDate)<=@EndDate

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
