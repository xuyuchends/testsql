SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Labor_GetScheduleTemp]
@DetailID int,
	@ScheduleID int,
	@StoreID int,
	@type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if(@type = 0)
		begin
			select * from LaborScheduleTemp where ScheduleID = @ScheduleID and StoreID = @StoreID
		end 
	else if(@type = 1)
		begin
			select * from LaborScheduleTemp where ID = @DetailID
		end
END
GO
