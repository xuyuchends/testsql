SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblMODIFIER_MENU_SETUP_Sel]
	-- Add the parameters for the stored procedure here
	@modifierMenuID nvarchar(20),
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@sqlType='GetModifierScreens')
		SELECT  modifierMenuID from CDM_tblmodifier_menu_setup  order by modifierMenuID
	else if (@sqlType='SQLSELECTDETAIL')
		SELECT ModifierMenuID,Language_1_Name,Language_2_Name,Language_3_Name,Language_4_Name,Language_5_Name,ForceModifier,ModifierMenuType,Limit_Num_Allowed,ShortCut_Menu,ModifierMenuCategory,last_update,Num_Free,ModFilename, EditorID ,EditorName  FROM CDM_tblMODIFIER_MENU_SETUP	WHERE ModifierMenuID = @ModifierMenuID
END
GO
