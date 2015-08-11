SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblSHORTCUTS_InUpDel]
@ShortcutID bigint  ,
@ID nvarchar(50) ,
@Caption nvarchar(50) ,
@Language_2_Name nvarchar(50) ,
@Language_3_Name nvarchar(50) ,
@Language_4_Name nvarchar(50) ,
@Language_5_Name nvarchar(50) ,
@Display_Seq int ,
@Link nvarchar(50) ,
@Action nvarchar(50) ,
@Color nvarchar(50) ,
@All_Sections nvarchar(50) ,
@Section nvarchar(50) ,
@Special_Process nvarchar(50) ,
@Hide_Menu nvarchar(50) ,
@Hide_ShortMenu nvarchar(50) ,
@Security_Module nvarchar(50) ,
@Security_FieldID nvarchar(50) ,
@Show_Button nvarchar(50) ,
@UnSelected_State nvarchar(50) ,
@Extra_Menu nvarchar(50) ,
@ShortCut_Menu nvarchar(15) ,
@Menu_Meal_Type nvarchar(10) ,
@default_menu_link char(1) ,
@fore_color nvarchar(15) ,
@back_color_net nvarchar(50) ,
@fore_color_net nvarchar(50) ,
@Web_Show bit ,
@OrderMan_Caption nvarchar(50) ,
@MCColor nvarchar(50) ,
@MCfore_color nvarchar(50) ,
@ActionID bigint,
@EditorID int ,
@EditorName nvarchar(50) ,
@GUID uniqueidentifier,
@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@sqlType='SQLINSERT')
	begin
		INSERT INTO CDM_tblSHORTCUTS(ID,Caption,Language_2_Name,Language_3_Name,Language_4_Name,
		Language_5_Name,Display_Seq,Link,Action,Color,All_Sections,Section,Special_Process,Hide_Menu,
		Hide_ShortMenu,Security_Module,Security_FieldID,Show_Button,UnSelected_State,Extra_Menu,
		ShortCut_Menu,Menu_Meal_Type,default_menu_link,fore_color,back_color_net,fore_color_net,
		Web_Show,OrderMan_Caption,LastUpdate,EditorID,EditorName,MCColor,MCfore_color,ActionID) 
		VALUES (@ID,@Caption,@Language_2_Name,@Language_3_Name,@Language_4_Name,@Language_5_Name,
		@Display_Seq,@Link,@Action,@Color,@All_Sections,@Section,@Special_Process,@Hide_Menu,
		@Hide_ShortMenu,@Security_Module,@Security_FieldID,@Show_Button,@UnSelected_State,@Extra_Menu,
		@ShortCut_Menu,@Menu_Meal_Type,@default_menu_link,@fore_color,@back_color_net,@fore_color_net,
		@Web_Show,@OrderMan_Caption,GETDATE(),@EditorID,@EditorName,@MCColor,@MCfore_color,@Action)
			
		-- 如果有状态为new的就更新，没有就insert
		if exists(select * from CDM_Transfer_Shortcuts 	where TransferState=1 and Shortcut=@ID)
			update CDM_Transfer_Shortcuts set CDMOperate='Modify' where TransferState=1 and Shortcut=@ID
		else
			INSERT INTO CDM_Transfer_Shortcuts(Shortcut,CDMOperate,EditorID,EditorName,GUID,TransferState) 
			VALUES (@ID,'Modify',@EditorID,@EditorName,@GUID,1)
	end
	else if (@sqlType='SQLDELETELink')
	begin
		delete from CDM_tblSHORTCUTS where id=@ID
		if exists(select * from CDM_Transfer_Shortcuts 	where TransferState=1 and Shortcut=@ID)
			update CDM_Transfer_Shortcuts set CDMOperate='Delete' where TransferState=1 and Shortcut=@ID
		else
			INSERT INTO CDM_Transfer_Shortcuts(Shortcut,CDMOperate,EditorID,EditorName,GUID,TransferState) 
			VALUES (@ID,'Delete',@EditorID,@EditorName,@GUID,1)
	end
	else if (@sqlType='SQLDELETEButton')
	begin
		declare @innerID nvarchar(50)
		select  @innerID=id  from CDM_tblSHORTCUTS where ShortcutID=@ShortcutID
		delete from CDM_tblSHORTCUTS where ShortcutID=@ShortcutID
		if exists(select * from CDM_tblSHORTCUTS where ID=@innerID)
		begin
			--ID还存在
			if exists(select * from CDM_Transfer_Shortcuts 	where TransferState=1 and Shortcut=@ID)
				update CDM_Transfer_Shortcuts set CDMOperate='Modify' where TransferState=1 and Shortcut=@ID
			else
				INSERT INTO CDM_Transfer_Shortcuts(Shortcut,CDMOperate,EditorID,EditorName,GUID,TransferState) 
				VALUES (@ID,'Modify',@EditorID,@EditorName,@GUID,1)
		end
		else
		begin
			--ID还存在
			if exists(select * from CDM_Transfer_Shortcuts 	where TransferState=1 and Shortcut=@ID)
				update CDM_Transfer_Shortcuts set CDMOperate='Delete' where TransferState=1 and Shortcut=@ID
			else
				INSERT INTO CDM_Transfer_Shortcuts(Shortcut,CDMOperate,EditorID,EditorName,GUID,TransferState) 
				VALUES (@ID,'Delete',@EditorID,@EditorName,@GUID,1)
		end
	end
END
GO
