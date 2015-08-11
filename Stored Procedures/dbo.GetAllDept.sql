SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[GetAllDept]
(
	@StoreID int
)
as
select dbo.fn_GetAllDepartment(@StoreID)
GO
