SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Rpt_OrdersByTenderTypeAll]
(
	@StoreID nvarchar(20),
	@BeginDate datetime,
	@EndDate Datetime,
	@PaymentType nvarchar(20),
	@MethodID nvarchar(20),
	@RevenueCenter nvarchar(50)
)
as
begin
declare @table1 nvarchar(max)
declare @sql nvarchar(max)
declare @sqlWhere nvarchar(max)
SET NOCOUNT ON;
set @sqlWhere=''
if isnull(@PaymentType,'')=''
begin
	set @sqlWhere+=' and p.MethodID = '''+@MethodID+''''
end
else
  begin
	set @sqlWhere+=' and pm.PaymentType='''+@PaymentType+''''
end
set @table1='select pm.Name PaymentType,pm.ID PaymentMethodID,p.MethodID,o.ID as orderID, SUM(o.GuestCount) as GuestCount, 

SUM(p.Amount) as TenderAmount,COUNT(p.LineNum) as TenderCount ,COUNT(CheckID) as Quantity ,o.BusinessDate
from #tempOrder as o
inner join  #tempCheck as c on o.StoreID=c.StoreID and o.ID=c.OrderID and o.BusinessDate=c.BusinessDate 
inner join #tempPayment as p on c.StoreID=p.StoreID and c.ID=p.CheckID 
inner join paymentMethod as pm on p.MethodID=pm.name and p.Storeid=pm.StoreID
where o.businessDate BETWEEN '''+ Convert(nvarchar,@BeginDate,120)+ ''' AND '''+ Convert(nvarchar,@EndDate,120) + '''
AND o.StoreID = '+Convert(nvarchar,@storeID)+@sqlWhere+'
group by p.MethodID,pm.Name,pm.ID,o.ID,CONVERT(varchar(10), p.BusinessDate, 23),o.BusinessDate'


set @sql='
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')
drop table #tempOrder
select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempPayment'') and type=''U'')
drop table #tempPayment
select * into #tempPayment from [dbo].[fnPaymentTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempCheck'') and type=''U'')
drop table #tempCheck
select * into #tempCheck from [dbo].[fnCheckTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')


select table1.PaymentType,table1.PaymentMethodID,table1.MethodID as MethodID,
o.ID as OrderID,Quantity,
CONVERT(varchar(10),o.businessDate,23) as BusinessDate,
convert(varchar(2),DATEPART(HOUR,o.OpenTime))+'':''+convert(varchar(2),DATEPART(minute,o.OpenTime) ) as StartTime,
DATEDIFF(MINUTE,o.OpenTime,o.CloseTime) as Duration,
(select SUM(p.Amount) from #tempPayment as p inner join #tempCheck as c on c.StoreID=p.StoreID and c.ID=p.CheckID where o.StoreID=c.StoreID and o.ID=c.OrderID) as CheckTotal,
table1.TenderAmount as TenderAmount,
table1.GuestCount as GuestCount
from('+@table1+') as table1
inner join #tempOrder as o on o.ID=table1.orderID and o.businessDate=table1.businessDate 
where o.businessDate BETWEEN '''+ Convert(nvarchar,@BeginDate,120)+ ''' AND '''+ Convert(nvarchar,@EndDate,120) + '''
AND o.StoreID = '+Convert(nvarchar,@storeID)
 if isnull(@RevenueCenter,'')<>''
 begin
	set @sql+=' and o.RevenueCenter='''+@RevenueCenter+''''
 end

set @sql+='order by table1.MethodID,o.ID,CONVERT(varchar(10),o.businessDate,23)'
--select @sql
execute sp_executesql @sql
end
GO
