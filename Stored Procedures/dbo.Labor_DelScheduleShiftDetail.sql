SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Labor_DelScheduleShiftDetail]
@detailID int
AS
BEGIN
	SET NOCOUNT ON;
	delete from LaborScheduleShiftDetail where ID = @detailID
END
GO
