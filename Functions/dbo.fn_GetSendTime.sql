SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[fn_GetSendTime]
 
 (
	@StoreIDList nvarchar(2000)
 )  
 
 RETURNS nvarchar(100)
 
 AS  
 
 BEGIN 
declare @retValue nvarchar(2000)
declare @StoreID nvarchar(20)
declare @selValue nvarchar(20)
set @retValue=''
declare cur cursor
read_only
for select * from dbo.f_split(@StoreIDList,',')

open cur
fetch next from cur into @StoreID
while(@@fetch_status=0)

begin
	if ISNULL(@StoreID,'')<>''
	begin
	
		select @selValue=convert(datetime,convert(nvarchar(20),getdate(),102)+' '+convert(nvarchar(20),begintime,8)) from mealperiod where storeid=@StoreID and begintime<endtime
		and case when  DATEPART(WEEKDAY,getdate())=1 then 'SUNDAY' 
				when DATEPART(WEEKDAY,getdate())=2 then 'MONDAY'
				when DATEPART(WEEKDAY,getdate())=3 then 'TUESDAY'
				when DATEPART(WEEKDAY,getdate())=4 then 'WEDNESDAY'
				when DATEPART(WEEKDAY,getdate())=5 then 'THURSDAY'
				when DATEPART(WEEKDAY,getdate())=6 then 'FRIDAY'
				when DATEPART(WEEKDAY,getdate())=7 then 'SATURDAY' end =mealperiod.dayofweek
				order by begintime 
		if @retValue=''
		begin
			set @retValue=@selValue
		end
		else
		begin
			set @retValue=@retValue+','+@selValue
		end
	end
	
fetch next from cur into @StoreID
end
close cur
deallocate cur
 
 	RETURN @retValue
 
 END

 
GO
