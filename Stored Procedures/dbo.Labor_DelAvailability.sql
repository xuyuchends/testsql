SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Labor_DelAvailability]
@AviabilityID int 
as
begin
delete from LaborAvailability where ID = @AviabilityID
end
GO
