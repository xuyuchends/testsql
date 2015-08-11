SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[sel_StoreByTaskID]
(
	@taskID int
)
as
select  distinct StoreID,s.StoreName from TaskDetail t inner join EnterpriseUser e on t.AssignedUserID=e.ID
inner join Store s on s.ID=e.StoreID where  TaskID=@taskID and StoreID<>0
GO
