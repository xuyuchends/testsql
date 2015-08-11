SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_Transfer_Shortcuts_Sel]
	-- Add the parameters for the stored procedure here
	@ID int,
	@GUID uniqueidentifier,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	 --//新建的数据(在MC上新建)
 --       New = 1,
 --       //等待传输的数据（等待请求更新到hotsauce的数据）
 --       WaitTransfer = 2,
 --       // 等待删除的数据(设定了结束时间，等待自动逻辑删除的数据)
 --       WaitLogicDeleted = 3,
 --       //正在传输的数据
 --       Transferring = 4,
 --       //已传输的数据
 --      HasTransfered = 5,
--      // error
 --     Error = 6,
  --      // close
  --      Close=7
	SET NOCOUNT ON;
	if (@sqlType='Transfer')
		SELECT ID,Shortcut FROM CDM_Transfer_Shortcuts
		where TransferState=1 
	else if (@sqlType='GUID')
		SELECT  ID,Shortcut FROM CDM_Transfer_Shortcuts
		where GUID=@GUID and TransferState=1 
END
GO
