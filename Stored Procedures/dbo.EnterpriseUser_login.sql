SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[EnterpriseUser_login]
	@UserName nvarchar(50),
	@Password nvarchar(50),
	@locationID nvarchar(50),-- '' is all store ,other is store ID
	@LoginCount int,
	@LoginOrNot int,
	@type nvarchar(50)
AS
BEGIN
	declare @InnerLoginCount int
	SET NOCOUNT ON;
	if @type='SQLLogin'
	begin
	 -- login failure
	   if @LoginOrNot=0
	   begin 
		select @InnerLoginCount=eu.LoginCount from EnterpriseUser as eu where eu.UserName=@UserName
		if @InnerLoginCount>=@LoginCount
			begin
				if (@locationID='')
					update EnterpriseUser set Enable=0 where UserName=@UserName and StoreID=0
				else
					update EnterpriseUser set Enable=0 from EnterpriseUser as eu 
					inner join store as s on eu.StoreID=s.ID
					where eu.UserName=@UserName and s.LocationID=@locationID 
			end
		else
		begin
			if (@locationID='')
				update EnterpriseUser set LoginCount=LoginCount+1 where UserName=@UserName and StoreID=0
			else
				update EnterpriseUser set LoginCount=LoginCount+1 from EnterpriseUser as eu 
				inner join store as s on eu.StoreID=s.ID
				where eu.UserName=@UserName and s.LocationID=@locationID 
		end
	   end
	   -- login successed
	   else if @LoginOrNot=1
	   begin
			if (@locationID='')
				update EnterpriseUser set LoginCount=0 where UserName=@UserName and StoreID=0
			else
				update EnterpriseUser set LoginCount=0 from EnterpriseUser as eu 
				inner join store as s on eu.StoreID=s.ID
				 where eu.UserName=@UserName and s.LocationID=@locationID 
	   end
	end
	else if @type='SQLSelect'
	begin
		if (@locationID='')
		begin
			select eu.ID as UserID,
			eu.FirstName+' ' +eu.LastName as UserName,
			eu.StoreID as StoreID,
			eu.IsManager as IsManager,
			eu.Enable as Enable,
			eu.Email as Email,
			eu.LoginCount as LoginCount,
			'1' as UserType
			from EnterpriseUser as eu where eu.UserName=@userName and eu.Password=@Password and [Enable]!='0' and eu.StoreID=0
		end
		else
		begin
			select eu.ID as UserID,
			eu.FirstName+' ' +eu.LastName as UserName,
			eu.StoreID as StoreID,
			eu.IsManager as IsManager,
			eu.Enable as Enable,
			eu.Email as Email,
			eu.LoginCount as LoginCount,
			case when  eu.StoreID>0 and eu.IsManager=1 then '4' else '8' end as UserType
			from EnterpriseUser as eu
			inner join store as s on s.id=eu.StoreID
			 where eu.UserName=@userName and eu.Password=@Password and [Enable]!='0' and s.LocationID=@locationID

		end
	end
	else if @type='SQLSelectUserNameAndLocationID'
	begin
		if (@locationID='')
		begin
			select eu.ID as UserID,
			eu.FirstName+' ' +eu.LastName as UserName,
			eu.StoreID as StoreID,
			eu.IsManager as IsManager,
			eu.Enable as Enable,
			eu.Email as Email,
			eu.LoginCount as LoginCount,
			'1' as UserType
			from EnterpriseUser as eu where eu.UserName=@userName
		end
		else
		begin
			select eu.ID as UserID,
			eu.FirstName+' ' +eu.LastName as UserName,
			eu.StoreID as StoreID,
			eu.IsManager as IsManager,
			eu.Enable as Enable,
			eu.Email as Email,
			eu.LoginCount as LoginCount,
			case when  eu.StoreID>0 and eu.IsManager=1 then '4' else '8' end as UserType
			from EnterpriseUser as eu
			inner join store as s on s.id=eu.StoreID
			 where eu.UserName=@userName and s.LocationID=@locationID
		end
	end
END
GO
