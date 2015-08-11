SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[QB_ProfileSel]
	-- Add the parameters for the stored procedure here
	@UserName nvarchar(200),
	@Password nvarchar(200),
	@Type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@Type = 1)
		begin
			select ID,UserName,Password from QB_Profile where UserName = @UserName
		end
	else if(@Type = 2)
		begin
			select ID,UserName,Password from QB_Profile
		end
	else if(@Type = 3)
		begin
			select ID,UserName,Password from QB_Profile where UserName = @UserName and Password =@Password
		end
END
GO
