SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Labor_GetMealPeriod]
@StoreID int 
as
begin
  select * from MealPeriod where StoreID =@StoreID
end
GO
