SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[QB_EventTypeInUpDel]
	@RefNum int,
	@EventDataType nvarchar(200),
	@Type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@Type = 1)
		begin
			insert into QB_EventType(RefNum,EventDataType) values(@RefNum,@EventDataType)
		end
	else if(@Type =2)
		begin
			delete from QB_EventType where RefNum = @RefNum
		end
END
GO
