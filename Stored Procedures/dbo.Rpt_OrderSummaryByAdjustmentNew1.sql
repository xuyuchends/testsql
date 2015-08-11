SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Rpt_OrderSummaryByAdjustmentNew1]
(
	@BeginDate datetime,
	@EndDate datetime,
	@StoreID int,
	@RevenueCenter nvarchar(200),
	@Adjustments nvarchar(200)
)
as
begin
declare @tabel1 nvarchar(max)
declare @sql nvarchar(max)
SET NOCOUNT ON;
set @tabel1='select v.name as Adjustname, 
oli.OrderID as orderID, 
abs(isnull(SUM(oli.Qty),0)) as Quantity, 
abs(isnull(SUM(oli.Qty*(oli.Price-oli.AdjustedPrice)),0)) as Amount, 
abs(isnull(sum(Qty*Price),0)) as TotalSales
from OrderLineItem oli
inner join Void as  v on oli.AdjustID=v.ID and oli.StoreID=v.StoreID 
inner join Store as s on s.ID=oli.StoreID 
where  oli.SI<>''N/A'' and oli.StoreID ='+CONVERT(nvarchar,@StoreID)
if  ISNULL(@Adjustments,'')<>''
begin
	set @tabel1+=' and v.name='''+@Adjustments+''''
end
set @tabel1+=' group by v.Name,  oli.OrderID'
set @sql='select o.id as orderID, 
   CONVERT(varchar(12),o.BusinessDate,101) as Date, 
   convert(varchar(2),DATEPART(HOUR,o.OpenTime))+'':''+convert(varchar(2),DATEPART(minute,o.OpenTime) ) StartTime, 
    DATEDIFF(MINUTE,o.OpenTime,o.CloseTime) as Duration,
    tabel1.Adjustname as Adjustname,
    tabel1.Quantity as Quantity,
    tabel1.Amount as Amount,
    tabel1.TotalSales as TotalSales,
    (
    select SUM(p.amount) from Payment as p inner join [Check] as c on c.ID=p.CheckID and c.StoreID=p.StoreID
    inner join [Order] as o1 on o1.ID=c.OrderID and o.StoreID=c.StoreID
    where o1.ID=o.ID  and o1.StoreID ='+CONVERT(nvarchar,@StoreID)+'
    ) as CheckTotal
    from [Order] as o inner join ('+@tabel1+') as tabel1 on tabel1.orderID=o.ID
	where  o.BusinessDate BETWEEN '''+ Convert(nvarchar,@BeginDate,120)+ ''' AND '''+ Convert(nvarchar,@EndDate,120) + '''
	and o.StoreID ='+CONVERT(nvarchar,@StoreID)
	if  ISNULL(@RevenueCenter,'')<>''
begin
	set @sql+=' and o.RevenueCenter='''+@RevenueCenter+''''
end
--select @sql
exec sp_executesql @sql
end
GO
