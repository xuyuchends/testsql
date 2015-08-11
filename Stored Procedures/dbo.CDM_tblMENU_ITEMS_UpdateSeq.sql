SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblMENU_ITEMS_UpdateSeq]
	-- Add the parameters for the stored procedure here
	@Item_Id int  ,
	@Sequence int ,
	@EditorID int ,
	@EditorName nvarchar(50) ,
	@GUID uniqueidentifier,
	@sqlType nvarchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @innerSequence int
	if (@sqlType='SQLUpdateMLSequence')
	begin
		update CDM_tblMENU_ITEMS set Display_Sequence=@Sequence,last_update=GETDATE() where Item_Id=@Item_Id
	end
	else if (@sqlType='SQLUpdateHotItemSequence')
	begin
		update CDM_tblMENU_ITEMS set Hot_Item_Display_Seq=@Sequence,last_update=GETDATE() where Item_Id=@Item_Id
	end

END
GO
