SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[MoveEmployeeToEnterpriseUser]
@StoreID int 
AS
BEGIN
SET NOCOUNT ON;
declare @EmployeeID int 
declare @FirstName  nvarchar(50)
declare @LastName  nvarchar(50)
declare @Phone  nvarchar(50)
declare @Address1  nvarchar(200)
declare @Address2  nvarchar(200)
declare @City  nvarchar(50)
declare @ZipCode  nvarchar(50)

--delete from EnterpriseUser  where not exists (select * from Employee as e where e.StoreID=EnterpriseUser.StoreID and e.ID=EnterpriseUser.EmployeeID )
--and EnterpriseUser.StoreID=@StoreID
declare cur cursor
	for SELECT ID,FirstName,LastName,Phone,Address1,Address2,City,ZipCode from Employee
	where StoreID=@StoreID
	open cur
	fetch next from cur into @EmployeeID,@FirstName,@LastName,@Phone,@Address1,@Address2,@City,@ZipCode
	while(@@fetch_status=0)
	begin
		if not exists(select * from EnterpriseUser where StoreID=@StoreID and EmployeeID=@EmployeeID)
		begin
			declare @userName nvarchar(50)
			declare @Passwrod nvarchar(50)
			set @userName=@FirstName+''+@LastName
			set @Passwrod=@FirstName+''+@LastName
			if ( select count(*) from EnterpriseUser where Enable=1 and StoreID=@StoreID and UserName=@userName and 
			Password=@Passwrod)>0
			begin
				set @userName=@FirstName+''+@LastName+ cast(@EmployeeID as nvarchar)
				set @Passwrod=@FirstName+''+@LastName+ cast(@EmployeeID as nvarchar)
			end
			INSERT INTO EnterpriseUser(StoreID,EmployeeID,FirstName,LastName,IsManager,Email,HomePhone,MobilePhone,MobileCarrier,Address,AddressCont,City,State,Zip,UserName,Password,LoginCount,IsTerminated,Enable,FromFOH)
				VALUES         (@StoreID,@EmployeeID,@FirstName,@LastName,0,      ''   ,@Phone   ,@Phone     ,''           ,@Address1+' '+@Address2,'',@City,'',@ZipCode,@username,@Passwrod,0,0,1,1)
		end
		fetch next from cur into @EmployeeID,@FirstName,@LastName,@Phone,@Address1,@Address2,@City,@ZipCode
	end
close cur
deallocate cur

--update enable=0 if not in employee table
update EnterpriseUser set Enable=0 where EmployeeID not in (select id from Employee)
and  fromFOH=1 
END
GO
