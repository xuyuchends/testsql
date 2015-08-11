SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TabMenu_sel]
@UserTpye int,
@ParentID int,
@Level	int,
@type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if @type=1
	begin
		select ID, Name, Path, parentID, Css from TabMenu
		where  Enable=1 and PathLevel=@Level and parentID=@ParentID and UserType & @UserTpye=@UserTpye
		order by Sort desc
	end
	-- select parent info by parnetID
	else  if @type=2
	begin
		select ID, Name, Path, parentID, Css from TabMenu 
		where  Enable=1 and PathLevel=1 and ID=@ParentID 
		order by Sort desc
	end
END
GO
