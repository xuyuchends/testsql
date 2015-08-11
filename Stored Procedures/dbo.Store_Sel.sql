SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Store_Sel]
	@storeID int,
	@loginName nvarchar(50),
	@type int
AS
BEGIN
	SET NOCOUNT ON;
	if @type=1
	begin
		if @storeID=0
		begin
			select id as StoreID,username as UserName,password as Password,storename as StoreName,LocationID as LoginName,Phone,Address,[Address Cont.] as AddressCont,City,
	[State/Province],[Zip/Postal Code]	from Store
		end
		else
		begin
			select id as StoreID,username as UserName,password as Password,storename as StoreName,LocationID as LoginName,Phone,Address,[Address Cont.] as AddressCont,City,
	[State/Province],[Zip/Postal Code]		 from Store where id=@storeID
		end
	end
	else if @type=2
	begin
		select id as StoreID,username as UserName,password as Password,storename as StoreName,LocationID as LoginName,Phone,Address,[Address Cont.] as AddressCont,City,
	[State/Province],[Zip/Postal Code]	from Store where LocationID=@loginName
	end
	else if @type=3
	begin
		select COUNT(*) from Store where StoreName=@loginName and ID<>@storeID
	end
	else if @type=4
	begin
		select ID StoreID,StoreName from Store where ID<>@storeID
	end
END
GO
