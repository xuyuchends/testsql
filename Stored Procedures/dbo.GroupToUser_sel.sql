SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GroupToUser_sel]
	@GroupID int,
	@UserID int,
	@type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if @type=1
	begin
		select gtu.GroupID as GroupID,g.Name as GroupName  from GroupToUser as gtu inner join [Group] as g on g.ID=gtu.GroupID where gtu.UserID=@UserID
	end
		
END
GO
