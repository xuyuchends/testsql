SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Labor_InsTimeOff]
@ID int,
@StartTime datetime,
@EndTime datetime,
@Status int,
@Comments nvarchar(500),
@ApplicantID int,
@ApprovedBy nvarchar(50),
@ApprovedTime datetime,
@RequestTime datetime,
@Type int
as
begin
if(@Type=0)
begin
insert into laborTimeoff(StartTime,EndTime,[Status],Comments,ApplicantID,ApprovedBy,ApprovedTime,RequestTime)
values(@StartTime,@EndTime,@Status,@Comments,@ApplicantID,@ApprovedBy,@ApprovedTime,@RequestTime)
end
else if(@Type = 1)
begin
update laborTimeoff set [Status]=@Status, ApprovedBy=@ApprovedBy,ApplicantID=@ApplicantID,ApprovedTime=@ApprovedTime where ID = @ID
end
end
GO
