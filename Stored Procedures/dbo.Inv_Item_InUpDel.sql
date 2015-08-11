SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_Item_InUpDel]
	-- Add the parameters for the stored procedure here
	@ID int,
	@Description nvarchar(200),
	@RefNum nvarchar(200),
	@CategoryID int,
	@HotItem bit,
	@RecipeUnitID int ,
	@CountUnitID int,
	@Initial decimal(18,2),
	@CountPeirod int,
	@UPC nvarchar(200),
	@WastePercent decimal(18,2),
	@PrepItem bit,
	@AlertQty int,
	@PreferredVendorID int,
	@IsActive bit,
	@Creator int,
	@Editor int,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @error int
set @error=0
    -- Insert statements for procedure here
    if ISNULL(@sqlType,'')='SQLINSERT'
    begin
    begin tran
		INSERT INTO [Inv_Item]
			   ([Description]
			   ,[RefNum]
			   ,[CategoryID]
			   ,[HotItem]
			   ,[RecipeUnitID]
			   ,CountUnitID
			   ,[InitialCost]
			   ,[CountPeriod]
			   ,[UPC]
			   ,[WastePercent]
			   ,[PrepItem]
			   ,[AlertQty]
			   ,[PreferredVendorID]
			   ,[IsActive]
			   ,[LastUpdate]
			   ,[Creator]
			   ,[Editor])
		 VALUES(@Description,@RefNum,@CategoryID,@HotItem,@RecipeUnitID,@CountUnitID,@Initial,@CountPeirod,
		 @UPC,@WastePercent,@PrepItem,@AlertQty,@PreferredVendorID,@IsActive,GETDATE(),@Creator,@Editor)
		 set @error=@error+@@ERROR
			select @@IDENTITY
			
				INSERT INTO ReportAlert([AlertName],[TriggerBelowValues],[TriggerAboveValues]
			   ,[StartDate],[EndDate],[AlertFrequency],[SendtoStore],[UserID],[CreateDate],[Sendto])
		 VALUES
			   (convert(nvarchar(20),@@IDENTITY)+'-'+@Description,@AlertQty,null,convert(nvarchar(20),GETDATE(),23),null,
			   1,dbo.[fn_GetAllStoreID](),@Creator,GETDATE(),1)
			   set @error=@error+@@ERROR
		if @error>0
		rollback tran
		else
		commit tran
	end
	else if ISNULL(@sqlType,'')='SQLDELETE'
	update  [Inv_Item] set IsActive=0 ,Editor=@Editor,LastUpdate=GETDATE() where id=@ID
	else if ISNULL(@sqlType,'')='SQLUPDATE'
	begin
		declare @sqlWhere nvarchar(max)
		declare @sql nvarchar(max)
		set @sqlWhere='' 
		if ISNULL(@RefNum,'')<>''
		begin
			set @sqlWhere=@sqlWhere+' ,[RefNum]= '''+@RefNum+''''
		end
		if ISNULL(@Description,'')<>''
		begin
			set @sqlWhere=@sqlWhere+' ,[Description]= '''+@Description+''''
		end
		if ISNULL(@CategoryID,'0')<>'0'
		begin
			set @sqlWhere=@sqlWhere+' ,[CategoryID]= '+CONVERT(nvarchar(20),@CategoryID)
		end
		if ISNULL(@HotItem,'')<>''
		begin
			set @sqlWhere=@sqlWhere+' ,HotItem= '+CONVERT(nvarchar(20),@HotItem)
		end
		
		-- Commented out by Johnson Tseng: Once recipe id is inserted, it can not be changed.
		--if ISNULL(@RecipeUnitID,'0')<>'0'
		--begin
		--	set @sqlWhere=@sqlWhere+' ,RecipeUnitID= '+CONVERT(nvarchar(20),@RecipeUnitID)
		--end
		
		if ISNULL(@CountUnitID,'0')<>'0'
		begin
			set @sqlWhere=@sqlWhere+' ,CountUnitID= '+CONVERT(nvarchar(20),@CountUnitID)
		end
		
		if ISNULL(@Initial,'0')<>'0'
		begin
			set @sqlWhere=@sqlWhere+' ,InitialCost= '+CONVERT(nvarchar(20),@Initial)
		end
		
		if ISNULL(@CountPeirod,'0')<>'0'
		begin
			set @sqlWhere=@sqlWhere+' ,CountPeriod= '+CONVERT(nvarchar(20),@CountPeirod)
		end
		
		if ISNULL(@UPC,'')<>''
		begin
			set @sqlWhere=@sqlWhere+' ,UPC= '''+@UPC+''''
		end
		if ISNULL(@WastePercent,'0')<>'0'
		begin
			set @sqlWhere=@sqlWhere+' ,WastePercent= '+CONVERT(nvarchar(20),@WastePercent)
		end
		
		if @PrepItem is not null
		begin
			set @sqlWhere=@sqlWhere+' ,PrepItem= '+CONVERT(nvarchar(20),@PrepItem)
		end
		
		if ISNULL(@AlertQty,'0')<>'0'
		begin
			set @sqlWhere=@sqlWhere+' ,AlertQty= '+CONVERT(nvarchar(20),@AlertQty)
		end
		if @PreferredVendorID is not null
		begin
			if @PreferredVendorID=0
			begin
				set @sqlWhere=@sqlWhere+' ,PreferredVendorID= null'
			end
			else
			begin
				set @sqlWhere=@sqlWhere+' ,PreferredVendorID= '+CONVERT(nvarchar(20),@PreferredVendorID)
			end
		end
		if @IsActive is not null
		begin
			set @sqlWhere=@sqlWhere+' ,IsActive= '+CONVERT(nvarchar(20),@IsActive)
		end
		if ISNULL(@Creator,'0')<>'0'
		begin
			set @sqlWhere=@sqlWhere+' ,Creator= '+CONVERT(nvarchar(20),@Creator)
		end
		if ISNULL(@Editor,'0')<>'0'
		begin
			set @sqlWhere=@sqlWhere+' ,Editor= '+CONVERT(nvarchar(20),@Editor)
		end
		
		set @sqlWhere=SUBSTRING(@sqlWhere,3,len(@sqlWhere))
		set @sql='update [Inv_Item] set '+@sqlWhere+' where ID='+CONVERT(nvarchar(20),@ID)
	--select 	@sql
	    begin tran
		execute sp_executesql 	@sql
		set @error=@error+@error
			if(select COUNT(*) from ReportAlert where AlertName=convert(nvarchar(20),@ID)+'-'+@Description)=0
			begin
				INSERT INTO ReportAlert([AlertName],[TriggerBelowValues],[TriggerAboveValues]
			   ,[StartDate],[EndDate],[AlertFrequency],[SendtoStore],[UserID],[CreateDate],[Sendto])
		 VALUES
			   (convert(nvarchar(20),@ID)+'-'+@Description,@AlertQty,0,convert(nvarchar(20),GETDATE(),23),null,
			   1,dbo.[fn_GetAllStoreID](),@Creator,GETDATE(),1)
			   set @error=@error+@@ERROR
			end
			else
			begin
				update ReportAlert set TriggerBelowValues=@AlertQty where AlertName=convert(nvarchar(20),@ID)+'-'+@Description
				set @error=@error+@@ERROR
			end
		if @error>0
		rollback tran
		else
		commit tran
	end	 
END

GO
