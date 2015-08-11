SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[Labor_GetAvailabilityInfo]
@EmpID int,
@Audit int
AS
BEGIN
select * from LaborAvailabilityInfo where EmpID= @EmpID and Audit = @Audit
END
 
GO
