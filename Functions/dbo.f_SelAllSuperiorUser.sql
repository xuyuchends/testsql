SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[f_SelAllSuperiorUser] (@UserID int)
returns @t table(userID int, OrganizationID int)
as
begin
	declare @storeID int
	select @storeID=StoreID from EnterpriseUser where ID=@UserID
	--enterprise user
	if @storeID=0
	begin
		insert  @t select 0,otu.OrganizationID  from OrganizationToUser as otu where otu.UserID=@UserID
	end
	else
	-- store manager
	begin
		insert  @t select 0, o.parentID from Organization as o where o.StoreID in ( select eu.StoreID from EnterpriseUser as eu where ID=@UserID)
	end
	
	while @@rowcount > 0
	begin
		insert @t select 0,o.parentID from Organization as o where o.ID in (select OrganizationID from @t ) and o.ParentID not in(select OrganizationID from @t)
	end 
	insert @t select otu.UserID,0 from OrganizationToUser as otu inner join EnterpriseUser as eu on eu.ID=otu.UserID
	where eu.Enable=1 and otu.OrganizationID in (select OrganizationID  from @t)
	delete from  @t where userID=0
   return
end
GO
