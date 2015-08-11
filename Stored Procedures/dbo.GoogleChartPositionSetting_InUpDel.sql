SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GoogleChartPositionSetting_InUpDel]
@StoreID int,
@PositionID int,
@IntervalType int,
@IsShow bit,
@reportName nvarchar(50),
@SQLTYPE nvarchar(200)
	-- Add the parameters for the stored procedure here	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if ISNULL(@SQLTYPE,'')='SQLDELETE'
    delete from GoogleChartPositionSetting where StoreID=@StoreID and IntervalType=@IntervalType
    and ReportName=@reportName
    else if ISNULL(@SQLTYPE,'')='SQLINSERT'
    insert into GoogleChartPositionSetting values(@StoreID,@PositionID, @reportName,@IntervalType,@IsShow,
    (select ISNULL( MAX(Display),0) from GoogleChartPositionSetting)+1,GETDATE())
    
	
END
GO
