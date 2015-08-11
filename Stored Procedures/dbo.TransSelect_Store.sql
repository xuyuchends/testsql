SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TransSelect_Store]
@UserName nvarchar(200),
@PassWord nvarchar(200)
AS
BEGIN
	SELECT [ID],[UserName],[Password],[StoreName] from Store where UserName = @UserName and [Password] =@PassWord
END
GO
