SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[ReportParameter_sel]
(
	@ReportDetailID int
)
as
select * from ReportParameter where ReportDetailID=@ReportDetailID
GO
