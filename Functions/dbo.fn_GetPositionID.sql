SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[fn_GetPositionID]
 
 (
	@PositionName nvarchar(2000),
	@StoreID int
 )  
 
 RETURNS nvarchar(100)
 
 AS  
 
 BEGIN 
 	declare @ID int
               declare @retValue nvarchar(100)
               set @retValue=''
declare cur cursor
read_only
for select distinct id from position where Name in (select * from dbo.f_split(@PositionName,',')) and StoreID =@StoreID

open cur
fetch next from cur into @ID
while(@@fetch_status=0)

begin
	if ISNULL(@retValue,'')=''
	begin
	set @retValue=@retValue+convert(nvarchar(20),@ID)
	end
	else
	begin
		set @retValue=@retValue+','+convert(nvarchar(20),@ID)
	end
fetch next from cur into @ID
end
close cur
deallocate cur
 
 	RETURN @retValue
 
 END
 
GO
