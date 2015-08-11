SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[f_SelAvailableUser](@userID int,@userGroup int)

RETURNS @t TABLE (nodeID int,storeID int,storeName nvarchar(50), userID int)

AS
begin
--enterpriser user(不包括当前节点)
if (@userGroup=1)
begin
	insert @t select o.id as nodeID,0,'',0 from Organization as o inner join OrganizationToUser as otu on o.ID=otu.OrganizationID  where  otu.UserID=@userID
	while @@rowcount > 0
		begin
			insert @t select o1.ID as nodeID,0,'',0 from Organization as o1 inner join @t as b
			on o1.ParentID = b.nodeID  and o1.id not in(select nodeID from @t) 
		end
	insert @t select distinct 0,0,'',userid from OrganizationToUser as otu where otu.OrganizationID in (select nodeID from @t)
	delete from @t where userID =0 or userID=@userID
end
else if (@userGroup=2)
--store manager(不包括当前节点)
begin
	insert into @t select 0 as nodeID,s.ID as storeID,s.StoreName as storeName,eu.ID as  userID from EnterpriseUser as eu inner join store as s on s.ID=eu.StoreID 
	where eu.StoreID in (select StoreID from f_SelAvailableStore(@userID)) and eu.IsManager=1 and eu.StoreID>0 and eu.Enable=1
end
else if (@userGroup=4)
--store user(不包括当前节点=4)
begin
	insert into @t select 0 as nodeID,s.ID as storeID,s.StoreName as storeName,eu.ID as  userID from EnterpriseUser as eu inner join store as s on s.ID=eu.StoreID 
	where eu.StoreID in (select StoreID from f_SelAvailableStore(@userID)) and eu.IsManager=0 and eu.StoreID>0 and eu.Enable=1
end
else if (@userGroup=1|2)
begin
 insert @t select * from f_AvailableUser(@userID,1) union select * from f_AvailableUser(@userID,2)
end
else if (@userGroup=1|4)
begin
 insert @t select * from f_AvailableUser(@userID,1) union select * from f_AvailableUser(@userID,4)
end
else if (@userGroup=2|4)
begin
 insert @t select * from f_AvailableUser(@userID,2) union select * from f_AvailableUser(@userID,4)
end
else if (@userGroup=1|2|4)
begin
 insert @t select * from f_AvailableUser(@userID,1) union select * from f_AvailableUser(@userID,2) union select * from f_AvailableUser(@userID,4)
end
return
end
GO
