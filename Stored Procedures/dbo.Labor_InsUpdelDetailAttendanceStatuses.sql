SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Labor_InsUpdelDetailAttendanceStatuses]
@AttendanceID int,
@DetailID int


AS
BEGIN
DECLARE @Count int
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 

    -- Insert statements for procedure here
	BEGIN try
		insert into LaborDetailAttendanceStatuses(AttendanceStatusesID,DetailID) values(@AttendanceID,@DetailID)
	END try
	begin Catch
		if @@ERROR>0
			begin
					update LaborDetailAttendanceStatuses set AttendanceStatusesID =@AttendanceID  where DetailID = @DetailID
			end	
	end Catch
END
GO
