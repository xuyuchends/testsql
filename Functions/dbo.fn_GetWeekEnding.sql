SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_GetWeekEnding]
(
	@date datetime
)
RETURNS datetime
AS
BEGIN
	declare @WeekEndingShow datetime
	declare @WeekStartDay int =0
	select top 1 @WeekStartDay =WeekStartDay from  LaborWeekStart
	-- sun -> sat
	if (@WeekStartDay<0)
		set @WeekStartDay=7-@WeekStartDay
	--set @WeekEndingShow=dateadd(day,case when datepart(weekday,@date)=@WeekStartDay then 0 
	--else 1-(datepart(weekday,@date)) +6+@WeekStartDay end,@date)
	set @WeekEndingShow=dateadd(day,case when datepart(weekday,@date)=@WeekStartDay then 0
	when datepart(weekday,@date)<@WeekStartDay then @WeekStartDay- datepart(weekday,@date)
	else 7+@WeekStartDay- datepart(weekday,@date) end,@date)
	return @WeekEndingShow

END
GO
