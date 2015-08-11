SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Labor_GetAvailabilityTime]

@AvaliablityID int
AS
BEGIN
select * from LaborAvailabilityTime where   Availabilityid = @AvaliablityID
END
GO
