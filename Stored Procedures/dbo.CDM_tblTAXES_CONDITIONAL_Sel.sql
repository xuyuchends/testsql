SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblTAXES_CONDITIONAL_Sel]
	-- Add the parameters for the stored procedure here
	@con_tax_id int,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@sqlType='SQLSELECT')
		SELECT con_tax_id,con_desc,con_type,con_primary_tax_id,con_quantity,con_check_total,con_category,con_success_tax_id,con_fail_tax_id,con_lastupdate,con_deleted,EditorID,EditorName FROM CDM_tblTAXES_CONDITIONAL where con_deleted = 'N'
	else if (@sqlType='SQLSELECTDETAIL')
		SELECT con_tax_id,con_desc,con_type,con_primary_tax_id,con_quantity,con_check_total,con_category,con_success_tax_id,con_fail_tax_id,con_lastupdate,con_deleted,EditorID,EditorName FROM CDM_tblTAXES_CONDITIONAL where con_tax_id=@con_tax_id
END
GO
