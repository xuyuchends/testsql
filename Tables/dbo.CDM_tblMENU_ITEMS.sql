CREATE TABLE [dbo].[CDM_tblMENU_ITEMS]
(
[Item_Id] [int] NOT NULL IDENTITY(1, 1),
[Item] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Abbreviated_Name] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MultiLanguageSetup] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Language_2_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Language_3_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Language_4_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Language_5_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KitchenPrintLang1] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KitchenPrintLang2] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KitchenPrintLang3] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KitchenPrintLang4] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KitchenPrintLang5] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Price] [money] NULL,
[Status] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Section] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Print_Zone] [int] NULL,
[Tax_Cat] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Receipt_Print] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Show_Button] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Display_Sequence] [int] NULL,
[Kitchen_Sum] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Open_Price] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Date_LastSold] [datetime] NULL,
[Alt_Price1] [money] NULL,
[Alt_Price2] [money] NULL,
[Happy_HourPrice] [money] NULL,
[SubMenu_1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumAllowed_1] [int] NULL,
[SubMenu_2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumAllowed_2] [int] NULL,
[SubMenu_3] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumAllowed_3] [int] NULL,
[SubMenu_4] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumAllowed_4] [int] NULL,
[SubMenu_5] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumAllowed_5] [int] NULL,
[SubMenu_6] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumAllowed_6] [int] NULL,
[SubMenu_7] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumAllowed_7] [int] NULL,
[SubMenu_8] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumAllowed_8] [int] NULL,
[SubMenu_9] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumAllowed_9] [int] NULL,
[SubMenu_10] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumAllowed_10] [int] NULL,
[MI_Type] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MI_Extra] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MI_Has_Children] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MI_Sale_Rpt_Category] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Picture] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PicStretchStyle] [int] NULL,
[Cost] [money] NULL,
[Open_Price_Minimum] [money] NULL,
[Alt_Pricing_In_Use] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Bar_Exclude_Tax] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Expo_Exclude] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Meal_Course] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[App_As_Entree_PZ] [smallint] NULL,
[Check_On_Hand_Qty] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Department] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RollUp_Add_Price] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Special_Instruction] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Line_Color] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Employee_Price] [money] NULL,
[Discount_Exclude] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Override_Parent_PZ] [smallint] NULL,
[Modifier] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Contest_Item] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Button_Color] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hot_Item] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hot_Item_Display_Seq] [int] NULL,
[KDS_Routing] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Prep_Time_Sec] [int] NULL,
[Recipe_Instructions] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Priced_By_Weight] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Linked_Item_ID] [int] NULL,
[last_update] [datetime] NULL,
[Linkable_Item] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax1] [smallint] NULL,
[tax2] [smallint] NULL,
[tax3] [smallint] NULL,
[tax4] [smallint] NULL,
[tax5] [smallint] NULL,
[smart_tax] [smallint] NULL,
[surcharge_tax] [smallint] NULL,
[conditional_tax] [smallint] NOT NULL,
[kitchen_print_group] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[upc_number] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[deleted] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[net_forecolor] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[net_backcolor] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[on_hand_warning_threshold] [decimal] (18, 4) NOT NULL,
[rewardPoints] [int] NOT NULL,
[Is_Uploading] [bit] NOT NULL,
[SeparateonKT] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Print_Label] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrintPriceonKT] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GratuityExclude] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[web_description] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[web_show] [bit] NOT NULL,
[SetPriceID] [int] NULL,
[OrderMan_Abbreviated_Name] [nvarchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderMan_Display_Sequence] [int] NULL,
[Mod1Filename] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mod2Filename] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mod3Filename] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mod4Filename] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mod5Filename] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mod6Filename] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mod7Filename] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mod8Filename] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mod9Filename] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mod10Filename] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Large_Picture] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EditorID] [int] NULL,
[EditorName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[CDM_tblMENU_ITEMS] ADD CONSTRAINT [PK_CDM_tblMENU_ITEMS] PRIMARY KEY CLUSTERED  ([Item_Id]) ON [PRIMARY]
GO
