SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[TaskDetail_Select]
@ID int,
@TaskID int,
@Status int,
@AssignedStoreID int
AS
BEGIN
	declare @sql nvarchar(2000)
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
set @sql='SELECT td.[ID],[TaskID],td.[Status],td.[Description],td.[AssignedStoreID],s.StoreName,s.id StoreID,Task.[Subject],Task.DueDate,task.AssignedTo,td.AssignedStoreID, (select value from ConstTable where Category=''TaskPriority'' and ID=[Priority]) as PriorityValue, Priority,task.UpdateUserID as Publisher,td.ResolveUserID,
    (select value from ConstTable as ct where ct.Category=''TaskState'' and ct.ID=td.[Status]) as StatusValue,td.ResolveTime,
    (select  FirstName +'' ''+ LastName from EnterpriseUser as eu where eu.ID=td.[ResolveUserID]) as EmployeeName,task.StoreID PubStoreID FROM [TaskDetail] td inner join Task on td.TaskID=Task.ID
    left join Store s on s.id=td.AssignedStoreID where td.Enable=1'
if ISNULL(ltrim(rtrim(@ID)),'')<>''
	set @sql=@sql + ' and td.[ID]=' + convert(nvarchar,@ID)
if ISNULL(ltrim(rtrim(@TaskID)),'')<>''
	set @sql=@sql + ' and td.[TaskID]=' + convert(nvarchar,@TaskID )
if ISNULL(ltrim(rtrim(@Status)),'')<>''
	set @sql=@sql + ' and td.[Status]=' + convert(nvarchar,@Status)
if ISNULL(ltrim(rtrim(@AssignedStoreID)),'')<>''
	set @sql=@sql + ' and td.[AssignedStoreID]=' + convert(nvarchar,@AssignedStoreID)
exec sp_executesql @sql
--select @sql
END
GO
