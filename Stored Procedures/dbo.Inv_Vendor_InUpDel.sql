SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_Vendor_InUpDel]
(
	@ID int,
	@Name nvarchar(50),
	@Code nvarchar(50),
	@Supplier bit,
	@TenderTypes nvarchar(max),
	@Contact nvarchar(50),
	@Archived bit,
	@Address nvarchar(max),
	@Address2 nvarchar(max),
	@City nvarchar(50),
	@state nvarchar(50),
	@Country nvarchar(50),
	@ZipCode nvarchar(20),
	@Phone nvarchar(20),
	@VendorStore nvarchar(max),
	@Creator int,
	@Editor int,
	@SQLOperationType nvarchar(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@SQLOperationType='SQLINSERT')
	begin
		declare @MaxDisplaySeq int
		select @MaxDisplaySeq=isnull(MAX(DisplaySeq),0) from Inv_Vendor
		set @MaxDisplaySeq+=1
		INSERT INTO [Inv_Vendor] ([Name],[Code],[Supplier],[TenderTypes],[Contact],[Archived],[Address],[Address2],[City],
		[state],[Country],[ZipCode],[Phone],[VendorStore],[DisplaySeq],[LastUpdate],[Creator],[Editor])
		VALUES
        (@Name,@Code,@Supplier,@TenderTypes,@Contact,@Archived,@Address,@Address2,@City,
         @state,@Country,@ZipCode,@Phone,@VendorStore,@MaxDisplaySeq,GETDATE(),@Creator,@Creator)
		select @@IDENTITY
	end
	else if @SQLOperationType='SQLUPDATE'
	begin
		UPDATE [Inv_Vendor] SET [Name] = @Name,[Code] = @Code,[Supplier] = @Supplier,[TenderTypes] = @TenderTypes,[Contact] = @Contact,
		[Archived] = @Archived,[Address] = @Address,[Address2] = @Address2,[City] = @City,[state] = @state,
		[Country] = @Country,[ZipCode] = @ZipCode,[Phone] = @Phone,[VendorStore] = @VendorStore,
		[LastUpdate] =GETDATE(),[Editor] = @Editor
		WHERE ID=@ID
	end
	else if @SQLOperationType='SQLDELETE'
	begin
		delete from [Inv_Vendor] WHERE ID=@ID
	end
END
GO
