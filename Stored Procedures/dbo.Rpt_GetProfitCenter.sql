SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Rpt_GetProfitCenter]
(
	@StoreID int
)
as
select Name from RevenueCenter where StoreID=@StoreID
GO
