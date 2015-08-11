SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_Transfer_HotItem_InUpDel]
@ID int  ,
@EditorID int ,
@EditorName nvarchar(50) ,
@GUID uniqueidentifier ,
@TransferState int ,
@sqlType nvarchar(200)
AS
BEGIN
	if (@sqlType='SQLINSERT')
	begin
	declare @innerID int=0
	-- 如果有状态为new的就更新，没有就insert
	select top 1 @innerID =ID from CDM_Transfer_HotItem 	where TransferState=1
	if (@innerID<>0)
		INSERT INTO CDM_Transfer_HotItem(HotItem,EditorID,EditorName,GUID,TransferState) VALUES ('Hotitem',@EditorID,@EditorName,@GUID,@TransferState)
	end
END
GO
