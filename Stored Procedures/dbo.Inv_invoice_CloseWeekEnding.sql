SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_invoice_CloseWeekEnding]
	-- Add the parameters for the stored procedure here
	@WeekEnding datetime,
	@status int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    --declare @WeekEndingShow datetime
		declare @WeekStartDay int =0
		select top 1 @WeekStartDay =WeekStartDay from  LaborWeekStart
		if (@WeekStartDay<0)
				set @WeekStartDay=7-@WeekStartDay
		--set @WeekEndingShow=dateadd(day,case when datepart(weekday,@WeekEnding)=1 then 0 else 1-(datepart(weekday,@WeekEnding)) +6+@WeekStartDay end,@WeekEnding)
		
	update Inv_Invoice set Status=@status where WeekEnding=DATEADD(day,-@WeekStartDay, @WeekEnding)
END
GO
