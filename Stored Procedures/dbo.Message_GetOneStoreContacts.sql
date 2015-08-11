SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Message_GetOneStoreContacts]
(
	@StoreID int
)
as

create table #retTable (StoreID nvarchar(50),StoreName nvarchar(100))
insert into #retTable values('EVERYONE','---EVERYONE---')

declare @ID nvarchar(50)
declare @Name nvarchar(50)
declare cur cursor
read_only
for select id,name from position  where Storeid = @StoreID

open cur
fetch next from cur into @ID,@Name
while(@@fetch_status=0)
begin
	insert into #retTable values('j-'+@ID,'--ALL '+@Name+'--')
	insert into #retTable select 'e-'+cast(eu.id as nvarchar(50)),eu.FirstName+' '+eu.LastName from EmployeeJob ej 
	inner join Position p on ej.PositionID=p.ID and ej.StoreID=p.StoreID
	inner join EnterpriseUser eu on ej.EmployeeID = eu.EmployeeID and ej.StoreID=eu.StoreID
	where p.ID=@ID and p.StoreID=@StoreID
fetch next from cur into @ID,@Name
end
close cur
deallocate cur
select * from #retTable
drop table #retTable

GO
