SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[QB_EventTypeSel]
	@RefNum int,
	@Type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@Type = 0)
		begin
			select RefNum,EventDataType from QB_EventType
		end
	else if(@Type = 1)
		begin
			select RefNum,EventDataType from QB_EventType where RefNum = @RefNum
		end
	
END
GO
