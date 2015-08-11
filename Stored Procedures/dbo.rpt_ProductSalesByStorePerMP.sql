SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create  PROCEDURE [dbo].[rpt_ProductSalesByStorePerMP] 
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
	select SaleGroup,StoreID,StoreName,Department,Category,ItemID,ItemName,SUM(Qty) Qty,SUM(Sold) Sold from ( select 
	(select Name from MealPeriod where StoreID=o.StoreID  
			and (case when		
				(EndTime>beginTime and (o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+'' ''+ CONVERT(nvarchar(20), beginTime,8) 
				and CONVERT(nvarchar(20), o.OpenTime,102) +'' ''+ CONVERT(nvarchar(20), EndTime,8)) ) 

			or (EndTime< beginTime and o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+'' ''+ CONVERT(nvarchar(20), BeginTime,8) 
			and CONVERT(nvarchar(20), o.OpenTime,102)+'' 23:59:59'') 
			or 
			(EndTime< beginTime and o.OpenTime between CONVERT(nvarchar(20), o.OpenTime,102)+'' 00:00:00'' 
			and CONVERT(nvarchar(20), o.OpenTime,102)+'' ''+CONVERT(nvarchar(20), EndTime,8)) 

			then 1 end )=1 
			 and DATEPART(WEEKDAY,o.OpenTime)=
			(case when [DayOfWeek]=''SUNDAY'' then 1
			when [DayOfWeek]=''MONDAY'' then 2
			when [DayOfWeek]=''TUESDAY'' then 3
			when [DayOfWeek]=''WEDNESDAY'' then 4
			when [DayOfWeek]=''THURSDAY'' then 5
			when [DayOfWeek]=''FRIDAY'' then 6
			when [DayOfWeek]=''SATURDAY'' then 7 end))  as SaleGroup,
	o.StoreID,s.StoreName,case when isnull(rtrim(ltrim(mi.UpcNumber)),'''')='''' then  ItemID else mi.UpcNumber end ItemID,
	mi.ReportDepartment Department,mi.ReportCategory Category,mi.Name ItemName,isnull(sum(Qty),2) Qty,
	isnull(SUM(Qty*oli.Price),2) Sold from OrderLineItem oli right join MenuItem mi on oli.ItemID=mi.ID
	and mi.StoreID=oli.StoreID
	inner join [Order] o on oli.StoreID=o.StoreID and oli.BusinessDate=o.BusinessDate and oli.OrderID=o.ID
	inner join Store s on s.ID=oli.StoreID
	 where o.BusinessDate between '''+CONVERT(nvarchar(20),@beginTime)+''' and '''+CONVERT(nvarchar(20),@endTime)+'''  AND MI.ReportDepartment <> ''MODIFIER'' and oli.SI<>''N/A'' 
	 and  MI.MIType NOT IN (''GC'', ''IHPYMNT'') and o.Status=''Close''
	and oli.StoreID in ('+@StoreID+')
	'+@sql+'
	group by o.StoreID,o.OpenTime, mi.UpcNumber,mi.ReportDepartment,mi.ReportCategory,itemid,mi.Name,s.StoreName) b 
	group by StoreID,StoreName,SaleGroup,Department,Category, ItemID,ItemName'
	
	exec sp_executesql @sqlAll
END

GO
