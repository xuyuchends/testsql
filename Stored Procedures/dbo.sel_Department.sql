SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[sel_Department]
(
	@StoreId int
)
as
if isnull(@storeid,0)=0
select distinct Department from MenuItem 
else
select distinct Department from MenuItem where StoreID=@storeID

GO
