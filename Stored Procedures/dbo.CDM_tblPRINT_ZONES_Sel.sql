SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblPRINT_ZONES_Sel]
	-- Add the parameters for the stored procedure here
	@ID int,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@sqlType='SQLSELECT')
		SELECT ID,PZID,PrintZone_Name,PrintZone_Path,PrintZone_Status,PrinterType,Default_Delay_Time,Priority_Delay_Time,Prompt_Printer,Auto_Redirect_Offline,backup_printer,backup_printer_path FROM CDM_tblPRINT_ZONES
		order by PZID
END
GO
