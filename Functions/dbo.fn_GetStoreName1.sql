SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[fn_GetStoreName1]
 
 (
	@StoreId nvarchar(2000)
 )  
 
 RETURNS nvarchar(max)
 
 AS  
 
 BEGIN 
 	declare @StoreName varchar(100)
               declare @retValue nvarchar(max)
               set @retValue=''
declare cur cursor
read_only
for select distinct StoreName from store where id in (select * from dbo.f_split(@StoreID,','))

open cur
fetch next from cur into @StoreName
while(@@fetch_status=0)

begin
	if ISNULL(@retValue,'')=''
	begin
	set @retValue=@retValue+@StoreName
	end
	else
	begin
		set @retValue=@retValue+','+@StoreName
	end
fetch next from cur into @StoreName
end
close cur
deallocate cur
 
 	RETURN @retValue
 
 END
GO
