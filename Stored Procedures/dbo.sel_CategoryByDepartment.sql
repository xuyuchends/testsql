SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[sel_CategoryByDepartment]
(
	@storeID int,
	@Department nvarchar(20)
)
as
if isnull(@storeid,0)<>0
select distinct Department+'/'+Category as Category,Category as Categorys from MenuItem where StoreID=@storeID and Department=@Department
else
select distinct Department+'/'+Category as Category,Category as Categorys 
from MenuItem where Department=@Department

GO
