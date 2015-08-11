SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[task_CheckIsCompleteAndUpdateStatus]
(
	@taskID int
)
as
declare @count int
select @count=COUNT(*) from TaskDetail where TaskID=@taskID and Status=1
if @count=0
begin
	update Task set Status=2 where ID=@taskID
end
GO
