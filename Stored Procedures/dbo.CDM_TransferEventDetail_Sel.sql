SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[CDM_TransferEventDetail_Sel]
	-- Add the parameters for the stored procedure here
	@eventID int,
	@eventDetailID int,
	@storeID int,
	@beginTime datetime,
	@endTime datetime,
	@status int,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@sqlType='SelectTransferData')
		select top 1 EventID,EventDetailID,StoreID,TransferTime,TransferType,Status,EditorName,EditorID,CreateTime,LastUpdate
		from
		(
		SELECT te.ID as EventID, ted.ID AS EventDetailID, ted.StoreID as StoreID, ted.BeginTime as TransferTime, 
		'begin' as TransferType, ted.Status as Status, te.EditorName as EditorName, te.EditorID as EditorID, 
		te.CreateTime as CreateTime, te.LastUpdate as LastUpdate
		FROM CDM_TransferEvent AS te INNER JOIN CDM_TransferEventDetail AS ted ON te.ID = ted.EventID
		where ted.Status= 1 and ted.storeID=@storeID and ted.BeginTime<=GETDATE()
		) as table1 
		order by TransferTime asc
	else if (@sqlType='SQLSELECT')
		SELECT ID,EventID,StoreID,BeginTime,EndTime,Status,LastUpdate  FROM CDM_TransferEventDetail
		where ID=@eventDetailID
		
END
GO
