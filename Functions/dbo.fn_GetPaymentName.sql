SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fn_GetPaymentName]
 
 (
	@StoreId nvarchar(2000)
 )  
 
 RETURNS nvarchar(max)
 
 AS  
 
 BEGIN 
 	declare @Name varchar(100)
               declare @retValue nvarchar(max)
               set @retValue=''
declare cur cursor
read_only
for select distinct Name from PaymentMethod where StoreID in (select * from dbo.f_split(@StoreID,','))

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
