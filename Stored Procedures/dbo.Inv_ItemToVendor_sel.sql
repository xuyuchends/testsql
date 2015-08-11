SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_ItemToVendor_sel]
	-- Add the parameters for the stored procedure here
	@ItemID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


		SELECT [ItemID],[VendorID],[SupplierCode],[Description],[LastUnitPrice],[OrderUnit],[StockPerOrder],[ReceipePerStock],[UPC],[DisplaySeq],[LastUpdate],[Creator],[Editor] from Inv_ItemToVendor where ItemID=@ItemID
END
GO
