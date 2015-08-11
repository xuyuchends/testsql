SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Contact_InUpDel]
@SQLOperationType nvarchar(50),
@ID int,
@Firstname nvarchar(50),
@Lastname nvarchar(50),
@Company  nvarchar(50),
@JobTitle nvarchar(50),
@HomePhone nvarchar(50),
@MobilePhone nvarchar(50),
@WorkPhone nvarchar(50),
@Fax nvarchar(50),
@Email nvarchar(50),
@Address nvarchar(100),
@AddressCont nvarchar(50),
@City nvarchar(2000),
@StateOrProvince nvarchar(50),
@ZipOrPostalCode  nvarchar(50),
@County nvarchar(50),
@WhoCanView int,
@CreateUserID int,
@StoreID int
AS
BEGIN
declare @FirstnameOld nvarchar(50)
declare @LastnameOld nvarchar(50)
declare @CompanyOld  nvarchar(50)
declare @JobTitleOld nvarchar(50)
declare @HomePhoneOld nvarchar(50)
declare @MobilePhoneOld nvarchar(50)
declare @WorkPhoneOld nvarchar(50)
declare @FaxOld nvarchar(50)
declare @EmailOld nvarchar(50)
declare @AddressOld nvarchar(100)
declare @AddressContOld nvarchar(50)
declare @CityOld nvarchar(2000)
declare @StateOrProvinceOld int
declare @ZipOrPostalCodeOld nvarchar(50)
declare @CountyOld nvarchar(50)
declare @WhoCanViewOld int
declare @CreateUserIDOld int
declare @StoreIDOld int
	SET NOCOUNT ON;
	if @SQLOperationType='SQLInsert'
	begin
		INSERT INTO [ContactManage]
           ([FirstName]
           ,[LastName]
           ,[Company]
           ,[JobTitle]
           ,[HomePhone]
           ,[MobilePhone]
           ,[WorkPhone]
           ,[Fax]
           ,[Email]
           ,[Address]
           ,[AddressCont]
           ,[City]
           ,[StateOrProvince]
           ,[ZipOrPostalCode]
           ,Country
           ,[WhoCanView]
           ,[CreateUserID]
           ,[StoreID]
           ,[CreateDate])
     VALUES(@Firstname,@Lastname,@Company,@JobTitle,@HomePhone,@MobilePhone,@WorkPhone,@Fax,@Email,@Address,@AddressCont,@City,@StateOrProvince,@ZipOrPostalCode,@County,@WhoCanView,@CreateUserID,@StoreID,GETDATE())
	select @@IDENTITY
	end
	else if @SQLOperationType='SQLUpdate'
	begin
		select @FirstnameOld=FirstName,@LastnameOld=LastName,@CompanyOld=Company,@JobTitleOld=JobTitle,@HomePhoneOld=HomePhone,@MobilePhoneOld=MobilePhone,@WorkPhoneOld=WorkPhone,@FaxOld=Fax,@EmailOld=Email,@AddressOld=[Address],@AddressContOld=AddressCont,@CityOld=City,@StateOrProvinceOld=StateOrProvince,@ZipOrPostalCodeOld=ZipOrPostalCode,@CountyOld=Country,@WhoCanViewOld=WhoCanView,@CreateUserIDOld=CreateUserID,@StoreIDOld=StoreID	 from [ContactManage] where ID=@ID
	
		if ISNULL(@Firstname,'')='' begin set @Firstname=@FirstnameOld end
		if ISNULL(@LastName,'')='' begin set @LastName=@LastnameOld end
		if ISNULL(@Company,'')='' begin set @Company=@CompanyOld end
		if ISNULL(@JobTitle,'')='' begin set @JobTitle=@JobTitleOld end
		if ISNULL(@HomePhone,'')='' begin set @HomePhone=@HomePhoneOld end
		if ISNULL(@MobilePhone,'')='' begin set @MobilePhone=@MobilePhoneOld end
		if ISNULL(@WorkPhone,'')='' begin set @WorkPhone=@WorkPhoneOld end
		if ISNULL(@Fax,'')='' begin set @Fax=@FaxOld end
		if ISNULL(@Email,'')='' begin set @Email=@EmailOld end
		if ISNULL(@Address,'')='' begin set @Address=@AddressOld end
		if ISNULL(@AddressCont,'')='' begin set @AddressCont=@AddressContOld end
		if ISNULL(@City,'')='' begin set @City=@CityOld end
		if ISNULL(@StateOrProvince,'')='' begin set @StateOrProvince=@StateOrProvinceOld end
		if ISNULL(@ZipOrPostalCode,'')='' begin set @ZipOrPostalCode=@ZipOrPostalCodeOld end
		if ISNULL(@County,'')='' begin set @County=@CountyOld end
		if ISNULL(@WhoCanView,'0')='0' begin set @WhoCanView=@WhoCanViewOld end
		if ISNULL(@CreateUserID,'0')='0' begin set @CreateUserID=@CreateUserIDOld end
	
		if @StoreID is null begin set @StoreID=@StoreIDOld end
		update [ContactManage] set FirstName=@Firstname,LastName=@LastName,Company=@Company,JobTitle=@JobTitle,HomePhone=@HomePhone,MobilePhone=@MobilePhone,WorkPhone=@WorkPhone,Fax=@Fax,@Email=Email,[Address]=@Address,AddressCont=@AddressCont,City=@City,StateOrProvince=@StateOrProvince,ZipOrPostalCode=@ZipOrPostalCode,Country=@County,WhoCanView=@WhoCanView,CreateUserID=@CreateUserID,StoreID=@StoreID
	where ID=@ID	
	end
	else if @SQLOperationType='SQLDelete'
	begin
		delete from [ContactManage] where ID=@ID
	end
END
GO
