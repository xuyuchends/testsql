SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Labor_GiveUpIns]
@DetailID int,
@ShiftID int,
@IsGiveup int,
@GiveUpFrom int,
@GiveUpStatus int,
@Type int
as
begin
--ok
if(@Type = 0)
begin
update LaborScheduleShiftDetail set 
ShiftID = @ShiftID ,IsGiveUp = @IsGiveup,GiveUpFrom = @GiveUpFrom,GiveUpStatus = @GiveUpStatus
where ID = @DetailID
end
else if(@Type = 1)
begin
update LaborScheduleShiftDetail set
IsGiveUp = @IsGiveup,GiveUpFrom = @GiveUpFrom,GiveUpStatus = @GiveUpStatus
where ID = @DetailID

end
end
GO
