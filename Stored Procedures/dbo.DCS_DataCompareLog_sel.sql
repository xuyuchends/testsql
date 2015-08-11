SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DCS_DataCompareLog_sel] 
	-- Add the parameters for the stored procedure here
	@storeID int,
	@Datetime datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select COUNT(*) from DCS_DataCompareLog where StoreID=@storeID and CompareDate=@Datetime
	
END
GO
