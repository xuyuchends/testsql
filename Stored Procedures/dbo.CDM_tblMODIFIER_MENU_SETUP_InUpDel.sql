SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblMODIFIER_MENU_SETUP_InUpDel]
@ModifierMenuID nvarchar(20) ,
@NewModifierMenuID nvarchar(20) ,
@Language_1_Name nvarchar(30) ,
@Language_2_Name nvarchar(30) ,
@Language_3_Name nvarchar(30) ,
@Language_4_Name nvarchar(30) ,
@Language_5_Name nvarchar(30) ,
@ForceModifier char(1) ,
@ModifierMenuType nvarchar(10) ,
@Limit_Num_Allowed char(1) ,
@ShortCut_Menu nvarchar(30) ,
@ModifierMenuCategory nvarchar(15) ,
@Num_Free int ,
@ModFilename varchar(10) ,
@EditorID int ,
@EditorName nvarchar(50) ,
@GUID uniqueidentifier,
@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @innerModifierMenuID nvarchar(20) 
	declare @innerNewModifierMenuID nvarchar(20) 
	declare @innerLanguage_1_Name nvarchar(30) 
	declare @innerLanguage_2_Name nvarchar(30) 
	declare @innerLanguage_3_Name nvarchar(30) 
	declare @innerLanguage_4_Name nvarchar(30) 
	declare @innerLanguage_5_Name nvarchar(30) 
	declare @innerForceModifier char(1) 
	declare @innerModifierMenuType nvarchar(10) 
	declare @innerLimit_Num_Allowed char(1) 
	declare @innerShortCut_Menu nvarchar(30) 
	declare @innerModifierMenuCategory nvarchar(15) 
	declare @innerNum_Free int 
	declare @innerModFilename varchar(10) 
	if (@sqlType='SQLINSERT')
		begin
		INSERT INTO CDM_tblMODIFIER_MENU_SETUP(ModifierMenuID,Language_1_Name,Language_2_Name,
		Language_3_Name,Language_4_Name,Language_5_Name,ForceModifier,ModifierMenuType,
		Limit_Num_Allowed,ShortCut_Menu,ModifierMenuCategory,last_update,Num_Free,ModFilename,
		EditorID,EditorName) VALUES (@NewModifierMenuID,@Language_1_Name,@Language_2_Name,@Language_3_Name,
		@Language_4_Name,@Language_5_Name,@ForceModifier,@ModifierMenuType,@Limit_Num_Allowed,
		@ShortCut_Menu,@ModifierMenuCategory,GETDATE(),@Num_Free,@ModFilename,@EditorID,@EditorName)
		
		INSERT INTO CDM_Transfer_tblMODIFIER_MENU_SETUP(ModifierMenuID,Language_1_Name,Language_2_Name,
		Language_3_Name,Language_4_Name,Language_5_Name,ForceModifier,ModifierMenuType,Limit_Num_Allowed,
		ShortCut_Menu,ModifierMenuCategory,last_update,Num_Free,ModFilename,CDMOperate,EditorID,EditorName,GUID,
		TransferState) VALUES (@ModifierMenuID,@Language_1_Name,@Language_2_Name,@Language_3_Name,
		@Language_4_Name,@Language_5_Name,@ForceModifier,@ModifierMenuType,
		@Limit_Num_Allowed,@ShortCut_Menu,@ModifierMenuCategory,GETDATE(),@Num_Free,@ModFilename,'Modify',
		@EditorID,@EditorName,@GUID,1)
		end
	else if (@sqlType='SQLUPDATE')
		begin
		UPDATE CDM_tblMODIFIER_MENU_SETUP SET ModifierMenuID=@newModifierMenuID,
		Language_1_Name=@Language_1_Name,Language_2_Name=@Language_2_Name,Language_3_Name=@Language_3_Name,
		Language_4_Name=@Language_4_Name,Language_5_Name=@Language_5_Name,ForceModifier=@ForceModifier,
		ModifierMenuType=@ModifierMenuType,Limit_Num_Allowed=@Limit_Num_Allowed,ShortCut_Menu=@ShortCut_Menu,
		ModifierMenuCategory=@ModifierMenuCategory,last_update=GETDATE(),Num_Free=@Num_Free,
		ModFilename=@ModFilename, EditorID=@EditorID,EditorName=@EditorName where ModifierMenuID=@ModifierMenuID
		
		INSERT INTO CDM_Transfer_tblMODIFIER_MENU_SETUP(ModifierMenuID,Language_1_Name,Language_2_Name,
		Language_3_Name,Language_4_Name,Language_5_Name,ForceModifier,ModifierMenuType,Limit_Num_Allowed,
		ShortCut_Menu,ModifierMenuCategory,last_update,Num_Free,ModFilename,CDMOperate,EditorID,EditorName,GUID,
		TransferState) VALUES (@newModifierMenuID,@Language_1_Name,@Language_2_Name,@Language_3_Name,
		@Language_4_Name,@Language_5_Name,@ForceModifier,@ModifierMenuType,
		@Limit_Num_Allowed,@ShortCut_Menu,@ModifierMenuCategory,GETDATE(),@Num_Free,@ModFilename,'Modify',
		@EditorID,@EditorName,@GUID,1)
		end
	else if (@sqlType='SQLDELETE')
		begin
		SELECT @innerLanguage_1_Name=Language_1_Name,@innerLanguage_2_Name= Language_2_Name,@innerLanguage_3_Name= Language_3_Name,@innerLanguage_4_Name= Language_4_Name,@innerLanguage_5_Name= Language_5_Name,@innerForceModifier= ForceModifier,@innerModifierMenuType= ModifierMenuType,@innerLimit_Num_Allowed= Limit_Num_Allowed,@innerShortCut_Menu= ShortCut_Menu ,@innerModifierMenuCategory= ModifierMenuCategory,@innerNum_Free= Num_Free,@innerModFilename= ModFilename FROM CDM_tblMODIFIER_MENU_SETUP
		delete from CDM_tblMODIFIER_MENU_SETUP  where ModifierMenuID=@ModifierMenuID
		
		INSERT INTO CDM_Transfer_tblMODIFIER_MENU_SETUP(ModifierMenuID,Language_1_Name,Language_2_Name,
		Language_3_Name,Language_4_Name,Language_5_Name,ForceModifier,ModifierMenuType,Limit_Num_Allowed,
		ShortCut_Menu,ModifierMenuCategory,last_update,Num_Free,ModFilename,CDMOperate,EditorID,EditorName,GUID,
		TransferState) VALUES (@ModifierMenuID,@innerLanguage_1_Name,@innerLanguage_2_Name,@innerLanguage_3_Name,
		@innerLanguage_4_Name,@innerLanguage_5_Name,@innerForceModifier,@innerModifierMenuType,
		@innerLimit_Num_Allowed,@innerShortCut_Menu,@innerModifierMenuCategory,GETDATE(),@innerNum_Free,@innerModFilename,'Delete',
		@EditorID,@EditorName,@GUID,1)
		end
END
GO
