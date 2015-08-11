SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--state
--新建的数据(在MC上新建)
--New=1,
--//等待传输的数据（等待请求更新到hotsauce的数据）
--WaitTransfer =2,
--等待删除的数据(设定了结束时间，等待自动逻辑删除的数据)
--WaitLogicDeleted =3,
--正在传输的数据
--Transferring=4,
--已传输的数据
--HasTransfered= 5,
--error
--Error=6
-- =============================================
CREATE PROCEDURE [dbo].[CDM_TransferEventDetail_InUpDel]
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
	if (@sqlType='SQLINSERT')
		INSERT INTO CDM_TransferEventDetail(EventID,StoreID,BeginTime,EndTime,Status,LastUpdate) 
		VALUES (@EventID,@StoreID,@BeginTime,@EndTime,@Status,GETDATE())
	else if (@sqlType='UpdateWaitTransferData' or @sqlType='UpdateWaitLogicOppositeData' )
		UPDATE CDM_TransferEventDetail SET Status=4, LastUpdate=GETDATE() where ID=@eventDetailID
	else if (@sqlType='SQLDELETE')
	begin
		if exists (select * from CDM_TransferEventDetail where eventID=@eventID and status <>1)
			select 0
		else
		begin
			delete from  CDM_TransferEventDetail where EventID=@eventID
			select 1
		end
	end
	else if (@sqlType='HasTransfered')
		begin
			UPDATE CDM_TransferEventDetail SET Status=5, LastUpdate=GETDATE() where ID=@eventDetailID
		end
	else if (@sqlType='UpdateState')
		begin
			UPDATE CDM_TransferEventDetail SET Status=@status, LastUpdate=GETDATE() where ID=@eventDetailID
		end
END
GO
