SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_ImportFromPOS]
	-- Add the parameters for the stored procedure here
	@ItemName nvarchar(200),
	@UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    declare @storeID int
    declare @ItemID int
    declare @Error int
	select top 1 @storeID=StoreID ,@ItemID=ID from MenuItem where Name=@ItemName
	begin tran 
	delete  from Inv_MenuItemMap where stMID=@ItemID
	set @Error=@Error+@@ERROR
	if @@ERROR>0
		rollback tran
	else
	begin
		delete from Inv_MenuItemRecipe where InvMID=@ItemID
		set @Error=@Error+@@ERROR
		if @@ERROR>0
		rollback tran
		else
		begin
			delete from Inv_MenuItem where ID in (select distinct InvMID from Inv_MenuItemMap where stMID=@ItemID)
			set @Error=@Error+@@ERROR
			if @@ERROR>0
			rollback tran
			else
			begin
				--INSERT INTO [Inv_Item]([Description],[RefNum],[CategoryID],[HotItem],[RecipeUnitID]
    --       ,[InitialCost],[CountPeriod],[CountUnitID],[UPC],[WastePercent],[PrepItem],[AlertQty]
    --       ,[PreferredVendorID],[IsActive],[LastUpdate],[Creator],[Editor])
    -- select Name ,'',null, from MenuItem 
    commit tran
			end			
		end
	end			
END
GO
