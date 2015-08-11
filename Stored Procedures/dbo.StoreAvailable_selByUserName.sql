SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:phil
-- Description:	通过companyID检索该公司全部组织结构
--通过ID 检索当前组织结构
-- =============================================
CREATE PROCEDURE [dbo].[StoreAvailable_selByUserName]
@UserName nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @userID int
	select @userID=ID from EnterpriseUser where UserName=@UserName
if (ISNULL( @userID,'0') <>'0')
begin
	
	
with cte(id,StoreID,ParentID,Name) as 
(
	select id,StoreID,ParentID, Name from Organization where id =
	(select top 1 OrganizationID from OrganizationToUser where UserID=@UserID order by OrganizationID asc)
	union all 
	select o.id,o.StoreID,o.ParentID,o.Name from Organization as o 
	inner join cte as c  on o.ParentID  =c.id
) 
select cte.id,cte.StoreID,ParentID,s.StoreName,City,
	[State/Province] from cte
inner join Store s on s.ID=cte.StoreID where cte.StoreID is not null and cte.StoreID <>0
union
select o.ID,o.StoreID,o.ParentID,s.StoreName,s.City,s.[State/Province]
from Organization as o inner join Store as s on o.StoreID=s.ID inner join EnterpriseUser as eu on s.ID=eu.StoreID
where eu.ID=@UserID
end
END


GO
