SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[OrganizationUser_sel]
@OrganizationID int,
@type int
AS
BEGIN
declare @storeID int
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--=0, select user of current node 
	select @storeID=StoreID from Organization where ID=@OrganizationID
	if @storeID>0
	begin
		select eu.ID as employeeID,eu.FirstName+ ' '+eu.LastName as employeeName, 0 as available from EnterpriseUser as eu 
		where eu.StoreID=@storeID and eu.IsManager=1
	end
	else
	begin
		if @type=1
		--当前所有员工(不包括store的员工)
		begin
		select eu.ID as employeeID,eu.FirstName+ ' '+eu.LastName as employeeName  from EnterpriseUser as eu 
		where eu.StoreID=0 or eu.StoreID is null
		end
		else if @type=2
		--当前节点的员工
		begin
		select eu.ID as employeeID,eu.FirstName+ ' '+eu.LastName as employeeName  from EnterpriseUser as eu 
		inner join OrganizationToUser as otu on eu.ID =otu.UserID 
		where otu.OrganizationID=@OrganizationID
		end
		else if @type=3
		--上级员工(不可选)
		begin
			select eu.ID as employeeID,eu.FirstName+ ' '+eu.LastName as employeeName  from EnterpriseUser as eu 
			inner join 
			(
				select otu.UserID  from OrganizationToUser as otu where otu.OrganizationID in( select id from f_SelOrganization(@OrganizationID,2))
			) as table1 on table1.UserID=eu.ID
		end
	end
end
GO
