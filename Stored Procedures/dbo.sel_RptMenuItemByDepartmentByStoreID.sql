SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create proc [dbo].[sel_RptMenuItemByDepartmentByStoreID]
(
	@StoreId int,
	@Department nvarchar(50)
)
as
if isnull(@storeid,0)=0
select distinct ID,  Name from MenuItem where ReportDepartment=@Department order by Name 
else
select distinct  ID,  Name from MenuItem  where ReportDepartment=@Department and  StoreID=@storeID  order by Name 
GO
