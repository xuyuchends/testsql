SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblTAX_RATES_Sel]
	-- Add the parameters for the stored procedure here
	@tax_id int,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@sqlType='SQLSELECT')
		SELECT tax_id,tax_name,tax_rate,tax_min_amt,tax_type,tax_lastupdate,tax_make_exclusive,tax_make_tax_id,tax_deleted,last_update,EditorID,EditorName FROM CDM_tblTAX_RATES where tax_deleted = 'N'
	else if (@sqlType='SQLSELECTDETAIL')
		SELECT tax_id,tax_name,tax_rate,tax_min_amt,tax_type,tax_lastupdate,tax_make_exclusive,tax_make_tax_id,tax_deleted,last_update,EditorID,EditorName
		FROM CDM_tblTAX_RATES where tax_id=@tax_id
	else if (@sqlType='SQLGETSMART')
		SELECT tax_id,tax_name FROM CDM_tblTAX_RATES where tax_make_exclusive = 'N' and tax_deleted = 'N'
END
GO
