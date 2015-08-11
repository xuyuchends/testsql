SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblMENU_PROFILE_InUpDel]
@pk bigint  ,
@menu_link nvarchar(30) ,
@dayofweek nvarchar(20) ,
@beginTime datetime ,
@endtime datetime ,
@menu_event nvarchar(20) ,
@EditorID int ,
@EditorName nvarchar(50) ,
@GUID uniqueidentifier,
@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@sqlType='SQLINSERT')
		INSERT INTO CDM_tblMENU_PROFILE(menu_link,dayofweek,beginTime,endtime,menu_event,EditorID,EditorName,LastUpdate) VALUES (@menu_link,@dayofweek,@beginTime,@endtime,@menu_event,@EditorID,@EditorName,GETDATE())
	else if (@sqlType='SQLDELETE')
		delete from CDM_tblMENU_PROFILE where menu_event=@menu_event
END
GO
