SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create FUNCTION [dbo].[fn_GetAllStoreID]
 
 (
	
 )  
 
 RETURNS nvarchar(max)
 
 AS  
 
 BEGIN 
 	declare @StoreID varchar(100)
               declare @retValue nvarchar(max)
               set @retValue=''
declare cur cursor
read_only
for select distinct id from store 

open cur
fetch next from cur into @StoreID
while(@@fetch_status=0)

begin
	if ISNULL(@retValue,'')=''
	begin
	set @retValue=@retValue+@StoreID
	end
	else
	begin
		set @retValue=@retValue+','+@StoreID
	end
fetch next from cur into @StoreID
end
close cur
deallocate cur
 
 	RETURN @retValue
 
 END
 
GO
