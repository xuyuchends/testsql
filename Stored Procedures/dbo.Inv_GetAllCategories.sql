SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_GetAllCategories]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
	select  ig.Name+'/'+dbo.[fn_GetParentMenuItemCategory](mic.id) CategoryName,mic.ID CategoryID from Inv_MenuItemCategory mic 
	inner join  Inv_ItemGroup ig on mic.GroupID=ig.ID
	where (select COUNT(*) from Inv_MenuItemCategory where ParentID=mic.ID)=0
END
GO
