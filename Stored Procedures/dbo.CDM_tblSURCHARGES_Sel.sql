SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblSURCHARGES_Sel]
	-- Add the parameters for the stored procedure here
	@surID int,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@sqlType='SQLSELECT')
		SELECT sur_id,sur_desc,sur_type,sur_amt,sur_percent,sur_lastupdate,sur_deleted,last_update,EditorID,EditorName FROM CDM_tblSURCHARGES 
		where sur_deleted='N'
	else if (@sqlType='SQLSELECTDETAIL')
		SELECT sur_id,sur_desc,sur_type,sur_amt,sur_percent,sur_lastupdate,sur_deleted,last_update,EditorID,EditorName FROM CDM_tblSURCHARGES 
		 where sur_id=@surID
END
GO
