SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[task_CheckIsAllComplete]
(
	@taskID int
)
as
select COUNT(*) from TaskDetail where TaskID=@taskID and Status=1
GO
