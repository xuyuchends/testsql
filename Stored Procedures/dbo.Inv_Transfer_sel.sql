SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_Transfer_sel]
	-- Add the parameters for the stored procedure here
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
	@currStoreID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @sql nvarchar(max)
	declare @sqlWhere nvarchar(max)
	set @sqlWhere=''
	if(ISNULL(@ID,0)<>0)
	begin
		set @sqlWhere=@sqlWhere+' and t.ID='+CONVERT(nvarchar(20),@ID)
	end
	if(ISNULL(@FromUserID,0)<>0)
	begin
		set @sqlWhere=@sqlWhere+' and t.FromUserID='+CONVERT(nvarchar(20),@FromUserID)
	end
	if(ISNULL(@FromStoreID,0)<>0)
	begin
		if(ISNULL(@ToStoreID,0)<>0)
		begin
			set @sqlWhere=@sqlWhere+' and (t.FromStoreID= '+CONVERT(nvarchar(20),@FromStoreID)+
			' or t.ToStoreID='+CONVERT(nvarchar(20),@ToStoreID)+')'
			
		end
		else
		begin
			set @sqlWhere=@sqlWhere+' and t.FromStoreID='+CONVERT(nvarchar(20),@FromStoreID)
		end
	end
	else
	begin
		if(ISNULL(@ToStoreID,0)<>0)
		begin
			
			if(ISNULL(@FromStoreID,0)<>0)
			begin
				set @sqlWhere=@sqlWhere+' and (t.FromStoreID= '+CONVERT(nvarchar(20),@FromStoreID)+
				' or t.ToStoreID='+CONVERT(nvarchar(20),@ToStoreID)+')'
			end
			else
			begin
				set @sqlWhere=@sqlWhere+' and t.ToStoreID='+CONVERT(nvarchar(20),@ToStoreID)
			end
		end
	end
	if(ISNULL(@CreateionDate,'')<>'')
	begin
		set @sqlWhere=@sqlWhere+' and t.CreationDate='''+CONVERT(nvarchar(20),@CreateionDate)+''''
	end
	
	if(ISNULL(@ToUserID,0)<>0)
	begin
		set @sqlWhere=@sqlWhere+' and t.ToUserID='+CONVERT(nvarchar(20),@ToUserID)
	end
	if(ISNULL(@TransferDate,'')<>'')
	begin
		set @sqlWhere=@sqlWhere+' and t.TransferDate='''+CONVERT(nvarchar(20),@TransferDate)+''''
	end
	if(ISNULL(@weekEnding,'')<>'')
	begin
		declare @WeekStartDay int =0
		select top 1 @WeekStartDay =WeekStartDay from  LaborWeekStart
		if (@WeekStartDay<0)
				set @WeekStartDay=7-@WeekStartDay
		set @sqlWhere=@sqlWhere+' and t.weekEnding=DATEADD(day,-'+CONVERT(nvarchar(20),@WeekStartDay)+', '''+CONVERT(nvarchar(20),@weekEnding)+''')'
	end
	if ISNULL(@Status,0)<>0
	begin
		set @sqlWhere=@sqlWhere+' and t.Status='+CONVERT(nvarchar(20),@Status)
	end
	set @sql='select t.*,case when ISNULL(FromStoreID,0)='+convert(nvarchar(20),@currStoreID)+' then (select StoreName From Store where ID=ToStoreID) 
when ISNULL(ToStoreID,0)='+convert(nvarchar(20),@currStoreID)+' then (select StoreName From Store where ID=FromStoreID) 
end StoreName,(select StoreName From Store where ID=FromStoreID) FromStorename,
(select StoreName From Store where ID=ToStoreID) ToStorename,
(select StoreName From Store where ID=ToStoreID)  approveStoreName,eu.FirstName+'' ''+eu.LastName SendBY,
eu1.FirstName+'' ''+eu1.LastName ReceivedBY,(select sum(td.Qty*its.LastUnitPrice)  from Inv_TransferDetail td inner join Inv_ItemToStore its on td.InvItemID=its.ItemID
and its.StoreID=t.FromStoreID where TransferID=t.ID) TransferValue  from Inv_Transfer t
inner join EnterpriseUser eu on t.FromUserID=eu.ID
left join EnterpriseUser eu1 on t.ToUserID=eu1.ID where 1=1 '+@sqlWhere

--select @sql
	exec sp_executesql @sql
END
GO
