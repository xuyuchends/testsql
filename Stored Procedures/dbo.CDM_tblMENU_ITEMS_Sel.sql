SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblMENU_ITEMS_Sel]
	-- Add the parameters for the stored procedure here
	@menuItemID int,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@sqlType='GetMenuCategory')
		select distinct(mi_sale_rpt_category) from CDM_tblMENU_ITEMS where mi_sale_rpt_category<>'' and mi_sale_rpt_category is not null order by mi_sale_rpt_category

	else if (@sqlType='GetMmenulink')
		select distinct(category) from CDM_tblMENU_ITEMS with(nolock) where deleted ='N' and item <> 'blank' and  category<>'' and category is not null  order by category
	else if (@sqlType='GetMenuGroupMenuLinks')	
		select distinct(category) from CDM_tblmenu_items with(nolock)where [section] =  'DINING' and  category<>'' and category is not null 
	else if (@sqlType='GetMenuItemType')	
		Select distinct MI_Type from CDM_tblmenu_items  where   MI_Type<>'' and MI_Type is not null  order by MI_Type Asc
	else if (@sqlType='GetDepartment')	
		Select distinct department from CDM_tblmenu_items  where   department<>'' and department is not null order by department asc
	else if (@sqlType='SQLSELECTDETAIL')
		SELECT Item_Id,Item,Abbreviated_Name,MultiLanguageSetup,Language_2_Name,Language_3_Name,Language_4_Name,
		Language_5_Name,KitchenPrintLang1,KitchenPrintLang2,KitchenPrintLang3,KitchenPrintLang4,KitchenPrintLang5,
		Price,Status,Section,Category,Print_Zone,Tax_Cat,Receipt_Print,Show_Button,Display_Sequence,Kitchen_Sum,Active,
		Open_Price,Date_LastSold,Alt_Price1,Alt_Price2,Happy_HourPrice,SubMenu_1,NumAllowed_1,SubMenu_2,NumAllowed_2,
		SubMenu_3,NumAllowed_3,SubMenu_4,NumAllowed_4,SubMenu_5,NumAllowed_5,SubMenu_6,NumAllowed_6,SubMenu_7,
		NumAllowed_7,SubMenu_8,NumAllowed_8,SubMenu_9,NumAllowed_9,SubMenu_10,NumAllowed_10,MI_Type,MI_Extra,
		MI_Has_Children,MI_Sale_Rpt_Category,Picture,PicStretchStyle,Cost,Open_Price_Minimum,Alt_Pricing_In_Use,
		Bar_Exclude_Tax,Expo_Exclude,Meal_Course,App_As_Entree_PZ,Check_On_Hand_Qty,Department,RollUp_Add_Price,
		Special_Instruction,Line_Color,Employee_Price,Discount_Exclude,Override_Parent_PZ,Modifier,Contest_Item,
		Button_Color,Hot_Item,Hot_Item_Display_Seq,KDS_Routing,Prep_Time_Sec,Recipe_Instructions,Priced_By_Weight,
		Linked_Item_ID,last_update,Linkable_Item,tax1,tax2,tax3,tax4,tax5,smart_tax,surcharge_tax,conditional_tax,
		kitchen_print_group,upc_number,deleted,net_forecolor,net_backcolor,on_hand_warning_threshold,rewardPoints,
		Is_Uploading,SeparateonKT,Print_Label,PrintPriceonKT,GratuityExclude,web_description,web_show,SetPriceID,
		OrderMan_Abbreviated_Name,OrderMan_Display_Sequence,Mod1Filename,Mod2Filename,Mod3Filename,Mod4Filename,
		Mod5Filename,Mod6Filename,Mod7Filename,Mod8Filename,Mod9Filename,Mod10Filename,Large_Picture,EditorID,
		EditorName FROM CDM_tblMENU_ITEMS where Item_Id=@menuItemID
	else if (@sqlType='GetHotItem')
	select Item_Id  from CDM_tblMENU_ITEMS where Hot_Item='Y' and deleted='N'
END
GO
