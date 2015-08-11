SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[sel_CompTaskUserByStoreID]
(
	@StoreID int,
	@TaskID int
)
as

select ResolveTime,FirstName+' '+LastName as UserName,StoreID from TaskDetail t inner join EnterpriseUser e on t.AssignedUserID=e.ID where e.StoreID=@StoreID and Status=2  and t.TaskID=@TaskID
GO
