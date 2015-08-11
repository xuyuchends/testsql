SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Labor_IsManager]
@userID int
as
begin
select * from EnterpriseUser where ID = @userID
end
GO
