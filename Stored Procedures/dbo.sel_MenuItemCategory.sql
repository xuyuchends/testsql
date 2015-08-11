SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[sel_MenuItemCategory]
(
	@storeID int
)
as
select distinct Department+'/'+Category as Category from MenuItem where StoreID=@storeID
GO
