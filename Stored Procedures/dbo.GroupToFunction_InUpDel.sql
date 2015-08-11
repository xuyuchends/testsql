SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GroupToFunction_InUpDel]
	@SQLOperationType nvarchar(50),
	@GroupID int,
	@FunctionID int,
	@AllOrOneShow int,
	@UserID int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if	@SQLOperationType='SQLInsert'
	begin
		insert into GroupToFunction (GroupID,FunctionID,AllOrOneShow,UserID,LastUpdate) values(@GroupID,@FunctionID,@AllOrOneShow,@UserID,GETDATE())
	end
	else if @SQLOperationType='SQLDelete'
	begin
		delete from GroupToFunction where GroupID=@GroupID
	end
END
GO
