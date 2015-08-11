SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Sel_StoreManagerByStoreID]
@StoreID int
as 
select FirstName+' '+LastName,ID from EnterpriseUser where StoreID=@StoreID and IsManager=1
GO
