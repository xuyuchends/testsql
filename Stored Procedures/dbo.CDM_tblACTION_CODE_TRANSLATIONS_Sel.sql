SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblACTION_CODE_TRANSLATIONS_Sel]
	-- Add the parameters for the stored procedure here
	@ID int,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@sqlType='SQLSELECT')
		SELECT ID,Action_Code,Special_Process,Security_FieldID,Security_Module,Link,English_Translation  FROM CDM_tblACTION_CODE_TRANSLATIONS
	else if (@sqlType='SQLSELECTDETAIL')
		SELECT ID,Action_Code,Special_Process,Security_FieldID,Security_Module,Link,English_Translation  FROM CDM_tblACTION_CODE_TRANSLATIONS
		where ID=@id
END
GO
