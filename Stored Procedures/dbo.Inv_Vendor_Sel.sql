SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_Vendor_Sel]
(
	@ID int,
	@Name nvarchar,
	@Code nvarchar,
	@Supplier bit,
	@TenderTypes nvarchar(max),
	@Contact nvarchar,
	@Archived bit,
	@Address nvarchar,
	@Address2 nvarchar,
	@City nvarchar(50),
	@state nvarchar(50),
	@Country nvarchar(50),
	@ZipCode nvarchar(20),
	@Phone nvarchar(20),
	@VendorStore nvarchar(max),
	@DisplaySeq int,
	@LastUpdate datetime,
	@Creator int,
	@Editor int,
	@SQLOperationType nvarchar(50)
)
as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@SQLOperationType='SQLSELECT')
		if (@Name='')
			select ID,Name,Code,Supplier,TenderTypes,Contact,Archived,[Address],Address2,City,[state],Country,ZipCode,Phone,
			(select COUNT(*) from f_split(VendorStore,',') ) as  StoreCount,VendorStore,
			DisplaySeq,LastUpdate,Creator,Editor from Inv_Vendor 
			where Archived=@Archived
			order by Name 
		else
			select ID,Name,Code,Supplier,TenderTypes,Contact,Archived,[Address],Address2,City,[state],Country,ZipCode,Phone,
			(select COUNT(*) from f_split(VendorStore,',') ) as  StoreCount,VendorStore,
			DisplaySeq,LastUpdate,Creator,Editor from Inv_Vendor 
			where Archived=@Archived and Name like +@Name+'%' 
			order by Name 
	else if (@SQLOperationType='SQLSELECTDETAIL')
			select ID,Name,Code,Supplier,TenderTypes,Contact,Archived,[Address],Address2,City,[state],Country,ZipCode,Phone,VendorStore,DisplaySeq,LastUpdate,Creator,Editor from Inv_Vendor 
			where ID=@ID
	else if (@SQLOperationType ='GetCharlist')
		SELECT  distinct SUBSTRING(Name,1,1) as Name FROM [Inv_Vendor] where Archived<>@Archived
		order by  SUBSTRING(Name,1,1) asc
	else if (@SQLOperationType ='GetAvailableStoreByID')
		select col as StoreID from dbo.f_split ((select top 1 VendorStore from Inv_Vendor where ID=@id),',')
		order by col
	else if(@SQLOperationType ='GetVendorByStoreID')
	begin
		if isnull(@VendorStore,0)=0
		select ID,Name from Inv_Vendor
		else
		select ID,Name from Inv_Vendor where @VendorStore in (select * from dbo.f_split(VendorStore,','))
	end
END
GO
