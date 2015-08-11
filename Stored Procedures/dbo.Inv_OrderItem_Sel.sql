SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_OrderItem_Sel]
(
	@OrderID int,
	@ItemID int,
	@ItemLineID int,
	@Qty int,
	@UnitPrice money,
	@OrderUnitID int,
	@SQLOperationType nvarchar(50)
)
as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@SQLOperationType='SQLSELECT')
		SELECT itv.SupplierCode,  itv.OrderUnit as OrderUnitID, ufm.Name as OrderUnitName , oi.OrderID, oi.ItemID,i.Description as ItemName, oi.Qty, oi.UnitPrice, i.RefNum
		FROM dbo.Inv_Order AS o INNER JOIN
		dbo.Inv_OrderItem AS oi ON o.ID = oi.OrderID INNER JOIN
		dbo.Inv_ItemToVendor AS itv ON o.VendorID = itv.VendorID AND oi.ItemID = itv.ItemID and oi.OrderUnitID = itv.OrderUnit INNER JOIN
		dbo.Inv_Item AS i ON oi.ItemID = i.ID inner join Inv_UnitOfMeasures as ufm on ufm.ID=itv.OrderUnit
		where OrderID=@OrderID
		order by ItemLineID 
	else if (@SQLOperationType='SQLSELECTDETAIL')
		SELECT OrderID,ItemID,ItemLineID,Qty,UnitPrice,OrderUnitID FROM Inv_OrderItem
		where OrderID=@OrderID and ItemID=@ItemID and OrderUnitID = @OrderUnitID
END
GO
