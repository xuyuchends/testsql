SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GoogleChartSetting_InUpDel]
@Name nvarchar(50),
@ShowType int,
@IntervalType int,
@IsShow bit,
@SQLOperationType nvarchar(50)
	-- Add the parameters for the stored procedure here	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if @SQLOperationType='SQLUpdate'
	begin
		update GoogleChartSetting set [ShowType]=@ShowType,[IntervalType]=@IntervalType,isShow=@IsShow 
		where Name = @Name and IntervalType = @IntervalType
	end
	
END
GO
