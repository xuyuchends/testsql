SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Rpt_TenderDetailsByDateAll]
(
	@BeginDate datetime,
	@EndDate Datetime,
	@StoreID nvarchar(200),
	@PaymentType nvarchar(20),
	@MethodID nvarchar(20),
	@RevenueCenter nvarchar(50)
)
as
declare @sql nvarchar(max)
SET NOCOUNT ON;
 set @sql='if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')
drop table #tempOrder
select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempPayment'') and type=''U'')
drop table #tempPayment
select * into #tempPayment from [dbo].[fnPaymentTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempCheck'') and type=''U'')
drop table #tempCheck
select * into #tempCheck from [dbo].[fnCheckTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

 
 SELECT p.StoreID as StoreID,pm.PaymentType as PaymentType,o.BusinessDate,
	p.MethodID as MethodID ,COUNT(p.MethodID) as count,SUM(p.Amount) Total,SUM(o.GuestCount) GuestCount
	FROM #tempCheck as c INNER JOIN #tempPayment as p ON c.ID = p.CheckID  and p.StoreID=c.StoreID and p.BusinessDate=c.BusinessDate
	inner join #tempOrder o on o.ID=c.OrderID and o.StoreID=c.StoreID and o.BusinessDate=c.BusinessDate
	inner join PaymentMethod as pm on o.storeid=pm.storeid and pm.name=p.MethodID
	where 1=1 '
 if isnull(@RevenueCenter,'')<>''
 begin
	set @sql+=' and o.RevenueCenter='''+@RevenueCenter+''''
 end
if isnull(@PaymentType,'')=''
 begin
	set @sql+=' and p.MethodID = '''+@MethodID+''''
 end
 else
  begin
	set @sql+=' and pm.PaymentType = '''+@PaymentType+''''
 end
 set @sql+='group by p.StoreID,pm.PaymentType,p.MethodID,o.BusinessDate'
-- select @sql
execute sp_executesql @sql
GO
