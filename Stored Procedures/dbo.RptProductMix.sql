SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[RptProductMix]
@StoreID int,
@Department nvarchar(50),
@ItemID int,
@TimeBegin datetime,
@timeEnd datetime,
@IsDate bit
AS
	declare @sql nvarchar(max)
	declare @sqlFilter nvarchar(max)
	declare @orderItemSql nvarchar(max)
	declare @orderItemFilter nvarchar(max)
	set @orderItemFilter=''
if @IsDate=1
	set @orderItemFilter=' where (ParentSplitLineNum<>0 or Price<>0 ) and storeID='+cast(@StoreID as nvarchar) +' and BusinessDate BETWEEN '''+ Convert(nvarchar,@TimeBegin,120)+ ''' AND '''+ Convert(nvarchar,@timeEnd,120) + ''''
else
	set @orderItemFilter=' where (ParentSplitLineNum<>0 or Price<>0 ) and storeID='+cast(@StoreID as nvarchar)+' and TimeOrdered BETWEEN '''+ Convert(nvarchar,@TimeBegin,120)+ ''' AND '''+ Convert(nvarchar,@timeEnd,120) + ''''
	
set @orderItemSql=' SELECT itemid, SUM(Qty)as Qty,
SUM((Price-AdjustedPrice)*Qty ) as Sold,
COUNT(distinct OrderID ) as Ticket,
cast(  (SUM(Qty)/cast(COUNT(distinct OrderID)as decimal(18,2))) as decimal(18,2 )) as AvgQtyTicket
FROM [OrderLineItem]'+@orderItemFilter+' group by StoreID ,ItemID '

if CONVERT(varchar(10), @TimeBegin, 120 )<DATEADD(YEAR,-2,CONVERT(varchar(10), GETDATE(), 120 ))
or CONVERT(varchar(10), @timeEnd, 120 )<DATEADD(YEAR,-2,CONVERT(varchar(10), GETDATE(), 120 ))
	set @orderItemSql+=' union SELECT itemid, SUM(Qty)as Qty,
	SUM((Price-AdjustedPrice)*Qty ) as Sold,
	COUNT(distinct OrderID ) as Ticket,
	cast(  (SUM(Qty)/cast(COUNT(distinct OrderID)as decimal(18,2))) as decimal(18,2 )) as AvgQtyTicket
	FROM [OrderLineItemArchive]'+@orderItemfilter+' group by StoreID ,ItemID '

set @orderItemSql='('+@orderItemSql+') as oli'
set @sql=' select mi.ReportDepartment as Department,
mi.ReportCategory as Category,
case when mi.UpcNumber is null OR mi.UpcNumber='''' then  cast (mi.ID as nvarchar(50)) else mi.UpcNumber end as ItemNumber,
mi.ReportName as ItemName,
oli.Qty as Qty,oli.Sold as Sold,oli.Ticket as Ticket,oli.AvgQtyTicket
from'+@orderItemSql+' inner join MenuItem as mi on mi.ID=oli.ItemID and mi.StoreID='+cast(@StoreID   as nvarchar)
set @sqlFilter=' where mi.storeID='+cast(@StoreID   as nvarchar)

if isnull(@Department,'')<>''
	set @sqlFilter+=' and mi.ReportDepartment='''+@Department+''''
if isnull(@ItemID,'')<>''
	set @sqlFilter+=' and mi.ID='''+cast(@ItemID  as nvarchar)+''''

set @sql+=@sqlFilter
--select @sql
execute sp_executesql @sql

GO
