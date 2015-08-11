SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[EnterpriseUser_sel]
@UserID int,
@StoreID int,
@JobID int,
@IsTerminated int,
@type int
AS
BEGIN
	SET NOCOUNT ON;
	if @type=1
	-- enterprise user list
	begin
		select  t.UserID,t.AllName,t.OrganizationName
		from
		(
		select distinct eu.ID as UserID,eu.FirstName+' '+eu.LastName as AllName,o.Name as OrganizationName
			from EnterpriseUser as eu
			inner join OrganizationToUser as otu on eu.ID=otu.UserID
			inner join Organization as o on o.ID=otu.OrganizationID
			where eu.ID in (select userID from f_SelAvailableUser(@UserID,1)) and o.StoreID=0
			 and IsTerminated=0 and Enable=1
		union
		select eu.ID as UserID,eu.FirstName+' '+eu.LastName as AllName, 'not assigned' as OrganizationName
			from EnterpriseUser as eu where not exists (select * from OrganizationToUser as otu where otu.UserID=eu.ID )
			and eu.StoreID=0 and IsTerminated=0 and Enable=1
		) as  t
		order by case t.OrganizationName when 'not assigned' then 1 else 2 end,t.AllName 
	end
	else if @type=2
	-- store manager  and store user list
	begin
		select UserID,StoreID,StoreName,AllName,LEFT(JobName,LEN(JobName)-1) as JobName,IsManager
		from (
			select distinct eu.ID as UserID,eu.StoreID,s.StoreName as StoreName, eu.FirstName+','+eu.LastName as AllName,eu.FirstName,eu.LastName,eu.IsManager,eu.IsTerminated,eu.MobilePhone ,
			(
				SELECT p.Name+',' FROM Position as p inner join EmployeeJob as ej on p.ID=ej.PositionID and p.StoreID=ej.StoreID 
				where eu.EmployeeID=ej.EmployeeID and eu.StoreID=ej.StoreID  and eu.StoreID=@StoreID
				FOR XML PATH('')
			) AS JobName
		from EnterpriseUser as eu 
		inner join Employee as e on e.ID =eu.EmployeeID and e.StoreID=eu.StoreID
			inner join  EmployeeJob as ej on e.StoreID=ej.StoreID and e.ID=ej.EmployeeID
			inner join Store as s on eu.StoreID=s.ID
		where eu.StoreID=@StoreID  and eu.StoreID>0   and eu.IsTerminated=0  and Enable=1
		)  as t
		order by IsManager desc,FirstName,LastName
	end
	
	else if @type=3
	-- select store user
	begin
	-- all job
		if @JobID=0
		begin
			select UserID,StoreID,StoreName,AllName,LEFT(JobName,LEN(JobName)-1) as JobName,IsManager
			from (
				select distinct eu.ID as UserID,eu.StoreID,s.StoreName as StoreName, eu.FirstName+','+eu.LastName as AllName,eu.FirstName,eu.LastName,
				eu.IsManager,eu.IsTerminated, eu.MobilePhone ,
				(
					SELECT p.Name+',' FROM Position as p inner join EmployeeJob as ej on p.ID=ej.PositionID and p.StoreID=ej.StoreID 
					where eu.EmployeeID=ej.EmployeeID and eu.StoreID=ej.StoreID  and eu.StoreID=@StoreID
					FOR XML PATH('')
				) AS JobName
			from EnterpriseUser as eu 
			inner join Employee as e on e.ID =eu.EmployeeID and e.StoreID=eu.StoreID
			inner join  EmployeeJob as ej on e.StoreID=ej.StoreID and e.ID=ej.EmployeeID
			inner join Store as s on eu.StoreID=s.ID
			where eu.StoreID=@StoreID and eu.StoreID>0 
			and eu.IsTerminated=0 and Enable=1
			)  as t
			order by FirstName,LastName
		end
		else
	-- one job
		begin
			select distinct eu.ID as UserID,eu.StoreID,s.StoreName as StoreName, eu.FirstName+','+eu.LastName as AllName,eu.IsManager,eu.IsTerminated, ej.PositionID as JobID,eu.MobilePhone,p.Name as jobName,eu.FirstName,eu.LastName
			from EnterpriseUser as eu 
			inner join Employee as e on e.ID =eu.EmployeeID and e.StoreID=eu.StoreID
			inner join  EmployeeJob as ej on e.StoreID=ej.StoreID and e.ID=ej.EmployeeID
			inner join Store as s on eu.StoreID=s.ID
			inner join Position as p on p.ID=ej.PositionID and p.StoreID=ej.StoreID
			where eu.StoreID=@StoreID and eu.StoreID>0
			and eu.IsTerminated=0 
			and  ej.PositionID=@JobID
			and Enable=1
			order by FirstName,LastName
		end
		
	end
	else if @type=4
	-- select EnterpriseUser by UserID
	begin
		SELECT [ID]
      ,[StoreID]
      ,[FirstName]
      ,[LastName]
      , FirstName+','+LastName as AllName
      ,[IsManager]
      ,[Email]
      ,[HomePhone]
      ,[MobilePhone]
      ,[MobileCarrier]
      ,[Address]
      ,[AddressCont]
      ,[City]
      ,[State]
      ,[Zip]
      ,[UserName]
      ,[Password]
      ,[LoginCount]
      ,[IsTerminated]
      ,[Enable]
      ,SendMessageWhen
      ,SendEmailWhen
  FROM [EnterpriseUser] where ID=@UserID and IsTerminated=0 and Enable=1
	end
	else if @type=5
	-- select EnterpriseUser and Authority
	begin
	SELECT eu.ID 
		,eu.StoreID as storeID	
	,o.StoreID as OrganizationStoreID  --null is store user ,0 is enterprise manager,>0 is store manager
      ,FirstName
      ,LastName
      , FirstName
      ,LastName
      ,IsManager
      ,Email
      ,HomePhone
      ,MobilePhone
      ,MobileCarrier
      ,Address
      ,AddressCont
      ,City
      ,State
      ,Zip
      ,UserName
      ,Password
      ,LoginCount
      ,IsTerminated
      ,Enable
      FROM OrganizationToUser as otu  inner join Organization as o on o.ID=otu.OrganizationID 
      right outer join EnterpriseUser as eu  on eu.ID=otu.UserID 
   where eu.ID=@UserID and IsTerminated=0 and Enable=1
	end
END
GO
