SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[inv_MoveItemToStoreToArchive]
as
	declare @CloseTime datetime
	declare @businessdate datetime
	declare @StoreID int
	declare @InventoryInstalled bit
	set @businessdate=convert(nvarchar(20),dateadd(DAY,-1,GETDATE()),102)
	
	declare cur cursor 
	for select EodTime,StoreID,InventoryInstalled from StoreSetting2
	open cur
	fetch next from cur into @CloseTime,@StoreID,@InventoryInstalled
	while(@@fetch_status=0)

	begin
		if @InventoryInstalled=1
		begin
			if(select COUNT(*) from Inv_ItemToStoreArchive where BusinessDate=@businessdate
			and StoreID=@StoreID)=0
			begin
				if GETDATE()>CONVERt(datetime, CONVERT(nvarchar(20),GETDATE(),102)+' '+CONVERT(nvarchar(20),@CloseTime,8))
				begin
					insert into Inv_ItemToStoreArchive 
					select ItemID,StoreID,UnitOnHand,LastUnitPrice,convert(nvarchar(20),dateadd(DAY,-1,GETDATE()),102)
					,GETDATE() from Inv_ItemToStore where StoreID=@StoreID
				end
			end
		end
		fetch next from cur into @CloseTime,@StoreID,@InventoryInstalled
	end
	close cur
	deallocate cur
 
GO
