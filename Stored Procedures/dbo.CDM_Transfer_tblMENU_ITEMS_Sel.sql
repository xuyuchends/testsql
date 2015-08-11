SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_Transfer_tblMENU_ITEMS_Sel]
	-- Add the parameters for the stored procedure here
	@ID int,
	@GUID uniqueidentifier,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	 --//新建的数据(在MC上新建)
 --       New = 1,
 --       //等待传输的数据（等待请求更新到hotsauce的数据）
 --       WaitTransfer = 2,
 --       // 等待删除的数据(设定了结束时间，等待自动逻辑删除的数据)
 --       WaitLogicDeleted = 3,
 --       //正在传输的数据
 --       Transferring = 4,
 --       //已传输的数据
 --      HasTransfered = 5,
--      // error
 --     Error = 6,
  --      // close
  --      Close=7
	SET NOCOUNT ON;
	if (@sqlType='Comapre')
		SELECT top 2 id, Item_Id,Item,Abbreviated_Name,MultiLanguageSetup,Language_2_Name,Language_3_Name,Language_4_Name,Language_5_Name,KitchenPrintLang1,KitchenPrintLang2,KitchenPrintLang3,KitchenPrintLang4,KitchenPrintLang5,Price,Status,Section,Category,Print_Zone,Tax_Cat,Receipt_Print,Show_Button,Display_Sequence,Kitchen_Sum,Active,Open_Price,Date_LastSold,Alt_Price1,Alt_Price2,Happy_HourPrice,SubMenu_1,NumAllowed_1,SubMenu_2,NumAllowed_2,SubMenu_3,NumAllowed_3,SubMenu_4,NumAllowed_4,SubMenu_5,NumAllowed_5,SubMenu_6,NumAllowed_6,SubMenu_7,NumAllowed_7,SubMenu_8,NumAllowed_8,SubMenu_9,NumAllowed_9,SubMenu_10,NumAllowed_10,MI_Type,MI_Extra,MI_Has_Children,MI_Sale_Rpt_Category,Picture,PicStretchStyle,Cost,Open_Price_Minimum,Alt_Pricing_In_Use,Bar_Exclude_Tax,Expo_Exclude,Meal_Course,App_As_Entree_PZ,Check_On_Hand_Qty,Department,RollUp_Add_Price,Special_Instruction,Line_Color,Employee_Price,Discount_Exclude,Override_Parent_PZ,Modifier,Contest_Item,Button_Color,Hot_Item,Hot_Item_Display_Seq,KDS_Routing,Prep_Time_Sec,Recipe_Instructions,Priced_By_Weight,Linked_Item_ID,last_update,Linkable_Item,tax1,tax2,tax3,tax4,tax5,smart_tax,surcharge_tax,conditional_tax,kitchen_print_group,upc_number,deleted,net_forecolor,net_backcolor,on_hand_warning_threshold,rewardPoints,Is_Uploading,SeparateonKT,Print_Label,PrintPriceonKT,GratuityExclude,web_description,web_show,SetPriceID,OrderMan_Abbreviated_Name,OrderMan_Display_Sequence,Mod1Filename,Mod2Filename,Mod3Filename,Mod4Filename,Mod5Filename,Mod6Filename,Mod7Filename,Mod8Filename,Mod9Filename,Mod10Filename,Large_Picture  FROM CDM_Transfer_tblMENU_ITEMS
		where ID <=@ID and Item_Id=(select Item_Id from CDM_Transfer_tblMENU_ITEMS where id=@ID ) order by ID desc
	else if (@sqlType='Transfer')
		SELECT  id, Item_Id,Item,Abbreviated_Name,MultiLanguageSetup,Language_2_Name,Language_3_Name,Language_4_Name,Language_5_Name,KitchenPrintLang1,KitchenPrintLang2,KitchenPrintLang3,KitchenPrintLang4,KitchenPrintLang5,Price,Status,Section,Category,Print_Zone,Tax_Cat,Receipt_Print,Show_Button,Display_Sequence,Kitchen_Sum,Active,Open_Price,Date_LastSold,Alt_Price1,Alt_Price2,Happy_HourPrice,SubMenu_1,NumAllowed_1,SubMenu_2,NumAllowed_2,SubMenu_3,NumAllowed_3,SubMenu_4,NumAllowed_4,SubMenu_5,NumAllowed_5,SubMenu_6,NumAllowed_6,SubMenu_7,NumAllowed_7,SubMenu_8,NumAllowed_8,SubMenu_9,NumAllowed_9,SubMenu_10,NumAllowed_10,MI_Type,MI_Extra,MI_Has_Children,MI_Sale_Rpt_Category,Picture,PicStretchStyle,Cost,Open_Price_Minimum,Alt_Pricing_In_Use,Bar_Exclude_Tax,Expo_Exclude,Meal_Course,App_As_Entree_PZ,Check_On_Hand_Qty,Department,RollUp_Add_Price,Special_Instruction,Line_Color,Employee_Price,Discount_Exclude,Override_Parent_PZ,Modifier,Contest_Item,Button_Color,Hot_Item,Hot_Item_Display_Seq,KDS_Routing,Prep_Time_Sec,Recipe_Instructions,Priced_By_Weight,Linked_Item_ID,last_update,Linkable_Item,tax1,tax2,tax3,tax4,tax5,smart_tax,surcharge_tax,conditional_tax,kitchen_print_group,upc_number,deleted,net_forecolor,net_backcolor,on_hand_warning_threshold,rewardPoints,Is_Uploading,SeparateonKT,Print_Label,PrintPriceonKT,GratuityExclude,web_description,web_show,SetPriceID,OrderMan_Abbreviated_Name,OrderMan_Display_Sequence,Mod1Filename,Mod2Filename,Mod3Filename,Mod4Filename,Mod5Filename,Mod6Filename,Mod7Filename,Mod8Filename,Mod9Filename,Mod10Filename,Large_Picture  FROM CDM_Transfer_tblMENU_ITEMS
		where TransferState=1 order by ID asc
	else if (@sqlType='GUID')
		SELECT   id, Item_Id,Item,Abbreviated_Name,MultiLanguageSetup,Language_2_Name,Language_3_Name,Language_4_Name,Language_5_Name,KitchenPrintLang1,KitchenPrintLang2,KitchenPrintLang3,KitchenPrintLang4,KitchenPrintLang5,Price,Status,Section,Category,Print_Zone,Tax_Cat,Receipt_Print,Show_Button,Display_Sequence,Kitchen_Sum,Active,Open_Price,Date_LastSold,Alt_Price1,Alt_Price2,Happy_HourPrice,SubMenu_1,NumAllowed_1,SubMenu_2,NumAllowed_2,SubMenu_3,NumAllowed_3,SubMenu_4,NumAllowed_4,SubMenu_5,NumAllowed_5,SubMenu_6,NumAllowed_6,SubMenu_7,NumAllowed_7,SubMenu_8,NumAllowed_8,SubMenu_9,NumAllowed_9,SubMenu_10,NumAllowed_10,MI_Type,MI_Extra,MI_Has_Children,MI_Sale_Rpt_Category,Picture,PicStretchStyle,Cost,Open_Price_Minimum,Alt_Pricing_In_Use,Bar_Exclude_Tax,Expo_Exclude,Meal_Course,App_As_Entree_PZ,Check_On_Hand_Qty,Department,RollUp_Add_Price,Special_Instruction,Line_Color,Employee_Price,Discount_Exclude,Override_Parent_PZ,Modifier,Contest_Item,Button_Color,Hot_Item,Hot_Item_Display_Seq,KDS_Routing,Prep_Time_Sec,Recipe_Instructions,Priced_By_Weight,Linked_Item_ID,last_update,Linkable_Item,tax1,tax2,tax3,tax4,tax5,smart_tax,surcharge_tax,conditional_tax,kitchen_print_group,upc_number,deleted,net_forecolor,net_backcolor,on_hand_warning_threshold,rewardPoints,Is_Uploading,SeparateonKT,Print_Label,PrintPriceonKT,GratuityExclude,web_description,web_show,SetPriceID,OrderMan_Abbreviated_Name,OrderMan_Display_Sequence,Mod1Filename,Mod2Filename,Mod3Filename,Mod4Filename,Mod5Filename,Mod6Filename,Mod7Filename,Mod8Filename,Mod9Filename,Mod10Filename,Large_Picture  FROM CDM_Transfer_tblMENU_ITEMS
		where GUID=@GUID and TransferState=1 
END
GO
