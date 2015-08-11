SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[report_GetUserID]
(
	@StoreID int,
	@SendTO nvarchar(20),
	@UserID int
)
as
if @SendTO='0'
begin
	select id from EnterpriseUser where StoreID=0
end
else if @SendTO='1'
begin
	 select id from EnterpriseUser where StoreID=@StoreID
end
else if @SendTO='-1'
begin
	select @UserID 
end
else
begin
	select id from EnterpriseUser where StoreID=0
	union
	select id from EnterpriseUser where StoreID=@StoreID
end
GO
