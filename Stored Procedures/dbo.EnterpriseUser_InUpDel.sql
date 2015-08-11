SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[EnterpriseUser_InUpDel]
@ID int ,
@StoreID int ,
@FirstName nvarchar(50) ,
@LastName nvarchar(50) ,
@IsManager bit ,
@Email nvarchar(200) ,
@HomePhone nvarchar(50) ,
@MobilePhone nvarchar(50) ,
@MobileCarrier nvarchar(50) ,
@Address nvarchar(200) ,
@AddressCont nvarchar(200) ,
@City nvarchar(50) ,
@State nvarchar(50) ,
@Zip nvarchar(50) ,
@UserName nvarchar(50) ,
@Password nvarchar(50) ,
@LoginCount int ,
@Enable bit ,
@SendEmailWhen int,
@SendMessageWhen int,
@GroupID int,
@SQLOperationType nvarchar(50),
@ErrorMsg nvarchar(200) output 
AS


BEGIN
	SET NOCOUNT ON;
	declare @returnID as int
	set @returnID=0
	if @SQLOperationType='SQLInsert'
	begin
		if exists(select * from EnterpriseUser where FirstName=@FirstName and LastName=@LastName 
		and StoreID=@StoreID and IsTerminated=0 and Enable=1)
		begin
			set @ErrorMsg='current user already exists,please modify fisrt name or Last name'
			return
		end
		if exists(select * from EnterpriseUser where UserName=@UserName and Password=@Password 
		and StoreID=@StoreID and IsTerminated=0 and Enable=1)
		begin
			set @ErrorMsg='current user already exists,please modify user name'
			return
		end
		if exists(select * from EnterpriseUser where Email=@Email and StoreID=@StoreID 
		and IsTerminated=0 and Enable=1)
		begin
			set @ErrorMsg='current Email already exists,please input another'
			return
		end
		begin try
			begin tran
				INSERT INTO [EnterpriseUser]
			   ([StoreID]
			   ,[FirstName]
			   ,[LastName]
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
			   ,SendEmailWhen
			   ,SendMessageWhen)
		 VALUES
			   (0,
			   @FirstName,
			   @LastName, 
			   0,
			   @Email,
			   @HomePhone,
			   @MobilePhone,
			   @MobileCarrier,
			   @Address,
			   @AddressCont,
			   @City,
			   @State,
			   @Zip,
			   @UserName,
			   @Password,
			   0,
			   0,
			   @Enable,
			   @SendEmailWhen,
			   @SendMessageWhen)
				  set @returnID=@@IDENTITY
				insert into GroupToUser (GroupID,UserID) values (@GroupID,@returnID)
			commit tran
		end try
		begin catch
			rollback tran
		end catch
		return @returnID
	end
	else if @SQLOperationType='SQLUpdate'
	begin
		if exists(select * from EnterpriseUser where FirstName=@FirstName and LastName=@LastName 
		and ID<>@ID and StoreID=@StoreID  and IsTerminated=0 and Enable=1)
		begin
			set @ErrorMsg='current user already exists,please modify fisrt name or Last name'
			return
		end
		if exists(select * from EnterpriseUser where UserName=@UserName and Password=@Password 
		and ID<>@ID and StoreID=@StoreID and IsTerminated=0 and Enable=1)
		begin
			set @ErrorMsg='current user already exists,please modify user name'
			return
		end
		if exists(select * from EnterpriseUser where Email=@Email and ID<>@ID and StoreID=@StoreID
		and IsTerminated=0 and Enable=1)
		begin
			set @ErrorMsg='current Email already exists,please input another'
			return
		end
		begin try
		begin tran
		-- enterprise user 
			if (@StoreID=0)
			begin
			UPDATE [EnterpriseUser]
				SET [FirstName] = @FirstName
				,[LastName] = @LastName
				,[IsManager] = 0
				,[Email] = @Email
				,[HomePhone] = @HomePhone
				,[MobilePhone] = @MobilePhone
				,[MobileCarrier] = @MobileCarrier
				,[Address] = @Address
				,[AddressCont] = @AddressCont
				,[City] = @City
				,[State] = @State
				,[Zip] = @Zip
				,[UserName] = @UserName
				,[Password] = @Password
				,LoginCount=0
				,[Enable] = @Enable
				,SendEmailWhen=@SendEmailWhen
				,SendMessageWhen=@SendMessageWhen
				
			WHERE ID=@ID
			delete from GroupToUser where UserID=@ID
			insert into GroupToUser (GroupID,UserID) values (@GroupID,@ID)
			end
			else
			begin
				UPDATE [EnterpriseUser]
				SET [FirstName] = @FirstName
				,[LastName] = @LastName
				,[IsManager] = @IsManager
				,[Email] = @Email
				,[HomePhone] = @HomePhone
				,[MobilePhone] = @MobilePhone
				,[MobileCarrier] = @MobileCarrier
				,[Address] = @Address
				,[AddressCont] = @AddressCont
				,[City] = @City
				,[State] = @State
				,[Zip] = @Zip
				,[UserName] = @UserName
				,[Password] = @Password
				,LoginCount=0
				,[Enable] = @Enable
				,SendEmailWhen=@SendEmailWhen
				,SendMessageWhen=@SendMessageWhen
				WHERE ID=@ID
				if @IsManager=1
				begin
					delete from GroupToUser where UserID=@ID
					insert into GroupToUser (GroupID,UserID) values (@GroupID,@ID)
				end
			end
		commit tran
		end try
		begin catch
			rollback tran
		end catch
	end 
	--else if @SQLOperationType='SQLDelete'
	--	-- create from pos not delete
	--begin try
	--begin tran
	--	delete from DocumentManager where UserID=@ID
	--	delete from GroupToUser where UserID=@ID
	--	delete from ManagerLogDetail where ManagerLogID in (select ID from ManagerLog where UserID=@ID)
	--	delete from ManagerLog where UserID=@ID
	--	delete from OrganizationToUser where UserID=@ID
	--	delete from TaskDetail where TaskID in (select ID from Task Task where UpdateUserID=@ID)
	--	delete from Task where UpdateUserID=@ID
	--commit tran
	--end try
	--begin catch
	--rollback tran
	--end catch
		
		
	else if @SQLOperationType='SQLProfileUpdate'
	begin
		if exists(select * from EnterpriseUser where FirstName=@FirstName and LastName=@LastName 
		and ID<>@ID and StoreID=@StoreID and IsTerminated=0 and Enable=1)
		begin
			set @ErrorMsg='current user already exists,please modify fisrt name or Last name'
			return
		end
		if exists(select * from EnterpriseUser where UserName=@UserName and Password=@Password 
		and ID<>@ID and StoreID=@StoreID and IsTerminated=0 and Enable=1)
		begin
			set @ErrorMsg='current user already exists,please modify user name'
			return
		end
		if exists(select * from EnterpriseUser where Email=@Email and ID<>@ID and StoreID=@StoreID
		and IsTerminated=0 and Enable=1)
		begin
			set @ErrorMsg='current Email already exists,please input another'
			return
		end
		UPDATE [EnterpriseUser]
			SET [FirstName] = @FirstName
			,[LastName] = @LastName
			,[Email] = @Email
			,[HomePhone] = @HomePhone
			,[MobilePhone] = @MobilePhone
			,[MobileCarrier] = @MobileCarrier
			,[Address] = @Address
			,[AddressCont] = @AddressCont
			,[City] = @City
			,[State] = @State
			,[Zip] = @Zip
			,[UserName] = @UserName
			,[Password] = @Password
			,SendEmailWhen=@SendEmailWhen
				,SendMessageWhen=@SendMessageWhen
		WHERE ID=@ID
	end 	
END



GO
