SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create proc [dbo].[Labor_GetEnterpriseByID]
@EmpID int,
@StoreID int,
@Type int
as
begin
if(@Type=0)
	begin
		select * from EnterpriseUser where EmployeeID = @EmpID AND StoreID = @StoreID
	end
end
GO
