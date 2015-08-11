SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Labor_InsUpdAvailabilityInfo]
@EmpID int,
@Audit int,
@ManagerNotes nvarchar(500)
AS
BEGIN
update LaborAvailabilityInfo set ManagerNotes = @ManagerNotes where EmpID = @EmpID and Audit = @Audit
 if(@@rowcount=0)
 insert into LaborAvailabilityInfo(EmpID,Audit,ManagerNotes) values(@EmpID,@Audit,@ManagerNotes)
END
GO
