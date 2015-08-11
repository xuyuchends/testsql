SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblmodifier_menus_InUpDel]
@ModifierMenuID nvarchar(20) ,
@MenuItemID char(30) ,
@Display_Sequence smallint ,
@ModifierPrice money ,
@UseModifierPrice bit ,
@PriceLevel smallint ,
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
		INSERT INTO CDM_tblMODIFIER_MENUS(ModifierMenuID,MenuItemID,Display_Sequence,ModifierPrice,
		UseModifierPrice,PriceLevel,EditorID,EditorName) VALUES (@ModifierMenuID,@MenuItemID,
		@Display_Sequence,@ModifierPrice,@UseModifierPrice,@PriceLevel,@EditorID,@EditorName)
		end
	else if (@sqlType='SQLDELETE')
		delete from CDM_tblMODIFIER_MENUS  where ModifierMenuID=@ModifierMenuID
END
GO
