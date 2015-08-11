SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_UnitOfMeasures_Sel]
(
	@ID int,
	@Name nvarchar(200),
	@Creator int,
	@Editor int
)
as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(ISNULL(@ID,0)<>0)
	begin
		SELECT [ID]
      ,[Name]
      ,[Creator]
      ,[Editor]
      ,[LastUpdate] from Inv_UnitOfMeasures where ID=@ID 
	end
	else
	begin
		SELECT [ID]
      ,[Name]
      ,[Creator]
      ,[Editor]
      ,[LastUpdate] from Inv_UnitOfMeasures Order By Name
	end
END
GO
