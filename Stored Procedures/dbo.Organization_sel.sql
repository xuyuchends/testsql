SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Organization_sel]
@ID int,
@type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--=0, select root
if (@type=0)
begin
with cte(id,ParentID,Name,StoreID) as 
(
	select id,ParentID, Name ,StoreID from Organization where ParentID = 0
	union all 
	select o.id,o.ParentID,o.Name,O.StoreID from Organization as o 
	inner join cte as c  on o.ParentID  =c.id
) 
select * from cte
end
--=1 select one node
else if (@type=1)
begin
with cte(id,ParentID,Name,StoreID) as 
(
	select id,ParentID, Name ,StoreID from Organization where ID  = @ID
	union all 
	select o.id,o.ParentID,o.Name,O.StoreID from Organization as o 
	inner join cte as c  on o.ParentID  =c.id
) 
select * from cte
end
--=2 node not in a line
else if (@type=2)
begin
with cte(id,ParentID,Name,StoreID) as 
(
	select id,ParentID, Name ,StoreID from Organization where ID  = @ID
	union all 
	select o.id,o.ParentID,o.Name,O.StoreID from Organization as o 
	inner join cte as c  on o.ParentID  =c.id
) ,
 cte1(id,ParentID,Name,StoreID) as 
(
	select id,ParentID, Name ,StoreID from Organization where ParentID = 0
	union all 
	select o.id,o.ParentID,o.Name,O.StoreID from Organization as o 
	inner join cte1 as c  on o.ParentID  =c.id
) 
select * from cte1  where cte1.id not in (select id from cte) and (StoreID=0 or StoreID is null)
end
-- select node tree by userID
else if (@type=3)
begin

with cte(id,ParentID,Name,StoreID) as 
(
	select id,ParentID, Name ,StoreID from Organization where ID  = (select top 1 OrganizationID  from OrganizationToUser where UserID=@ID )
	union all 
	select o.id,o.ParentID,o.Name,O.StoreID from Organization as o 
	inner join cte as c  on o.ParentID  =c.id
) 
select * from cte
end
END
GO
