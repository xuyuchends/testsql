SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[rpt_GetStoreNameList]
(
	@StoreIDlist nvarchar(2000)
)
as
select [dbo].[fn_GetStoreName](@StoreIDlist)
GO
