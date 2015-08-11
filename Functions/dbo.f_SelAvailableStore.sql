SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[f_SelAvailableStore] (@userID int)-- must be enterprise user
returns @t table(id int,ParentID int,storeid int)
as
begin
    insert @t select top 1 o.id,o.ParentID,o.StoreID from Organization as o 
    inner join OrganizationToUser as otu on otu.UserID=@userID 
    order by OrganizationID asc
    while @@rowcount > 0
		begin
			insert @t select o1.ID as ID,o1.ParentID as ParentID,o1.StoreID as storeid from Organization as o1 inner join @t as b
			on o1.ParentID = b.id  and o1.id not in(select id from @t)
        end
    delete from @t where storeid is null or storeid=''
   return
end
GO
