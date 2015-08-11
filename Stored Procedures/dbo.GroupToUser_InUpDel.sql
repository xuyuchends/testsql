SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GroupToUser_InUpDel]
@SQLOperationType nvarchar(50),
	@GroupID int,
	@UserID int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if @SQLOperationType='SQLUpdate'
		begin
			delete from GroupToUser where UserID=@UserID
			insert into GroupToUser (GroupID,UserID) values(@GroupID,@UserID)
		end
END
GO
