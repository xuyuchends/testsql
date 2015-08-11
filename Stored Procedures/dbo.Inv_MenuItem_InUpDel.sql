SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Inv_MenuItem_InUpDel]
(
	@ID int,
	@Name nvarchar(200),
	@Price decimal(18,2),
	@RefNumber nvarchar(50),
	@CategoryID int,
	@IsEntree bit,
	@IsModifier bit,
	@IsActive bit,
	@Recipe nvarchar,
	@FromPOS bit,
	@Creator int,
	@Editor int,
	@DoubleItemID int,
	@SQLOperationType nvarchar(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @MenuItemID int
	declare @CategoryName nvarchar(20)
	if(@SQLOperationType='SQLINSERT')
	begin
		select @CategoryName=name from Inv_MenuItemCategory where ID=@CategoryID
		select @MenuItemID = ID from Inv_MenuItem where CategoryID=@CategoryID and Name=@Name
		select Top 1 @IsModifier = IsModifier from MenuItem where Name=@Name and Category=@CategoryName
		if isnull(@MenuItemID,0)=0
		begin
		if isnull(@DoubleItemID,0)<>0
		begin
		INSERT INTO Inv_MenuItem (Name,Price,RefNumber, CategoryID,IsEntree,IsModifier,IsActive,Recipe,FromPOS,LastUpdate,Creator,Editor,doubleItemID,isDouble)
			VALUES(@Name+' - DOUBLE',@Price*2,@RefNumber,@CategoryID,@IsEntree,@IsModifier,@IsActive,@Recipe,@FromPOS,getdate(),@Creator,@Creator,0,1)
			select @DoubleItemID=@@IDENTITY
		end	
			INSERT INTO Inv_MenuItem (Name,Price,RefNumber, CategoryID,IsEntree,IsModifier,IsActive,Recipe,FromPOS,LastUpdate,Creator,Editor,doubleItemID,isDouble)
			VALUES(@Name,@Price,@RefNumber,@CategoryID,@IsEntree,@IsModifier,@IsActive,@Recipe,@FromPOS,getdate(),@Creator,@Creator,@doubleItemID,0)
			set @MenuItemID=@@IDENTITY
		end
		else
		begin
			if isnull(@DoubleItemID,0)<>0
		begin
			if (select COUNT(*) from Inv_MenuItem where id = (select DoubleItemID from Inv_MenuItem where ID=@MenuItemID))=0
			begin
		INSERT INTO Inv_MenuItem (Name,Price,RefNumber, CategoryID,IsEntree,IsModifier,IsActive,Recipe,FromPOS,LastUpdate,Creator,Editor,doubleItemID,isDouble)
			VALUES(@Name+' - DOUBLE',@Price*2,@RefNumber,@CategoryID,@IsEntree,@IsModifier,@IsActive,@Recipe,@FromPOS,getdate(),@Creator,@Creator,0,1)
			select @DoubleItemID=@@IDENTITY
			insert into Inv_MenuItemRecipe select @DoubleItemID,InvItemID,Qty*2 from Inv_MenuItemRecipe where InvMID=@MenuItemID
			insert into Inv_MenuItemMap select StoreID,@DoubleItemID,(select DoubleItemID from MenuItem where ID=stMID) from Inv_MenuItemMap where InvMID=@MenuItemID
			update Inv_MenuItem set DoubleItemID=@DoubleItemID where ID=@MenuItemID
			end
		end	
		end
		select @MenuItemID
	end							
	else if @SQLOperationType='SQLUPDATE'
	begin
		--select @DoubleItemID=DoubleItemID from Inv_MenuItem where ID=@ID 
		 UPDATE Inv_MenuItem SET Name = @Name,Price=@Price,RefNumber=@RefNumber,CategoryID = @CategoryID,IsEntree = @IsEntree,IsModifier = @IsModifier,
		 IsActive = @IsActive,Recipe = @Recipe,FromPOS = @FromPOS,LastUpdate = getdate(),
		 Editor = @Editor
		 WHERE ID=@ID
		 select @DoubleItemID=doubleItemID from Inv_MenuItem  WHERE ID=@ID
		 --update DoubleItem
		 if ISNULL(@DoubleItemID,0)<>0
		  UPDATE Inv_MenuItem SET Name = @Name+' DOUBLE',Price=@Price*2,RefNumber=@RefNumber,CategoryID = @CategoryID,IsEntree = @IsEntree,IsModifier = @IsModifier,
		 IsActive = @IsActive,Recipe = @Recipe,FromPOS = @FromPOS,LastUpdate = getdate(),
		 Editor = @Editor
		 WHERE ID=@DoubleItemID
	end
	else if @SQLOperationType='SQLDELETE'
	begin
		 UPDATE Inv_MenuItem SET IsActive = 0,LastUpdate = getdate(),Editor = @Editor
		 WHERE ID=@ID
	end
	else if @SQLOperationType='SQLDELETEPOS'
	begin
		DELETE FROM Inv_MenuItem WHERE FromPOS=@FromPOS
	end
	
END


GO
