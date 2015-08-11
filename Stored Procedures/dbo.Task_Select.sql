SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Task_Select]
@ID int,
@Status int,
@UserID int,
@StoreIDDetail int,
@StoreID int
AS
BEGIN
	declare @sql nvarchar(2000)
	declare @sql1 nvarchar(2000)
	declare @UserType nvarchar(20)
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
set @sql='SELECT [ID] taskID,null as TaskDetailID,[Subject],[DueDate],[Description],[Priority],[Status],AssignedTo,
case when (select count(*) from TaskDetail where TaskID=Task.ID and Status=1 and Enable=1)=0 
then (select top 1 ResolveUserID from TaskDetail order by ResolveTime desc) else UpdateUserID end as ResolveUserID,UpdateUserID as Publisher,(select  FirstName + LastName from EnterpriseUser as eu where eu.ID=UpdateUserID) as EmployeeName,
	(select value from ConstTable where Category=''TaskPriority'' and ID=[Priority]) as PriorityValue, Priority,
	(select value from ConstTable where Category=''TaskState'' and ID=[Status]) as StatusValue,Status,UpdateTime as ResolveTime,1 as Enable,StoreID PubStoreID  from [Task] where 1=1'
	
set @sql1='select t.id taskID, td.id TaskDetailID,t.Subject,t.DueDate,td.Description,t.Priority,td.Status,t.AssignedTo,td.ResolveUserID ,t.UpdateUserID as Publisher,(select  FirstName + LastName from EnterpriseUser as eu where eu.ID=td.ResolveUserID) as EmployeeName,
(select value from ConstTable where Category=''TaskPriority'' and ID=t.[Priority]) as PriorityValue,  t.Priority,  
(select value from ConstTable where Category=''TaskState'' and ID=td.[Status]) as StatusValue,td.Status,td.ResolveTime,td.Enable,t.StoreID PubStoreID from TaskDetail td inner join Task t on 
td.TaskID=t.ID where td.Enable=1'

if ISNULL(ltrim(rtrim(@UserID)),'0')<>'0'
begin
	select @UserType=( case when StoreID=0 then '1' when (StoreID>0 and IsManager=1 and Enable=1 ) then 4 end) from EnterpriseUser
	where ID=@UserID
	if @UserType='1'
	begin
		set @sql=@sql+' and (AssignedTo=0 or AssignedTo=2 or AssignedTo=4)'
	end
	else if @UserType='4'
	begin
		set @sql=@sql+' and AssignedTo=0'
	end
	set @sql=@sql + ' and UpdateUserID=' + convert(nvarchar,@UserID)
	--set @sql1=@sql1 + ' and ResolveUserID=' + convert(nvarchar,@UserID)
end	
if ISNULL(ltrim(rtrim(@Status)),'0')<>'0'
begin
	set @sql=@sql + ' and Status=' + convert(nvarchar,@Status)
	set @sql1=@sql1 + ' and td.Status=' + convert(nvarchar,@Status)
	end
if ISNULL(ltrim(rtrim(@ID)),'0')<>'0'
begin
	set @sql=@sql + ' and id=' + convert(nvarchar,@id)
	set @sql1=@sql1 + ' and t.id=' + convert(nvarchar,@id)
end
if @StoreIDDetail is not null
begin
	set @sql1=@sql1 + ' and td.AssignedStoreID=' + convert(nvarchar,@StoreIDDetail)
end
if @StoreID is not null
begin
	set @sql=@sql + ' and StoreID=' + convert(nvarchar,@StoreID)
end
set @sql='('+ @sql+') union ('+@sql1+')'

--select @sql	
exec sp_executesql @sql
END
GO
