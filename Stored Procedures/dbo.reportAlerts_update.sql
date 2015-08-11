SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[reportAlerts_update]
(
	@id int
)
as
update ReportAlert set LastSendDate=GETDATE() where ID=@id
GO
