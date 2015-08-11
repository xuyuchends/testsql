SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[sel_taskByID]
(
	@taskID int
)
as
SELECT [Task].[ID],[Subject],[DueDate],[Description],[Priority],[Status],AssignedTo,UpdateUserID,   (select value from ConstTable where Category='TaskPriority' and ID=[Priority]) as PriorityValue,    case when (select COUNT(*) from TaskDetail td inner join EnterpriseUser e on e.ID = td.AssignedUserID where storeid=e.StoreID and Status=2 and TaskID=[Task].ID)=0 then 'Not Completed' else 'Completed' end as  StatusValue  from [Task] inner join EnterpriseUser e on e.ID=Task.UpdateUserID where  [Task].id=@taskID
GO
