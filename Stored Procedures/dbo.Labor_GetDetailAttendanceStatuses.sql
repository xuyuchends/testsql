SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Labor_GetDetailAttendanceStatuses]
	@DetailID int
AS
BEGIN
	select * from LaborDetailAttendanceStatuses where DetailID = @DetailID
END
GO
