SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[OrganizationUser_InUpDel]
@OrganizationID int,
@Type int,
@IsFirstDelete int,
@UserID int,
@UserName nvarchar(50) output 
AS
BEGIN
	SET NOCOUNT ON;
	-- modify the user of current node 
if (@type=0)
begin
	if (@IsFirstDelete=1)
		begin
			delete from OrganizationToUser where OrganizationID=@OrganizationID
		end
	if @UserID in (select otu.UserID from OrganizationToUser as otu where otu.OrganizationID in(select id from f_SelOrganization(@OrganizationID,2)))
		begin
			select @UserName=eu.FirstName+' ' +eu.LastName from EnterpriseUser as eu where eu.ID=@UserID 
			return
		end
	else
		begin
			insert into OrganizationToUser (OrganizationID,UserID) values (@OrganizationID,@UserID)
		end
end
END
GO
