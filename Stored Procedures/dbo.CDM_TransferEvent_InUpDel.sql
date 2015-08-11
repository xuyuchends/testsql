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
CREATE PROCEDURE [dbo].[CDM_TransferEvent_InUpDel]
	-- Add the parameters for the stored procedure here
	@ID int  ,
	@StoreIDs nvarchar(max) ,
	@BeginTime datetime ,
	@EndTime datetime ,
	@EditorID int ,
	@EditorName nvarchar(50) ,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	if (@sqlType='SQLINSERT')
	begin
	INSERT INTO CDM_TransferEvent(StoreIDs,BeginTime,EndTime,EditorID,EditorName,CreateTime,LastUpdate) VALUES (@StoreIDs,@BeginTime,@EndTime,@EditorID,@EditorName,GETDATE(),GETDATE())
		select @@identity
	end
	else if (@sqlType='SQLDELETE')
	begin
		delete from CDM_TransferEvent where ID=@ID
	end
END
GO
