SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblMENU_ITEMS_InUpDel]
	-- Add the parameters for the stored procedure here
	@Item_Id int  ,
@Item nvarchar(25) ,
@Abbreviated_Name nvarchar(25) ,
@MultiLanguageSetup nvarchar(50) ,
@Language_2_Name nvarchar(50) ,
@Language_3_Name nvarchar(50) ,
@Language_4_Name nvarchar(50) ,
@Language_5_Name nvarchar(50) ,
@KitchenPrintLang1 nvarchar(1) ,
@KitchenPrintLang2 nvarchar(1) ,
@KitchenPrintLang3 nvarchar(1) ,
@KitchenPrintLang4 nvarchar(1) ,
@KitchenPrintLang5 nvarchar(1) ,
@Price money ,
@Status nvarchar(10) ,
@Section nvarchar(25) ,
@Category nvarchar(20) ,
@Print_Zone int ,
@Tax_Cat nvarchar(1) ,
@Receipt_Print nvarchar(1) ,
@Show_Button nvarchar(1) ,
@Display_Sequence int ,
@Kitchen_Sum nvarchar(1) ,
@Active nvarchar(1) ,
@Open_Price nvarchar(1) ,
@Date_LastSold datetime ,
@Alt_Price1 money ,
@Alt_Price2 money ,
@Happy_HourPrice money ,
@SubMenu_1 nvarchar(50) ,
@NumAllowed_1 int ,
@SubMenu_2 nvarchar(50) ,
@NumAllowed_2 int ,
@SubMenu_3 nvarchar(50) ,
@NumAllowed_3 int ,
@SubMenu_4 nvarchar(50) ,
@NumAllowed_4 int ,
@SubMenu_5 nvarchar(50) ,
@NumAllowed_5 int ,
@SubMenu_6 nvarchar(50) ,
@NumAllowed_6 int ,
@SubMenu_7 nvarchar(50) ,
@NumAllowed_7 int ,
@SubMenu_8 nvarchar(50) ,
@NumAllowed_8 int ,
@SubMenu_9 nvarchar(50) ,
@NumAllowed_9 int ,
@SubMenu_10 nvarchar(50) ,
@NumAllowed_10 int ,
@MI_Type nvarchar(15) ,
@MI_Extra nvarchar(1) ,
@MI_Has_Children nvarchar(1) ,
@MI_Sale_Rpt_Category nvarchar(50) ,
@Picture nvarchar(500) ,
@PicStretchStyle int ,
@Cost money ,
@Open_Price_Minimum money ,
@Alt_Pricing_In_Use char(1) ,
@Bar_Exclude_Tax char(1) ,
@Expo_Exclude char(1) ,
@Meal_Course nvarchar(2) ,
@App_As_Entree_PZ smallint ,
@Check_On_Hand_Qty char(1) ,
@Department nvarchar(15) ,
@RollUp_Add_Price char(1) ,
@Special_Instruction char(1) ,
@Line_Color nvarchar(10) ,
@Employee_Price money ,
@Discount_Exclude char(1) ,
@Override_Parent_PZ smallint ,
@Modifier char(1) ,
@Contest_Item char(1) ,
@Button_Color nvarchar(10) ,
@Hot_Item char(1) ,
@Hot_Item_Display_Seq int ,
@KDS_Routing varchar(3) ,
@Prep_Time_Sec int ,
@Recipe_Instructions nvarchar(max)  ,
@Priced_By_Weight char(1) ,
@Linked_Item_ID int ,
@last_update datetime ,
@Linkable_Item char(1) ,
@tax1 smallint ,
@tax2 smallint ,
@tax3 smallint ,
@tax4 smallint ,
@tax5 smallint ,
@smart_tax smallint ,
@surcharge_tax smallint ,
@conditional_tax smallint ,
@kitchen_print_group nvarchar(20) ,
@upc_number nvarchar(50) ,
@deleted char(1) ,
@net_forecolor nvarchar(20) ,
@net_backcolor nvarchar(20) ,
@on_hand_warning_threshold decimal(18, 4) ,
@rewardPoints int ,
@Is_Uploading bit ,
@SeparateonKT char(1) ,
@Print_Label nvarchar(10) ,
@PrintPriceonKT char(1) ,
@GratuityExclude char(1) ,
@web_description nvarchar(100) ,
@web_show bit ,
@SetPriceID int ,
@OrderMan_Abbreviated_Name nvarchar(7) ,
@OrderMan_Display_Sequence int ,
@Mod1Filename varchar(10) ,
@Mod2Filename varchar(10) ,
@Mod3Filename varchar(10) ,
@Mod4Filename varchar(10) ,
@Mod5Filename varchar(10) ,
@Mod6Filename varchar(10) ,
@Mod7Filename varchar(10) ,
@Mod8Filename varchar(10) ,
@Mod9Filename varchar(10) ,
@Mod10Filename varchar(10) ,
@EditorID int ,
@EditorName nvarchar(50) ,
@GUID uniqueidentifier,
@sqlType nvarchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @InnerItem_Id int  
declare @InnerItem nvarchar(25) 
declare @InnerAbbreviated_Name nvarchar(25) 
declare @InnerMultiLanguageSetup nvarchar(50) 
declare @InnerLanguage_2_Name nvarchar(50) 
declare @InnerLanguage_3_Name nvarchar(50) 
declare @InnerLanguage_4_Name nvarchar(50) 
declare @InnerLanguage_5_Name nvarchar(50) 
declare @InnerKitchenPrintLang1 nvarchar(1) 
declare @InnerKitchenPrintLang2 nvarchar(1) 
declare @InnerKitchenPrintLang3 nvarchar(1) 
declare @InnerKitchenPrintLang4 nvarchar(1) 
declare @InnerKitchenPrintLang5 nvarchar(1) 
declare @InnerPrice money 
declare @InnerStatus nvarchar(10) 
declare @InnerSection nvarchar(25) 
declare @InnerCategory nvarchar(20) 
declare @InnerPrint_Zone int 
declare @InnerTax_Cat nvarchar(1) 
declare @InnerReceipt_Print nvarchar(1) 
declare @InnerShow_Button nvarchar(1) 
declare @InnerDisplay_Sequence int 
declare @InnerKitchen_Sum nvarchar(1) 
declare @InnerActive nvarchar(1) 
declare @InnerOpen_Price nvarchar(1) 
declare @InnerDate_LastSold datetime 
declare @InnerAlt_Price1 money 
declare @InnerAlt_Price2 money 
declare @InnerHappy_HourPrice money 
declare @InnerSubMenu_1 nvarchar(50) 
declare @InnerNumAllowed_1 int 
declare @InnerSubMenu_2 nvarchar(50) 
declare @InnerNumAllowed_2 int 
declare @InnerSubMenu_3 nvarchar(50) 
declare @InnerNumAllowed_3 int 
declare @InnerSubMenu_4 nvarchar(50) 
declare @InnerNumAllowed_4 int 
declare @InnerSubMenu_5 nvarchar(50) 
declare @InnerNumAllowed_5 int 
declare @InnerSubMenu_6 nvarchar(50) 
declare @InnerNumAllowed_6 int 
declare @InnerSubMenu_7 nvarchar(50) 
declare @InnerNumAllowed_7 int 
declare @InnerSubMenu_8 nvarchar(50) 
declare @InnerNumAllowed_8 int 
declare @InnerSubMenu_9 nvarchar(50) 
declare @InnerNumAllowed_9 int 
declare @InnerSubMenu_10 nvarchar(50) 
declare @InnerNumAllowed_10 int 
declare @InnerMI_Type nvarchar(15) 
declare @InnerMI_Extra nvarchar(1) 
declare @InnerMI_Has_Children nvarchar(1) 
declare @InnerMI_Sale_Rpt_Category nvarchar(50) 
declare @InnerPicture nvarchar(500) 
declare @InnerPicStretchStyle int 
declare @InnerCost money 
declare @InnerOpen_Price_Minimum money 
declare @InnerAlt_Pricing_In_Use char(1) 
declare @InnerBar_Exclude_Tax char(1) 
declare @InnerExpo_Exclude char(1) 
declare @InnerMeal_Course nvarchar(2) 
declare @InnerApp_As_Entree_PZ smallint 
declare @InnerCheck_On_Hand_Qty char(1) 
declare @InnerDepartment nvarchar(15) 
declare @InnerRollUp_Add_Price char(1) 
declare @InnerSpecial_Instruction char(1) 
declare @InnerLine_Color nvarchar(10) 
declare @InnerEmployee_Price money 
declare @InnerDiscount_Exclude char(1) 
declare @InnerOverride_Parent_PZ smallint 
declare @InnerModifier char(1) 
declare @InnerContest_Item char(1) 
declare @InnerButton_Color nvarchar(10) 
declare @InnerHot_Item char(1) 
declare @InnerHot_Item_Display_Seq int 
declare @InnerKDS_Routing varchar(3) 
declare @InnerPrep_Time_Sec int 
declare @InnerRecipe_Instructions nvarchar(max)  
declare @InnerPriced_By_Weight char(1) 
declare @InnerLinked_Item_ID int 
declare @Innerlast_update datetime 
declare @InnerLinkable_Item char(1) 
declare @Innertax1 smallint 
declare @Innertax2 smallint 
declare @Innertax3 smallint 
declare @Innertax4 smallint 
declare @Innertax5 smallint 
declare @Innersmart_tax smallint 
declare @Innersurcharge_tax smallint 
declare @Innerconditional_tax smallint 
declare @Innerkitchen_print_group nvarchar(20) 
declare @Innerupc_number nvarchar(50) 
declare @Innerdeleted char(1) 
declare @Innernet_forecolor nvarchar(20) 
declare @Innernet_backcolor nvarchar(20) 
declare @Inneron_hand_warning_threshold decimal(18,4) 
declare @InnerrewardPoints int 
declare @InnerIs_Uploading bit 
declare @InnerSeparateonKT char(1) 
declare @InnerPrint_Label nvarchar(10) 
declare @InnerPrintPriceonKT char(1) 
declare @InnerGratuityExclude char(1) 
declare @Innerweb_description nvarchar(100) 
declare @Innerweb_show bit 
declare @InnerSetPriceID int 
declare @InnerOrderMan_Abbreviated_Name nvarchar(7) 
declare @InnerOrderMan_Display_Sequence int 
declare @InnerMod1Filename varchar(10) 
declare @InnerMod2Filename varchar(10) 
declare @InnerMod3Filename varchar(10) 
declare @InnerMod4Filename varchar(10) 
declare @InnerMod5Filename varchar(10) 
declare @InnerMod6Filename varchar(10) 
declare @InnerMod7Filename varchar(10) 
declare @InnerMod8Filename varchar(10) 
declare @InnerMod9Filename varchar(10) 
declare @InnerMod10Filename varchar(10) 

	 if (@sqlType='SQLINSERT')
	begin
		INSERT INTO CDM_tblMENU_ITEMS(Item,Abbreviated_Name,MultiLanguageSetup,Language_2_Name,
		Language_3_Name,Language_4_Name,Language_5_Name,KitchenPrintLang1,KitchenPrintLang2,
		KitchenPrintLang3,KitchenPrintLang4,KitchenPrintLang5,Price,Status,Section,Category,
		Print_Zone,Tax_Cat,Receipt_Print,Show_Button,Display_Sequence,Kitchen_Sum,Active,
		Open_Price,Date_LastSold,Alt_Price1,Alt_Price2,Happy_HourPrice,SubMenu_1,NumAllowed_1,SubMenu_2,
		NumAllowed_2,SubMenu_3,NumAllowed_3,SubMenu_4,NumAllowed_4,SubMenu_5,NumAllowed_5,SubMenu_6,
		NumAllowed_6,SubMenu_7,NumAllowed_7,SubMenu_8,NumAllowed_8,SubMenu_9,NumAllowed_9,SubMenu_10,
		NumAllowed_10,MI_Type,MI_Extra,MI_Has_Children,MI_Sale_Rpt_Category,Picture,PicStretchStyle,
		Cost,Open_Price_Minimum,Alt_Pricing_In_Use,Bar_Exclude_Tax,Expo_Exclude,Meal_Course,App_As_Entree_PZ,
		Check_On_Hand_Qty,Department,RollUp_Add_Price,Special_Instruction,Line_Color,Employee_Price,
		Discount_Exclude,Override_Parent_PZ,Modifier,Contest_Item,Button_Color,Hot_Item,Hot_Item_Display_Seq,
		KDS_Routing,Prep_Time_Sec,Recipe_Instructions,Priced_By_Weight,Linked_Item_ID,last_update,
		Linkable_Item,tax1,tax2,tax3,tax4,tax5,smart_tax,surcharge_tax,conditional_tax,kitchen_print_group,
		upc_number,deleted,net_forecolor,net_backcolor,on_hand_warning_threshold,rewardPoints,Is_Uploading,
		SeparateonKT,Print_Label,PrintPriceonKT,GratuityExclude,web_description,web_show,SetPriceID,
		OrderMan_Abbreviated_Name,OrderMan_Display_Sequence,Mod1Filename,Mod2Filename,Mod3Filename,
		Mod4Filename,Mod5Filename,Mod6Filename,Mod7Filename,Mod8Filename,Mod9Filename,Mod10Filename,
		Large_Picture,EditorID,EditorName) VALUES (@Item,@Abbreviated_Name,@MultiLanguageSetup,
		@Language_2_Name,@Language_3_Name,@Language_4_Name,@Language_5_Name,@KitchenPrintLang1,
		@KitchenPrintLang2,@KitchenPrintLang3,@KitchenPrintLang4,@KitchenPrintLang5,@Price,@Status,@Section,
		@Category,@Print_Zone,@Tax_Cat,@Receipt_Print,@Show_Button,@Display_Sequence,@Kitchen_Sum,@Active,
		@Open_Price,@Date_LastSold,@Alt_Price1,@Alt_Price2,@Happy_HourPrice,@SubMenu_1,@NumAllowed_1,@SubMenu_2,
		@NumAllowed_2,@SubMenu_3,@NumAllowed_3,@SubMenu_4,@NumAllowed_4,@SubMenu_5,@NumAllowed_5,@SubMenu_6,
		@NumAllowed_6,@SubMenu_7,@NumAllowed_7,@SubMenu_8,@NumAllowed_8,@SubMenu_9,@NumAllowed_9,@SubMenu_10,
		@NumAllowed_10,@MI_Type,@MI_Extra,@MI_Has_Children,@MI_Sale_Rpt_Category,@Picture,@PicStretchStyle,
		@Cost,@Open_Price_Minimum,@Alt_Pricing_In_Use,@Bar_Exclude_Tax,@Expo_Exclude,@Meal_Course,@App_As_Entree_PZ,
		@Check_On_Hand_Qty,@Department,@RollUp_Add_Price,@Special_Instruction,@Line_Color,@Employee_Price,
		@Discount_Exclude,@Override_Parent_PZ,@Modifier,@Contest_Item,@Button_Color,@Hot_Item,@Hot_Item_Display_Seq,
		@KDS_Routing,@Prep_Time_Sec,@Recipe_Instructions,@Priced_By_Weight,@Linked_Item_ID,@last_update,
		@Linkable_Item,@tax1,@tax2,@tax3,@tax4,@tax5,@smart_tax,@surcharge_tax,@conditional_tax,@kitchen_print_group,
		@upc_number,@deleted,@net_forecolor,@net_backcolor,@on_hand_warning_threshold,@rewardPoints,@Is_Uploading,
		@SeparateonKT,@Print_Label,@PrintPriceonKT,@GratuityExclude,@web_description,@web_show,@SetPriceID,
		@OrderMan_Abbreviated_Name,@OrderMan_Display_Sequence,@Mod1Filename,@Mod2Filename,@Mod3Filename,@Mod4Filename,
		@Mod5Filename,@Mod6Filename,@Mod7Filename,@Mod8Filename,@Mod9Filename,@Mod10Filename,null,@EditorID,
		@EditorName)
		
		set @InnerItem_Id=@@IDENTITY;
		
		INSERT INTO CDM_Transfer_tblMENU_ITEMS(Item_Id,Item,Abbreviated_Name,MultiLanguageSetup,
		Language_2_Name,Language_3_Name,Language_4_Name,Language_5_Name,KitchenPrintLang1,KitchenPrintLang2,
		KitchenPrintLang3,KitchenPrintLang4,KitchenPrintLang5,Price,Status,Section,Category,Print_Zone,Tax_Cat,
		Receipt_Print,Show_Button,Display_Sequence,Kitchen_Sum,Active,Open_Price,Date_LastSold,
		Alt_Price1,Alt_Price2,Happy_HourPrice,SubMenu_1,NumAllowed_1,SubMenu_2,NumAllowed_2,SubMenu_3,
		NumAllowed_3,SubMenu_4,NumAllowed_4,SubMenu_5,NumAllowed_5,SubMenu_6,NumAllowed_6,SubMenu_7,
		NumAllowed_7,SubMenu_8,NumAllowed_8,SubMenu_9,NumAllowed_9,SubMenu_10,NumAllowed_10,MI_Type,
		MI_Extra,MI_Has_Children,MI_Sale_Rpt_Category,Picture,PicStretchStyle,Cost,Open_Price_Minimum,
		Alt_Pricing_In_Use,Bar_Exclude_Tax,Expo_Exclude,Meal_Course,App_As_Entree_PZ,Check_On_Hand_Qty,
		Department,RollUp_Add_Price,Special_Instruction,Line_Color,Employee_Price,Discount_Exclude,
		Override_Parent_PZ,Modifier,Contest_Item,Button_Color,Hot_Item,Hot_Item_Display_Seq,KDS_Routing,
		Prep_Time_Sec,Recipe_Instructions,Priced_By_Weight,Linked_Item_ID,last_update,Linkable_Item,tax1,
		tax2,tax3,tax4,tax5,smart_tax,surcharge_tax,conditional_tax,kitchen_print_group,upc_number,deleted,
		net_forecolor,net_backcolor,on_hand_warning_threshold,rewardPoints,Is_Uploading,SeparateonKT,Print_Label,
		PrintPriceonKT,GratuityExclude,web_description,web_show,SetPriceID,OrderMan_Abbreviated_Name,
		OrderMan_Display_Sequence,Mod1Filename,Mod2Filename,Mod3Filename,Mod4Filename,Mod5Filename,Mod6Filename,
		Mod7Filename,Mod8Filename,Mod9Filename,Mod10Filename,Large_Picture,EditorID,EditorName,GUID,TransferState)
		 VALUES (@InnerItem_Id,@Item,@Abbreviated_Name,@MultiLanguageSetup,@Language_2_Name,@Language_3_Name,
		 @Language_4_Name,@Language_5_Name,@KitchenPrintLang1,@KitchenPrintLang2,@KitchenPrintLang3,
		 @KitchenPrintLang4,@KitchenPrintLang5,@Price,@Status,@Section,@Category,@Print_Zone,@Tax_Cat,
		 @Receipt_Print,@Show_Button,@Display_Sequence,@Kitchen_Sum,@Active,@Open_Price,@Date_LastSold,
		 @Alt_Price1,@Alt_Price2,@Happy_HourPrice,@SubMenu_1,@NumAllowed_1,@SubMenu_2,@NumAllowed_2,
		 @SubMenu_3,@NumAllowed_3,@SubMenu_4,@NumAllowed_4,@SubMenu_5,@NumAllowed_5,@SubMenu_6,
		 @NumAllowed_6,@SubMenu_7,@NumAllowed_7,@SubMenu_8,@NumAllowed_8,@SubMenu_9,@NumAllowed_9,@SubMenu_10,
		 @NumAllowed_10,@MI_Type,@MI_Extra,@MI_Has_Children,@MI_Sale_Rpt_Category,@Picture,@PicStretchStyle,
		 @Cost,@Open_Price_Minimum,@Alt_Pricing_In_Use,@Bar_Exclude_Tax,@Expo_Exclude,@Meal_Course,
		 @App_As_Entree_PZ,@Check_On_Hand_Qty,@Department,@RollUp_Add_Price,@Special_Instruction,@Line_Color,
		 @Employee_Price,@Discount_Exclude,@Override_Parent_PZ,@Modifier,@Contest_Item,@Button_Color,@Hot_Item,
		 @Hot_Item_Display_Seq,@KDS_Routing,@Prep_Time_Sec,@Recipe_Instructions,@Priced_By_Weight,@Linked_Item_ID,
		 @last_update,@Linkable_Item,@tax1,@tax2,@tax3,@tax4,@tax5,@smart_tax,@surcharge_tax,@conditional_tax,
		 @kitchen_print_group,@upc_number,@deleted,@net_forecolor,@net_backcolor,@on_hand_warning_threshold,
		 @rewardPoints,@Is_Uploading,@SeparateonKT,@Print_Label,@PrintPriceonKT,@GratuityExclude,@web_description,
		 @web_show,@SetPriceID,@OrderMan_Abbreviated_Name,@OrderMan_Display_Sequence,@Mod1Filename,
		 @Mod2Filename,@Mod3Filename,@Mod4Filename,@Mod5Filename,@Mod6Filename,@Mod7Filename,@Mod8Filename,
		 @Mod9Filename,@Mod10Filename,null,@EditorID,@EditorName,@GUID,1)
		select @InnerItem_Id;
	end
	
	else if (@sqlType='SQLUPDATE')
		begin
		SELECT @InnerItem_Id=Item_Id,@InnerItem=Item,@InnerAbbreviated_Name=Abbreviated_Name,
		@InnerMultiLanguageSetup=MultiLanguageSetup,@InnerLanguage_2_Name=Language_2_Name,
		@InnerLanguage_3_Name=Language_3_Name,@InnerLanguage_4_Name=Language_4_Name,
		@InnerLanguage_5_Name=Language_5_Name,@InnerKitchenPrintLang1=KitchenPrintLang1,
		@InnerKitchenPrintLang2=KitchenPrintLang2,@InnerKitchenPrintLang3=KitchenPrintLang3,
		@InnerKitchenPrintLang4=KitchenPrintLang4,@InnerKitchenPrintLang5=KitchenPrintLang5,
		@InnerPrice=Price,@InnerStatus=Status,@InnerSection=Section,@InnerCategory=Category,
		@InnerPrint_Zone=Print_Zone,@InnerTax_Cat=Tax_Cat,@InnerReceipt_Print=Receipt_Print,
		@InnerShow_Button=Show_Button,@InnerDisplay_Sequence=Display_Sequence,@InnerKitchen_Sum=Kitchen_Sum,
		@InnerActive=Active,@InnerOpen_Price=Open_Price,@InnerDate_LastSold=Date_LastSold,
		@InnerAlt_Price1=Alt_Price1,@InnerAlt_Price2=Alt_Price2,@InnerHappy_HourPrice=Happy_HourPrice,
		@InnerSubMenu_1=SubMenu_1,@InnerNumAllowed_1=NumAllowed_1,@InnerSubMenu_2=SubMenu_2,
		@InnerNumAllowed_2=NumAllowed_2,@InnerSubMenu_3=SubMenu_3,@InnerNumAllowed_3=NumAllowed_3,
		@InnerSubMenu_4=SubMenu_4,@InnerNumAllowed_4=NumAllowed_4,@InnerSubMenu_5=SubMenu_5,
		@InnerNumAllowed_5=NumAllowed_5,@InnerSubMenu_6=SubMenu_6,@InnerNumAllowed_6=NumAllowed_6,
		@InnerSubMenu_7=SubMenu_7,@InnerNumAllowed_7=NumAllowed_7,@InnerSubMenu_8=SubMenu_8,
		@InnerNumAllowed_8=NumAllowed_8,@InnerSubMenu_9=SubMenu_9,@InnerNumAllowed_9=NumAllowed_9,
		@InnerSubMenu_10=SubMenu_10,@InnerNumAllowed_10=NumAllowed_10,@InnerMI_Type=MI_Type,
		@InnerMI_Extra=MI_Extra,@InnerMI_Has_Children=MI_Has_Children,
		@InnerMI_Sale_Rpt_Category=MI_Sale_Rpt_Category,@InnerPicture=Picture,
		@InnerPicStretchStyle=PicStretchStyle,@InnerCost=Cost,@InnerOpen_Price_Minimum=Open_Price_Minimum,
		@InnerAlt_Pricing_In_Use=Alt_Pricing_In_Use,@InnerBar_Exclude_Tax=Bar_Exclude_Tax,
		@InnerExpo_Exclude=Expo_Exclude,@InnerMeal_Course=Meal_Course,@InnerApp_As_Entree_PZ=App_As_Entree_PZ,
		@InnerCheck_On_Hand_Qty=Check_On_Hand_Qty,@InnerDepartment=Department,
		@InnerRollUp_Add_Price=RollUp_Add_Price,@InnerSpecial_Instruction=Special_Instruction,
		@InnerLine_Color=Line_Color,@InnerEmployee_Price=Employee_Price,
		@InnerDiscount_Exclude=Discount_Exclude,@InnerOverride_Parent_PZ=Override_Parent_PZ,
		@InnerModifier=Modifier,@InnerContest_Item=Contest_Item,@InnerButton_Color=Button_Color,
		@InnerHot_Item=Hot_Item,@InnerHot_Item_Display_Seq=Hot_Item_Display_Seq,
		@InnerKDS_Routing=KDS_Routing,@InnerPrep_Time_Sec=Prep_Time_Sec,
		@InnerRecipe_Instructions=Recipe_Instructions,@InnerPriced_By_Weight=Priced_By_Weight,
		@InnerLinked_Item_ID=Linked_Item_ID,@Innerlast_update=last_update,
		@InnerLinkable_Item=Linkable_Item,@Innertax1=tax1,@Innertax2=tax2,@Innertax3=tax3,
		@Innertax4=tax4,@Innertax5=tax5,@Innersmart_tax=smart_tax,@Innersurcharge_tax=surcharge_tax,
		@Innerconditional_tax=conditional_tax,@Innerkitchen_print_group=kitchen_print_group,
		@Innerupc_number=upc_number,@Innerdeleted=deleted,@Innernet_forecolor=net_forecolor,
		@Innernet_backcolor=net_backcolor,@Inneron_hand_warning_threshold=on_hand_warning_threshold,
		@InnerrewardPoints=rewardPoints,@InnerIs_Uploading=Is_Uploading,@InnerSeparateonKT=SeparateonKT,
		@InnerPrint_Label=Print_Label,@InnerPrintPriceonKT=PrintPriceonKT,
		@InnerGratuityExclude=GratuityExclude,@Innerweb_description=web_description,@Innerweb_show=web_show,
		@InnerSetPriceID=SetPriceID,@InnerOrderMan_Abbreviated_Name=OrderMan_Abbreviated_Name,
		@InnerOrderMan_Display_Sequence=OrderMan_Display_Sequence,@InnerMod1Filename=Mod1Filename,
		@InnerMod2Filename=Mod2Filename,@InnerMod3Filename=Mod3Filename,@InnerMod4Filename=Mod4Filename,
		@InnerMod5Filename=Mod5Filename,@InnerMod6Filename=Mod6Filename,@InnerMod7Filename=Mod7Filename,
		@InnerMod8Filename=Mod8Filename,@InnerMod9Filename=Mod9Filename,@InnerMod10Filename=Mod10Filename
		 FROM  CDM_tblMENU_ITEMS where item_id=@Item_Id
		
		UPDATE CDM_tblMENU_ITEMS SET Item=@Item,Abbreviated_Name=@Abbreviated_Name,
		MultiLanguageSetup=@MultiLanguageSetup,Language_2_Name=@Language_2_Name,
		Language_3_Name=@Language_3_Name,Language_4_Name=@Language_4_Name,
		Language_5_Name=@Language_5_Name,KitchenPrintLang1=@KitchenPrintLang1,
		KitchenPrintLang2=@KitchenPrintLang2,KitchenPrintLang3=@KitchenPrintLang3,
		KitchenPrintLang4=@KitchenPrintLang4,KitchenPrintLang5=@KitchenPrintLang5,
		Price=@Price,Status=@Status,Section=@Section,Category=@Category,Print_Zone=@Print_Zone,Tax_Cat=@Tax_Cat,
		Receipt_Print=@Receipt_Print,Show_Button=@Show_Button,Display_Sequence=@Display_Sequence,
		Kitchen_Sum=@Kitchen_Sum,Active=@Active,Open_Price=@Open_Price,Date_LastSold=@Date_LastSold,
		Alt_Price1=@Alt_Price1,Alt_Price2=@Alt_Price2,Happy_HourPrice=@Happy_HourPrice,SubMenu_1=@SubMenu_1,
		NumAllowed_1=@NumAllowed_1,SubMenu_2=@SubMenu_2,NumAllowed_2=@NumAllowed_2,SubMenu_3=@SubMenu_3,
		NumAllowed_3=@NumAllowed_3,SubMenu_4=@SubMenu_4,NumAllowed_4=@NumAllowed_4,SubMenu_5=@SubMenu_5,
		NumAllowed_5=@NumAllowed_5,SubMenu_6=@SubMenu_6,NumAllowed_6=@NumAllowed_6,SubMenu_7=@SubMenu_7,
		NumAllowed_7=@NumAllowed_7,SubMenu_8=@SubMenu_8,NumAllowed_8=@NumAllowed_8,SubMenu_9=@SubMenu_9,
		NumAllowed_9=@NumAllowed_9,SubMenu_10=@SubMenu_10,NumAllowed_10=@NumAllowed_10,MI_Type=@MI_Type,
		MI_Extra=@MI_Extra,MI_Has_Children=@MI_Has_Children,MI_Sale_Rpt_Category=@MI_Sale_Rpt_Category,
		Picture=@Picture,PicStretchStyle=@PicStretchStyle,Cost=@Cost,Open_Price_Minimum=@Open_Price_Minimum,
		Alt_Pricing_In_Use=@Alt_Pricing_In_Use,Bar_Exclude_Tax=@Bar_Exclude_Tax,Expo_Exclude=@Expo_Exclude,
		Meal_Course=@Meal_Course,App_As_Entree_PZ=@App_As_Entree_PZ,Check_On_Hand_Qty=@Check_On_Hand_Qty,
		Department=@Department,RollUp_Add_Price=@RollUp_Add_Price,Special_Instruction=@Special_Instruction,
		Line_Color=@Line_Color,Employee_Price=@Employee_Price,Discount_Exclude=@Discount_Exclude,
		Override_Parent_PZ=@Override_Parent_PZ,Modifier=@Modifier,Contest_Item=@Contest_Item,
		Button_Color=@Button_Color,Hot_Item=@Hot_Item,Hot_Item_Display_Seq=@Hot_Item_Display_Seq,
		KDS_Routing=@KDS_Routing,Prep_Time_Sec=@Prep_Time_Sec,Recipe_Instructions=@Recipe_Instructions,
		Priced_By_Weight=@Priced_By_Weight,Linked_Item_ID=@Linked_Item_ID,last_update=@last_update,
		Linkable_Item=@Linkable_Item,tax1=@tax1,tax2=@tax2,tax3=@tax3,tax4=@tax4,tax5=@tax5,
		smart_tax=@smart_tax,surcharge_tax=@surcharge_tax,conditional_tax=@conditional_tax,
		kitchen_print_group=@kitchen_print_group,upc_number=@upc_number,deleted=@deleted,
		net_forecolor=@net_forecolor,net_backcolor=@net_backcolor,on_hand_warning_threshold=@on_hand_warning_threshold,
		rewardPoints=@rewardPoints,Is_Uploading=@Is_Uploading,SeparateonKT=@SeparateonKT,Print_Label=@Print_Label,
		PrintPriceonKT=@PrintPriceonKT,GratuityExclude=@GratuityExclude,web_description=@web_description,
		web_show=@web_show,SetPriceID=@SetPriceID,OrderMan_Abbreviated_Name=@OrderMan_Abbreviated_Name,
		OrderMan_Display_Sequence=@OrderMan_Display_Sequence,Mod1Filename=@Mod1Filename,Mod2Filename=@Mod2Filename,
		Mod3Filename=@Mod3Filename,Mod4Filename=@Mod4Filename,Mod5Filename=@Mod5Filename,Mod6Filename=@Mod6Filename,
		Mod7Filename=@Mod7Filename,Mod8Filename=@Mod8Filename,Mod9Filename=@Mod9Filename,Mod10Filename=@Mod10Filename,
		EditorID=@EditorID,EditorName=@EditorName 
		where Item_Id=@Item_Id
		
		if ( @innerItem!=@Item or @innerAbbreviated_Name!=@Abbreviated_Name or 
		@innerMultiLanguageSetup!=@MultiLanguageSetup or @innerLanguage_2_Name!=@Language_2_Name 
		or @innerLanguage_3_Name!=@Language_3_Name or @innerLanguage_4_Name!=@Language_4_Name 
		or @innerLanguage_5_Name!=@Language_5_Name or @innerKitchenPrintLang1!=@KitchenPrintLang1 
		or @innerKitchenPrintLang2!=@KitchenPrintLang2 or @innerKitchenPrintLang3!=@KitchenPrintLang3 
		or @innerKitchenPrintLang4!=@KitchenPrintLang4 or @innerKitchenPrintLang5!=@KitchenPrintLang5 
		or @innerPrice!=@Price or @innerStatus!=@Status or @innerSection!=@Section 
		or @innerCategory!=@Category or @innerPrint_Zone!=@Print_Zone or @innerTax_Cat!=@Tax_Cat 
		or @innerReceipt_Print!=@Receipt_Print or @innerShow_Button!=@Show_Button 
		or @innerDisplay_Sequence!=@Display_Sequence or @innerKitchen_Sum!=@Kitchen_Sum 
		or @innerActive!=@Active or @innerOpen_Price!=@Open_Price or @innerDate_LastSold!=@Date_LastSold 
		or @innerAlt_Price1!=@Alt_Price1 or @innerAlt_Price2!=@Alt_Price2 
		or @innerHappy_HourPrice!=@Happy_HourPrice or @innerSubMenu_1!=@SubMenu_1 
		or @innerNumAllowed_1!=@NumAllowed_1 or @innerSubMenu_2!=@SubMenu_2 
		or @innerNumAllowed_2!=@NumAllowed_2 or @innerSubMenu_3!=@SubMenu_3 
		or @innerNumAllowed_3!=@NumAllowed_3 or @innerSubMenu_4!=@SubMenu_4 
		or @innerNumAllowed_4!=@NumAllowed_4 or @innerSubMenu_5!=@SubMenu_5 
		or @innerNumAllowed_5!=@NumAllowed_5 or @innerSubMenu_6!=@SubMenu_6 
		or @innerNumAllowed_6!=@NumAllowed_6 or @innerSubMenu_7!=@SubMenu_7 
		or @innerNumAllowed_7!=@NumAllowed_7 or @innerSubMenu_8!=@SubMenu_8 
		or @innerNumAllowed_8!=@NumAllowed_8 or @innerSubMenu_9!=@SubMenu_9 
		or @innerNumAllowed_9!=@NumAllowed_9 or @innerSubMenu_10!=@SubMenu_10 
		or @innerNumAllowed_10!=@NumAllowed_10 or @innerMI_Type!=@MI_Type 
		or @innerMI_Extra!=@MI_Extra or @innerMI_Has_Children!=@MI_Has_Children 
		or @innerMI_Sale_Rpt_Category!=@MI_Sale_Rpt_Category or @innerPicture!=@Picture 
		or @innerPicStretchStyle!=@PicStretchStyle or @innerCost!=@Cost 
		or @innerOpen_Price_Minimum!=@Open_Price_Minimum or @innerAlt_Pricing_In_Use!=@Alt_Pricing_In_Use 
		or @innerBar_Exclude_Tax!=@Bar_Exclude_Tax or @innerExpo_Exclude!=@Expo_Exclude 
		or @innerMeal_Course!=@Meal_Course or @innerApp_As_Entree_PZ!=@App_As_Entree_PZ 
		or @innerCheck_On_Hand_Qty!=@Check_On_Hand_Qty or @innerDepartment!=@Department 
		or @innerRollUp_Add_Price!=@RollUp_Add_Price or @innerSpecial_Instruction!=@Special_Instruction 
		or @innerLine_Color!=@Line_Color or @innerEmployee_Price!=@Employee_Price 
		or @innerDiscount_Exclude!=@Discount_Exclude or @innerOverride_Parent_PZ!=@Override_Parent_PZ 
		or @innerModifier!=@Modifier or @innerContest_Item!=@Contest_Item 
		or @innerButton_Color!=@Button_Color or @innerHot_Item!=@Hot_Item 
		or @innerHot_Item_Display_Seq!=@Hot_Item_Display_Seq or @innerKDS_Routing!=@KDS_Routing 
		or @innerPrep_Time_Sec!=@Prep_Time_Sec or @innerRecipe_Instructions!=@Recipe_Instructions 
		or @innerPriced_By_Weight!=@Priced_By_Weight or @innerLinked_Item_ID!=@Linked_Item_ID 
		or @innerLast_update!=@Last_update or @innerLinkable_Item!=@Linkable_Item or @innerTax1!=@Tax1 
		or @innerTax2!=@Tax2 or @innerTax3!=@Tax3 or @innerTax4!=@Tax4 or @innerTax5!=@Tax5 
		or @innerSmart_tax!=@Smart_tax or @innerSurcharge_tax!=@Surcharge_tax 
		or @innerConditional_tax!=@Conditional_tax or @innerKitchen_print_group!=@Kitchen_print_group 
		or @innerUpc_number!=@Upc_number or @innerDeleted!=@Deleted or @innerNet_forecolor!=@Net_forecolor 
		or @innerNet_backcolor!=@Net_backcolor or @innerOn_hand_warning_threshold!=@On_hand_warning_threshold 
		or @innerRewardPoints!=@RewardPoints or @innerIs_Uploading!=@Is_Uploading 
		or @innerSeparateonKT!=@SeparateonKT or @innerPrint_Label!=@Print_Label 
		or @innerPrintPriceonKT!=@PrintPriceonKT or @innerGratuityExclude!=@GratuityExclude 
		or @innerWeb_description!=@Web_description or @innerWeb_show!=@Web_show 
		or @innerSetPriceID!=@SetPriceID or @innerOrderMan_Abbreviated_Name!=@OrderMan_Abbreviated_Name 
		or @innerOrderMan_Display_Sequence!=@OrderMan_Display_Sequence or @innerMod1Filename!=@Mod1Filename 
		or @innerMod2Filename!=@Mod2Filename or @innerMod3Filename!=@Mod3Filename 
		or @innerMod4Filename!=@Mod4Filename or @innerMod5Filename!=@Mod5Filename 
		or @innerMod6Filename!=@Mod6Filename or @innerMod7Filename!=@Mod7Filename 
		or @innerMod8Filename!=@Mod8Filename or @innerMod9Filename!=@Mod9Filename 
		or @innerMod10Filename!=@Mod10Filename )
		INSERT INTO CDM_Transfer_tblMENU_ITEMS(Item_Id,Item,Abbreviated_Name,MultiLanguageSetup,
		Language_2_Name,Language_3_Name,Language_4_Name,Language_5_Name,KitchenPrintLang1,KitchenPrintLang2,
		KitchenPrintLang3,KitchenPrintLang4,KitchenPrintLang5,Price,Status,Section,Category,Print_Zone,Tax_Cat,
		Receipt_Print,Show_Button,Display_Sequence,Kitchen_Sum,Active,Open_Price,Date_LastSold,Alt_Price1,
		Alt_Price2,Happy_HourPrice,SubMenu_1,NumAllowed_1,SubMenu_2,NumAllowed_2,SubMenu_3,NumAllowed_3,SubMenu_4,
		NumAllowed_4,SubMenu_5,NumAllowed_5,SubMenu_6,NumAllowed_6,SubMenu_7,NumAllowed_7,SubMenu_8,NumAllowed_8,
		SubMenu_9,NumAllowed_9,SubMenu_10,NumAllowed_10,MI_Type,MI_Extra,MI_Has_Children,MI_Sale_Rpt_Category,
		Picture,PicStretchStyle,Cost,Open_Price_Minimum,Alt_Pricing_In_Use,Bar_Exclude_Tax,Expo_Exclude,Meal_Course,
		App_As_Entree_PZ,Check_On_Hand_Qty,Department,RollUp_Add_Price,Special_Instruction,Line_Color,Employee_Price,
		Discount_Exclude,Override_Parent_PZ,Modifier,Contest_Item,Button_Color,Hot_Item,Hot_Item_Display_Seq,
		KDS_Routing,Prep_Time_Sec,Recipe_Instructions,Priced_By_Weight,Linked_Item_ID,last_update,Linkable_Item,
		tax1,tax2,tax3,tax4,tax5,smart_tax,surcharge_tax,conditional_tax,kitchen_print_group,upc_number,deleted,
		net_forecolor,net_backcolor,on_hand_warning_threshold,rewardPoints,Is_Uploading,SeparateonKT,Print_Label,
		PrintPriceonKT,GratuityExclude,web_description,web_show,SetPriceID,OrderMan_Abbreviated_Name,
		OrderMan_Display_Sequence,Mod1Filename,Mod2Filename,Mod3Filename,Mod4Filename,Mod5Filename,Mod6Filename,
		Mod7Filename,Mod8Filename,Mod9Filename,Mod10Filename,Large_Picture,EditorID,EditorName,GUID,TransferState) 
		VALUES (@Item_Id,@Item,@Abbreviated_Name,@MultiLanguageSetup,@Language_2_Name,@Language_3_Name,@Language_4_Name,
		@Language_5_Name,@KitchenPrintLang1,@KitchenPrintLang2,@KitchenPrintLang3,@KitchenPrintLang4,
		@KitchenPrintLang5,@Price,@Status,@Section,@Category,@Print_Zone,@Tax_Cat,@Receipt_Print,@Show_Button,
		@Display_Sequence,@Kitchen_Sum,@Active,@Open_Price,@Date_LastSold,@Alt_Price1,@Alt_Price2,
		@Happy_HourPrice,@SubMenu_1,@NumAllowed_1,@SubMenu_2,@NumAllowed_2,@SubMenu_3,@NumAllowed_3,@SubMenu_4,
		@NumAllowed_4,@SubMenu_5,@NumAllowed_5,@SubMenu_6,@NumAllowed_6,@SubMenu_7,@NumAllowed_7,@SubMenu_8,
		@NumAllowed_8,@SubMenu_9,@NumAllowed_9,@SubMenu_10,@NumAllowed_10,@MI_Type,@MI_Extra,@MI_Has_Children,
		@MI_Sale_Rpt_Category,@Picture,@PicStretchStyle,@Cost,@Open_Price_Minimum,@Alt_Pricing_In_Use,
		@Bar_Exclude_Tax,@Expo_Exclude,@Meal_Course,@App_As_Entree_PZ,@Check_On_Hand_Qty,@Department,
		@RollUp_Add_Price,@Special_Instruction,@Line_Color,@Employee_Price,@Discount_Exclude,@Override_Parent_PZ,
		@Modifier,@Contest_Item,@Button_Color,@Hot_Item,@Hot_Item_Display_Seq,@KDS_Routing,@Prep_Time_Sec,
		@Recipe_Instructions,@Priced_By_Weight,@Linked_Item_ID,@last_update,@Linkable_Item,@tax1,@tax2,@tax3,
		@tax4,@tax5,@smart_tax,@surcharge_tax,@conditional_tax,@kitchen_print_group,@upc_number,@deleted,
		@net_forecolor,@net_backcolor,@on_hand_warning_threshold,@rewardPoints,@Is_Uploading,@SeparateonKT,
		@Print_Label,@PrintPriceonKT,@GratuityExclude,@web_description,@web_show,@SetPriceID,
		@OrderMan_Abbreviated_Name,@OrderMan_Display_Sequence,@Mod1Filename,@Mod2Filename,@Mod3Filename,
		@Mod4Filename,@Mod5Filename,@Mod6Filename,@Mod7Filename,@Mod8Filename,@Mod9Filename,@Mod10Filename,
		null,@EditorID,@EditorName,@GUID,1)
		end
END

GO
