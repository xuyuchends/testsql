SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GoogleChartPositionSetting_Sel]
 @StoreID int,
 @Type int,
 @ReportName nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
    select p.Name PositionName, p.ID PositionID,
	isnull((select IsShow from GoogleChartPositionSetting where StoreID=p.StoreID and p.ID=PositionID
	and IntervalType=@Type and ReportName=@ReportName),0) IsShow
	from Position p  where   p.StoreID=@StoreID 
END
GO
