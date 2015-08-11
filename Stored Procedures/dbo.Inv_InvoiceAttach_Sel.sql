SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_InvoiceAttach_Sel]
(
	@ID int,
	@InvoiceID int,
	@FilePath nvarchar,
	@Description nvarchar,
	@FileType nvarchar,
	@FileAlias nvarchar,
	@SQLOperationType nvarchar(50)
)
as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 if (@SQLOperationType='SQLSELECT')
		SELECT [ID],[InvoiceID],[FilePath],[Description],[FileType],[FileAlias],FileName
		FROM [Inv_InvoiceAttach] where InvoiceID=@InvoiceID
END
GO
