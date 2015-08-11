SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[QB_DepartmentSel]
@Type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if(@Type = 1)
		begin
			select distinct Department from MenuItem group by Department
		end
	else if(@Type =2)
		begin
			select distinct Name from PaymentMethod
		end
	else if(@Type =3)
		begin
			select distinct Name from TaxCategory
		end
END
GO
