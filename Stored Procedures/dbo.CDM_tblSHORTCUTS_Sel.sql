SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblSHORTCUTS_Sel]
	-- Add the parameters for the stored procedure here
	@ID nvarchar(50),
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@sqlType='GetAvailShortcuts')
		select distinct(id) from CDM_tblshortcuts
	else if (@sqlType='GetShortcutsByMenuName')
	SELECT ShortcutID,ID,Caption,Language_2_Name,Language_3_Name,Language_4_Name,Language_5_Name,
	Display_Seq,Link,Action,Color,All_Sections,Section,Special_Process,Hide_Menu,Hide_ShortMenu,
	Security_Module,Security_FieldID,Show_Button,UnSelected_State,Extra_Menu,ShortCut_Menu,
	Menu_Meal_Type,default_menu_link,fore_color,back_color_net,fore_color_net,Web_Show,OrderMan_Caption,
	LastUpdate,EditorID,EditorName,MCColor,MCfore_color,ActionID  FROM CDM_tblSHORTCUTS
	where Caption not like '%zzz%'  and ID=@ID
END
GO
