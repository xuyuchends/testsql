SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 CREATE proc [dbo].[GetAllMealPeriod]
(
	@StoreID int,
	@Type nvarchar(20)
)
as
select dbo.fn_GetMealPeriod1(@StoreID,@Type)

GO
