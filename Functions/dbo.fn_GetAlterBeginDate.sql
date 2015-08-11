SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_GetAlterBeginDate]
(
	@AlertFrequency int,
	@CreateDate datetime
)
RETURNS datetime
AS
BEGIN
  declare @returnBeginDate nvarchar(100)
	if @AlertFrequency=1
	begin
		set	@returnBeginDate= DATEADD(DAY,-1,GETDATE())
	end
	else if @AlertFrequency=2
	begin
		set @returnBeginDate=CONVERT(nvarchar(20),GETDATE(),101)+' '+
					convert(nvarchar(10),DATEPART(hour,getdate())-1)+':'+
					CONVERT(nvarchar(10), DATEPART(MI,@CreateDate))+':'+
					 convert(nvarchar(10),DATEPART(S,@CreateDate))
	end
	else if @AlertFrequency=3
	begin
		set @returnBeginDate=DATEADD(day,-1,DATEADD(week,-1,GETDATE()))
	end
	return @returnBeginDate
END
GO
