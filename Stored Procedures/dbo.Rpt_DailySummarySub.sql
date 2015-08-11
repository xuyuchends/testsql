SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Rpt_DailySummarySub]
(
	@BeginTime datetime,
	@endTime datetime,
	@StoreID int
)
as
declare @tipWithHeld decimal(18,2)
execute Rpt_DepartmentSalesSub @BeginTime,@endTime,@StoreID

GO
