SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:@Type:Category,ClassRef	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[QB_AdjustmentCategorySel]
@ID int,
@Type int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if(@Type = 0)
		begin
			select ID,Name,Type from QB_AdjustmentCategory
		end
	else if(@Type = 1)
		begin
			select  ID,Name,Type from QB_AdjustmentCategory where ID = @ID
		end
END
GO
