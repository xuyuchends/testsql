SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Sel_AllEnterpriseUser]
as
select FirstName+','+LastName as UserName,'e-'+convert(nvarchar(20),ID) as UserID from EnterpriseUser where StoreID=0
GO
