SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_MenuItemRecipe_InUpDel]
(
	@InvMID int,
	@InvItemID int,
	@Qty decimal(18,2),
	@SQLOperationType nvarchar(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @InvDoubleItemID int
	select @InvDoubleItemID=DoubleItemID from Inv_MenuItem where id=@InvMID
	if(@SQLOperationType='SQLINSERT')
	begin
		INSERT INTO Inv_MenuItemRecipe(InvMID,InvItemID,Qty)VALUES(@InvMID,@InvItemID,@Qty)
		--Double Item
		if ISNULL(@InvDoubleItemID,0)<>0
		INSERT INTO Inv_MenuItemRecipe(InvMID,InvItemID,Qty)VALUES(@InvDoubleItemID,@InvItemID,@Qty*2)	
	end			
	else if @SQLOperationType='SQLDELETE'
	begin
		DELETE FROM Inv_MenuItemRecipe WHERE InvMID=@InvMID
		--Double Item
		DELETE FROM Inv_MenuItemRecipe WHERE InvMID=@InvDoubleItemID
		end
END
GO
