SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GoogleChartSetting_Sel]
@ID int,
@IntervalType int,
@Type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
    if(@Type = 0)
		begin
			select [ID],[Name],[Describe],[ShowType],[IntervalType],IsShow from GoogleChartSetting
			where IntervalType = @IntervalType
			order by display
		end
	else if(@Type = 1)
		begin
			select  [ID],[Name],[Describe],[ShowType],[IntervalType],IsShow from GoogleChartSetting 
			order by display
		end
END
GO
