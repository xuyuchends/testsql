SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[sel_getStoreIDByTask]
(
	@taskID int
)
as
select distinct AssignedStoreID StoreID from TaskDetail  where TaskID=@taskID
and AssignedStoreID>0 and Enable=1
GO
