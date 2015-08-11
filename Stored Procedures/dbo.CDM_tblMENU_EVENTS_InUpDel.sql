SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblMENU_EVENTS_InUpDel]
@pk bigint  ,
@menu_event nvarchar(50) ,
@return_value nvarchar(20) ,
@use_same_as_dining char(1) ,
@EditorID int ,
@EditorName nvarchar(50) ,
@GUID uniqueidentifier,
@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@sqlType='SQLUPDATE')
		UPDATE CDM_tblMENU_EVENTS SET return_value=@return_value,
		use_same_as_dining=@use_same_as_dining,EditorID=@EditorID,EditorName=@EditorName,LastUpdate=GETDATE()
		where pk=@pk
	else if (@sqlType='TransferInsert')
		begin
			declare @innerID int=0
			-- 如果有状态为new的就更新，没有就insert
			select top 1 @innerID =ID from CDM_Transfer_tblMENU_EVENTS 	where pk=@pk and TransferState=1
			if (@innerID<>0)
				begin
				UPDATE CDM_Transfer_tblMENU_EVENTS SET EditorID=@EditorID,EditorName=@EditorName,GUID=@GUID
				where ID=@innerID
				return @innerID
				end
			else
				begin
				INSERT INTO CDM_Transfer_tblMENU_EVENTS(pk,EditorID,EditorName,GUID,TransferState) VALUES (@pk,@EditorID,@EditorName,@GUID,1)
				return @@identity
				end
		end
END
GO
