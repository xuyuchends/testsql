SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SF_FormulasInUpDel]
	  @ID int,
      @ForecastID int,
      @Percentage decimal(18,2),
      @Quantity int,
      @Unit nvarchar(50),
      @EditorID int,
      @EditorName nvarchar(200),
      @Type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
	if(@Type = 1)
		begin
			insert into SF_Formulas (ForecastID ,Percentage,Quantity,Unit,EditorID,EditorName,LastUpdate) 
			values(@ForecastID,@Percentage,@Quantity,@Unit,@EditorID,@EditorName,getdate())
			SELECT @@identity
		end    -- Insert statements for procedure here
	else if(@Type = 2)
		begin
			update SF_Formulas set ForecastID=@ForecastID , Percentage=@Percentage,Quantity=@Quantity,Unit=@Unit,EditorID=@EditorID,EditorName=@EditorName,LastUpdate=getdate()
			where ID = @ID
		END
	else if(@Type = 3)
		begin
			delete from SF_Formulas where ForecastID = @ForecastID
		end
END
GO
