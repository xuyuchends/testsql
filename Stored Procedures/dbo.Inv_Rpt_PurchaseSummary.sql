SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_Rpt_PurchaseSummary] 
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
	Select sto.StoreName,ven.Name, Sum(invD.Qty) as Qty, sto.ID StoreID,ven.ID VendorID,Sum(invD.Qty * invD.UnitPrice) as TotalPurchased
		From Inv_InvoiceDetail invD 
		join Inv_Invoice invH on invD.InvoiceID = invH.ID
		join Inv_item items on items.ID = invD.InvItemID
		join Inv_Vendor ven on ven.ID = invH.vendorid
		join Store sto on sto.id = invH.storeId

		Where 
		 invH.StoreID in (select * from dbo.f_split( '''+Convert(nvarchar(20),@StoreID)+''','',''))
		and convert(nvarchar(20), invH.InvoiceDate,101) between '''+Convert(nvarchar(20),@BeginDate,101)+'''
		 and '''+Convert(nvarchar(20),@endDate,101)+''''+@sqlWhere+'
		Group by sto.StoreName,sto.ID,ven.ID,ven.Name'
		--select @sql
		execute sp_executesql @sql
END
GO
