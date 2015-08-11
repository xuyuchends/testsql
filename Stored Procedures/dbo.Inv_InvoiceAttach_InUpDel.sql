SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_InvoiceAttach_InUpDel]
(
	@ID int,
	@InvoiceID int,
	@FilePath nvarchar(200),
	@Description nvarchar(200),
	@FileType nvarchar(200),
	@FileAlias nvarchar(200),
	@FileName nvarchar(200),
	@SQLOperationType nvarchar(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@SQLOperationType='SQLINSERT')
	begin
		INSERT INTO Inv_InvoiceAttach(InvoiceID,FilePath,Description,FileType,FileAlias,[FileName])
		VALUES(@InvoiceID,@FilePath,@Description,@FileType,@FileAlias,@FileName)
	select @@IDENTITY
	end							
	else if @SQLOperationType='SQLDELETE'
	begin
		delete from Inv_InvoiceAttach WHERE InvoiceID=@InvoiceID
	end
END
GO
