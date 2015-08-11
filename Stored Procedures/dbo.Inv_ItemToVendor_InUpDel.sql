SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_ItemToVendor_InUpDel]
	-- Add the parameters for the stored procedure here
	@ItemID int,
	@VendorID int,
	@SupllierCode nvarchar(200),
	@Description nvarchar(200),
	@LastUnitPrice decimal(18,2),
	@OrderUnit int ,
	@StockPerOrder float,
	@ReceipePerStock float,
	@UPC nvarchar(200),
	@Creator int,
	@Editor int,
	@DisplaySeq int,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
declare @currentDisplaySeq int
	declare @transferID int
	declare @transferDisplaySeq int
    -- Insert statements for procedure here
    if ISNULL(@sqlType,'')='SQLINSERT'
	INSERT INTO Inv_ItemToVendor
		(ItemID,
           [VendorID]
           ,[SupplierCode]
           ,[Description]
           ,[LastUnitPrice]
           ,[OrderUnit]
           ,[StockPerOrder]
           ,[ReceipePerStock]
           ,[UPC]
           ,[DisplaySeq]
           ,[LastUpdate]
           ,[Creator]
           ,[Editor])
     VALUES(@ItemID,@VendorID,@SupllierCode,@Description,@LastUnitPrice,@OrderUnit,@StockPerOrder,@ReceipePerStock,@UPC,
     (select isnull(MAX(DisplaySeq),0) from Inv_ItemToVendor where VendorID=@VendorID)+1,GETDATE(),@Creator,@Editor)
	
	else if ISNULL(@sqlType,'')='SQLDELETE'
	delete from Inv_ItemToVendor where ItemID=@ItemID
	else if ISNULL(@sqlType,'')='SQLUpdate'
	begin
		declare @sqlWhere nvarchar(max)
		declare @sql nvarchar(max)
		set @sqlWhere=''
		if ISNULL(@SupllierCode,'')<>''
		begin
			set @sqlWhere=@sqlWhere+' ,[SupplierCode]= '''+@SupllierCode+''''
		end
		if ISNULL(@Description,'')<>''
		begin
			set @sqlWhere=@sqlWhere+' ,[Description]= '''+@Description+''''
		end
		if ISNULL(@LastUnitPrice,0)<>0
		begin
			set @sqlWhere=@sqlWhere+' ,[LastUnitPrice]= '+CONVERT(nvarchar(20),@LastUnitPrice)
		end
		if ISNULL(@OrderUnit,0)<>0
		begin
			set @sqlWhere=@sqlWhere+' ,[OrderUnit]= '+CONVERT(nvarchar(20),@OrderUnit)
		end
		if ISNULL(@StockPerOrder,0)<>0
		begin
			set @sqlWhere=@sqlWhere+' ,StockPerOrder= '+CONVERT(nvarchar(20),@StockPerOrder)
		end
		if ISNULL(@ReceipePerStock,0)<>0
		begin
			set @sqlWhere=@sqlWhere+' ,ReceipePerStock= '+CONVERT(nvarchar(20),@ReceipePerStock)
		end
		if ISNULL(@UPC,'')<>''
		begin
			set @sqlWhere=@sqlWhere+' ,UPC= '''+@UPC+''''
		end
		if ISNULL(@Creator,0)<>0
		begin
			set @sqlWhere=@sqlWhere+' ,Creator= '+CONVERT(nvarchar(20),@Creator)
		end
		if ISNULL(@Editor,0)<>0
		begin
			set @sqlWhere=@sqlWhere+' ,Editor= '+CONVERT(nvarchar(20),@Editor)
		end
		set @sql='update Inv_ItemToVendor set lastupdate=getdate() '+@sqlWhere+'where ItemID='+CONVERT(nvarchar(20),@ItemID)+' and VendorID='+CONVERT(nvarchar(20),@VendorID) + ' and OrderUnit=' + Convert(nvarchar(20),@OrderUnit)
		execute (@sql)
	end	 
	else if ISNULL(@sqlType,'')='SQLUp'
	begin
		begin tran
			select @currentDisplaySeq=DisplaySeq from Inv_ItemToVendor itv inner join Inv_Item i on itv.ItemID=i.ID
			 where ID=@ItemID and VendorID=@VendorID
			select top 1 @transferID=ItemID,@transferDisplaySeq= DisplaySeq from Inv_ItemToVendor 
			where DisplaySeq=
			(
				select MAX(DisplaySeq) from  Inv_ItemToVendor itv inner join Inv_Item i on itv.ItemID=i.ID
				  where VendorID=@VendorID and itv.DisplaySeq<@currentDisplaySeq 
			)
			if (@transferID is not null)
			begin
				update Inv_ItemToVendor set DisplaySeq=@currentDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() 
				where ItemID=@transferID and VendorID=@VendorID
				update Inv_ItemToVendor set DisplaySeq=@transferDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() 
				where ItemID=@ItemID and VendorID=@VendorID
			end
		commit tran
	end
	else if ISNULL(@sqlType,'')='SQLDown'
	begin
		begin tran
			select @currentDisplaySeq=DisplaySeq from Inv_ItemToVendor itv inner join Inv_Item i on itv.ItemID=i.ID
			 where ID=@ItemID and VendorID=@VendorID
			select top 1 @transferID=ItemID,@transferDisplaySeq= DisplaySeq from Inv_ItemToVendor 
			where DisplaySeq=
			(
				select min(DisplaySeq) from  Inv_ItemToVendor itv inner join Inv_Item i on itv.ItemID=i.ID
				  where VendorID=@VendorID and itv.DisplaySeq>@currentDisplaySeq 
			)
			if (@transferID is not null)
			begin
				update Inv_ItemToVendor set DisplaySeq=@currentDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() 
				where ItemID=@transferID and VendorID=@VendorID
				update Inv_ItemToVendor set DisplaySeq=@transferDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() 
				where ItemID=@ItemID and VendorID=@VendorID
			end
		commit tran
	end
	else if ISNULL(@sqlType,'')='SQLSort'
	begin
		select 1
		select @DisplaySeq
		select @ItemID
		select @VendorID
		update Inv_ItemToVendor set DisplaySeq=@DisplaySeq,Editor=@Editor,LastUpdate=GETDATE() 
		where ItemID=@ItemID and VendorID=@VendorID
			
	end
END
GO
