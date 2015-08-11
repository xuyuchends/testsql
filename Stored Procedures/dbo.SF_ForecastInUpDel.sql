SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SF_ForecastInUpDel]
	-- Add the parameters for the stored procedure here
	  @ID int,
      @Name nvarchar(200),
      @IsDefault bit,
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
			if(@IsDefault = 1)
				begin
					update SF_Forecast set IsDefault=0
				end
			insert into SF_Forecast (Name,IsDefault,EditorID,EditorName,LastUpdate) 
			values(@Name,@IsDefault,@EditorID,@EditorName,getdate())
			select @@identity
		end    -- Insert statements for procedure here
	else if(@Type = 2)
		begin
			if(@IsDefault = 1)
				begin
					update SF_Forecast set IsDefault=0
				end
			update SF_Forecast set Name=@Name,IsDefault=@IsDefault,EditorID=@EditorID,EditorName=@EditorName,LastUpdate=getdate()
			where ID = @ID
		END
	else if(@Type = 3)
		begin
			delete from SF_Formulas where ForecastID = @ID
			delete from SF_Forecast where ID = @ID
		end
END
GO
