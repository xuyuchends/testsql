SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Labor_InsUpdWeekStartDay]
	@WeekStartDay int,
	@WeekStartTime Datetime,
	@TimeZong nvarchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    update  LaborWeekStart set WeekStartDay=@WeekStartDay,WeekStartTime = @WeekStartTime,TimeZone=@TimeZong
    if @@ROWCOUNT = 0
	insert into LaborWeekStart(WeekStartDay,WeekStartTime,TimeZone) values(@WeekStartDay,@WeekStartTime,@TimeZong)
END
GO
