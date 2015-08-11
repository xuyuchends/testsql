SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_Transfer_MenuLink_InUpDel]
	@ID int  ,
@MenuLink nvarchar(50) ,
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
		select top 1 @innerID =ID from CDM_Transfer_MenuLink 	where TransferState=1 and MenuLink=@MenuLink
		if (@innerID<>0)
		INSERT INTO CDM_Transfer_MenuLink(MenuLink,EditorID,EditorName,GUID) VALUES (@MenuLink,@EditorID,@EditorName,@GUID)
	end
END
GO
