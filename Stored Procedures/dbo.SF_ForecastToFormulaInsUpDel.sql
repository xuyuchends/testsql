SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SF_ForecastToFormulaInsUpDel]
	-- Add the parameters for the stored procedure here
	@StoreID int,
	@ForeCastID int,
	@EditorID int,
	@EditorName nvarchar(50),
	@Type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		if(@Type = 1)
		
		begin try  
			insert into SF_ForecastToFormula([StoreID]
						  ,[ForecastID]
						  ,[EditorID]
						  ,EditorName
						  ,[LastUpdate])
						  values(@StoreID,@ForeCastID,@EditorID,@EditorName,getdate())
		END TRY
		BEGIN CATCH
			if @@ERROR <>0
				update SF_ForecastToFormula set ForecastID = @ForecastID ,LastUpdate = getdate() where StoreID = @StoreID
		end  CATCH 
			
		 else if(@Type =2)
			begin
				update SF_ForecastToFormula set ForecastID = @ForecastID ,LastUpdate = getdate() where StoreID = @StoreID
			end
		else if(@Type = 3)
			begin
				delete from SF_ForecastToFormula where StoreID = @StoreID
			end
		else if(@Type = 4)
			begin
				delete from SF_ForecastToFormula 
			end
END
GO
