SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[LoopingMoveArchive]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
EXECUTE  MoveOrderToArchive
EXECUTE  MoveOrderLineItemToArchive
EXECUTE  MoveCheckToArchive
EXECUTE  MovePaymentToArchive
EXECUTE  MovePaidInTrxToArchive
EXECUTE  MovePaidOutTrxToArchive
EXECUTE  MoveTaxToArchive
EXECUTE  MoveAchiveDeleteRecords
EXECUTE MoveEmailToLog
END
GO
