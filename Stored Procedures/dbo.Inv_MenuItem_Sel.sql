SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_MenuItem_Sel]
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
	@SQLOperationType nvarchar(50)
)
as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@SQLOperationType='SQLSELECT')
	begin
		if (isnull(@IsActive,'')='')
		begin
			if ISNULL(@ID,0)<>0
			begin
				SELECT m.ID, m.Name, m.CategoryID, m.IsModifier, m.IsActive, m.IsEntree, m.FromPOS, m.Recipe, m.LastUpdate, 
		m.Creator, m.Editor, mc.Name AS CategoryName,m.price,m.RefNumber
		FROM dbo.Inv_MenuItem m  INNER JOIN dbo.Inv_MenuItemCategory AS mc ON m.CategoryID = mc.ID
		where m.ID=@ID  and m.isDouble=0
			end
			else
			begin
			SELECT m.ID, m.Name, m.CategoryID, m.IsModifier, m.IsActive, m.IsEntree, m.FromPOS, m.Recipe, m.LastUpdate, 
		m.Creator, m.Editor, mc.Name AS CategoryName,m.price,m.RefNumber
		FROM dbo.Inv_MenuItem AS m INNER JOIN dbo.Inv_MenuItemCategory AS mc ON m.CategoryID = mc.ID
			where m.CategoryID=@CategoryID  and m.isDouble=0
			order by Name asc
			end
		
		end
		else
		begin
			if ISNULL(@ID,0)<>0
			begin
				SELECT m.ID, m.Name, m.CategoryID, m.IsModifier, m.IsActive, m.IsEntree, m.FromPOS, m.Recipe, m.LastUpdate, 
		m.Creator, m.Editor, mc.Name AS CategoryName,m.price,m.RefNumber
		FROM dbo.Inv_MenuItem m  INNER JOIN dbo.Inv_MenuItemCategory AS mc ON m.CategoryID = mc.ID
		where m.ID=@ID and mc.IsActive=1 and m.IsActive=1
		and m.isDouble=0
			end
			else
			begin
			SELECT m.ID, m.Name, m.CategoryID, m.IsModifier, m.IsActive, m.IsEntree, m.FromPOS, m.Recipe, m.LastUpdate, 
		m.Creator, m.Editor, mc.Name AS CategoryName,m.price,m.RefNumber FROM Inv_MenuItem m INNER JOIN dbo.Inv_MenuItemCategory AS mc ON m.CategoryID = mc.ID
			where mc.IsActive=1 and CategoryID=@CategoryID and m.IsActive=1
			and m.isDouble=0
			order by Name asc
			end
		end
	end
	else if (@SQLOperationType='SQLSELECTDETAIL')
			SELECT ID,Name,CategoryID,IsEntree,IsModifier,IsActive,Recipe,FromPOS,LastUpdate,Creator,Editor,price,RefNumber FROM Inv_MenuItem
		where ID=@ID and isDouble=0
END


GO
