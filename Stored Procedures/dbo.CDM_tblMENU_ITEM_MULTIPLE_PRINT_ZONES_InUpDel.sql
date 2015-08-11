SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblMENU_ITEM_MULTIPLE_PRINT_ZONES_InUpDel]
	-- Add the parameters for the stored procedure here
	@menuItemID int,
	@print_Zone int,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@sqlType='SQLINSERT')
		insert into CDM_tblmenu_item_multiple_print_zones values (@menuItemID, @print_Zone)
	else if (@sqlType='SQLDELETE')
		delete from CDM_tblmenu_item_multiple_print_zones where itemID=@menuItemID
END
GO
