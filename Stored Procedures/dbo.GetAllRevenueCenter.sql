SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[GetAllRevenueCenter]
(
	@StoreID int
)
as
SET NOCOUNT ON;
select dbo.fn_GetRevenueCenter(@StoreID)
GO
