SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SF_FormulaDataInsUpdDel] 
	@StoreID int,
	@DayPart nvarchar(50),
	@ForecastsDate datetime,
	@ForecastValue decimal(18,0),
	@ModifyValue decimal(18,0),
	@EditorID int,	
	@Type int
AS
BEGIN
	SET NOCOUNT ON;
	if(@Type = 1)
		begin
			insert into SF_FormulaData([StoreID]
				  ,[DayPart]
				  ,[ForecastsDate]
				  ,[ForecastValue]
				  ,[ModifyValue]
				  ,[EditorID]
				  ,[LastUpdate])
			values(@StoreID,@DayPart,@ForecastsDate,@ForecastValue,@ModifyValue,@EditorID,getdate())
		end
	else if(@Type = 2)
		begin
			update SF_FormulaData set ModifyValue =@ModifyValue ,EditorID = @EditorID,LastUpdate=getdate()
			where StoreID = @StoreID and DayPart=@DayPart and ForecastsDate = @ForecastsDate
		end
	else if(@Type = 3)
		begin
			delete from SF_FormulaData where StoreID=@StoreID and ForecastsDate between @ForecastsDate and dateadd(day,6,@ForecastsDate)   
		end
END
GO
