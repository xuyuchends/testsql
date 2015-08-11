SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Labor_GetEmployeeByPosition]
@str varchar(500),
@storeID int
as

 declare @next int 
 declare @id int
 set @next=1
 declare @newtb table (ID int)
 
 while @next<=dbo.Get_StrArrayLength(@str,',')
   begin
    set @id =CONVERT(int,dbo.Get_StrArrayStrOfIndex(@str,',',@next))
     set @next=@next+1
		insert into @newtb values(@id)
		
   end
   select distinct empjob.* ,users.LastName,users.FirstName,users.Phone 'Phone' from EmployeeJob as empjob  
   join Employee as users on empjob.EmployeeID= users.ID and empjob.StoreID = users.StoreID
   where empjob.StoreID = @storeID and users.IsTerminated = 0  and empjob.PositionID in( select ID From @newtb)
   order  by PositionID,users.LastName
GO
