SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SF_ForecastSel]
	@ID int,
	@Type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@Type = 0)
		begin
			SELECT  [ID]
				  ,[Name]
				  ,[IsDefault]
				  ,[EditorID]
				  ,[EditorName]
				  ,[LastUpdate]
			  FROM  [SF_Forecast]
		end
	else if(@Type = 1)
		begin
		SELECT  [ID]
				  ,[Name]
				  ,[IsDefault]
				  ,[EditorID]
				  ,[EditorName]
				  ,[LastUpdate]
			  FROM  [SF_Forecast] where ID=@ID
		end
END
GO
