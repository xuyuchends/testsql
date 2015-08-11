SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[f_SelAvailableUserWithManagerLog](@userID int)

RETURNS @t TABLE (nodeID int,storeID int, userID int)

AS
begin
	declare @innerSotreID int
	select @innerSotreID=StoreID from EnterpriseUser where ID=@userID
	-- enterprise user
	if @innerSotreID=0
	begin
		insert @t select o.id as nodeID,0,0 from Organization as o inner join OrganizationToUser as otu on o.ID=otu.OrganizationID  where  otu.UserID=@userID
		while @@rowcount > 0
		begin
			insert @t select o1.ID as nodeID,o1.StoreID,0 from Organization as o1 inner join @t as b
			on o1.ParentID = b.nodeID  and o1.id not in(select nodeID from @t) 
		end
		insert @t select 0,0,userid from OrganizationToUser as otu inner join EnterpriseUser as eu on otu.UserID =eu.ID where otu.OrganizationID in (select nodeID from @t) and eu.Enable=1
		insert @t select 0, eu.StoreID,eu.ID from EnterpriseUser as eu where eu.StoreID in (select storeid from @t) and eu.IsManager=1 and eu.Enable=1
		delete from @t where userID =0 and userID<>@userID
	end
	else
	begin
		insert @t select 0, eu.StoreID,eu.ID  from EnterpriseUser as eu where eu.StoreID=@innerSotreID and eu.IsManager=1 and eu.Enable=1
	end
return
end
GO
