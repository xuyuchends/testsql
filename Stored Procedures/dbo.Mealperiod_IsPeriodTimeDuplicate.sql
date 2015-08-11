SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Mealperiod_IsPeriodTimeDuplicate]
(
	@StoreID nvarchar(20),
	@BeginTime datetime,
	@EndTime datetime,
	@DayOfWeek nvarchar(20),
	@DayPartName nvarchar(50)
	
)
as
select * from [dbo].[f_GetMealPeriodRange](@BeginTime,@EndTime,@StoreID,@DayOfWeek,@DayPartName)

GO
