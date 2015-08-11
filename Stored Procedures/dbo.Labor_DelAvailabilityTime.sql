SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Labor_DelAvailabilityTime]
@AviabilityID int 
as
begin
delete from LaborAvailabilityTime where AvailabilityID = @AviabilityID
end
GO
