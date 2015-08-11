SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[f_SelOrganization] (@ID int,@type int)
returns @t table(id int)
as
begin
-- =1.检索当前节点和下面所有节点
	if(@type=1)
	begin
		insert @t select o.id from Organization as o  where  o.ID=@ID
		while @@rowcount > 0
			begin
				insert @t select o1.ID as ID from Organization as o1 inner join @t as b
				on o1.ParentID = b.id  and o1.id not in(select id from @t)
			end
    end
-- =2.检索当前节点上面所有节点(不包括当前节点)
    else if(@type=2)
	begin
		insert @t select o.ParentID from Organization as o  where  o.ID=@ID
		while @@rowcount > 0
			begin
				insert @t select o.ParentID from Organization as o  where  o.ID in (select id from @t)  and o.ParentID not in(select id from @t)
			end 
    end
   return
end
GO
