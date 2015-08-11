SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Contact_sel]
(
	@id int,
	@name nvarchar(20),
	@Userid int,
	@StoreID int,
	@Type int,
	@LookInType int,
	@TableName nvarchar(20)
)
as
declare @UserType nvarchar(20)
if @Type=1 --select by ID
begin
	if isnull(@TableName,'')='Contact'
	begin
	select FirstName,LastName,Company,JobTitle,HomePhone,MobilePhone,WorkPhone,Fax,Email,[Address],AddressCont,City,StateOrProvince,ZipOrPostalCode,Country,WhoCanView,CreateUserID,StoreID from ContactManage where ID=@id
	end	
	else
	begin
	select FirstName,LastName,(select StoreName from Store where ID=StoreID) as Company,case when StoreID>0 and IsManager=0 then [dbo].[fn_GetJobTitle](eu.EmployeeID,eu.StoreID) when StoreID>0 and IsManager=1 then 'MANAGER' else '' end as JobTitle,HomePhone,MobilePhone,'' as WorkPhone,'' as Fax,Email,Address,AddressCont,'' as City,State as StateOrProvince,Zip ZipOrPostalCode,'' as Country,1 as WhoCanView,ID CreateUserID,StoreID from EnterpriseUser eu where ID=@id
end
	end
--else if @Type=2 --select by Name
--begin
--	select @UserType=( case when StoreID=0 then 'EnterpriseUser' when StoreID>0 and IsManager=1 then 'StoreManager' else 'StoreEmployee' end) from EnterpriseUser where ID=@Userid
--	if @LookInType=2
--	begin
--		if isnull(@name,'')<>''
--		begin
--			if @UserType='EnterpriseUser'	
--			begin
--				select FirstName,LastName,Company,JobTitle,case when CreateUserID=@Userid then 1 else 0 end as isAddedBySelf from ContactManage where (FirstName like '%'+@name+'%' or LastName like '%'+@name+'%') and (CreateUserID=@Userid or (StoreID=@StoreID and WhoCanView=1) or (select  case when StoreID=0 then 'EnterpriseUser' when StoreID>0 and IsManager=1 then 'StoreManager' else 'StoreEmployee' end from EnterpriseUser where ID=CreateUserID)='EnterpriseUser' and StoreID=0 and WhoCanView=1)
--				union
--				select FirstName,LastName,
--				(select StoreName from Store where ID=eu.StoreID) as Company
--				,case when (StoreID>0 and IsManager=0) then [dbo].[fn_GetJobTitle](eu.EmployeeID,eu.StoreID) when StoreID>0 and IsManager=1 then 'MANAGER' else null end as JobTitle ,0
--				from EnterpriseUser eu where StoreID=@StoreID and
--			  (FirstName like '%'+@name+'%' or LastName like '%'+@name+'%')
--			end
--			else if @UserType='StoreManager'
--			begin
--				select FirstName,LastName,Company,JobTitle,case when CreateUserID=@Userid then 1 else 0 end as isAddedBySelf from ContactManage where (FirstName like '%'+@name+'%' or LastName like '%'+@name+'%') and (CreateUserID=@Userid or (StoreID=@StoreID and WhoCanView=1))
--				union
--				select FirstName,LastName,
--				(select StoreName from Store where ID=eu.StoreID) as Company
--				,case when (StoreID>0 and IsManager=0) then [dbo].[fn_GetJobTitle](eu.EmployeeID,eu.StoreID) when StoreID>0 and IsManager=1 then 'MANAGER' else null end as JobTitle ,0
--				from EnterpriseUser eu where StoreID=@StoreID and
--			  (FirstName like '%'+@name+'%' or LastName like '%'+@name+'%')
--			end
--		end
--		else
--		begin
--			if @UserType='EnterpriseUser'	
--			begin
--				select FirstName,LastName,Company,JobTitle,case when CreateUserID=@Userid then 1 else 0 end as isAddedBySelf from ContactManage where (CreateUserID=@Userid or (StoreID=@StoreID and WhoCanView=1) or (select  case when StoreID=0 then 'EnterpriseUser' when StoreID>0 and IsManager=1 then 'StoreManager' else 'StoreEmployee' end from EnterpriseUser where ID=CreateUserID)='EnterpriseUser' and StoreID=0 and WhoCanView=1)
--				union
--				select FirstName,LastName,
--				(select StoreName from Store where ID=eu.StoreID) as Company
--				,case when (StoreID>0 and IsManager=0) then [dbo].[fn_GetJobTitle](eu.EmployeeID,eu.StoreID) when StoreID>0 and IsManager=1 then 'MANAGER' else null end as JobTitle ,0
--				from EnterpriseUser eu where StoreID=@StoreID 
--			end
--			else if @UserType='StoreManager'
--			begin
--				select FirstName,LastName,Company,JobTitle,case when CreateUserID=@Userid then 1 else 0 end as isAddedBySelf from ContactManage where (CreateUserID=@Userid or (StoreID=@StoreID and WhoCanView=1))
--				union
--				select FirstName,LastName,
--				(select StoreName from Store where ID=eu.StoreID) as Company
--				,case when (StoreID>0 and IsManager=0) then [dbo].[fn_GetJobTitle](eu.EmployeeID,eu.StoreID) when StoreID>0 and IsManager=1 then 'MANAGER' else null end as JobTitle,0 isAddedBySelf
--				from EnterpriseUser eu where StoreID=@StoreID 
--			end
--		end
--	end
--	else
--	begin
--		if isnull(@name,'')<>''
--		begin
--			select FirstName,LastName,Company,JobTitle,1 isAddedBySelf from ContactManage where (FirstName like '%'+@name+'%' or LastName like '%'+@name+'%') and CreateUserID=@Userid 
--		end
--		else
--		begin
--			select FirstName,LastName,Company,JobTitle,1 isAddedBySelf from ContactManage where CreateUserID=@Userid 
--		end
--	end
--end
else if @Type=3 --select by fist letter
begin
	select @UserType=( case when StoreID=0 then 'EnterpriseUser' when StoreID>0 and IsManager=1 then 'StoreManager' else 'StoreEmployee' end) from EnterpriseUser where ID=@Userid
	if @LookInType=2
	begin	
		if isnull(@name,'')<>''
		begin
			if isnull(@name,'')='Other'
			begin
				if @UserType='EnterpriseUser'	
				begin
					select FirstName+','+LastName as [Name],Company,JobTitle,case when CreateUserID=@Userid then 1 else 0 end as isAddedBySelf,id,'Contact' TableName from ContactManage where ((ascii(SUBSTRING(FirstName,1,1))<65 or ascii(SUBSTRING(FirstName,1,1))>123)  or	(ascii(SUBSTRING(LastName,1,1))<65 and ascii(SUBSTRING(LastName,1,1))>123 and ISNULL(FirstName,'')='')) and (CreateUserID=@Userid or (StoreID=@StoreID and WhoCanView=2) or (select  case when StoreID=0 then 'EnterpriseUser' when StoreID>0 and IsManager=1 then 'StoreManager' else 'StoreEmployee' end from EnterpriseUser where ID=CreateUserID)='EnterpriseUser' and StoreID=0 and WhoCanView=2)
					union all
					select FirstName+','+LastName as [Name],
					(select StoreName from Store where ID=eu.StoreID) as Company
					,case when (StoreID>0 and IsManager=0) then [dbo].[fn_GetJobTitle](eu.EmployeeID,eu.StoreID) when StoreID>0 and IsManager=1 then 'MANAGER' else null end as JobTitle ,0 as isAddedBySelf,eu.id,
		'Employee' TableName 			
					from EnterpriseUser eu where StoreID=@StoreID and
				  ((ascii(SUBSTRING(FirstName,1,1))<65 or ascii(SUBSTRING(FirstName,1,1))>123)  or	(ascii(SUBSTRING(LastName,1,1))<65 and ascii(SUBSTRING(LastName,1,1))>123 and ISNULL(FirstName,'')=''))
				end
				else if @UserType='StoreManager'
				begin
					select FirstName+','+LastName as [Name],Company,JobTitle,case when CreateUserID=@Userid then 1 else 0 end as isAddedBySelf,id,'Contact' TableName from ContactManage where ((ascii(SUBSTRING(FirstName,1,1))<65 or ascii(SUBSTRING(FirstName,1,1))>123)  or	(ascii(SUBSTRING(LastName,1,1))<65 and ascii(SUBSTRING(LastName,1,1))>123 and ISNULL(FirstName,'')='')) and (CreateUserID=@Userid or (StoreID=@StoreID and WhoCanView=2))
					union all
					select FirstName+','+LastName as [Name],
					(select StoreName from Store where ID=eu.StoreID) as Company
					,case when (StoreID>0 and IsManager=0) then [dbo].[fn_GetJobTitle](eu.EmployeeID,eu.StoreID) when StoreID>0 and IsManager=1 then 'MANAGER' else null end as JobTitle ,0 isAddedBySelf,eu.id,'Employee' TableName
					from EnterpriseUser eu where StoreID=@StoreID and
				  ((ascii(SUBSTRING(FirstName,1,1))<65 or ascii(SUBSTRING(FirstName,1,1))>123)  or	(ascii(SUBSTRING(LastName,1,1))<65 and ascii(SUBSTRING(LastName,1,1))>123 and ISNULL(FirstName,'')=''))
				end
			end
			else
			begin
				if @UserType='EnterpriseUser'	
				begin
					select FirstName+','+LastName as [Name],Company,JobTitle,case when CreateUserID=@Userid then 1 else 0 end as isAddedBySelf,id,'Contact' TableName from ContactManage where (FirstName like @name+'%' or (LastName like @name+'%' and ISNULL(FirstName,'')='')) and (CreateUserID=@Userid or (StoreID=@StoreID and WhoCanView=2) or (select  case when StoreID=0 then 'EnterpriseUser' when StoreID>0 and IsManager=1 then 'StoreManager' else 'StoreEmployee' end from EnterpriseUser where ID=CreateUserID)='EnterpriseUser' and StoreID=0 and WhoCanView=2)
					union all
					select FirstName+','+LastName as [Name],
					(select StoreName from Store where ID=eu.StoreID) as Company
					,case when (StoreID>0 and IsManager=0) then [dbo].[fn_GetJobTitle](eu.EmployeeID,eu.StoreID) when StoreID>0 and IsManager=1 then 'MANAGER' else null end as JobTitle ,0 as isAddedBySelf,eu.id,
		'Employee' TableName 			
					from EnterpriseUser eu where StoreID=@StoreID and
				  (FirstName like @name+'%' or (LastName like @name+'%' and ISNULL(FirstName,'')=''))
				end
				else if @UserType='StoreManager'
				begin
					select FirstName+','+LastName as [Name],Company,JobTitle,case when CreateUserID=@Userid then 1 else 0 end as isAddedBySelf,id,'Contact' TableName from ContactManage where (FirstName like @name+'%' or (LastName like @name+'%' and ISNULL(FirstName,'')='')) and (CreateUserID=@Userid or (StoreID=@StoreID and WhoCanView=2))
					union all
					select FirstName+','+LastName as [Name],
					(select StoreName from Store where ID=eu.StoreID) as Company
					,case when (StoreID>0 and IsManager=0) then [dbo].[fn_GetJobTitle](eu.EmployeeID,eu.StoreID) when StoreID>0 and IsManager=1 then 'MANAGER' else null end as JobTitle ,0 isAddedBySelf,eu.id,'Employee' TableName
					from EnterpriseUser eu where StoreID=@StoreID and
				  (FirstName like @name+'%' or (LastName like @name+'%' and ISNULL(FirstName,'')=''))
				end
			end
		end
	end
	else
	begin
		if isnull(@name,'')<>''
		begin 
			if isnull(@name,'')='Other'
			begin
				
				if @UserType='EnterpriseUser'	
				begin
					select FirstName+','+LastName as [Name],Company,JobTitle,1 as isAddedBySelf,id,'Contact' TableName from ContactManage where ((ascii(SUBSTRING(FirstName,1,1))<65 or ascii(SUBSTRING(FirstName,1,1))>123)  or	(ascii(SUBSTRING(LastName,1,1))<65 and ascii(SUBSTRING(LastName,1,1))>123 and ISNULL(FirstName,'')='')) and CreateUserID=@Userid 
					
				end
				else if @UserType='StoreManager'
				begin
					select FirstName+','+LastName as [Name],Company,JobTitle,1 as isAddedBySelf,id,'Contact' TableName from ContactManage where ((ascii(SUBSTRING(FirstName,1,1))<65 or ascii(SUBSTRING(FirstName,1,1))>123)  or	(ascii(SUBSTRING(LastName,1,1))<65 and ascii(SUBSTRING(LastName,1,1))>123 and ISNULL(FirstName,'')='')) and CreateUserID=@Userid
				end
			end
			else
			begin
				if @UserType='EnterpriseUser'	
				begin
					select FirstName+','+LastName as [Name],Company,JobTitle,1 as isAddedBySelf,id,'Contact' TableName from ContactManage where (FirstName like @name+'%' or (LastName like @name+'%' and ISNULL(FirstName,'')='')) and CreateUserID=@Userid 
				end
				else if @UserType='StoreManager'
				begin
					select FirstName+','+LastName as [Name],Company,JobTitle,1 as isAddedBySelf,id,'Contact' TableName from ContactManage where (FirstName like @name+'%' or (LastName like @name+'%' and ISNULL(FirstName,'')='')) and CreateUserID=@Userid
				end
			end
		end
	end
end
else if @Type=4 --select All fist letter
begin
	select @UserType=( case when StoreID=0 then 'EnterpriseUser' when StoreID>0 and IsManager=1 then 'StoreManager' else 'StoreEmployee' end) from EnterpriseUser where ID=@Userid
	if @LookInType=2
	begin	
		if isnull(@name,'')<>''
		begin
			if @UserType='EnterpriseUser'	
			begin
				select distinct case when ascii( FirstLeter) between 65 and 123 then FirstLeter else 'Other' end FirstLeter, 
case when ascii( FirstLeter) between 65 and 123 then 0 else 1 end OrderCol  from ( select case when isnull(FirstName,'')<>'' then SUBSTRING(FirstName,1,1) else SUBSTRING(LastName,1,1) end FirstLeter from ContactManage where (FirstName like '%'+@name+'%' or (LastName like @name+'%' and ISNULL(FirstName,'')='')) and (CreateUserID=@Userid or (StoreID=@StoreID and WhoCanView=2) or (select  case when StoreID=0 then 'EnterpriseUser' when StoreID>0 and IsManager=1 then 'StoreManager' else 'StoreEmployee' end from EnterpriseUser where ID=CreateUserID)='EnterpriseUser' and StoreID=0 and WhoCanView=2)
				union all
				select case when isnull(FirstName,'')<>'' then SUBSTRING(FirstName,1,1) else SUBSTRING(LastName,1,1) end FirstLeter from EnterpriseUser eu where StoreID=@StoreID and
			  (FirstName like @name+'%' or (LastName like '%'+@name+'%' and ISNULL(FirstName,'')=''))) b order by OrderCol
			end
			else if @UserType='StoreManager'
			begin
				select distinct case when ascii( FirstLeter) between 65 and 123 then FirstLeter else 'Other' end FirstLeter, 
case when ascii( FirstLeter) between 65 and 123 then 0 else 1 end OrderCol from ( select case when isnull(FirstName,'')<>'' then SUBSTRING(FirstName,1,1) else SUBSTRING(LastName,1,1) end FirstLeter from ContactManage where (FirstName like '%'+@name+'%' or (LastName like '%'+@name+'%' and ISNULL(FirstName,'')='')) and (CreateUserID=@Userid or (StoreID=@StoreID and WhoCanView=2))
				union all
				select case when isnull(FirstName,'')<>'' then SUBSTRING(FirstName,1,1) else SUBSTRING(LastName,1,1) end FirstLeter from EnterpriseUser eu where StoreID=@StoreID and
			  (FirstName like '%'+@name+'%' or (LastName like @name+'%' and ISNULL(FirstName,'')=''))) b order by OrderCol
			end
		end
		else
		begin
			if @UserType='EnterpriseUser'	
			begin
				select distinct case when ascii( FirstLeter) between 65 and 123 then FirstLeter else 'Other' end FirstLeter, 
case when ascii( FirstLeter) between 65 and 123 then 0 else 1 end OrderCol from ( select case when isnull(FirstName,'')<>'' then SUBSTRING(FirstName,1,1) else SUBSTRING(LastName,1,1) end FirstLeter from ContactManage where (CreateUserID=@Userid or (StoreID=@StoreID and WhoCanView=2) or (select  case when StoreID=0 then 'EnterpriseUser' when StoreID>0 and IsManager=1 then 'StoreManager' else 'StoreEmployee' end from EnterpriseUser where ID=CreateUserID)='EnterpriseUser' and StoreID=0 and WhoCanView=2)
				union all
				select case when isnull(FirstName,'')<>'' then SUBSTRING(FirstName,1,1) else SUBSTRING(LastName,1,1) end FirstLeter from EnterpriseUser eu where StoreID=@StoreID) b order by OrderCol
			end
			else if @UserType='StoreManager'
			begin
				select distinct case when ascii( FirstLeter) between 65 and 123 then FirstLeter else 'Other' end FirstLeter, 
case when ascii( FirstLeter) between 65 and 123 then 0 else 1 end OrderCol from ( select case when isnull(FirstName,'')<>'' then SUBSTRING(FirstName,1,1) else SUBSTRING(LastName,1,1) end FirstLeter from ContactManage where (CreateUserID=@Userid or (StoreID=@StoreID and WhoCanView=2))
				union all
				select case when isnull(FirstName,'')<>'' then SUBSTRING(FirstName,1,1) else SUBSTRING(LastName,1,1) end FirstLeter from EnterpriseUser eu where StoreID=@StoreID) b order by OrderCol
			end
		end
	end
	else
	begin
		if isnull(@name,'')<>''
		begin
			if @UserType='EnterpriseUser'	
			begin
				 select distinct case when ascii( FirstLeter) between 65 and 123 then FirstLeter else 'Other' end FirstLeter, 
case when ascii( FirstLeter) between 65 and 123 then 0 else 1 end OrderCol from (select distinct case when isnull(FirstName,'')<>'' then SUBSTRING(FirstName,1,1) else SUBSTRING(LastName,1,1) end FirstLeter from ContactManage where (FirstName like '%'+@name+'%' or (LastName like '%'+@name+'%' and ISNULL(FirstName,'')='')) and CreateUserID=@Userid) b order by OrderCol
			end
			else if @UserType='StoreManager'
			begin
				select distinct case when ascii( FirstLeter) between 65 and 123 then FirstLeter else 'Other' end FirstLeter, 
case when ascii( FirstLeter) between 65 and 123 then 0 else 1 end OrderCol from (select distinct case when isnull(FirstName,'')<>'' then SUBSTRING(FirstName,1,1) else SUBSTRING(LastName,1,1) end FirstLeter from ContactManage where (FirstName like '%'+@name+'%' or (LastName like '%'+@name+'%' and ISNULL(FirstName,'')='')) and CreateUserID=@Userid) b order by OrderCol
			end
		end
		else
		begin
			if @UserType='EnterpriseUser'	
			begin
				select distinct case when ascii( FirstLeter) between 65 and 123 then FirstLeter else 'Other' end FirstLeter, 
case when ascii( FirstLeter) between 65 and 123 then 0 else 1 end OrderCol from (select distinct case when isnull(FirstName,'')<>'' then SUBSTRING(FirstName,1,1) else SUBSTRING(LastName,1,1) end FirstLeter from ContactManage where CreateUserID=@Userid ) b order by OrderCol
			end
			else if @UserType='StoreManager'
			begin
				select distinct case when ascii( FirstLeter) between 65 and 123 then FirstLeter else 'Other' end FirstLeter, 
case when ascii( FirstLeter) between 65 and 123 then 0 else 1 end OrderCol from (select distinct case when isnull(FirstName,'')<>'' then SUBSTRING(FirstName,1,1) else SUBSTRING(LastName,1,1) end FirstLeter from ContactManage where CreateUserID=@Userid ) b order by OrderCol
			end
		end
	end
end
GO
