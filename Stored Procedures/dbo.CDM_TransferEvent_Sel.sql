SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[CDM_TransferEvent_Sel]
	-- Add the parameters for the stored procedure here
@ID int  ,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@sqlType='SQLSELECT')
		SELECT ID,StoreIDs,BeginTime,EndTime,EditorID,EditorName,CreateTime,LastUpdate  FROM CDM_TransferEvent
		where not exists(select * from CDM_TransferEventDetail as ted where ted.EventID=CDM_TransferEvent.ID and  ted.Status in (2,3,4,5,7))
		order by ID desc
	else if (@sqlType='SQLSELECTDETAIL')
		SELECT ID,StoreIDs,BeginTime,EndTime,EditorID,EditorName,CreateTime,LastUpdate  FROM CDM_TransferEvent
		where id=@ID
END
GO
