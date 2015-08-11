SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 CREATE PROCEDURE [dbo].[rpt_ProductSalesByStore] 
	-- Add the parameters for the stored procedure here
	@StoreID nvarchar(max),
	@beginTime datetime,
	@endTime datetime,
	@Department nvarchar(200),
	@Category nvarchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    declare @sqlAll nvarchar(max)
    declare @sql nvarchar(max)
    set @sql=''
    if isnull(@Department,'')<>''
		 set @sql=@sql+' and MI.ReportDepartment='''+CONVERT(nvarchar(200),@Department)+''''
	if isnull(@Category,'')<>''
		 set @sql=@sql+' and MI.ReportCategory='''+CONVERT(nvarchar(200),@Category)+''''
		 set @sqlAll='
		select oli.StoreID,
		s.StoreName,
		case when isnull(rtrim(ltrim(mi.UpcNumber)),'''')='''' then  CONVERT(nvarchar(20), mi.ID) else rtrim(ltrim(mi.UpcNumber)) end as ItemID,
		rtrim(ltrim(mi.Name)) as ItemName,
		isnull(sum(Qty),2) as Qty,
		isnull(SUM((oli.Price-oli.AdjustedPrice)*oli.Qty ),0) as Sold,
		MI.ReportDepartment as  Department,
		MI.ReportCategory as Category from OrderLineItem oli inner join MenuItem mi on oli.ItemID=mi.ID
		and mi.StoreID=oli.StoreID
		inner join Store s on s.ID=oli.StoreID
		where BusinessDate between '''+CONVERT(nvarchar(20),@beginTime)+''' and '''+CONVERT(nvarchar(20),@endTime)+''' and oli.Status=''Close''
		and oli.StoreID in ('+@StoreID+') 
		AND MI.ReportDepartment <> ''MODIFIER'' and oli.SI<>''N/A''  and oli.RecordType<>''VOID'''+@sql+'
		group by oli.StoreID,rtrim(ltrim(mi.UpcNumber)),MI.ReportDepartment,MI.ReportCategory,rtrim(ltrim(mi.Name)), mi.ID,s.StoreName'
	    exec sp_executesql @sqlAll
		--select @sqlAll
END
GO
