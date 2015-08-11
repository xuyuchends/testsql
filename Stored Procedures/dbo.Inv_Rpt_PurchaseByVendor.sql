SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_Rpt_PurchaseByVendor]
	-- Add the parameters for the stored procedure here
	@StoreID nvarchar(200),
	@BeginDate datetime,
	@endDate datetime,
	@VendorID int,
	@ItemID int,
	@CategoryID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    declare @sqlWhere nvarchar(max)
    declare @sql nvarchar(max)
    set @sqlWhere=''
    if ISNULL(@VendorID,0)<>0
    begin
		set @sqlWhere=@sqlWhere+' and invH.VendorID='+Convert(nvarchar(20),@VendorID)
    end
    if ISNULL(@ItemID,0)<>0
    begin
		set @sqlWhere=@sqlWhere+' and invD.InvItemID='+Convert(nvarchar(20),@ItemID)
    end 
    if ISNULL(@CategoryID,0)<>0
    begin
		set @sqlWhere=@sqlWhere+' and items.CategoryID='+Convert(nvarchar(20),@CategoryID)
    end 
    set @sql='
	Select items.ID ItemID, (items.description + '' –'' + vitems.description) as ''ItemName'', vitems.SupplierCode, invH.Num, invD.Qty,uom.Name, invD.UnitPrice,
	( invD.Qty * invD.UnitPrice) as ''ExtPrice'',items.ID,invH.Num InvoiceNum,invH.InvoiceDate
		From Inv_InvoiceDetail invD 
		join Inv_Invoice invH on invD.InvoiceID = invH.ID
		join Inv_item items on items.ID = invD.InvItemID
		join Inv_ItemToVendor vitems on vitems.ItemID = items.ID
		join Inv_UnitOfMeasures uom on uom.ID = vitems.OrderUnit

		Where 
		 invH.StoreID in (select * from dbo.f_split( '''+Convert(nvarchar(20),@StoreID)+''','',''))
		and convert(nvarchar(20), invH.InvoiceDate,101) between '''+Convert(nvarchar(20),@BeginDate,101)+'''
		 and '''+Convert(nvarchar(20),@endDate,101)+''''+@sqlWhere
		--select @sql
		execute sp_executesql @sql

END
GO
