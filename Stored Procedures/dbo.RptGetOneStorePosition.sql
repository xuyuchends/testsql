SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 create proc [dbo].[RptGetOneStorePosition]
        (
			@StoreID int,
			@ReportName nvarchar(50),
			@IntervalType int
        )
        as
        select dbo.fn_GetPositionByReport(@StoreID,@ReportName,@IntervalType)
GO
