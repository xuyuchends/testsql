SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[CDM_tblMENU_EVENTS_Sel]
	-- Add the parameters for the stored procedure here
	@pk nvarchar(20),
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@sqlType='SQLSELECT')
		SELECT pk,menu_event,return_value,use_same_as_dining  FROM CDM_tblMENU_EVENTS
END
GO
