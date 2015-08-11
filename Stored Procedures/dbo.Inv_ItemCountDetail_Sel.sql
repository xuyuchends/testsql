SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_ItemCountDetail_Sel]
	@CountID int,
	@ItemID int,
	@StockUnitQOH decimal(18,2),
	@UseUnitQOH decimal(18,2),
	@StockUnitTOH decimal(18,2),
	@UseUnitTOH decimal(18,2),
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if (@sqlType='SQLSELECT')
		SELECT CountID,ItemID,StockUnitQOH,UseUnitQOH,StockUnitTOH,UseUnitTOH FROM Inv_ItemCountDetail
	else if (@sqlType='SQLSELECTDETAIL')
		SELECT CountID,ItemID,StockUnitQOH,UseUnitQOH,StockUnitTOH,UseUnitTOH FROM Inv_ItemCountDetail
		where CountID=@CountID and ItemID=@ItemID
END
GO
