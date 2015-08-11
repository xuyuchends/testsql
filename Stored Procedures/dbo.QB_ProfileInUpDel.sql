SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[QB_ProfileInUpDel]
	@ID int,
	@UserName nvarchar(200),
	@Password nvarchar(200),
	@ProFileID int output,
	@Type int
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 if	(@Type = 1)
		begin
			insert into QB_Profile(UserName,[Password]) values(@UserName,@Password)
		set	@ProFileID=@@identity
		end
	else if(@Type = 2)
		begin
			update QB_Profile set UserName =@UserName ,[Password] = @Password where ID = @ID
		end
	else if(@Type = 3)
		begin
			delete QB_Profile where ID = @ID
		end	
END
GO
