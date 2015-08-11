SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Message_GetAllStoreContacts]
(
	@UserID int
)
as
Create table #temp (id int,StoreID int,ParentID int,StoreName nvarchar(50),city nvarchar(50),[State/Province] nvarchar(50))
insert into #temp exec StoreAvailable_sel @UserID

create table #retTable (ID nvarchar(20),Name nvarchar(50))
insert into #retTable values('All Store','All Store')

declare @StoreID nvarchar(50)
declare @StoreName nvarchar(50)
declare cur cursor
read_only
for select Storeid,StoreName from #temp

open cur
fetch next from cur into @StoreID,@StoreName
while(@@fetch_status=0)

begin
	insert into #retTable values('s-'+@StoreID,@StoreName)
	insert into #retTable select 'e-'+cast(ID as nvarchar(50)),'--'+FirstName+' '+LastName  from EnterpriseUser where StoreID=@StoreID
	and IsManager=1
fetch next from cur into @StoreID,@StoreName
end
close cur
deallocate cur
select * from #retTable
drop table #retTable



GO
