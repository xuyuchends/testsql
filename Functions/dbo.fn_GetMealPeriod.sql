SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[fn_GetMealPeriod]
 
 (
	@StoreId nvarchar(2000)
 )  
 
 RETURNS nvarchar(100)
 
 AS  
 
 BEGIN 
 	declare @Name varchar(100)
               declare @retValue nvarchar(100)
               set @retValue=''
declare cur cursor
read_only
for select distinct name from mealperiod where Storeid in (select * from dbo.f_split(@StoreID,','))

open cur
fetch next from cur into @Name
while(@@fetch_status=0)

begin
	if ISNULL(@retValue,'')=''
	begin
	set @retValue=@retValue+'['+@Name+']'
	end
	else
	begin
		set @retValue=@retValue+','+'['+@Name+']'
	end
fetch next from cur into @Name
end
close cur
deallocate cur
 
 	RETURN @retValue
 
 END
 
GO
