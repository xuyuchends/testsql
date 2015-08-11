SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Inv_MenuItemMap_InUpDel]
(
	@StoreID int,
	@InvMID int,
	@stMID int,
	@SQLOperationType nvarchar(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @DoubleItemID int
	declare @InvDoubleItemID int
	select @InvDoubleItemID=DoubleItemID from Inv_MenuItem where id=@InvMID
		select @DoubleItemID =DoubleItemID from MenuItem where id=@stMID
	if(@SQLOperationType='SQLINSERT')
	begin
		
		INSERT INTO Inv_MenuItemMap(StoreID,InvMID,stMID)VALUES(@StoreID,@InvMID,@stMID)	
		--Double Item
		if ISNULL(@InvDoubleItemID,0)<>0 and ISNULL(@DoubleItemID,0)<>0
		INSERT INTO Inv_MenuItemMap(StoreID,InvMID,stMID)VALUES(@StoreID,@InvDoubleItemID,@DoubleItemID)	
	end			
	else if @SQLOperationType='SQLDELETE'
	begin
		DELETE FROM Inv_MenuItemMap WHERE InvMID=@InvMID
		
		--DoubleItem
		DELETE FROM Inv_MenuItemMap WHERE InvMID=@InvDoubleItemID
	end
END
GO
