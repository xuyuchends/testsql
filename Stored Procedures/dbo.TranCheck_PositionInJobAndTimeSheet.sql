SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TranCheck_PositionInJobAndTimeSheet]
	@storeID int
as

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
create table #temptable
(
EmployeeID int,
Positioid int ,
type nvarchar(50)
)
	insert into #temptable
    -- Insert statements for procedure here
	SELECT e.EmployeeID ,e.PositionID,  'EmployeeJob'  from EmployeeJob as e 
	where not exists (select ID from Position as p where e.PositionID=p.ID and e.StoreID=p.StoreID )
	and e.PositionID<>0
	
	insert into #temptable
    -- Insert statements for procedure here
	SELECT e.EmployeeID ,e.PositionID,'EmployeeTimeSheet'  from EmployeeTimeSheet as e 
	where not exists (select ID from Position as p where e.PositionID=p.ID and e.StoreID=p.StoreID )
	and e.PositionID<>0
	
	delete from EmployeeJob  where not exists (select ID from Position as p where EmployeeJob.PositionID=p.ID and EmployeeJob.StoreID=p.StoreID )
	and EmployeeJob.PositionID<>0
	
		delete from EmployeeTimeSheet  where not exists (select ID from Position as p where EmployeeTimeSheet.PositionID=p.ID and EmployeeTimeSheet.StoreID=p.StoreID )
	and EmployeeTimeSheet.PositionID<>0
	
	select * from #temptable
	drop table #temptable
	

GO
