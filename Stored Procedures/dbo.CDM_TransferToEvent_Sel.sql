SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_TransferToEvent_Sel]
	-- Add the parameters for the stored procedure here
	@EventID int ,
	@TransferTable nvarchar(50) ,
	@TransferTableID int ,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@sqlType='SQLSELECT')
		SELECT distinct TransferTableID  FROM CDM_TransferToEvent where EventID=@EventID and TransferTable=@TransferTable
END
GO
