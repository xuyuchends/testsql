SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SF_FormulasSel]
	@ID int,
	@Type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@Type=0)
		begin
			SELECT [ID]
				  ,[ForecastID]
				  ,[Percentage]
				  ,[Quantity]
				  ,[Unit]
				  ,[EditorID]
				  ,[LastUpdate]
				  ,[EditorName]
			  FROM [SF_Formulas]
			  where ForecastID = @ID
		end
	else if(@Type=1)
		begin
			SELECT [ID]
				  ,[ForecastID]
				  ,[Percentage]
				  ,[Quantity]
				  ,[Unit]
				  ,[EditorID]
				  ,[LastUpdate]
				  ,[EditorName]
			  FROM [SF_Formulas]
			  where ID = @ID
		end
	else if(@Type =2)
		begin
			SELECT [ID]
				  ,SF_Formulas.[ForecastID]
				  ,[Percentage]
				  ,[Quantity]
				  ,[Unit]
				  ,SF_Formulas.[EditorID]
				  ,SF_Formulas.[LastUpdate]
				  ,SF_Formulas.[EditorName]
			  FROM [SF_Formulas]
			  join SF_ForecastToFormula on  SF_Formulas.ForecastID =SF_ForecastToFormula.ForecastID
			  where StoreID = @ID		
		end
	else if(@Type =3)
		begin
				SELECT SF_Formulas.[ID]
				  ,SF_Formulas.[ForecastID]
				  ,[Percentage]
				  ,[Quantity]
				  ,[Unit]
				  ,SF_Formulas.[EditorID]
				  ,SF_Formulas.[LastUpdate]
				  ,SF_Formulas.[EditorName]
			  FROM [SF_Formulas]
			  join SF_Forecast on  SF_Formulas.ForecastID =SF_Forecast.ID
			  where IsDefault =1
		end
END
GO
