SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[fn_GetPositionByReport]
 
 (
	@StoreId nvarchar(2000),
	@reportName nvarchar(50),
	@IntervalType int
 )  
 
 RETURNS nvarchar(MAX)
 
 AS  
 
 BEGIN 
 	declare @Name varchar(100)
               declare @retValue nvarchar(MAX)
               set @retValue=''
declare cur cursor
read_only
for select distinct name from position where Storeid in (select * from dbo.f_split(@StoreID,','))
and id in (select positionID from GoogleChartPositionSetting where IntervalType=@IntervalType
and ReportName=@reportName and isShow=1  and StoreID=Position.StoreID)

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

if @retValue=''
begin
	declare cur1 cursor
	read_only
	for select distinct name from position where Storeid in (select * from dbo.f_split(@StoreID,','))
	open cur1
	fetch next from cur1 into @Name
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
	fetch next from cur1 into @Name
	end
	close cur1
	deallocate cur1
end

 	RETURN @retValue
 
 END
 
GO
