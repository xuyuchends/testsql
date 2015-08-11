SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[sel_taskAndDetail]
(
	@taskID int,
	@UserID int
)
as
select t.ID,[Subject],[DueDate],td.[Description],[Priority],td.[Status],AssignedTo,eu.FirstName+' '+eu.LastName UpdateUserID,
	(select value from ConstTable where Category='TaskPriority' and ID=t.[Priority]) as PriorityValue, 
	 case when (select COUNT(*) from TaskDetail td inner join EnterpriseUser e on e.ID = td.AssignedUserID where storeid=eu.StoreID and Status=2 and TaskID=t.ID)=0 then 1 else 2 end as  StatusValue,td.ResolveTime from TaskDetail td 
	inner join Task t on td.TaskID=t.ID
	inner join EnterpriseUser eu on eu.ID=t.UpdateUserID
 where TaskID=@taskID and AssignedUserID=@UserID
GO
