SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 CREATE PROCEDURE [dbo].[QB_EventSel]
	-- Add the parameters for the stored procedure here
	@RefNum int,
	@UserName nvarchar(200),
	@Password nvarchar(200),
	@Type int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@Type = 0)
		begin
			select RefNum,ProfileID,BeginTime,EndTime,State,EditorID,EditorName,LastUpdate,UserName ,DownLoadUserName, isBalance from QB_Event
			join QB_Profile on QB_Profile.ID = ProfileID
		end
	else if(@Type =1)
		begin
			select RefNum,ProfileID,BeginTime,EndTime,State,EditorID,EditorName,LastUpdate,UserName,DownLoadUserName, isBalance from QB_Event 
			join QB_Profile on QB_Profile.ID = ProfileID
			where RefNum = @RefNum
		end
	else if(@Type =2)
		begin
			select RefNum,ProfileID,BeginTime,EndTime,State,EditorID,EditorName,LastUpdate,UserName,DownLoadUserName, isBalance from QB_Event 
			join QB_Profile on QB_Profile.ID = ProfileID
			where QB_Profile.UserName = @UserName and QB_Profile.Password=@Password
		end
END
GO
