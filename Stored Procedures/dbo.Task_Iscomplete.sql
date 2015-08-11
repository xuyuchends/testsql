SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Task_Iscomplete]
(
	@StoreID int
)
as
select  COUNT(*) from TaskDetail t inner join EnterpriseUser  e on t.AssignedUserID=e.ID
where e.StoreID=@StoreID and t.Status=2
GO
