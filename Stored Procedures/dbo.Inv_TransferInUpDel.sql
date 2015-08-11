SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_TransferInUpDel]
	@ID nvarchar(200),
	@FromStoreID int,
	@FromUserID int,
	@CreateionDate datetime,
	@ToStoreID int,
	@ToUserID int,
	@TransferDate datetime,
	@weekEnding datetime,
	@comments nvarchar(max),
	@Status int,
	@Type nvarchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @sqlwhere nvarchar(max)
	declare @sql nvarchar(max)
	set @sqlwhere=''
	
	if @Type='SQLInsert'
	begin
		INSERT INTO [Inv_Transfer]
           ([FromStoreID],[FromUserID],[CreationDate],[ToStoreID],[ToUserID],[TransferDate]
           ,[WeekEnding],[Comments],[Status],[LastUpdate])
           values(@FromStoreID,@FromUserID,@CreateionDate,@ToStoreID,null,null,
           @weekEnding,@comments,@Status,GETDATE())
		select @@IDENTITY
	end
	else if @Type='SQLUpdate'
	begin
		if ISNULL(@FromUserID,0)<>0
		begin
			set @sqlwhere=@sqlwhere+',FromUserID='+convert(nvarchar(20),@FromUserID)
		end
			if ISNULL(@ToUserID,0)<>0
		begin
			set @sqlwhere=@sqlwhere+',ToUserID='+convert(nvarchar(20),@ToUserID)
		end	
		if ISNULL(@TransferDate,'')<>''
		begin
			set @sqlwhere=@sqlwhere+',TransferDate='''+convert(nvarchar(20),@TransferDate)+''''
		end
		set @sql=' update Inv_Transfer set FromStoreID='+convert(nvarchar(20),@FromStoreID)+',
		ToStoreID='+convert(nvarchar(20),@ToStoreID)+',
		WeekEnding='''+convert(nvarchar(20),@weekEnding)+''',Comments='''+@comments+''',
		Status='+convert(nvarchar(20),@Status)+',LastUpdate=GETDATE()'+@sqlwhere+' where ID='+convert(nvarchar(20),@ID)
		--select @sql
		execute sp_executesql @sql
	end
	else if @Type='SQLDelete'
	begin
		delete from Inv_TransferDetail where TransferID=@ID
		delete from Inv_Transfer where id=@ID
	end
END
GO
