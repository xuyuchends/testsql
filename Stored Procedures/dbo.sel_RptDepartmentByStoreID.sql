SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sel_RptDepartmentByStoreID]
(
	@StoreId int
)
as
if isnull(@storeid,0)=0
select distinct ReportDepartment as Department from MenuItem  order by ReportDepartment
else
select distinct ReportDepartment as Department from MenuItem where StoreID=@storeID order by ReportDepartment
GO
