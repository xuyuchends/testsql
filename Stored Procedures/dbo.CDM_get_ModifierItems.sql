SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROCEDURE [dbo].[CDM_get_ModifierItems] 
	-- Add the parameters for the stored procedure here
	@modifierScreen nvarchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT     
		item_id, 
		CDM_tblMENU_ITEMS.Abbreviated_Name, 
		ModifierPrice,
		UseModifierPrice, 
		CDM_tblMENU_ITEMS.Price, 
		CDM_tblmodifier_menus.display_sequence

		FROM         CDM_tblMODIFIER_MENUS with(nolock) 
			INNER JOIN CDM_tblMENU_ITEMS with(nolock) ON CDM_tblMODIFIER_MENUS.MenuItemID = CDM_tblMENU_ITEMS.Item_Id

		WHERE     (CDM_tblMODIFIER_MENUS.ModifierMenuID = @modifierScreen)
		
			and CDM_tblmenu_items.show_button = 'Y'
			and CDM_tblmenu_items.active = 'Y' --05/13/2007 ML BUG FIX 393 ONLY GET ACTIVE ITEMS
			and CDM_tblmenu_items.deleted = 'N' --Bug 970 2008/02/15 Amy Chen
		
		ORDER by CDM_tblmodifier_menus.display_sequence

END
GO
