SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Labor_GetAvailability]
@StoreID int,
@EmpID int
AS
BEGIN
if(@EmpID <> 0)
begin
select * from LaborAvailability where EmpID = @EmpID and StoreID = @StoreID
end
else
begin 
select LaborAvailability.*,EnterpriseUser.FirstName,EnterpriseUser.LastName from LaborAvailability join EnterpriseUser on EmpID = EnterpriseUser.ID
 where  Audit=0 and LaborAvailability.StoreID = @StoreID  
end 
END
GO
